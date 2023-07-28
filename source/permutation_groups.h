#ifndef PERMUTTAION_GROUPS_H_
#define PERMUTATION_GROUPS_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"
#include "types.h"

Permutation findCycles(int include1Cycle, Permutation * permutation, int permutation_len);
Permutation computeProduct(Permutation * permutation, int permutation_len);

#endif
