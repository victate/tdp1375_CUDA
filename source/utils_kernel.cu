__global__ void minMaxKernel(const int *symbols, int *min, int *max)
{
    int i = threadIdx.x;
    if(*max < symbols[i]){
        *max = symbols[i];
    }
    if(*min > symbols[i] | min == 0){
        *min = symbols[i];
    }
}

