#include <stdio.h>
extern double sumar(double, double);

int main()
{
	double resultado = 0;
	resultado = sumar(5.3,3.2);
	printf("%f\n", resultado);
	return 0;
}