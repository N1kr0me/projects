#include<reg51.h>
sbit doorp=P2^0;
sbit doorn=P2^1;
sbit rs=P2^5;
sbit rw=P2^6;
sbit en=P2^7;
void lcddat(unsigned char);
void lcdcmd(unsigned char);
void lcddis(unsigned char *);
void lcd_init();
void serial_init();
void check();
void delay();
void mdelay();
unsigned char rfid[12],v1;

sbit IR1=P0^0;
sbit IR2=P0^1;
sbit IR3=P0^2;
sbit IR4=P0^3;
sbit slot1=P0^4;
sbit slot2=P0^5;
sbit slot3=P0^6;
sbit slot4=P0^7;
sfr LCD=0xB0;
void lcddata(unsigned char c);
void printstring(unsigned char ch[]);
void msdelay(unsigned int i);

void main ()
{
	doorp=doorn=0;
	serial_init();
	lcd_init();
	lcddis("RFID BASED CAR");
	lcdcmd(0xc0);
	lcddis("PARKING SYSTEM");
	delay();
	delay();
	lcdcmd(0x01);
	while(1)
	{
		lcdcmd(0x01);
		lcddis("SWIPE YOUR CARD");
		for(v1=0;v1<12;v1++)
		{
			while(RI==0);
			rfid[v1]=SBUF;
			RI=0;
			SBUF=rfid[v1];
			while(TI==0);
			TI=0;
		}
		check();
	}
}
void check()
{
//1A3465B89356- SHARMA SLOT, 3245FR6786A1-MURTHY SLOT
//234R56Y71297-KHAN SLOT, 145678HA34EC - REDDY SLOT
	if(rfid[0]=='1'&&rfid[1]=='A'&&rfid[2]=='3'&&rfid[3]=='4'&&rfid[4]=='6'&& rfid[5]=='5'&&rfid[6]=='B'&& rfid[7]=='8'&&rfid[8]=='9'&&rfid[9]=='3'&&rfid[10]=='5'&&rfid[11]=='6')
	{
		lcdcmd(0x01);
		lcddis("ASSOCIATION MEMBER");
		lcdcmd(0xc0);
		lcddis("SHARMA- SLOT 101");
		delay();
		delay();
		lcdcmd(0x01);
		doorp=1;
		doorn=0;
		lcddis("DOOR OPENING"); 
		lcdcmd(0xc0);
		lcddis("ALLOW INSIDE");
		mdelay();
		doorp=0;
		doorn=0;
		delay(); 
		lcdcmd(0x01);
		doorp=0;
		doorn=1; 
		lcddis("DOOR CLOSING"); 
		mdelay();
		doorp=0;
		doorn=0;
	}
	else if(rfid[0]=='3'&&rfid[1]=='2'&&rfid[2]=='4'&&rfid[3]=='5'&&rfid[4]=='F'&&rfid[5]=='R'&&rfid[6]=='6'&&rfid[7]=='7'&&rfid[8]=='8'&&rfid[9]=='6'&&rfid[10]=='A'&&rfid[11]=='1')
	{
		lcdcmd(0x01);
		lcddis("ASSOCIATION MEMBER");
		lcdcmd(0xc00);
		lcddis("MURTHY- SLOT 105");
		delay();
		delay();
		lcdcmd(0x01);
		doorp=1;
		doorn=0;
		lcddis("DOOR OPENING"); 
		lcdcmd(0xc0);
		lcddis("ALLOW INSIDE");
		mdelay();
		doorp=0;
		doorn=0;
		delay(); 
		lcdcmd(0x01);
		doorp=0;
		doorn=1; 
		lcddis("DOOR CLOSING"); 
		mdelay();
		doorp=0; 
		doorn=0;
	}
	else if(rfid[0]=='2'&&rfid[1]=='3'&&rfid[2]=='4'&&rfid[3]=='R'&&rfid[4]=='5'&& rfid[5]=='6'&&rfid[6]=='Y'&&rfid[7]=='7'&&rfid[8]=='1'&&rfid[9]=='2'&&rfid[10]=='9'&&rfid[11]=='7')
	{
		lcdcmd(0x01);
		lcddis("ASSOCIATION MEMBER");
		lcdcmd(0xc0);
		lcddis("KHAN- SLOT 405");
		delay();
		delay();
		lcdcmd(0x01);
		doorp=1;
		doorn=0;
		lcddis("DOOR OPENING"); 
		lcdcmd(0xc0);
		lcddis("ALLOW INSIDE");
		mdelay();
		doorp=0;
		doorn=0;
		delay(); 
		lcdcmd(0x01);
		doorp=0;
		doorn=1; 
		lcddis("DOOR CLOSING"); 
		mdelay();
		doorp=0; doorn=0;
	}
	else if(rfid[0]=='1'&&rfid[1]=='4'&&rfid[2]=='5'&&rfid[3]=='6'&&rfid[4]=='7'&& rfid[5]=='8'&&rfid[6]=='H'&&rfid[7]=='A'&&rfid[8]=='3'&&rfid[9]=='4'&&rfid[10]=='E'&&rfid[11]=='C')
	{
		lcdcmd(0x01);
		lcddis("ASSOCIATION MEMBER");
		lcdcmd(0xc0);
		lcddis("REDDY- SLOT 103");
		delay();
		delay();
		lcdcmd(0x01);
		doorp=1;
		doorn=0;
		lcddis("DOOR OPENING"); 
		lcdcmd(0xc0);
		lcddis("ALLOW INSIDE");
		mdelay();
		doorp=0;
		doorn=0;
		delay(); 
		lcdcmd(0x01);
		doorp=0;
		doorn=1; 
		lcddis("DOOR CLOSING"); 
		mdelay();
		doorp=0;
		doorn=0;
	}
	else
	{
		slot1=0;
		slot2=0;
		slot3=0;
		slot4=0;
		lcdcmd(0x38);  // 2 lines 5x7 matrix 
		lcdcmd(0x0C);  //  desplay on cursor blinking
		lcdcmd(0x01);  // clear screen
		lcdcmd(0x06);  //  increment cursor
		while(1)
		{
			if(IR1 == 1)
			{
				slot1=0;
				lcdcmd(0x80);
				printstring("1.filled");
			}
			else
			{
				lcdcmd(0x80);
				printstring("1.empty ");
				slot1=1;
			}
			if(IR2 == 1)
			{
				slot2=0;
				lcdcmd(0x88);
				printstring("2.filled");
			}
			else
			{
				slot2=1;
				lcdcmd(0x88);
				printstring("2.empty ");
			}
			if(IR3 == 1)
			{
				slot3=0;
				lcdcmd(0xC0);
				printstring("3.filled");
			}
			else
			{	
				slot3=1;
				lcdcmd(0xC0);
				printstring("3.empty ");
			}
			if(IR4 == 1)
			{
				slot4=0;
				lcdcmd(0xC8);
				printstring("4.filled");
			}
			else
			{
				slot4=1;
				lcdcmd(0xC8);
				printstring("4.empty ");
			}
		}
	}
}	
void printstring(unsigned char ch[])
{
	unsigned int i;
	for(i=0;ch[i] != '\0' ;i++)
	lcddata(ch[i]); 
}
void msdelay(unsigned int i)
{
	unsigned int k;
	for(k=0;k<i;k++);
	for(k=0;k<100;k++);
}
void lcddata(unsigned char c);
{
	LCD=c;
	rs=1;
	en=1;
	msdelay(10);
	en=0;
}
void lcd_init()
{
	lcdcmd(0x38);
	lcdcmd(0x01);
	lcdcmd(0x10);
	lcdcmd(0x0c);
	lcdcmd(0x80);
}
void lcdcmd(unsigned char val)
{
	P1=val;
	rs=0;
	rw=0;
	en=1;
	delay();
	en=0;
}
void lcddat(unsigned char val)
{
	P1=val;
	rs=1;
	rw=0;
	en=1;
	delay();
	en=0;
}
void delay()
{
	unsigned int v5;
	for(v5=0;v5<6000;v5++);
}
void lcddis(unsigned char *s)
{
	unsigned char w;
	for(w=0;s[w]!='\0';w++)
	{
		lcddat(s[w]);
	}
}
void serial_init()
{
	SCON=0x50;
	TMOD=0x20;
	TH1=-3;	//baud rate 9600
	TR1=1;
}
void mdelay()
{
	unsigned int v6,v7;
	for(v6=0;v6<2;v6++)
	{
	for(v7=0;v7<60000;v7++);
	}
}
// automatic car parking
