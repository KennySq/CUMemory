#include"CUMemoryPool.cuh"
#include<Windows.h>

__device__ void* gGlobalMemory = nullptr;

CUMemoryPool::CUMemoryPool(unsigned long long initialSize)
	: mPageSize(LowerUnit(4)), mOffset(0)
	// mPageSize == 4KB
{
	if (initialSize == 0)
	{
		initialSize = 2147483648;
	}

	cudaError_t error = cudaMalloc(reinterpret_cast<void**>(gGlobalMemory), initialSize >> 1);
	if (error != NULL)
	{
		initialSize = initialSize >> 1;

		error = cudaMalloc(reinterpret_cast<void**>(gGlobalMemory), initialSize >> 1);
	
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
	cudaFree(gGlobalMemory);
	mPages.clear();
}

void CUMemoryPool::moveDevice(const Page& page)
{

	
}

void CUMemoryPool::moveHost(void* vtr, size_t size)
{
}
