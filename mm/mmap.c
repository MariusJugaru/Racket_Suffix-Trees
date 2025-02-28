// SPDX-License-Identifier: BSD-3-Clause

#include <sys/mman.h>
#include <errno.h>
#include <internal/syscall.h>

extern int errno;

void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
{
	/* TODO: Implement mmap(). */
	long ret;

	ret = syscall(9, addr, length, prot, flags, fd, offset);
	if (ret >= 0) {
		return (void *)ret;
	} else {
		errno = -ret;
		return MAP_FAILED;
	}
}

void *mremap(void *old_address, size_t old_size, size_t new_size, int flags)
{
	/* TODO: Implement mremap(). */
	long ret;

	ret = syscall(25, old_address, old_size, new_size, flags);
	if (ret >= 0) {
		return (void *)ret;
	} else {
		errno = -ret;
		return MAP_FAILED;
	}
}

int munmap(void *addr, size_t length)
{
	/* TODO: Implement munmap(). */
	int ret;

	ret = syscall(11, addr, length);
	if (ret >= 0) {
		return 0;
	} else {
		errno = -ret;
		return -1;
	}
}
