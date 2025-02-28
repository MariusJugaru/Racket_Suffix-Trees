// SPDX-License-Identifier: BSD-3-Clause

#include <unistd.h>
#include <internal/syscall.h>
#include <errno.h>

extern int errno;

off_t lseek(int fd, off_t offset, int whence)
{
	/* TODO: Implement lseek(). */
	off_t ret;
	ret = syscall(8, fd, offset, whence);

	if (ret >= 0) {
		return ret;
	} else {
		errno = -ret;
		return -1;
	}
}
