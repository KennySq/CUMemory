#include"CUMemoryPool.cuh"
#include<Windows.h>

__device__ void* gGlobalMemory0 = nullptr;
__device__ void* gGlobalMemory1 = nullptr;
__device__ void* gGlobalMemory2 = nullptr;
__device__ void* gGlobalMemory3 = nullptr;

CUMemoryPool::CUMemoryPool(unsigned long long initialSize)
	: mPageSize(LowerUnit(4)), mOffset(0), mLogicalOffset(0)
	// mPageSize == 4KB == 4096 bytes
{
	if (initialSize == 0)
	{
		initialSize = 2147483648;
	}

	cudaError_t error = cudaMalloc(reinterpret_cast<void**>(gGlobalMemory0), initialSize >> 1);
	if (error != NULL)
	{
		initialSize = initialSize >> 1;

		error = cudaMalloc(reinterpret_cast<void**>(gGlobalMemory0), initialSize >> 1);
	
		if (error != NULL)
		{
#ifdef _DEBUG
			std::cout << "Insufficient Video Memory.\n";
#endif
			return;
		}
	}

	int pageCount = (initialSize >> 1) / mPageSize;
	mPages.resize(pageCount);


	
	
}

CUMemoryPool::~CUMemoryPool()
{
	cudaFree(gGlobalMemory0);
	mPages.clear();
}

CUMemoryPool::Page& CUMemoryPool::findUnfilledPage(size_t size)
{
	for (auto i : mPageMap)
	{
		if (i.second.Size >= mPageSize)
		{
			continue;
		}

		if ((mPageSize - i.second.Size) >= size)
		{
			return i.second;
		}
	}

	mPageMap.insert_or_assign(mLogicalOffset, Page());

	Page& out = mPageMap[mLogicalOffset];

	mLogicalOffset += mPageSize;

	return out;
}


