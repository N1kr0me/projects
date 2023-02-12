
#include <Servo.h>

Servo HipServo;
Servo ThighServo;
Servo FootServo;

int fpos=120;
int tpos=90;
int hpos=90;
void setup() {
  // put your setup code here, to run once:
  HipServo.attach(6);
  ThighServo.attach(5);
  FootServo.attach(3);
}

void loop() {
  // put your main code here, to run repeatedly:
    HipServo.write(hpos);
    ThighServo.write(tpos);
    FootServo.write(fpos);
}
