#include "types.cuh"
#include <stdio.h>
#include <stdlib.h>
#include "utils_kernel.cu"


int getNumberOfEvenCycles(Permutation permutation){
    int numberOfEvenCycles = 0;

    for(int i = 0; i < permutation.sizeMulticycle; i++){
        numberOfEvenCycles += permutation.multicycle[i].sizeSymbols % 2;
    }
    return numberOfEvenCycles;
}

cudaError_t minMax(Cycle* new_cycle){
    
    cudaError_t cudaStatus = cudaSetDevice(0);
    int* min;
    int* min_ = (int *) malloc(sizeof(int *));
    int* max;
    int* max_ = (int *) malloc(sizeof(int *));
    int* symbols;
    int symbols_size = new_cycle[0].sizeSymbols;
    int* symbol_first = &new_cycle[0].symbols[0];

    cudaStatus = cudaMalloc((void**)&symbols, symbols_size * sizeof(int));
    cudaStatus = cudaMemcpy(symbols, new_cycle[0].symbols, symbols_size * sizeof(int), cudaMemcpyHostToDevice);
    cudaStatus = cudaMalloc((void**)&min, sizeof(int *));
    cudaStatus = cudaMemcpy(min, symbol_first, sizeof(int), cudaMemcpyHostToDevice);
    cudaStatus = cudaMalloc((void**)&max, sizeof(int *));
    cudaStatus = cudaMemcpy(max, symbol_first, sizeof(int), cudaMemcpyHostToDevice);
    cudaStatus = cudaMemcpy(symbols, new_cycle[0].symbols, symbols_size * sizeof(int), cudaMemcpyHostToDevice);
    
    minMaxKernel<<<1, symbols_size>>>(symbols, min, max);
    cudaStatus = cudaDeviceSynchronize();

    cudaStatus = cudaMemcpy(min_, min, sizeof(int), cudaMemcpyDeviceToHost);
    cudaStatus = cudaMemcpy(max_, max, sizeof(int), cudaMemcpyDeviceToHost);
    
    new_cycle[0].minSymbol = *min_;
    new_cycle[0].maxSymbol = *max_;

    cudaFree(max);
    cudaFree(min);
    cudaFree(symbols);
    free(min_);
    free(max_);
    
    return cudaStatus;
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

    Cycle * inverse_cyc = (Cycle *) malloc(sizeof(Cycle));
    inverse_cyc[0].symbols = (int *) malloc(moveCycle.sizeSymbols*sizeof(int));
    inverse_cyc[0].symbolsIndexes =  (int *) malloc(len*sizeof(int));
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

