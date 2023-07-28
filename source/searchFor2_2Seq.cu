//
// Created by Victoria Tate on 25/10/22.
//
#include <time.h>
#include "computeProduct.cu"

Cycle optimizedApplyTransposition(Cycle pi, Move move) {

    int a = move.cycle.symbols[0];
    int b = move.cycle.symbols[1];
    int c = move.cycle.symbols[2];

    int indexes[3];
    Cycle result_cycle;
    result_cycle.symbols = (int *) malloc(pi.sizeSymbols * sizeof(int));
    result_cycle.symbolsIndexes = (int *) malloc(pi.sizeSymbols * sizeof(int));
    result_cycle.sizeSymbols = pi.sizeSymbols;
    result_cycle.maxSymbol = pi.maxSymbol;
    result_cycle.minSymbol = pi.minSymbol;

    for (int i = 0; i < pi.sizeSymbols; i++) {
        if (pi.symbols[i] == a)
            indexes[0] = i;
        if (pi.symbols[i] == b)
            indexes[1] = i;
        if (pi.symbols[i] == c)
            indexes[2] = i;
    }

    quick_sort(indexes,0,sizeof(indexes)/sizeof(int)-1);

    int * result_symbols = (int *) malloc(pi.sizeSymbols * sizeof(int));
    int * result_index = (int *) malloc(pi.sizeSymbols * sizeof(int));

    for(int i=0; i < pi.sizeSymbols; i++){
        result_symbols[i] = 0;
        result_index[i] = 0;
    }

    for(int i = 0; i < indexes[0]; i++){
        result_symbols[i] = pi.symbols[i];
        result_index[pi.symbols[i]] = i;
    }
    for(int i = 0; i < indexes[2] - indexes[1]; i++){
        result_symbols[i + indexes[0]] = pi.symbols[i + indexes[1]];
        result_index[pi.symbols[i+indexes[1]]] = i + indexes[0];
    }
    for(int i = 0; i < indexes[1] - indexes[0]; i++){
        result_symbols[i + indexes[0] + (indexes[2] - indexes[1])] = pi.symbols[i + indexes[0]];
        result_index[pi.symbols[i + indexes[0]]] = i + indexes[0] + (indexes[2] - indexes[1]);
    }
    for(int i = 0; i < pi.sizeSymbols - indexes[2]; i++){
        result_symbols[i + indexes[2]] = pi.symbols[i + indexes[2]];
        result_index[pi.symbols[i + indexes[2]]] = i + indexes[2];
    }

    memcpy(result_cycle.symbols, result_symbols, pi.sizeSymbols * sizeof(int));
    memcpy(result_cycle.symbolsIndexes, result_index, pi.sizeSymbols * sizeof(int));

    free(result_symbols);
    free(result_index);

    return result_cycle;
}

