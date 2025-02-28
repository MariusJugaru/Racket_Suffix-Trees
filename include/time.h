/* SPDX-License-Identifier: BSD-3-Clause */

#ifndef __TIME_H__
#define __TIME_H__	1

#ifdef __cplusplus
extern "C" {
#endif

#include <internal/syscall.h>
#include <internal/types.h>
#include <errno.h>

typedef unsigned int time_t;

struct timespec {
	time_t tv_sec;
	long tv_nsec;
};

int nanosleep(const struct timespec *req, struct timespec *rem);
unsigned int sleep(unsigned int seconds);

#ifdef __cplusplus
}
#endif

#endif
