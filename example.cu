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
	void* ptr = malloc(4);

	int* intPtr = reinterpret_cast<int*>(ptr);

	free(ptr);
	
	CUMemory memory(1024);

	CUMemory memory2(512);
	
	void* devicePtr0 = memory.Alloc(4);
	void* devicePtr1 = memory.Alloc(16);
	void* devicePtr2 = memory.Alloc(32);
	void* devicePtr3 = memory.Alloc(8);
	void* devicePtr4 = memory.Alloc(16);
	void* devicePtr5 = memory.Alloc(4);

	void* devicePtr6 = memory2.Alloc(32);

	void* devicePtr7 = memory.Alloc(4);

	int src = 17;
	int data;

	WriteMemory<int>(devicePtr7, src);

	CopyDeivceToHost<int>(devicePtr7, &data, 1);

	memoryChecker << <1, 1 >> > ();

	memory.Release(devicePtr3);

	return 0;
}