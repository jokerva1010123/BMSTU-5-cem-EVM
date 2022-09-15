#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_sysid_qsys.h"
#include "altera_avalon_sysid_qsys_regs.h"

int main()
{
   char ch;
   alt_putstr("Hello from System on Chip\n");
   alt_putstr("Send any character\n");
   int id = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
   char a[6];
   int i = 1;
   while (id)
   {
      a[4 - i] = '0' + id % 10;
      id /= 10;
      i++;
   }
   a[4] = '\n';
   a[5] = '\0';
   for (int i = 0; i < 5; i++)
      alt_putchar(a[i]);
 /* Event loop never exits. */
   while (1) {
      ch=alt_getchar();
      alt_putchar(ch);

   }
   return 0;
}
