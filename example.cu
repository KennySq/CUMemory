#include"CUMemory.cuh"
#include<iostream>
#include<Windows.h>

__global__ void memoryChecker()
{

	return;
}

template<typename _Ty>
void CopyDeivceToHost(void* vtr, _Ty* out, unsigned int count)
{
	cudaMemcpy(out, vtr, sizeof(_Ty) * count, cudaMemcpyDeviceToHost);
}

template<typename _Ty>
void WriteMemory(void* vtr, _Ty data)
{
	cudaMemcpy(vtr, &data, sizeof(_Ty), cudaMemcpyHostToDevice);
}

int main()
{
	CUMemory mem(1024);
	
	void* ptr0 = mem.Alloc(4);
	void* ptr1 = mem.Alloc(16);
	mem.Release(ptr0);
	void* ptr2 = mem.Alloc(2);
	return 0;
}