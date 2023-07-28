#ifndef COMMON_OPERATIONS_H_
#define COMMON_OPERATIONS_H_

#include <time.h>
#include "permutation_groups.h"

Move * generateAll0And2Moves(Permutation spi, Cycle pi);

Cycle * searchFor2_2Seq(Permutation spi, Cycle pi);

#endif
