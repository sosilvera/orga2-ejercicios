#include <stdio.h>
extern void diagonal(short* matriz, short n, short* vector);

int main(int argc, char const *argv[]){
	short vector[3];
	short matriz[3][3] = {
		{1,2,3},{4,5,6},{7,8,9}
	};

	short n = 3;
	diagonal((short *)matriz, n, vector);

	for (short i = 0; i < n; ++i){
		printf("%hd\n", vector[i]);
	}

	return 0;
}