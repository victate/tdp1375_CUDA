//
// Created by Victoria Tate on 24/10/22.
//

#ifndef TCC_C_TYPES_H
#define TCC_C_TYPES_H

typedef struct {
    int sizeSymbols;
    int * symbols;
    int * symbolsIndexes;
    int minSymbol;
    int maxSymbol;
} Cycle;

typedef struct {
    Cycle* multicycle;
    int minSymbol;
    int maxSymbol;
    int sizeMulticycle;
    int numOfEvenCycles;
} Permutation;

typedef struct {
    Cycle cycle;
    int move;
} Move;


#endif //TCC_C_TYPES_H
