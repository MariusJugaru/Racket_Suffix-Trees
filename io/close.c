// SPDX-License-Identifier: BSD-3-Clause

#include <unistd.h>
#include <internal/syscall.h>
#include <stdarg.h>
#include <errno.h>

extern int errno;

int close(int fd)
{
	/* TODO: Implement close(). */
	int ret;
	ret = syscall(3, fd);

	if (ret >= 0) {
		return 0;
	} else {
		errno = -ret;
		return -1;
	}
}
