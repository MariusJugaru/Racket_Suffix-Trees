// SPDX-License-Identifier: BSD-3-Clause

#include <internal/mm/mem_list.h>
#include <internal/types.h>
#include <internal/essentials.h>
#include <sys/mman.h>
#include <string.h>
#include <stdlib.h>

void *malloc(size_t size)
{
	/* TODO: Implement malloc(). */
	int ret;
	void *start = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

	if (mem_list_head.prev == NULL)
		mem_list_init();
	ret = mem_list_add(start, size);
	if (ret == -1)
		return NULL;
	else
		return start;
}

void *calloc(size_t nmemb, size_t size)
{
	/* TODO: Implement calloc(). */
	int ret;
	size_t i;
	void *start;

	mem_list_init();
	for (i = 0; i < nmemb; i++) {
		start = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
		ret = mem_list_add(start, size);
		if (ret == -1)
			return NULL;
	}
	return start;
}

void free(void *ptr)
{
	/* TODO: Implement free(). */
	if (ptr == NULL)
		return;
	struct mem_list *iter;
	iter = mem_list_find(ptr);

	int size = iter->len;
	munmap(ptr, size);
	mem_list_del(ptr);
}

void *realloc(void *ptr, size_t size)
{
	/* TODO: Implement realloc(). */
	if (ptr != NULL && size == 0)
		return NULL;
	struct mem_list *iter;
	iter = mem_list_find(ptr);

	size_t len = iter->len;
	void *ret = mremap(ptr, len, size, MREMAP_MAYMOVE);
	if (ret != (void *)-1) {
		iter->start = ret;
		iter->len = size;
		return ret;
	} else {
		return NULL;
	}
}

void *reallocarray(void *ptr, size_t nmemb, size_t size)
{
	/* TODO: Implement reallocarray(). */
	if (ptr != NULL && size == 0)
		return NULL;
	struct mem_list *iter;
	iter = mem_list_find(ptr);

	size_t len = iter->len;
	void *ret = mremap(ptr, len, size * nmemb, MREMAP_MAYMOVE);
	if (ret != (void *)-1) {
		iter->start = ret;
		iter->len = size;
		return ret;
	} else {
		return NULL;
	}
	return NULL;
}
