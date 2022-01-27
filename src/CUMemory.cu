#include"pch.h"
#include"CUMemory.cuh"

__device__ void* gGlobalMemory = nullptr;

CUMemory::CUMemory(size_t initSize)
	: mSize(initSize), mOffset(0)
{
	cudaError_t error = cudaMalloc(reinterpret_cast<void**>(&gGlobalMemory), initSize);

	if (error != NULL)
	{
		std::cout << "Failed to init CUMemory instance.\n";
	}

	mVirtual = gGlobalMemory;

	return;
}

CUMemory::~CUMemory()
{
	cudaFree(gGlobalMemory);
}

void* CUMemory::Alloc(size_t size)
{
	size_t ptr = reinterpret_cast<size_t>(mVirtual) + mOffset;

	Block block;
	block.Offset = mOffset;
	block.Size = size;

	mOffset += size;

	void* casted = reinterpret_cast<void*>(ptr);

	mBlocks.insert(std::pair<void*, Block>(casted, block));
	
	cudaMemset(casted, 0xCD, size);

	return casted;
}

void CUMemory::Release(void* ptr)
{
	Block& block = mBlocks[ptr];
	size_t size = block.Size;

	mReleasedBlocks.insert(std::pair<void*, Block>(ptr, block));
	mBlocks.erase(ptr);

	
	
}
