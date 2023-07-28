#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils.cu"

Permutation findCycles(int include1Cycle, Permutation * permutation, const int permutation_len)
{
    Cycle new_cycle;
    new_cycle.sizeSymbols = 0;
    Cycle * new_multicycle;
    Permutation new_permutations;
    int n = permutation[0].maxSymbol+1;
    int ** function = (int **) malloc(permutation_len * sizeof(int *));
    int counter = 0;
    int start = 0;
    int image = 0;
    int new_multicycle_size = 0;
    int * seen = (int *) malloc(n * sizeof(int));

    for(int i=0; i<permutation_len; i++){
        function[i] = (int *) malloc(n*sizeof(int));
        for(int j=0; j<n; j++){
            function[i][j] = -1;
        }
    }

    for(int i = 0; i < permutation_len; i++) {
        for (int j = 0; j < permutation[i].sizeMulticycle; j++) {
            Cycle c = permutation[i].multicycle[j];
            for (int k = 0; k < c.sizeSymbols; k++) {
                function[i][c.symbols[k]] = c.symbols[(c.symbolsIndexes[c.symbols[k]] + 1) % c.sizeSymbols];
            }
        }
    }

    for(int i=0; i<n; i++){
        seen[i] = 0;
    }

    while(counter < n){
        int i = 0;
        while(seen[i]==1){
            ++i;
        }
        start = i;
        image = start;

        for (int j = permutation_len - 1; j >= 0; j--) {
            if (function[j][image] != -1){
                image = function[j][image];
            }
        }

        if (image == start) {
            counter = counter + 1;
            seen[start] = 1;
            if (include1Cycle) {
                if (new_cycle.sizeSymbols > 0) {
                    new_cycle.symbols = (int *) realloc(new_cycle.symbols, (++new_cycle.sizeSymbols) * sizeof(int));
                } else {
                    new_cycle.symbols = (int *) malloc((++new_cycle.sizeSymbols) * sizeof(int));
                    new_cycle.symbolsIndexes = (int *) malloc((n+1) * sizeof(int));
                    for(int i=0; i < n; i++){
                        new_cycle.symbolsIndexes[i] = -1;
                    }
                }
                new_cycle.symbols[new_cycle.sizeSymbols - 1] = start;
                new_cycle.symbolsIndexes[start] = new_cycle.sizeSymbols - 1;

                for (int k = permutation_len - 1; k >= 0; k--) {
                    if(function[k][image] != -1){
                        image = function[k][image];
                    }
                }
            }
        }
        while (seen[start]==0) {
            counter = counter + 1;

            seen[start] = 1;
            image = start;

            if (new_cycle.sizeSymbols == 0) {
                new_cycle.symbols = (int *) malloc(sizeof(int));
                new_cycle.symbolsIndexes = (int *) malloc((n+1) * sizeof(int));

                for(int i=0; i < n; i++){
                    new_cycle.symbolsIndexes[i] = -1;
                }
                new_cycle.sizeSymbols = 1;
            } else {
                new_cycle.symbols = (int *) realloc(new_cycle.symbols, (++new_cycle.sizeSymbols) * sizeof(int));
            }
            new_cycle.symbols[new_cycle.sizeSymbols - 1] = start;
            new_cycle.symbolsIndexes[start] = new_cycle.sizeSymbols - 1;

            for (int k = permutation_len - 1; k >= 0; k--) {
                if(function[k][image] != -1){
                    image = function[k][image];
                }
            }
            start = image;
        }

        minMax(&new_cycle);
        
        if(new_multicycle_size > 0){
            new_multicycle = (Cycle *) realloc(new_multicycle, ++new_multicycle_size * sizeof(Cycle));
        } else {
            new_multicycle = (Cycle *) malloc(++new_multicycle_size * sizeof(Cycle));
        }
        new_multicycle[new_multicycle_size-1].symbols = (int *) malloc(new_cycle.sizeSymbols * sizeof(int));
        memcpy(new_multicycle[new_multicycle_size-1].symbols, new_cycle.symbols, new_cycle.sizeSymbols * sizeof(int));

        new_multicycle[new_multicycle_size-1].symbolsIndexes = (int *) malloc((n+1) * sizeof(int));
        memcpy(new_multicycle[new_multicycle_size-1].symbolsIndexes, new_cycle.symbolsIndexes, n * sizeof(int));

        new_multicycle[new_multicycle_size-1].sizeSymbols = new_cycle.sizeSymbols;
        new_multicycle[new_multicycle_size-1].maxSymbol = new_cycle.maxSymbol;
        new_multicycle[new_multicycle_size-1].minSymbol = new_cycle.minSymbol;
        new_cycle.sizeSymbols = 0;
        
        printf("starting to free cycle\n");
        free(new_cycle.symbols);
        free(new_cycle.symbolsIndexes);
        printf("freed new_cycle \n");
    }

    new_permutations.multicycle = new_multicycle;
    new_permutations.sizeMulticycle = new_multicycle_size;
    new_permutations.minSymbol = permutation[0].minSymbol;
    new_permutations.maxSymbol = permutation[0].maxSymbol;

    printf("getting number of even cycles\n");
    new_permutations.numOfEvenCycles = getNumberOfEvenCycles(new_permutations);

    free(function);
    free(seen);

    return new_permutations;
}

Permutation computeProduct(Permutation * permutation, int permutation_len) {
    return findCycles(1, permutation, permutation_len);
}
