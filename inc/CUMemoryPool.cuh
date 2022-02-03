#include"pch.h"
#include<vector>
#include<unordered_map>

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
	_Ty* Alloc(size_t count)
	{
		size_t typeSize = sizeof(_Ty);
		size_t size = count * typeSize;
		unsigned int pageCount = size / mPageSize;

		// when data is too large for a single page.
		if(size > mPageSize)
		{
			for (int i = 0; i < pageCount; i++)
			{
				Page p;

				p.Size += (size % mPageSize) > 0 ? (size % mPageSize) : mPageSize;
				p.Offsets.push_back(0);

				mPages[mPageCount] = p;
				mPageMap.insert_or_assign(mLogicalOffset, p);

				mPageCount++;

				mLogicalOffset += mPageSize;

			}
		}
		else
		{
			Page& p = findUnfilledPage(size);

			p.Size += size;
			p.Offsets.push_back(p.Size);
		}


		return nullptr;
	}
	
private:

	// 0x00000000' 00000000 ~ 0xFFFFFFFF' FFFFFFFF
	struct Page
	{
		Page()
			: Size(0)
		{

		}

		std::vector<size_t> Offsets;
		unsigned long long Size;
	};

	void* mVirtual;
	size_t mOffset;

	unsigned long long mVMSize;
	const unsigned long long mPageSize;
	unsigned long long mLogicalOffset;
	unsigned long long mPageCount;

	std::vector<CUMemoryPool::Page> mPages;

	// size_t : logical offset
	std::unordered_map<size_t, CUMemoryPool::Page> mPageMap;

	Page& findUnfilledPage(size_t size);
};