/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include "kheap.h"
#include "memory_manager.h"


/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 num_of_pages)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] cut_paste_pages
	// Write your code here, remove the pani`c and write your code
	//panic("cut_paste_pages() is not implemented yet...!!");
	uint32 startAddDest = ROUNDDOWN(dest_va,PAGE_SIZE);
	uint32 endAddDest = ROUNDUP(dest_va + (num_of_pages * PAGE_SIZE),PAGE_SIZE);
	for(uint32 i = startAddDest; i < endAddDest; i += PAGE_SIZE)
	{
		uint32 *ptr_page_table = NULL;
		struct FrameInfo* ptr_frame_info = get_frame_info(page_directory, i, &ptr_page_table);
		if (ptr_frame_info != NULL)// check page entry
		{
				return -1;
		}
	}
	for(uint32 i = startAddDest; i < endAddDest; i += PAGE_SIZE)
	{
		uint32 *ptr_page_table = NULL;
		get_page_table(page_directory,i, &ptr_page_table);
		if ( ptr_page_table ==  NULL) // va has no page table
		{
			create_page_table(page_directory, i);
		}
	}
	//	for(uint32 i = startAddDest; i < endAddDest; i += PAGE_SIZE) // Allocata & Map Dest.
		//	{
		//		struct FrameInfo *ptr_frame_info ;
		//		//allocate_frame(&ptr_frame_info) ;
		//		map_frame(ptr_page_directory, ptr_frame_info, i, pt_get_page_permissions(ptr_page_directory,tmp_Sourse_va ));
		//		tmp_Sourse_va += PAGE_SIZE;
		//	}
	//		for(unsigned char * i = (unsigned char *) startAddSource; i <= (unsigned char *) endAddSource; i++)
	//		{
	//			unsigned char *dest_ptr = (unsigned char *) startAddDest;  // read & write
	//			unsigned char *Source_ptr = i;
	//			*dest_ptr = *Source_ptr;
	//			(unsigned char *) startAddDest ++;
	//		}
	uint32 startAddSource = ROUNDDOWN(source_va,PAGE_SIZE);
	uint32 endAddSource = ROUNDUP(source_va + (num_of_pages * PAGE_SIZE),PAGE_SIZE);
	uint32 tmp_dest_va = startAddDest;
	for(uint32 i = startAddSource; i < endAddSource; i += PAGE_SIZE) // cut & paste
	{
		uint32 *ptr_page_table = NULL;
		struct FrameInfo* ptr_frame_info_source = get_frame_info(page_directory, i, &ptr_page_table);
		map_frame(page_directory, ptr_frame_info_source, tmp_dest_va, pt_get_page_permissions(page_directory,i));// cut & paste
		unmap_frame(page_directory, i); // remove source
		tmp_dest_va += PAGE_SIZE;
	}
	return 0;

	//	uint32 tmpstartAddDest = startAddDest;
	//	for(uint32 i = 0; i < num_of_pages; i++)
	//	{
	//		uint32 *ptr_page_table = NULL;
	//		struct FrameInfo* ptr_frame_info = get_frame_info(ptr_page_directory, tmpstartAddDest, &ptr_page_table);
	//		if (ptr_frame_info != NULL)// check page entry
	//		{
	//				return -1;
	//		}
	//		else
	//		{
	//			tmpstartAddDest += PAGE_SIZE;
	//		}
	//
	//	}

//	uint32 startAddSource = ROUNDDOWN(source_va,PAGE_SIZE);
//	uint32 endAddSource = ROUNDUP(source_va + (num_of_pages * PAGE_SIZE),PAGE_SIZE);
//
//	uint32 tmp_dest_va = dest_va;
////  Allocate frame from free frame list then map vPage to allocated frame then unmap source then return unmaped frame to free frame list
//	for(uint32 i = startAddSource; i < endAddSource; i += PAGE_SIZE)
//	{
//
//		uint32 *ptr_page_table = NULL;
//		struct FrameInfo* ptr_frame_info = get_frame_info(ptr_page_directory, i, &ptr_page_table);
//		int perm_to_set = pt_get_page_permissions(ptr_page_directory, i); // get perm from source
//		//                            source frame     va of destna
//		map_frame(ptr_page_directory, ptr_frame_info, tmp_dest_va, perm_to_set);
//		cprintf("perm error\n");
//		unmap_frame(ptr_page_directory, i);
//
////		int perm_to_set = pt_get_page_permissions(ptr_page_directory, i); // get perm from source
////		int perm_to_clear = pt_get_page_permissions(ptr_page_directory, tmp_dest_va);
//	//	cprintf("perm error\n");
//
////		uint32 *ptr_page_table_src = NULL;
////		uint32 *ptr_page_table_dest = NULL;
////		struct FrameInfo * ptr_frame_info = get_frame_info(ptr_page_directory, tmp_dest_va, &ptr_page_table_dest);
////		struct FrameInfo * ptr_frame_info2 = get_frame_info(ptr_page_directory, i, &ptr_page_table_src);
//
////		map_frame(ptr_page_directory, ptr_frame_info, tmp_dest_va, perm_to_set); // update perm. of dest.
//		//cprintf("perm error2\n");
////     	pt_set_page_permissions(ptr_page_directory,tmp_dest_va,perm_to_set,perm_to_clear);
////		ptr_page_table_dest[PTX(tmp_dest_va)] = ptr_page_table_src[PTX(i)];
//
////		unmap_frame(ptr_page_directory, i);
//
////		free_frame(to_frame_info(virtual_to_physical(ptr_page_directory, i)));
//	//	cprintf("perm error3\n");
//
//		tmp_dest_va += PAGE_SIZE;
//	}
//
}

