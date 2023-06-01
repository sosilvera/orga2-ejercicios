#include <stdio.h>

extern int floatCmp(float* a, float* b);

int main(int argc, char const *argv[])
{
	float a = 5.4;
	float b = 4.5;

	int result = floatCmp(&a, &b);

	printf("%d\n", result);

	return 0;
}