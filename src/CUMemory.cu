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
	for (std::map<void*, Block>::iterator itr = mReleasedBlocks.begin(); itr != mReleasedBlocks.end(); itr++)
	{
		if (itr->second.Size > size)
		{
			Block newBlock;
			newBlock.Offset = itr->second.Offset;
			newBlock.Size = size;
			
			if (itr->second.Size - size != 0)
			{
				Block rest;
				rest.Offset = itr->second.Offset + size;
				rest.Size = itr->second.Size - size;


				size_t restPtr = (size_t)itr->first + size;
				mReleasedBlocks.insert(std::make_pair(reinterpret_cast<void*>(restPtr), rest));
			}

			void* ptr = reinterpret_cast<void*>(reinterpret_cast<size_t>(mVirtual) + itr->second.Offset);
			mReleasedBlocks.erase(itr->first);
			mBlocks.insert(std::make_pair(ptr, newBlock));

			cudaMemset(ptr, 0xCD, size);

			return ptr;
		}
	}

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
