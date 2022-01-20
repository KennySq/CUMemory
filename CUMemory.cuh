#include"pch.h"

struct CUMemory
{
	struct Block
	{
		size_t Offset;
		size_t Size;
		bool bReleased;
	};
public:
	CUMemory(size_t initSize);
	~CUMemory();

	void* Alloc(size_t size);
	void Release(void* ptr);
private:
	void* mVirtual;
	size_t mSize;
	size_t mOffset;

	std::map<void*, Block> mBlocks;
};