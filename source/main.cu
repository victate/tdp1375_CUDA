#include "searchFor2_2Seq.cu"

int main()
{
    clock_t start, end;
    
    int sigma[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
    int sigma_index[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};

    int pi[] = {0, 12, 8, 3, 7, 2, 6, 1, 5, 9, 14, 13, 4, 11, 10};
    int pi_index[] = {0, 7, 5, 3, 12, 8, 6, 4, 2, 9, 14, 13, 4, 11, 10};

    /*
    int pi[] = {10, 11, 4, 13, 14, 9, 5, 1, 6, 2, 7, 3, 8, 12, 0};
    int pi_index[] = {14, 7, 9, 11, 2, 6, 8, 10, 12, 5, 0, 1, 13, 3, 4};
*/

    Cycle cycle_sigma;
    cycle_sigma.symbols = &sigma[0];
    cycle_sigma.symbolsIndexes = &sigma_index[0];
    cycle_sigma.sizeSymbols = 15;
    cycle_sigma.maxSymbol = 14;
    cycle_sigma.minSymbol = 0;

    Cycle cycle_pi;
    cycle_pi.symbols = &pi[0];
    cycle_pi.symbolsIndexes = &pi_index[0];
    cycle_pi.sizeSymbols = 15;
    cycle_pi.maxSymbol = 14;
    cycle_pi.minSymbol = 0;

    Permutation * permutation = (Permutation *) malloc(2*sizeof(Permutation));
    permutation[0].multicycle = &cycle_sigma;
    permutation[0].sizeMulticycle = sizeof(cycle_sigma)/sizeof(Cycle);
    permutation[0].maxSymbol = 14;
    permutation[0].minSymbol = 0;
    permutation[1].multicycle = getInverse(cycle_pi, cycle_pi.sizeSymbols);
    permutation[1].sizeMulticycle = sizeof(cycle_pi)/sizeof(Cycle);
    permutation[1].maxSymbol = 14;
    permutation[1].minSymbol = 0;

    printf("\nComputing product: \n");
    start = clock();


    Permutation new_permutation = computeProduct(permutation, 2);

    printf("\nPrinting multicycle: \n");
    for(int m=0; m<new_permutation.sizeMulticycle; m++) {
        if (m != 0) {
            printf("\n");
        }
        printf("%d = (", m);
        for (int c = 0; c < new_permutation.multicycle[m].sizeSymbols; c++) {
            if (c != 0) {
                printf(", ");
            }
            printf("%d", new_permutation.multicycle[m].symbols[c]);
        }
        printf(") Index: (");
        for (int c = 0; c < new_permutation.maxSymbol; c++) {
            if (c != 0) {
                printf(", ");
            }
            printf("%d", new_permutation.multicycle[m].symbolsIndexes[c]);
        }
        printf(")");
    }
    printf("\n\n");

    Cycle * moves = searchFor2_2Seq(new_permutation, cycle_pi);

    end = clock();
    printf("searchFor2_2Seq took %f millis\n", (double)(end - start) / CLOCKS_PER_SEC);

    printf("\nPrinting moves: \n");

    for(int i=0; i < sizeof(moves)/sizeof(moves[i].sizeSymbols); i++){
        printf("\n Move: %d \n Cycle: [", 2);
        for(int j = 0; j < moves[i].sizeSymbols; j++){
            if(j > 0){
                printf(", ");
            }
            printf("%d", moves[i].symbols[j]);
        }
        printf("] \n");
    }

    free(new_permutation.multicycle);
    free(moves);
    free(permutation);
}