Move * generateAll0And2Moves(Permutation spi, Cycle pi)
{
    clock_t t;
    t = clock();

    Move * moves;
    Cycle * cycle_index = (Cycle *) malloc(pi.sizeSymbols * sizeof(int));
    Cycle moveCycle;
    int moves_size = 0;
    int is_2Move = 1;
    int a;
    int b;
    int c;
    int delta;

    Permutation spi_;

    int spiNumberOfEvenCycles = 0;
    for (int i = 0; i < spi.sizeMulticycle; i++) {
        for(int s = 0; s < spi.multicycle[i].sizeSymbols; s++){
            cycle_index[spi.multicycle[i].symbols[s]] = spi.multicycle[i];
        }
        spiNumberOfEvenCycles += spi.multicycle[i].sizeSymbols % 2;
    }

    Permutation * permutation = (Permutation *) malloc(2*sizeof(Permutation));
    permutation[0].sizeMulticycle = spi.sizeMulticycle;
    permutation[0].multicycle = (Cycle *) malloc((spi.sizeMulticycle)*sizeof(Cycle));
    permutation[0].minSymbol = spi.minSymbol;
    permutation[0].maxSymbol = spi.maxSymbol;
    for(int c = 0; c < spi.sizeMulticycle; c++){
        permutation[0].multicycle[c] = spi.multicycle[c];
    }
    permutation[0].numOfEvenCycles = getNumberOfEvenCycles(permutation[0]);

    for (int i=0; i < pi.sizeSymbols - 2; i++){
        if(cycle_index[pi.symbols[i]].sizeSymbols > 1){
            for(int j = i + 1; j < pi.sizeSymbols - 1; j++){
                if(cycle_index[pi.symbols[j]].sizeSymbols > 1){
                    for(int k = j + 1; k < pi.sizeSymbols; k++){

                        if(cycle_index[pi.symbols[k]].sizeSymbols > 1){
                            a = pi.symbols[i];
                            b = pi.symbols[j];
                            c = pi.symbols[k];

                            if( cycle_index[a].symbols != cycle_index[b].symbols
                                &&  cycle_index[b].symbols != cycle_index[c].symbols
                                &&  cycle_index[a].symbols != cycle_index[c].symbols ){

                                is_2Move = 0;
                            }

                            if(is_2Move == 1){
                                int symbols[] = {a, b, c};
                                moveCycle.symbols = symbols;
                                moveCycle.sizeSymbols = 3;
                                int * symbolsIndexes = (int *) malloc((spi.maxSymbol+1) * sizeof(int));
                                for(int idx = 0; idx < spi.maxSymbol+1; idx++){
                                    symbolsIndexes[idx] = -1;
                                }
                                for(int idx = 0; idx < moveCycle.sizeSymbols; idx++){
                                    symbolsIndexes[symbols[idx]] = idx;
                                }
                                minMax(&moveCycle);
                                moveCycle.symbolsIndexes = &symbolsIndexes[0];

                                permutation[1].sizeMulticycle = 1;
                                permutation[1].multicycle = getInverse(moveCycle, spi.maxSymbol+1);
                                permutation[1].minSymbol = moveCycle.minSymbol;
                                permutation[1].maxSymbol = moveCycle.maxSymbol;
                                permutation[1].numOfEvenCycles = getNumberOfEvenCycles(permutation[1]);

                                spi_ = computeProduct(permutation, 2);

                                delta = spi_.numOfEvenCycles - spiNumberOfEvenCycles;
                                free(spi_.multicycle);

                                if(delta >= 0){
                                    if(moves_size == 0){
                                        moves = (Move *) malloc(++moves_size * sizeof(Move));
                                    } else{
                                        moves = (Move *) realloc(moves, ++moves_size * sizeof(Move));
                                    }
                                    moves[moves_size-1].move = delta;
                                    moves[moves_size-1].cycle.symbols = (int *) malloc(moveCycle.sizeSymbols * sizeof(int));
                                    moves[moves_size-1].cycle.symbolsIndexes = (int *) malloc((spi.maxSymbol+1)*sizeof(int));
                                    memcpy(moves[moves_size-1].cycle.symbols, moveCycle.symbols, moveCycle.sizeSymbols*sizeof(int));
                                    memcpy(moves[moves_size-1].cycle.symbolsIndexes, moveCycle.symbolsIndexes, (spi.maxSymbol+1)*sizeof(int));
                                    moves[moves_size-1].cycle.sizeSymbols = moveCycle.sizeSymbols;

                                }
                            }
                            is_2Move = 1;
                        }
                    }
                }
            }
        }
    }
    free(cycle_index);
    free(permutation[0].multicycle);
    permutation[0].sizeMulticycle = 0;
    free(permutation);
    double time_taken = ((double)t)/CLOCKS_PER_SEC;
    printf("generateAll0And2Moves took %f seconds\n", time_taken);
    return moves;
}

Cycle * searchFor2_2Seq(Permutation spi, Cycle pi) {
    clock_t start, end;
    start = clock();

    Move * moves = generateAll0And2Moves(spi, pi);

    Permutation inverse_move;
    inverse_move.sizeMulticycle = 1;

    int i = 0;
    int j = 0;
    while(moves[i].cycle.sizeSymbols > 0){
        if (moves[i].move == 2) {
            inverse_move.multicycle = getInverse(moves[i].cycle, moves[i].cycle.sizeSymbols);
            inverse_move.maxSymbol = inverse_move.multicycle[0].maxSymbol;
            inverse_move.minSymbol = inverse_move.multicycle[0].minSymbol;

            Permutation new_permutation[2] = {spi, inverse_move};

            Permutation _spi = computeProduct(new_permutation, 2);
            Cycle _pi = optimizedApplyTransposition(pi, moves[i]);
            Move * secondMoves = generateAll0And2Moves(_spi, _pi);

            while(secondMoves[j].cycle.sizeSymbols > 0) {
                if (secondMoves[j].move == 2) {
                    Cycle * result = (Cycle *) malloc(2*sizeof(Cycle));
                    result[0] = moves[i].cycle;
                    result[1] = secondMoves[j].cycle;
                    end = clock();
                    printf("The time was: %f\n", (double)(end - start) / CLOCKS_PER_SEC);
                    return result;

                } else {
                    j++;
                }
            }
            free(_spi.multicycle);
            free(_pi.symbols);
            free(_pi.symbolsIndexes);
            i ++;
        } else {
            i ++;
        }
    }
    end = clock();
    printf("The time was: %f\n", (double)(end - start) / CLOCKS_PER_SEC);
    return NULL;
}