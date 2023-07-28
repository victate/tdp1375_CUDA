#include "utils.h"

int getNumberOfEvenCycles(Permutation permutation){
    int numberOfEvenCycles = 0;

    for(int i = 0; i < permutation.sizeMulticycle; i++){
        numberOfEvenCycles += permutation.multicycle[i].sizeSymbols % 2;
    }
    return numberOfEvenCycles;
}

void minMax(Cycle cycle, int limits[2]){

    int max = cycle.symbols[0];
    int min = cycle.symbols[0];

    for (int i = 0; i < cycle.sizeSymbols; i++) {
        if(max < cycle.symbols[i]){
            max = cycle.symbols[i];
        }
        if(min > cycle.symbols[i]){
            min = cycle.symbols[i];
        }
    }
    limits[0] = min;
    limits[1] = max;
}

void permutationMinMax(Permutation permutation, int limits[2]){

    int min = permutation.multicycle[0].maxSymbol;
    int max = permutation.multicycle[0].minSymbol;

    for (int i = 1; i < permutation.sizeMulticycle; i++) {
        if(max < permutation.multicycle[i].maxSymbol){
            max = permutation.multicycle[i].maxSymbol;
        }
        if(min > permutation.multicycle[i].minSymbol){
            min = permutation.multicycle[i].minSymbol;
        }
    }
    limits[0] = min;
    limits[1] = max;
}

void quick_sort(int *indexes, int left, int right) {

    int i, j, x, y;

    i = left;
    j = right;
    x = indexes[(left + right) / 2];

    while(i <= j) {
        while(indexes[i] < x && i < right) {
            i++;
        }
        while(indexes[j] > x && j > left) {
            j--;
        }
        if(i <= j) {
            y = indexes[i];
            indexes[i] = indexes[j];
            indexes[j] = y;
            i++;
            j--;
        }
    }
    if(j > left) {
        quick_sort(indexes, left, j);
    }
    if(i < right) {
        quick_sort(indexes, i, right);
    }

}

Cycle * getInverse(Cycle moveCycle, int len){

    Cycle * inverse_cyc = malloc(sizeof(Cycle));
    inverse_cyc[0].symbols = malloc(moveCycle.sizeSymbols*sizeof(int));
    inverse_cyc[0].symbolsIndexes = malloc(len*sizeof(int));
    inverse_cyc[0].sizeSymbols = moveCycle.sizeSymbols;
    inverse_cyc[0].maxSymbol = moveCycle.maxSymbol;
    inverse_cyc[0].minSymbol = moveCycle.minSymbol;

    for(int i = 0; i < len; i++){
        inverse_cyc[0].symbolsIndexes[i] = -1;
    }

    for(int i = 0; i < moveCycle.sizeSymbols; i++){
        inverse_cyc[0].symbols[i] = moveCycle.symbols[moveCycle.sizeSymbols - 1 - i];
        inverse_cyc[0].symbolsIndexes[inverse_cyc[0].symbols[i]] = i;
    }

    return inverse_cyc;
}

