#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

//==================================================================//
//==================================================================//
//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)//
//==================================================================//
//==================================================================//

void initialize_dyn_block_system()
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//kpanic_into_prompt("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
	LIST_INIT(&FreeMemBlocksList);
	uint32 startAdd = KERNEL_HEAP_START;
	struct MemBlock *blockToInsert =NULL;
	uint32 memblock_size = 0;
#if STATIC_MEMBLOCK_ALLOC
	//DO NOTHING
#else
	/*[2] Dynamically allocate the array of MemBlockNodes
	 * 	remember to:
	 * 		1. set MAX_MEM_BLOCK_CNT with the chosen size of the array
	 * 		2. allocation should be aligned on PAGE boundary
	 * 	HINT: can use alloc_chunk(...) function
	 */
	MAX_MEM_BLOCK_CNT = NUM_OF_KHEAP_PAGES; //((0xFFFFF000-0xF6000000)/PAGE_SIZE)
	memblock_size = MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock);
	memblock_size = ROUNDUP(memblock_size,PAGE_SIZE);
	allocate_chunk(ptr_page_directory, startAdd, memblock_size,PERM_WRITEABLE); // allocate heap
	MemBlockNodes = (struct MemBlock*) startAdd;
	for(uint32 i =0 ; i<MAX_MEM_BLOCK_CNT ;i++)
	{
//		memset(MemBlockNodes[i], 0 , sizeof(struct MemBlock)); // may error
			MemBlockNodes[i].prev_next_info.le_next=NULL;
			MemBlockNodes[i].prev_next_info.le_prev=NULL;
			MemBlockNodes[i].size=0;
			MemBlockNodes[i].sva=0;
	}

#endif
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);

	//[4] Insert a new MemBlock with the remaining heap size into the FreeMemBlocksList
//
	blockToInsert = LIST_FIRST(&(AvailableMemBlocksList));
	LIST_REMOVE(&(AvailableMemBlocksList), blockToInsert);
	blockToInsert->sva = startAdd + memblock_size; // comment when use static system

//	uint32 endAddDest = ROUNDUP(dest_va + (num_of_pages * PAGE_SIZE),PAGE_SIZE);
	blockToInsert->size = (MAX_MEM_BLOCK_CNT* PAGE_SIZE);


	blockToInsert->size -= memblock_size;         //MemBlockNodes->size; // comment when use static system


//	LIST_INSERT_HEAD(&(FreeMemBlocksList) , blockToInsert);
	insert_sorted_with_merge_freeList(blockToInsert);

}

void* kmalloc(unsigned int size)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kmalloc
	// your code is here, remove the panic and write your code
	//kpanic_into_prompt("kmalloc() is not implemented yet...!!");

	//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)
	//refer to the project presentation and documentation for details
	// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy
	//change this "return" according to your answer

	unsigned int SIZE = ROUNDUP(size,PAGE_SIZE);

	if(isKHeapPlacementStrategyFIRSTFIT()) // FIRSTFIT
	{
		struct MemBlock *allocated_block_FF =  alloc_block_FF(SIZE);
		if(allocated_block_FF != NULL)
		{
			allocate_chunk(ptr_page_directory, allocated_block_FF->sva, allocated_block_FF->size, PERM_WRITEABLE);
			insert_sorted_allocList(allocated_block_FF);
//			struct FrameInfo * ptr_frame_info = NULL ;
//			ptr_frame_info = to_frame_info((unsigned int)virtual_to_physical(ptr_page_directory,(uint32)ROUNDDOWN(allocated_block_FF->sva,PAGE_SIZE)));
			for(uint32 i = allocated_block_FF->sva; i < ROUNDUP((allocated_block_FF->sva + allocated_block_FF->size),PAGE_SIZE); i += PAGE_SIZE)
			{
				to_frame_info((unsigned int)virtual_to_physical(ptr_page_directory,(uint32)ROUNDDOWN\
						(i,PAGE_SIZE)))->va =(uint32) ROUNDDOWN(i,PAGE_SIZE);
			}
//		map_frame(ptr_page_directory, ptr_frame_info, (uint32)ROUNDDOWN(allocated_block_FF->sva,PAGE_SIZE),PERM_WRITEABLE);
			//			ptr_frame_info->va = allocated_block_FF->sva;
//			cprintf("physical_address %x\n",to_frame_info((unsigned int)virtual_to_physical(ptr_page_directory,(uint32)allocated_block_FF->sva))->va);
			return (void *) allocated_block_FF->sva;
		}
	}
	else if (isKHeapPlacementStrategyBESTFIT()) // BESTFIT
	{
		struct MemBlock *allocated_block_BF =  alloc_block_BF(SIZE);
		if(allocated_block_BF != NULL)
		{
			allocate_chunk(ptr_page_directory, allocated_block_BF->sva, allocated_block_BF->size, PERM_WRITEABLE);
			insert_sorted_allocList(allocated_block_BF);
			for(uint32 i = allocated_block_BF->sva; i < ROUNDUP((allocated_block_BF->sva + allocated_block_BF->size),PAGE_SIZE); i += PAGE_SIZE)
			{
				to_frame_info((unsigned int)virtual_to_physical(ptr_page_directory,(uint32)ROUNDDOWN\
						(i,PAGE_SIZE)))->va =(uint32) ROUNDDOWN(i,PAGE_SIZE);
			}
			return (void *) allocated_block_BF->sva;
		}
	}
	else if(isKHeapPlacementStrategyNEXTFIT()) // NEXTFIT
	{
		struct MemBlock *allocated_block_NF =  alloc_block_NF(SIZE);
		if(allocated_block_NF != NULL)
		{
			allocate_chunk(ptr_page_directory, allocated_block_NF->sva, allocated_block_NF->size, PERM_WRITEABLE);
			insert_sorted_allocList(allocated_block_NF);
			for(uint32 i = allocated_block_NF->sva; i < ROUNDUP((allocated_block_NF->sva + allocated_block_NF->size),PAGE_SIZE); i += PAGE_SIZE)
			{
				to_frame_info((unsigned int)virtual_to_physical(ptr_page_directory,(uint32)ROUNDDOWN\
						(i,PAGE_SIZE)))->va =(uint32) ROUNDDOWN(i,PAGE_SIZE);
			}
			return (void *) allocated_block_NF->sva;
		}
	}
	return (void *) NULL;
}

