#include <stdio.h>
extern int sumar(int, int);

int main()
{
	int resultado = 0;
	resultado = sumar(5,3);
	printf("%d\n", resultado);
	return 0;
}