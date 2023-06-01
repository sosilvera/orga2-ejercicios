#include <stdio.h>
// Esta retorna el resultado de la operacion:
// a0-a1+a2-a3+a4-a5+a6-a7

extern int suma_parametros( int a0, int a1, int a2, int a3, int a4, int a5 ,int a6, int a7 );

int main(int argc, char const *argv[])
{
	int resultado = 0;
	
	resultado = suma_parametros(1, 2, 3, 4, 5, 6, 7, 8);
	
	printf("%d\n", resultado);
	return 0;
}