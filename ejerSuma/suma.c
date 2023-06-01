#include <stdio.h>

extern short suma(short* vector, short n);

int main(int argc, char const *argv[])
{
	short v[5];

	v[0] = 1;
	v[1] = 2;
	v[2] = 3;
	v[3] = 4;
	v[4] = 5;

	short result = 0;

	result = suma(v, 5);

	printf("%hd\n", result);

	return 0;
}