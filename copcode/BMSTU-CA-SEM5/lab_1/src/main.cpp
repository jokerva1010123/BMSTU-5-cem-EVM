#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_sysid_qsys.h"
#include "altera_avalon_sysid_qsys_regs.h"

int main()
{
	char ch;
	alt_putstr("Hello from System on Chip\n");
	
	int SystemID = IORD_ALTERA_AVALON_SYSID_QSYS_ID(SYSID_QSYS_0_BASE);
	alt_printf("%x", SystemID);
	
	return 0;
}
