#define Grove_Water_Sensor 8 // Attach Water sensor to Arduino Digital Pin 8

void setup() {
   pinMode(Grove_Water_Sensor, INPUT); // The Water Sensor is an Input
   Serial.begin(9600);
}

void loop() {
   /* The water sensor will switch LOW when water is detected.
   Get the Arduino to illuminate the LED and activate the buzzer
   when water is detected, and switch both off when no water is present */
   if( digitalRead(Grove_Water_Sensor) == LOW) {
      Serial.println("Wetness Detected");
   }else {
      Serial.println("No wetness");
   }
   delay(1000);
}