//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 size)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] copy_paste_chunk
	// Write your code here, remove the panic and write your code
	//panic("copy_paste_chunk() is not implemented yet...!!");

	uint32 startAddSource = ROUNDDOWN(source_va,PAGE_SIZE);
	uint32 tmpstartAddSource = startAddSource;
	uint32 endAddSource = ROUNDUP(source_va + size,PAGE_SIZE);

	uint32 startAddDest = ROUNDDOWN(dest_va,PAGE_SIZE);

	uint32 endAddDest = ROUNDUP(dest_va + size,PAGE_SIZE);

	for(uint32 i = startAddDest; i < endAddDest; i += PAGE_SIZE) // check PERM_WRITEABLE
	{
		uint32 *ptr_page_table = NULL;
		struct FrameInfo* ptr_frame_info = get_frame_info(page_directory, i, &ptr_page_table);
		if (ptr_frame_info != NULL)// check page entry
		{
				if((pt_get_page_permissions(page_directory, i) & PERM_WRITEABLE) != PERM_WRITEABLE)
				{
					return -1;
				}
		}
	}

	for(uint32 i = startAddDest; i < endAddDest; i += PAGE_SIZE) //check page tabel exist or not
	{
		uint32 *ptr_page_table = NULL;
		get_page_table(page_directory,i, &ptr_page_table);
		if ( ptr_page_table ==  NULL) // va has no page table
		{
			create_page_table(page_directory, i);
		}
	}

	for(uint32 i = startAddDest; i < endAddDest; i += PAGE_SIZE) // check page exist or not
	{
		uint32 *ptr_page_table = NULL;
		struct FrameInfo* ptr_frame_info = get_frame_info(page_directory, i, &ptr_page_table);
		if (ptr_frame_info == NULL)// check page entry
		{
			allocate_frame(&ptr_frame_info);
			map_frame(page_directory, ptr_frame_info, i, pt_get_page_permissions(page_directory, tmpstartAddSource));
		}
//		else
//		{
//			pt_set_page_permissions(page_directory, i, pt_get_page_permissions(page_directory, tmpstartAddSource), pt_get_page_permissions(page_directory, i));
//		}
		tmpstartAddSource += PAGE_SIZE;
	}

//	char * tmpStartAddDest = ( char *) startAddDest;
	char * tmpStartAddDest = ( char *) dest_va;
//	for( char * i = ( char *) startAddSource; i < ( char *) endAddSource; i++) // read & write
	for( char * i = ( char *) source_va; i < ( char *) (source_va + size); i++)// read & write chunk content only without fragementation
	{
//		char *Source_ptr = i;
		*tmpStartAddDest = *i;

		//cprintf("source %x",*Source_ptr);
		//cprintf("Dest before  %x",*tmpStartAddDest);
//		cprintf("Dest before  %x",tmpStartAddDest);
		tmpStartAddDest++;
		//cprintf("Destafter %x",*tmpStartAddDest);
//		cprintf("Dest before  %x",tmpStartAddDest);
//		break;
	}

	return 0;
}

