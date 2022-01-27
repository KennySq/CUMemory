#include"pch.h"
#include<vector>

// default 2GB
// try extend when over use.

inline unsigned long long LowerUnit(unsigned long long size)
{
	return size << 10;
}

inline unsigned long long UpperUnit(unsigned long long size)
{
	return size >> 10;
}

struct CUMemoryPool
{
	CUMemoryPool(unsigned long long initialSize = 0);
	~CUMemoryPool();

	template<typename _Ty>
	_Ty* Alloc(size_t size)
	{
		size_t typeSize = sizeof(_Ty);
	
		size_t ptr = (reinterpret_cast<size_t>(mVirtual) + mOffset);
		
		mOffset += size;

		return reinterpret_cast<void*>(ptr);

	}
	
private:

	// 0x00000000' 00000000 ~ 0xFFFFFFFF' FFFFFFFF
	struct Page
	{
		Page(unsigned long long size, void* offset)
			: Size(size), Offset(offset)
		{

		}

		Page()
			: Size(-1), Offset(nullptr)
		{

		}

		unsigned long long Size;
		void* Offset;
	};

	void moveDevice(const Page& page);
	void moveHost(void* vtr, size_t size);

	void* mPhysical;
	void* mHostVirtual;

	void* mVirtual;
	size_t mOffset;

	unsigned long long mVMSize;
	const unsigned long long mPageSize;

	std::vector<CUMemoryPool::Page> mPages;
};