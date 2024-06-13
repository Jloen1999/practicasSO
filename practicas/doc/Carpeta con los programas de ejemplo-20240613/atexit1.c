#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void finalizar()
{
  printf("Finalizando programa con pid: %d cuyo padre es %d \n",getpid(),getppid());
}
int main(void){
	if (atexit(finalizar)!=0)
	{
		printf("Error al configurar rutina atexit\n");
	        exit(-1);
	}
  printf("Se está ejecutando el programa con pid: %d cuyo padre es %d \n",getpid(),getppid());
  printf("Antes de llamar a exit\n");
  exit(1);
}
