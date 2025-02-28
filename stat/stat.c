// SPDX-License-Identifier: BSD-3-Clause

#include <sys/stat.h>
#include <internal/syscall.h>
#include <fcntl.h>
#include <errno.h>

extern int errno;

int stat(const char *restrict path, struct stat *restrict buf)
{
	/* TODO: Implement stat(). */
	int ret;
	ret = syscall(4, path, buf);

	if (ret >= 0) {
		return 0;
	} else {
		errno = -ret;
		return -1;
	}
}