//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should share the given size from dest_va with the source_va
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int share_chunk(uint32* page_directory, uint32 source_va,uint32 dest_va, uint32 size, uint32 perms)
{
    //TODO: [PROJECT MS2] [CHUNK OPERATIONS] share_chunk
    // Write your code here, remove the panic and write your code
    //panic("share_chunk() is not implemented yet...!!");

    uint32 sourceStart = ROUNDDOWN(source_va,PAGE_SIZE);
    uint32 sourceEnd = ROUNDUP(source_va+size,PAGE_SIZE);

    uint32 destStart = ROUNDDOWN(dest_va,PAGE_SIZE);
    uint32 destEnd = ROUNDUP(dest_va+size,PAGE_SIZE);

    for(uint32 i = destStart; i < destEnd; i += PAGE_SIZE)
    {
        uint32* ptr_page_tableDest = NULL;
        get_page_table(page_directory,i,&ptr_page_tableDest);
        struct FrameInfo* ptr_frame_info = get_frame_info(page_directory,i, &ptr_page_tableDest);
        if (ptr_frame_info != NULL)// check page entry
        {
                        return -1;
        }
    }
    for(uint32 i = destStart; i <destEnd; i += PAGE_SIZE)
    {
        uint32* ptr_page_tableDest = NULL;
        get_page_table(page_directory,i,&ptr_page_tableDest);
        if ( ptr_page_tableDest ==  NULL) // check page table
        {
            ptr_page_tableDest=create_page_table(page_directory, i);
        }
    }

    for(uint32 source_va = sourceStart,dest_va = destStart ; source_va < sourceEnd; source_va += PAGE_SIZE,dest_va += PAGE_SIZE)  // share
    {
        uint32* ptr_page_tableSource = NULL;
        uint32* ptr_page_tableDest = NULL;

        get_page_table(page_directory,source_va, &ptr_page_tableSource);
        get_page_table(page_directory,dest_va, &ptr_page_tableDest);

        struct FrameInfo* ptr_frame_info_source = get_frame_info(page_directory, source_va, &ptr_page_tableSource);
        map_frame(page_directory,ptr_frame_info_source,dest_va,perms); // map from source to dest.
    }
    return 0;
}

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate in RAM the given range [va, va+size)
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] allocate_chunk
		    // Write your code here, remove the panic and write your code
		    uint32 tmpEnd = ROUNDUP(va+size,PAGE_SIZE);
		    uint32 tmpStart = ROUNDDOWN(va,PAGE_SIZE);

		    for(uint32 i = tmpStart; i < tmpEnd; i += PAGE_SIZE)
		    {
		        uint32 *ptr_page_table = NULL;
		        get_page_table(page_directory,i, &ptr_page_table);
		        struct FrameInfo* ptr_frame_info = get_frame_info(page_directory, i, &ptr_page_table);
		        if (ptr_frame_info != NULL)// check page entry
		        {
		                return -1;
		        }
		    }
		    for(uint32 i = tmpStart; i < tmpEnd; i += PAGE_SIZE)
		    {
		        uint32 *ptr_page_table = NULL;
		        get_page_table(page_directory,i, &ptr_page_table);
		        if ( ptr_page_table ==  NULL) // va has no page table
		        {
		            create_page_table(page_directory, i);
		        }
		    }

		    for(uint32 i = tmpStart; i < tmpEnd; i += PAGE_SIZE) // allocate
		    {
		        uint32 *ptr_page_temp = NULL;
		        struct FrameInfo *ptr_frame_info = get_frame_info(page_directory,i,&ptr_page_temp);
		        allocate_frame(&ptr_frame_info);
		        map_frame(page_directory, ptr_frame_info, i, perms);
		    }

		    return 0;

}

/*BONUS*/
//=====================================
// 5) CALCULATE ALLOCATED SPACE IN RAM:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva, uint32 *num_tables, uint32 *num_pages)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_allocated_space
	// Write your code here, remove the panic and write your code
	//panic("calculate_allocated_space() is not implemented yet...!!");

	uint32 startAdd = ROUNDDOWN(sva,PAGE_SIZE);
	uint32 endAdd = ROUNDUP(eva,PAGE_SIZE);
	uint32 *ptr_Prev_page_table = NULL;
    int flag = 0;
	for(uint32 i = startAdd; i < endAdd; i += PAGE_SIZE)
	{
		uint32 *ptr_page_table = NULL;
		struct FrameInfo* ptr_frame_info = get_frame_info(page_directory, i, &ptr_page_table);
		if(ptr_frame_info != NULL)
		{
			flag = 1;
			if (ptr_frame_info->references != 0)// allocated page
			{

				(*num_pages)++;

				if((*num_tables) == 0) // first table
				{
//					cprintf(" first table\n");

					(*num_tables)++;
				}
				else if(ptr_Prev_page_table != ptr_page_table) // New table
				{
//					cprintf(" new table\n");
					(*num_tables)++;
				}
				ptr_Prev_page_table = ptr_page_table;
			}
		}


	}
	if(flag == 0) // if page table exist without pages
	{
		for(uint32 i = startAdd; i < endAdd; i += PAGE_SIZE)
		{
			uint32 *ptr_page_table_2 = NULL;
			int ret = get_page_table(page_directory, i, &ptr_page_table_2);
			if (ret ==  TABLE_IN_MEMORY)
			{
				(*num_tables)++;
			}
	}
}



}