void kfree(void* virtual_address)
{
//	cprintf("KFREEEEEEEEEEEEE\n");
	//TODO: [PROJECT MS2] [KERNEL HEAP] kfree
	// Write your code here, remove the panic and write your code
	//panic("kfree() is not implemented yet...!!");

//	struct MemBlock *firstBlock = LIST_FIRST(&(FreeMemBlocksList));
//	if((uint32) virtual_address <= LIST_LAST(&(FreeMemBlocksList))->sva &&  (uint32) virtual_address >= LIST_FIRST(&(FreeMemBlocksList))->sva)
//	{
//	cprintf("HEllo, from NFOX the greatest coder from the kfree!\n");


	//	LIST_FOREACH(element, &(AllocMemBlocksList))
	//	{
	//		element->sva == (uint32) virtual_address;
	//		break;
	//	}
	    struct MemBlock *BLOCK = NULL;
		uint32 tmpAdd = ROUNDDOWN( (uint32) virtual_address,PAGE_SIZE);
		BLOCK = find_block(&(AllocMemBlocksList),tmpAdd);
		if( BLOCK != NULL ) // && (BLOCK->sva + BLOCK->size) < KERNEL_HEAP_MAX && BLOCK->sva >= KERNEL_HEAP_START+sizeof(MemBlockNodes)
		{
			for(uint32 i = tmpAdd; i < ROUNDUP((BLOCK->sva + BLOCK->size), PAGE_SIZE); i += PAGE_SIZE)
			{
				uint32 *ptr_page_temp = NULL;
				struct FrameInfo *ptr_frame_info = get_frame_info(ptr_page_directory,i,&ptr_page_temp);
//				free_frame(ptr_frame_info);
				unmap_frame(ptr_page_directory,i);
			}
			LIST_REMOVE(&(AllocMemBlocksList),BLOCK);
			insert_sorted_with_merge_freeList(BLOCK);
		}
//	}
}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_virtual_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_virtual_address() is not implemented yet...!!");

	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details
	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================

	struct FrameInfo * ptr_frame_info = NULL ;
//	cprintf("physical_address %x\n",physical_address);
	ptr_frame_info = to_frame_info(ROUNDDOWN((uint32)physical_address,PAGE_SIZE));
//	cprintf("virt %x\n",ptr_frame_info->va);

	if(ptr_frame_info != NULL)
	{
		return (unsigned int)ptr_frame_info->va;
	}
	return (unsigned int) NULL;
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_physical_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_physical_address() is not implemented yet...!!");

	//return the physical address corresponding to given virtual_address
	//refer to the project presentation and documentation for details

	return virtual_to_physical(ptr_page_directory,(uint32)virtual_address);
}


