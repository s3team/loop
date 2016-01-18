#include <stdio.h>
#include <string.h>

int opaque(int x);

int main(int argc, char *argv[])
{
    char buf[32];
    int n;

    scanf("%s", buf);
    n = strlen(buf);
    opaque(n);
    
    return 0;
}

int opaque(int x)
{
	int y=0;
	if(x<10)
		{
			y=x+1;
			if(x>0)
				{
			 	 y=x+2;
			 	 if(y*y>=0)
			 	 	  {
			 	 	  	 if(x==3)
			 	 	  	 	return 1;
			 	 	  }
			  }
			
		}
	return 0;	
	
}
