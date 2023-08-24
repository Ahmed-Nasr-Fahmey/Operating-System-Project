
/*
 * dyn_block_management.c
 *
 *  Created on: Sep 21, 2022
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"
struct MemBlock* Last = NULL;

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
	cprintf("\n=========================================\n");

}

//********************************************************************************//
//********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

//	if(numOfBlocks <= 10000) // for static MemBlockNodes
//	{
		for(int i = 0; i < numOfBlocks; i++)
		{
			MemBlockNodes[i].size = 0;
			MemBlockNodes[i].sva = 0;
			LIST_INSERT_TAIL(&(AvailableMemBlocksList), &MemBlockNodes[i]);
		}
//	}
}

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	struct MemBlock *element;

	LIST_FOREACH(element ,blockList)
	{
		if(element->sva == va)
			return element;
	}


	return NULL;
}

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	struct MemBlock *element;
	struct MemBlock *next;

	if(LIST_EMPTY(&AllocMemBlocksList) || AllocMemBlocksList.lh_first->sva > blockToInsert->sva) // insert head
	{
		 LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
	}
	else if(AllocMemBlocksList.lh_last->sva < blockToInsert->sva) //insert tail
	{
		LIST_INSERT_TAIL(&(AllocMemBlocksList),blockToInsert);
	}
	else{
		  LIST_FOREACH(element,&(AllocMemBlocksList)){
		  if(element->sva < blockToInsert->sva && blockToInsert->sva<LIST_NEXT(element)->sva){
//			next = LIST_NEXT(element);
//
//			element->prev_next_info.le_next = blockToInsert;
//			blockToInsert->prev_next_info.le_prev =element;
//
//			blockToInsert->prev_next_info.le_next=next;
//			next->prev_next_info.le_prev=blockToInsert;
//
//			AllocMemBlocksList.size +=1;

			  LIST_INSERT_AFTER(&(AllocMemBlocksList),element,blockToInsert);
			break;
			}
		}
	}
}

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	 struct MemBlock *element;
	 struct MemBlock *tmp;

	 LIST_FOREACH(element, &(FreeMemBlocksList))
	 {

		   if(element->size == size) // block is found with EXACT size
		   {
				tmp = element;

				LIST_REMOVE(&(FreeMemBlocksList), element);

				return tmp;
		   }

		   else if(element->size > size) //  block is found with GREATER size
		   {

				struct MemBlock* felement = LIST_FIRST(&(AvailableMemBlocksList));
				tmp = felement;
				LIST_REMOVE(&(AvailableMemBlocksList), felement);

				tmp->size = size;
				tmp->sva = element->sva;

				element->size = element->size - size;
				element->sva = tmp->sva + size;


				return tmp;

		   }
	  }

	 return NULL;  // no suitable block
}

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
    //TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
    // Write your code here, remove the panic and write your code
    // panic("alloc_block_BF() is not implemented yet...!!");
	struct MemBlock *element;
	struct MemBlock *tmp;

	struct MemBlock* Mini_block = LIST_FIRST(&(AvailableMemBlocksList));
	int flag = 0;
	LIST_FOREACH(element, &(FreeMemBlocksList)) // NULL
	{
		if(element->size >= size)
		{
			flag = 1;
		}

	}
	if(flag != 1)
	{
		return NULL;
	}

	LIST_FOREACH(element, &(FreeMemBlocksList)) // block is found with EXACT size
	{
		if(element->size == size)
		{
			tmp = element;
			LIST_REMOVE(&(FreeMemBlocksList), element);

			return tmp;
		}

	}
	Mini_block->size = 0xFFFFFFFF;
	LIST_FOREACH(element, &(FreeMemBlocksList)) // block is found with GREATER size
	{
		if(element->size > size)
		{
			if(element->size < Mini_block->size)
			{
				// Mini_block = element;  // Not working !!!
				Mini_block->sva = element->sva;
				Mini_block->size = element->size;

			}
		}
	}


	LIST_FOREACH(element, &(FreeMemBlocksList)) // block is found with GREATER size
	{
		if(element->sva == Mini_block->sva)
		{
			Mini_block->size = size;
			//Mini_block->sva = element->sva;
			element->sva += size;
			element->size -= size;
			LIST_REMOVE(&(AvailableMemBlocksList), Mini_block);
//			AvailableMemBlocksList.size--;
			break;
		}
	}
	return Mini_block;

}



