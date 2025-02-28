// SPDX-License-Identifier: BSD-3-Clause

#include <string.h>

char *strcpy(char *destination, const char *source)
{
	if (destination == NULL)
		return NULL;

	for (; *source != '\0'; source++, destination++) {
		*destination = *source;
	}

	*destination = '\0';

	return destination;
}

char *strncpy(char *destination, const char *source, size_t len)
{
	/* TODO: Implement strncpy(). */
	if (destination == NULL)
		return NULL;

	size_t i = 0;
	for (i = 0; i < len && *source != '\0'; source++, destination++, i++)
		*destination = *source;

	if (*source == '\0' && i > 0)
		*destination = '\0';
	return destination;
}

char *strcat(char *destination, const char *source)
{
	/* TODO: Implement strcat(). */
	if (destination == NULL)
		return NULL;

	while (*destination != '\0')
		destination++;
	for (; *source != '\0'; source++, destination++)
		*destination = *source;

	*destination = '\0';
	return destination;
}

char *strncat(char *destination, const char *source, size_t len)
{
	if (destination == NULL)
		return NULL;

	while (*destination != '\0')
		destination++;
	size_t i;
	for (i = 0; *source != '\0' && i < len; source++, destination++, i++)
		*destination = *source;

	*destination = '\0';
	/* TODO: Implement strncat(). */
	return destination;
}

int strcmp(const char *str1, const char *str2)
{
	/* TODO: Implement strcmp(). */
	if(str1 == NULL && str2 == NULL)
		return 0;
	if (str1 == NULL)
		return -(int)(*str2);
	if (str2 == NULL)
		return (int)(*str1);
	while (*str1 != '\0' && *str2 != '\0' && *str1 == *str2) {
		str1++;
		str2++;
	}
	if (*str1 == *str2)
		return 0;
	if (*str1 == '\0')
		return -(int)(*str2);
	if (*str2 == '\0')
		return (int)(*str1);
	return (int)(*str1 - *str2);
}

int strncmp(const char *str1, const char *str2, size_t len)
{
	/* TODO: Implement strncmp(). */
	if(str1 == NULL && str2 == NULL)
		return 0;
	if (str1 == NULL)
		return -(int)(*str2);
	if (str2 == NULL)
		return (int)(*str1);
	size_t i = 0;
	while (*str1 != '\0' && *str2 != '\0' && *str1 == *str2 && i < len - 1) {
		str1++;
		str2++;
		i++;
	}
	if (*str1 == *str2)
		return 0;
	if (*str1 == '\0')
		return -(int)(*str2);
	if (*str2 == '\0')
		return (int)(*str1);
	return (int)(*str1 - *str2);
	return -1;
}

size_t strlen(const char *str)
{
	size_t i = 0;

	for (; *str != '\0'; str++, i++)
		;

	return i;
}

char *strchr(const char *str, int c)
{
	/* TODO: Implement strchr(). */
	if (str == NULL)
		return NULL;
	char *p = str;
	while (*p != '\0' && *p != c)
		p++;
	if (*p != '\0')
		return p;
	else
		return NULL;
}

char *strrchr(const char *str, int c)
{
	/* TODO: Implement strrchr(). */
	if (str == NULL)
		return NULL;
	char *p = str;
	while (*p != '\0')
		p++;
	while (p != str && *p != c)
		p--;
	if (p == str && *p != c)
		return NULL;
	else
		return p;
}

char *strstr(const char *haystack, const char *needle)
{
	/* TODO: Implement strstr(). */
	if (haystack == NULL)
		return NULL;
	char *p = haystack;
	char *pSubString;
	char *pNeedle = needle;

	while (*p != '\0' && *pNeedle != '\0') {
		if (*p == *pNeedle) {
			if (*pNeedle == *needle)
				pSubString = p;
			pNeedle++;
		} else {
			pSubString = NULL;
			pNeedle = needle;
		}
		p++;
	}

	if (*pNeedle == '\0')
		return pSubString;
	else
		return NULL;
}

char *strrstr(const char *haystack, const char *needle)
{
	/* TODO: Implement strrstr(). */
	if (haystack == NULL)
		return NULL;
	char *p = haystack;
	char *pSubString = NULL;
	char *pSubStringAux = NULL;
	char *pNeedle = needle;

	while (*p != '\0') {
		if (*p == *pNeedle) {
			if (*pNeedle == *needle)
				pSubString = p;
			pNeedle++;
		} else {
			pSubString = NULL;
			pNeedle = needle;
		}
		p++;
		if (*pNeedle == '\0') {
			pSubStringAux = pSubString;
			pNeedle = needle;
		}
	}

	if (*pNeedle == '\0')
		return pSubString;
	else if (pSubStringAux != NULL)
		return pSubStringAux;
	else
		return NULL;
}

void *memcpy(void *destination, const void *source, size_t num)
{
	/* TODO: Implement memcpy(). */
	char *dst = (char *)destination;
	char *src = (char *)source;
	size_t i;

	for (i = 0; i < num; i++) {
		dst[i] = src[i];
	}
	return destination;
}

void *memmove(void *destination, const void *source, size_t num)
{
	/* TODO: Implement memmove(). */
	char *dst = (char *)destination;
	char *src = (char *)source;
	size_t i;

	if (dst < src) {
		for (i = 0; i < num; i++)
			dst[i] = src[i];
	} else {
		for (i = num; i > 0; i--) {
			dst[i - 1] = src[i - 1];
		}
	}

	return destination;
}

int memcmp(const void *ptr1, const void *ptr2, size_t num)
{
	/* TODO: Implement memcmp(). */
	char *p1 = (char *)ptr1;
	char *p2 = (char *)ptr2;
	size_t i = 0;

	while (i < num && *p1 != '\0' && *p2 != '\0' && *p1 == *p2) {
		i++;
		if (*p1 < *p2)
			return -1;
		if (*p1 > *p2)
			return 1;
		p1++;
		p2++;
	}
	return 0;
}

void *memset(void *source, int value, size_t num)
{
	/* TODO: Implement memset(). */
	char *p = (char *)source;
	size_t i;

	for (i = 0; i < num; i++) {
		*p = (unsigned char)value;
		p++;
	}
	return source;
}
