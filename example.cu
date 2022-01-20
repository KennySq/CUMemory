#include"CUMemory.cuh"
int main()
{
	CUMemory memory(1024);

	void* devicePtr0 = memory.Alloc(4);
	void* devicePtr1 = memory.Alloc(16);
	void* devicePtr2 = memory.Alloc(32);
	void* devicePtr3 = memory.Alloc(8);
	void* devicePtr4 = memory.Alloc(16);
	void* devicePtr5 = memory.Alloc(4);

	memory.Release(devicePtr3);

	return 0;
}