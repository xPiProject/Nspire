/*
xPi V2000 for Calculator
Ndless SDK Version

Copyleft (c) 2014 xPiProject

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <os.h>
#include <nspireio2.h>

nio_console con;
char sResult[2010];

void AllClr_VRAM()
{
	unsigned char * ptr;
	for (ptr = SCREEN_BASE_ADDRESS; ptr < SCREEN_BASE_ADDRESS + SCREEN_BYTES_SIZE; ptr += 2)
	    *(unsigned short *)ptr = 0xFFFF;
}

void CalcPi(int u)
{
    int a=10000,b,d,e,f[7001],g,h=0;
	int i;
	int c;
	
	char sBuf[10];
	
	memset(sResult,0,2010);
	if (u%4) u+=4-u%4;
	c=u/4*14;
	nio_printf(&con,"\n\nCalculation in progress...");
	
	for(i=0;i<c;i++)
        f[i]=a/5;
	
	sprintf(sResult,"3.141");
	
    for (i=0;c!=0;++i)
    { 
        d=0;
        g=c*2;
        b=c;
        while (1) 
        { 
            d=d+f[b]*a;
            g--;
            f[b]=d%g;
            d=d/g;
            g--;
            b--;
            if(b==0) break; 
            d=d*b; 
        }
        c=c-14;
		
		if (i>0)
		{
            sprintf(sBuf,"%04d",e+d/a);
		    strcat(sResult,sBuf);
		}
		
        e=d%a;
	}
	
	nio_printf(&con," Complete!\n\n");
	
	if (strlen(sResult)<=1005)
	    nio_printf(&con,"Result:\n%s",sResult);
	
	FILE* fn;
	fn=fopen("/documents/ndless/pi.txt.tns","w");
	fwrite(sResult,strlen(sResult),1,fn);
	fclose(fn);
	
	nio_printf(&con,"\n\nResult exported to /ndless/pi.txt\nPress [esc] to exit");
}

int main()
{
	char skBuff[50];
	
	AllClr_VRAM();
	
	nio_InitConsole(&con,53,30,0,0,15,0);
	nio_DrawConsole(&con);
	nio_printf(&con,"xPi V2000 for calculator\nNdless SDK Version\n");
	nio_printf(&con,"Enter digits and press [enter]: ");
	
	memset(skBuff,0,50);
	
	while(1) {
	    nio_fgets(skBuff,1000,&con);
		
	    if (isKeyPressed(KEY_NSPIRE_ESC))
		    return 0;
		
	    if (atoi(skBuff)<4 || atoi(skBuff)>2000)
	    {
		    nio_printf(&con,"\nIllegal input\n");
		    nio_printf(&con,"Enter digits and press [enter]: ");
		    memset(skBuff,0,50);
		    continue;
	    }
	    CalcPi(atoi(skBuff));
	    break;
    }
	
	while (1)
	{
	    wait_key_pressed();
		if (isKeyPressed(KEY_NSPIRE_ESC))
			break;
	}
	
	return 0;
}