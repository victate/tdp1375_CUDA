#ifndef UTILS_H_
#define UTILS_H_

#include "types.h"
#include <stdio.h>
#include <stdlib.h>

int getNumberOfEvenCycles(Permutation permutation);
void minMax(Cycle cycle, int limits[2]);
void quick_sort(int *indexes, int left, int right);
void permutationMinMax(Permutation permutation, int limits[2]);
Cycle * getInverse(Cycle moveCycle, int len);

#endif

