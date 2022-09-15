extern "C" 
{
void var006(int* c, const int* a, const int* b, const int len) 
{
    int minB = b[0];
    for (int i = 1; i < len; i++) 
    {
          if (minB > b[i]) 
          {
               minB = b[i];
          }    
    }
    int acc = 0;
    for(int i=0; i < len; i++)
    {
       acc += a[i] * minB;
       c[i] = acc;
    }
}
}
