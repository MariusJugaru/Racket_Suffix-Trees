// SPDX-License-Identifier: BSD-3-Clause

#include <sys/stat.h>
#include <internal/syscall.h>
#include <errno.h>

int fstat(int fd, struct stat *st)
{
	/* TODO: Implement fstat(). */
	int ret;
	ret = syscall(5, fd, st);

	if (ret >= 0) {
		return 0;
	} else {
		errno = -ret;
		return -1;
	}
	return -1;
}
