
#include <Servo.h>

Servo HipServo;
Servo ThighServo;
Servo FootServo;

int fpos=90;
int tpos=90;
int hpos=50;
void setup() {
  // put your setup code here, to run once:
  HipServo.attach(29);
  ThighServo.attach(31);
  FootServo.attach(33);
}

void loop() {
  // put your main code here, to run repeatedly:
    HipServo.write(hpos);
    ThighServo.write(tpos);
    FootServo.write(fpos);
}
