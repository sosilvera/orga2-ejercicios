#include <stdio.h>
#include <stdlib.h>

// float* floatClone(float* a){
// 	float *b = a;
// 	return b;
// }

extern float* floatClone(float* a);

int main(int argc, char const *argv[])
{
	float a = 5.4;
	float* p_b = floatClone(&a);
	printf("%f\n", *p_b);
	return 0;
}