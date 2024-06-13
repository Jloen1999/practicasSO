#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
   pid_t idproc, idproc_padre;
   uid_t ureal;
   int uefec;

   idproc=getpid();
   idproc_padre=getppid();
   ureal=getuid();
   uefec=geteuid();

   printf("Identificador proceso: %d U. real: %d  G. real: %d -- U.efec: %d G.efec: %d \n",idproc,ureal,getgid(),uefec,getegid());
   printf("Identificador proceso padre: %d \n",idproc_padre);
   sleep(15);
   return 0;
}
