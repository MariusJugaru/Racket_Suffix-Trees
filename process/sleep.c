// SPDX-License-Identifier: BSD-3-Clause

#include <time.h>

extern int errno;

int nanosleep(const struct timespec *req, struct timespec *rem) {
	int ret;
	ret = syscall(35, req, rem);

	if (ret >= 0) {
		return 0;
	} else {
		errno = -ret;
		return -1;
	}
}

unsigned int sleep(unsigned int seconds) {
	struct timespec wait = {seconds, 0};

	int ret;
	ret = syscall(35, &wait, NULL);

	if (ret >= 0) {
		return 0;
	} else {
		errno = -ret;
		return -1;
	}
}
