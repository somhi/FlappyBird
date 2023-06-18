// Initial ROM   //Hack to show OSD at core bootup
const char *bootrom_name="AUTOBOOTNES";
extern unsigned char romtype=0;

char *autoboot()
{
	char *result=0;
	romtype=0;
//	loadimage("NEXT186 VHD",'0');
	if(!LoadROM(bootrom_name))
		result="Show/hide OSD = key F12";
	return(result);
}

