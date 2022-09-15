#include <stdio.h>

#define len 8
#define enroll 2
#define elem_sz 4

int _x[]={1,2,3,4,5,6,7,8};
int main()
{
    int x31 = 0; 
    int x20 = len/enroll;
    int* x1 = _x;

    do {
      int x2 = x1[0];
      int x3 = x1[1];
      x1 += enroll;
      x20 -= 1;
      x31 += x2;
      x31 += x3;
    	} 
    while(x20 != 0);
    
    x31++;
    printf("%d", x31);
    return 0;
}
