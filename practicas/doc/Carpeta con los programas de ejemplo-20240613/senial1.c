#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

void manejador_senial_sigint(int);

int main(int argc, char* argv[])
{
	signal(SIGINT,manejador_senial_sigint);

	while(1)
	{
		printf("Mensaje hasta que se pulse CTRL_C\n");
		sleep(3);
	}
}
void manejador_senial_sigint(int senial)
{
 printf("Señal recibida: %d \n",senial);
//exit(0); 
}


