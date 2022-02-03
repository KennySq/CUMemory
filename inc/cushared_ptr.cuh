#include"pch.h"
#include<assert.h>
__device__ void* gGlobalMemory;

template<typename _Ty>
class cushared_ptr
{
public:

	cushared_ptr()
		: mPtr(nullptr), mRefCount(0)
	{
		size_t size = sizeof(_Ty);

		cudaError_t error = cudaMalloc(reinterpret_cast<void**>(&gGlobalMemory), size);
		assert(error == NULL);

		mPtr = gGlobalMemory;
		if (mRefCount == nullptr)
		{
			mRefCount = new unsigned int(0);
		}
		
		addRef();

	}

	cushared_ptr<_Ty>(cushared_ptr& other)
		: mPtr(other.mPtr), mRefCount(other.mRefCount)
	{
		addRef();
	}
	
	~cushared_ptr<_Ty>()
	{
		release();

		if (*mRefCount == 0)
		{
			cudaFree(mPtr);
		}
	}

private:
	friend cushared_ptr<_Ty> make_cushared();

	void addRef()
	{
		*mRefCount += 1;
	}
	void release()
	{
		*mRefCount -= 1;
	}

	void* mPtr;
	unsigned int* mRefCount;
};

template<typename _Ty>
cushared_ptr<_Ty> make_cushared()
{
	return cushared_ptr<_Ty>();
}