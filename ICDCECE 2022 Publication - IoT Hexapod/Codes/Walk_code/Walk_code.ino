#include <Servo.h>

 // ################################################################

class Leg
{
  public:
  Servo Hip;
  Servo Thigh;
  Servo Foot;
};
Leg RU;
Leg RM;
Leg RL;
Leg LU;
Leg LM;
Leg LL;
int fpos=90;
int tpos=90;
int rhpos=50;
int lhpos=130;

void setup() {
  // put your setup code here, to run once:
  
  RU.Hip.attach(29);
  RU.Thigh.attach(31);
  RU.Foot.attach(33);
  RM.Hip.attach(25);
  RM.Thigh.attach(27);
  RM.Foot.attach(23);
  RL.Hip.attach(26);
  RL.Thigh.attach(22);
  RL.Foot.attach(24);
  LU.Hip.attach(35);
  LU.Thigh.attach(37);
  LU.Foot.attach(39);
  LM.Hip.attach(32);
  LM.Thigh.attach(30);
  LM.Foot.attach(28);
  LL.Hip.attach(38);
  LL.Thigh.attach(34);
  LL.Foot.attach(36);
}


void loop() 
{
  // put your main code here, to run repeatedly:
  RU.Hip.write(rhpos);
  RU.Thigh.write(tpos);
  RU.Foot.write(fpos);
  RM.Hip.write(rhpos);
  RM.Thigh.write(tpos);
  RM.Foot.write(fpos);
  RL.Hip.write(rhpos);
  RL.Thigh.write(tpos);
  RL.Foot.write(fpos);
  LU.Hip.write(lhpos);
  LU.Thigh.write(tpos);
  LU.Foot.write(fpos);
  LM.Hip.write(lhpos);
  LM.Thigh.write(tpos);
  LM.Foot.write(fpos);
  LL.Hip.write(lhpos);
  LL.Thigh.write(tpos);
  LL.Foot.write(fpos);
}