/*BONUS*/
//=====================================
// 6) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
// calculate_required_frames:
// calculates the new allocation size required for given address+size,
// we are not interested in knowing if pages or tables actually exist in memory or the page file,
// we are interested in knowing whether they are allocated or not.
uint32 calculate_required_frames(uint32* page_directory, uint32 sva, uint32 size)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_required_frames
	// Write your code here, remove the panic and write your code

	uint32 startAdd = ROUNDDOWN(sva,PAGE_SIZE);
	uint32 endAdd = ROUNDUP(sva+size,PAGE_SIZE);
	uint32 count = 0;
	bool found = 0;
	for(uint32 i = startAdd ; i < endAdd ; i += PAGE_SIZE)
	{
		uint32 *ptr_page_table = NULL;
	    struct FrameInfo* ptr_frame_info = get_frame_info(page_directory, i, &ptr_page_table);
	    if(ptr_frame_info == NULL)
	    {
	    	count++;
	    }

	}

	for(uint32 i = startAdd ; i < endAdd ; i += PAGE_SIZE)
	{
		uint32 *ptr_page_table = NULL;
		get_page_table(page_directory,i,&ptr_page_table);
		uint32 tmp1 = i >> 22;
		tmp1 = tmp1 << 22;
		uint32 tmp2 = (i+PAGE_SIZE) >> 22;
		tmp2 = tmp2 << 22;
		if(ptr_page_table == NULL)
		{
			if(i == (endAdd - PAGE_SIZE) || startAdd == (endAdd-PAGE_SIZE))
				count++;
			else if(tmp1 != tmp2)
			{
//				cprintf("count = %d\n",count);
				count++;
//				cprintf("count = %d\n",count);
		    	found = 1;
			}
		}

	}

	if(count == 1 && found)
		return 2;

	return count;
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================

//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	// Write your code here, remove the panic and write your code
	panic("allocate_user_mem() is not implemented yet...!!");
}

//=====================================
// 2) FREE USER MEMORY:
//=====================================
void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3] [USER HEAP - KERNEL SIDE] free_user_mem
	// Write your code here, remove the panic and write your code
	//panic("free_user_mem() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
//	cprintf("Hello\n");
	for(uint32 i = virtual_address; i < ROUNDUP((virtual_address + size), PAGE_SIZE); i +=  PAGE_SIZE)
	{
//		cprintf("AFTER LOOP va = %x \t size = %d\n",i, size);

//		cprintf("welcome\n");

		uint32 *ptr_page_temp = NULL;                 //mem
		struct FrameInfo *ptr_frame_info = NULL;
		ptr_frame_info = get_frame_info(e->env_page_directory,i,&ptr_page_temp);
		if(ptr_frame_info != NULL) // unmap allocated frames in this range
		{
//			cprintf("FREEEEEEEEEE\n");
//			free_frame(ptr_frame_info);
			unmap_frame(e->env_page_directory, i);
		}
		pf_remove_env_page(e, i);                    // disk
		env_page_ws_invalidate(e, i);               // ws
	}
	for(uint32 i = virtual_address; i < ROUNDUP((virtual_address + size), PAGE_SIZE); i +=  PAGE_SIZE)
	{
		uint32 *ptr_page_table = NULL;
		get_page_table(e->env_page_directory,i,&ptr_page_table);
		int flag = 0;
		if(ptr_page_table != NULL)
		{
			for(int j = 0; j < 1024; j++) // num of entries
			{
				if(ptr_page_table[j] != 0) // check page table entries
				{
//					cprintf("j %d\n", j);
					flag = 1;
					break;
				}
			}
		}
		if(!flag) // if all entries in page table = zero
		{
//			cprintf("va = %x\n",i);
			kfree((void*)ptr_page_table);  // free page table
			e->env_page_directory[PDX(i)] = 0; // set directory entry to zero
		}
	}
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 2) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address, uint32 size)
{
	// your code is here, remove the panic and write your code
	panic("__free_user_mem_with_buffering() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Free any BUFFERED pages in the given range
	//4. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - KERNEL SIDE] move_user_mem
	//your code is here, remove the panic and write your code
	panic("move_user_mem() is not implemented yet...!!");

	// This function should move all pages from "src_virtual_address" to "dst_virtual_address"
	// with the given size
	// After finished, the src_virtual_address must no longer be accessed/exist in either page file
	// or main memory

	/**/
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//

