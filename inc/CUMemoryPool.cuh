#include"pch.h"
#include<vector>
#include<unordered_map>

// default 2GB
// try extend when over use.

inline size_t LowerUnit(size_t size)
{
	return size << 10;
}

inline size_t UpperUnit(size_t size)
{
	return size >> 10;
}

inline void* MoveOffset(void* ptr, size_t offset)
{
	size_t addr = reinterpret_cast<size_t>(ptr) + offset;

	return reinterpret_cast<void*>(addr);
}

struct CUMemoryPool
{
	CUMemoryPool(size_t initialSize = 0);
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
		Page(unsigned long long size)
			: Size(size), Offset(mPageOffset)
		{
			mPageOffset += size;
		}

		Page()
			: Size(-1), Offset(-1)
		{

		}

		size_t Size;
		size_t Offset;
	};

	void moveDevice(const Page& page);
	void moveHost(void* vtr, size_t size);

	void* mPhysical;
	void* mHostVirtual;

	void* mVirtual;
	size_t mOffset;

	unsigned long long mVMSize;
	const unsigned long long mPageSize;

	static size_t mPageOffset;

	std::unordered_map<const CUMemoryPool::Page&, size_t> mPages;
};