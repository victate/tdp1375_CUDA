# tdp1375_CUDA

----

To execute the **C program**, please change directory to source folder and then compile using GCC.

Below I detail this procedure:

 - Download *source* folder.
 - Open CMD or Terminal.
 - Run: cd [YOUR_PATH]/source
 - Run: gcc -o out .\*.c
 - Run: .\out.exe
 - The results will be printed.

----

To execute the **CUDA program**, please change directory to source folder and then compile using CUDA Toolkit. To develop this code I am using [cuda_12.1.r12.1](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html)

Below I detail this procedure:

 - Download *source* folder.
 - Open CMD or Terminal.
 - Run: cd [YOUR_PATH]/source
 - Run:  nvcc -o search2_2SeqCuda .\main.cu
 - Run: .\search2_2SeqCuda.exe
 - The results will be printed.
