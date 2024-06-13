
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

void manejador_senial_sigint(int);

int main(int argc, char* argv[])
{
 struct sigaction a;
  
 a.sa_handler=manejador_senial_sigint;
 sigemptyset(&a.sa_mask);
 a.sa_flags=0;
 sigaction(SIGINT,&a,NULL);
 while(1)
  {
   printf("Mensaje hasta que se pulse CTRL_C\n");
   sleep(3);
  }
}
void manejador_senial_sigint(int senial)
{
 printf("Señal recibida: %d \n",senial);
 exit(0); 
}