void kfreeall()
{
	panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
	panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
	panic("Not implemented!");
}




//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT MS2 - BONUS] [KERNEL HEAP] krealloc
	// Write your code here, remove the panic and write your code
	//panic("krealloc() is not implemented yet...!!");
	new_size = ROUNDUP(new_size, PAGE_SIZE);
	if(virtual_address == (void *)NULL && new_size != 0)
	{
		//new_size = ROUNDUP(new_size,PAGE_SIZE);
		return (void *) kmalloc(ROUNDUP((unsigned int)new_size, PAGE_SIZE));
	}
	else if(new_size == 0 && virtual_address != (void *)NULL)
	{
		kfree(virtual_address);
		return (void *) NULL;
	}
	else
	{
		virtual_address = (void *)ROUNDDOWN((uint32)virtual_address,PAGE_SIZE);

		struct MemBlock *element = NULL; // allocated block = element
		element = find_block(&(AllocMemBlocksList),(uint32)virtual_address); // allocated block

		struct MemBlock *nextElement = NULL;
		nextElement = find_block(&(FreeMemBlocksList),(uint32)(element->sva + element->size)); // free block

		if(element->size < new_size) // realloc   // two ways
		{
			uint32 perms = pt_get_page_permissions(ptr_page_directory,element->sva);
			uint32 sva = element->sva;
			uint32 size = element->size;
			if(nextElement == NULL || nextElement->size < (new_size - element->size)) // bestFit
			{
				//nextElement == NULL ||
//				cprintf("\nhello\n");
//				cprintf("va = %x\n",virtual_address);


				struct MemBlock *allocated_block_BF =  alloc_block_BF(new_size);

				if(allocated_block_BF == NULL)
				{
//					cprintf("element->size  ffffffffff= %x\n",element->size); // may element->size & element->sva = 0

					return (void *) NULL;
				}
				else // block found by best fit
				{
					int ret = cut_paste_pages(ptr_page_directory,ROUNDDOWN((uint32)virtual_address, PAGE_SIZE),(uint32)allocated_block_BF->sva, ROUNDUP(element -> size, PAGE_SIZE)/4096);

//					cprintf("returnedVA after kfree = %d\t%d\n",ROUNDUP(element -> size, PAGE_SIZE)/4096, ret);

					ret = allocate_chunk(ptr_page_directory,ROUNDUP((allocated_block_BF->sva + element->size), PAGE_SIZE), new_size - element-> size, perms);
//					cprintf("HEllo, from NFOX the greatest coder ever! %x \t %x \t %d\t%d\n", allocated_block_BF->sva, (allocated_block_BF->sva + element->size), (new_size - element->size)/PAGE_SIZE, ret);
					insert_sorted_allocList(allocated_block_BF);
					LIST_REMOVE(&AllocMemBlocksList, element);
					insert_sorted_with_merge_freeList(element);

					return (void *) allocated_block_BF->sva;
				}
			}
			else if(nextElement != NULL && nextElement->size >= (new_size - element->size)) // (new_size - element->size) == new size of new block
			{
//				cprintf("\n hello 2 \n");
				struct MemBlock *tmp = element;
				allocate_chunk(ptr_page_directory, tmp->sva+tmp->size, (new_size - tmp->size), perms); // PERM_WRITEABLE
				nextElement -> size -= (new_size - element->size);
				nextElement -> sva += (new_size - element->size);
//				cprintf("element->sva = %x\n",element->sva);
//				cprintf("element->sva = %x\n",element->sva);
//				cprintf("tmp->sva = %x\n",tmp->sva);
//				cprintf("tmp->size = %x\n",tmp->size);
				tmp->size = new_size;
//				cprintf("tmp->sva = %x\n",tmp->sva);
//				cprintf("tmp->size = %x\n",tmp->size);
//				cprintf("new size = %x\n",new_size);
				if(nextElement->size == 0)
				{
					nextElement -> sva = 0;
					LIST_REMOVE(&FreeMemBlocksList, nextElement);
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
				}
				for(uint32 i = (uint32)virtual_address; i < ROUNDUP((uint32)virtual_address + (new_size),PAGE_SIZE); i += PAGE_SIZE)
				{
					to_frame_info((unsigned int)virtual_to_physical(ptr_page_directory,(uint32)ROUNDDOWN\
							(i,PAGE_SIZE)))->va =(uint32) ROUNDDOWN(i,PAGE_SIZE);
				}
				return (void *) virtual_address;
			}
		}

		return (void *) virtual_address;

	}
	return (void *) virtual_address;
}
