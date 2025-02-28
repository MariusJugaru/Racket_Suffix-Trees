// SPDX-License-Identifier: BSD-3-Clause

#include <string.h>
#include <unistd.h>

int puts(const char *s)
{
	int succes;

	succes = write(1, s, strlen(s));
	write(1, "\n", 1);
	succes++;
	return succes;
}
