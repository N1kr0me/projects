int SensorPin = A0;

void setup() {
  // set up the LCD's number of columns and rows:
  Serial.begin(9600);
}

void loop() {

  int SensorValue = analogRead(SensorPin);   
  float SensorVolts = analogRead(SensorPin)*0.0048828125;   
  Serial.println(SensorValue);
  delay(1000);
  
}
