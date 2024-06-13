
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

extern char **environ;
int main(int argc, char *argv[])
{	
   for (int i=0;environ[i]!=NULL; i++)
   {
   printf("Variable entorno[%d]: %s \n",i,environ[i]);
   }
   return 0;
}
