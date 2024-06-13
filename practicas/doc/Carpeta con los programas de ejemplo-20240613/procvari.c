
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{	
 pid_t pid;
 int a=7;
 int b=3;
 pid=fork();
 switch (pid){
   case -1:
    printf("Error al crear el proceso\n");
    break;
   case 0:
    a=9;
   
    printf("Proceso hijo con id. de proceso: %d  e id. del proceso padre %d \n",getpid(),getppid());
    //visualiza b
    system("ls -la");
    printf("Proceso hijo con id. de proceso: %d  e id. del proceso padre %d \n",getpid(),getppid());
    break;
   default:
     //visualiza a
     // modifica el valor de b
    printf("Proceso padre (invocador) con id. de proceso: %d  e id. del proceso padre %d \n",getpid(),getppid());
//system("ps -o user,pid,ppid,cmd");
    break;
   }
   return 0;
}
