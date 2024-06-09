
#define echoPin 8 // Echo Pin
#define trigPin 9 // Trigger Pin

long duration;
long timestamp;
float distance; 

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  pinMode(6, INPUT_PULLUP);
  pinMode(7, INPUT_PULLUP);
}

void loop() {
  // determinar distancia
 
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH, 100000);
  
  // calcurar dist em cm
  distance = (duration * 0.034) / 2; // or duration / 29 / 2
  Serial.print("DIST:");
  Serial.println(distance);
  
  delay(60);

  // verificar button inputs
  if (millis() - timestamp > 50) {
    if (!digitalRead(6)) {
      Serial.println("BTN:R");
    }
    if (!digitalRead(7)) {
      Serial.println("BTN:L");
    }
    timestamp = millis();
  }
}