//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
//	struct MemBlock* element;
//	if(Last == NULL) // first element
//	{
//		  LIST_FOREACH(element, &(FreeMemBlocksList))
//			{
//				if(element->size == size) // block is found with EXACT size empty alloc. list
//				{
//					Last = element;  // may erorr
//					Last->sva = element->sva;
//					Last->size = element->size;
//					LIST_REMOVE(&(FreeMemBlocksList), element);
//					return Last;
//				}
//				else if(element->size > size) // block is found with GREATER size empty alloc. list
//				{
//					struct MemBlock* felement = LIST_FIRST(&(AvailableMemBlocksList));
//					Last = felement; // may erorr
//					Last->sva = felement->sva;
//					Last->size = felement->size;
//					LIST_REMOVE(&(AvailableMemBlocksList), felement);
//					Last->size = size;
//					Last->sva = element->sva;
//					element->size = element->size - size;
//					element->sva = Last->sva + size;
//					return Last;
//				}
//			}
//		return NULL;
//	}
//
//	LIST_FOREACH(element,&(FreeMemBlocksList))
//	{
//		if(element->sva > Last->sva) // after last element
//		{
//			 if(element->size == size) // block is found with EXACT size empty alloc. list
//			{
//				Last = element; // may erorr
//				 Last->sva = element->sva;
//				 Last->size = element->size;
//				LIST_REMOVE(&(FreeMemBlocksList), element);
//				return Last;
//			}
//			else if(element->size > size) // block is found with GREATER size empty alloc. list
//			{
//				struct MemBlock* felement = LIST_FIRST(&(AvailableMemBlocksList));
//				Last = felement; // may erorr
//				Last->sva = felement->sva;
//				Last->size = felement->size;
//				LIST_REMOVE(&(AvailableMemBlocksList), felement);
//				Last->size = size;
//				Last->sva = element->sva;
//				element->size = element->size - size;
//				element->sva = Last->sva + size;
//				return Last;
//			}
//		}
//	}
//
//	LIST_FOREACH(element,&(FreeMemBlocksList))
//		{
//			if(element->sva < Last->sva) // befor last element
//			{
//				 if(element->size == size) // block is found with EXACT size empty alloc. list
//				{
//					Last = element; // may erorr
//					 Last->sva = element->sva;
//					 Last->size = element->size;
//					LIST_REMOVE(&(FreeMemBlocksList), element);
//					return Last;
//				}
//				else if(element->size > size) // block is found with GREATER size empty alloc. list
//				{
//					struct MemBlock* felement = LIST_FIRST(&(AvailableMemBlocksList));
//					Last = felement; // may erorr
//					Last->sva = felement->sva;
//					Last->size = felement->size;
//					LIST_REMOVE(&(AvailableMemBlocksList), felement);
//					Last->size = size;
//					Last->sva = element->sva;
//					element->size = element->size - size;
//					element->sva = Last->sva + size;
//					return Last;
//				}
//			}
//		}
////	return Last;
//	return NULL;

}

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

	struct MemBlock *element;

	if(LIST_EMPTY(&(FreeMemBlocksList))) // insert head
	{
		LIST_INSERT_HEAD(&(FreeMemBlocksList) , blockToInsert);
	}
	else
	{
		LIST_FOREACH(element, &(FreeMemBlocksList))
		{

			 if((blockToInsert->sva + blockToInsert->size) == LIST_FIRST(&(FreeMemBlocksList))->sva) //insert & merge head
			 {
				 element->sva -= blockToInsert->size;
				 element->size += blockToInsert->size;
				 blockToInsert->size = 0;
				 blockToInsert->sva = 0;
//				 memset(blockToInsert, 0 , sizeof(struct MemBlock));
				 LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
				 break;
			 }
			 else if((blockToInsert->sva + blockToInsert->size) < LIST_FIRST(&(FreeMemBlocksList))->sva) //insert head
			 {
				 LIST_INSERT_HEAD(&(FreeMemBlocksList) , blockToInsert);
				 break;
			 }
			 else if((element->sva + element->size) == blockToInsert->sva && LIST_NEXT(element) == NULL) //insert & merge tail
			 {
				 element->size += blockToInsert->size;
				 blockToInsert->size = 0;
				 blockToInsert->sva = 0;
//				 memset(blockToInsert, 0 , sizeof(struct MemBlock));
				 LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
				 break;
			 }
			 else if(LIST_NEXT(element) == NULL) //insert tail
			 {
				 LIST_INSERT_TAIL(&(FreeMemBlocksList), blockToInsert);
				 break;
			 }
			 else // insert 2 blocks
			 {
				 if((element->sva + element->size) < blockToInsert->sva && (blockToInsert->sva + blockToInsert->size) < LIST_NEXT(element)->sva) // No merge
				 {
					 LIST_INSERT_AFTER(&(FreeMemBlocksList), element, blockToInsert);
					 break;
				 }
				 else if((element->sva + element->size) == blockToInsert->sva && (blockToInsert->sva + blockToInsert->size) < LIST_NEXT(element)->sva) // merge priv
				 {
					 element->size = element->size + blockToInsert->size;
					 blockToInsert->size = 0;
					 blockToInsert->sva = 0;
//					 memset(blockToInsert, 0 , sizeof(struct MemBlock));
					 LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
					 break;
				 }
				 else if((element->sva + element->size) < blockToInsert->sva && (blockToInsert->sva + blockToInsert->size) == LIST_NEXT(element)->sva) // merge next
				 {
					 element->prev_next_info.le_next->sva -= blockToInsert->size;
					 element->prev_next_info.le_next->size += blockToInsert->size;
					 blockToInsert->size = 0;
					 blockToInsert->sva = 0;
//					 memset(blockToInsert, 0 , sizeof(struct MemBlock));
					 LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
					 break;
				 }
				 else if((element->sva + element->size) == blockToInsert->sva && (blockToInsert->sva + blockToInsert->size) == LIST_NEXT(element)->sva) // merge priv & next
				 {
					 struct MemBlock* Next = element->prev_next_info.le_next;
					 element->size += (blockToInsert->size + Next->size);
//					 memset(Next, 0 , sizeof(struct MemBlock));
					 LIST_REMOVE(&(FreeMemBlocksList), Next);
					 Next->sva = 0;
					 Next->size = 0;
					 LIST_INSERT_HEAD(&(AvailableMemBlocksList), Next);
					 blockToInsert->size = 0;
					 blockToInsert->sva = 0;
//					 memset(blockToInsert, 0 , sizeof(struct MemBlock));
					 LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);

					 break;
				 }
			 }
		}
	}
}


