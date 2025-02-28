// SPDX-License-Identifier: BSD-3-Clause

#include <fcntl.h>
#include <internal/syscall.h>
#include <stdarg.h>
#include <errno.h>

extern int errno;

int open(const char *filename, int flags, ...)
{
	/* TODO: Implement open system call. */
	int fd;
	if ((flags & O_CREAT) == 0) {
		fd = syscall(2, filename, flags);
	} else {
		va_list ptr;
		va_start(ptr, flags);
		mode_t mode = va_arg(ptr, mode_t);
		fd = syscall(2, filename, flags, mode);
		va_end(ptr);
	}
	if (fd< 0) {
		errno = -fd;
		return -1;
	} else {
		return fd;
	}
}
