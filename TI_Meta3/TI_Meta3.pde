import processing.serial.*;

Serial port;
PShape sculp;
PImage cor;
float my;
float n;

void setup() {
  size(1200, 900, P3D);
  
  String portName = Serial.list()[2];
  port = new Serial(this, portName, 9600);
  sculp = loadShape("sculpure.obj");
  
  cor = loadImage("chrome.jpg");
  sculp.setTexture(cor);
}

void draw() {

  background(0);
  lights();

  while (port.available() > 0) {
    String data = port.readStringUntil('\n');
    if (data != null) {
      // verificar se o texto do serial tem dist
      if (data.contains("DIST")) {
        // funcao tirar o dist
        float numDist = dista(data);
        
        //processar e transformar a dist do sensor ultrassom
        if (numDist >= 30) {
          n = 110;
        } else if (numDist < 30 && numDist > 25) {
          n = 100;
        } else if (numDist < 25 && numDist > 20) {
          n = 90;
        } else if (numDist < 20 && numDist > 15) {
          n = 80;
        } else if (numDist < 15 && numDist > 10) {
          n = 60;
        } else if (numDist < 10) {
          n = 50;
        }
      }
      
      //verificar se tem o btn
      if (data.contains("BTN")) {
        // Extract the command character from the string
        char dir = direc(data);
        
        // Process the command
        turn(dir);
      }
    }
  }

  // desenhar o objeto e aplicar a escala e rotacao
  translate(width/2-100, height/2+100, 200);
  rotateZ(PI);
  rotateY(my);
  scale(n);
  shape(sculp);
}

// tirar o "dist"
float dista(String data) {
  String[] parts = data.split(":");
  if (parts.length >= 2) {
    return float(parts[1].trim());
  }
  return 0;
}

// tirar o "btn" 
char direc(String data) {
  String[] parts = data.split(":");
  if (parts.length >= 2) {
    return parts[1].charAt(0);
  }
  return '\0';
}

// rodas obj para esquerda e direita
void turn(char dir) {
  if (dir == 'L') {
    my += 0.02;
  } else if (dir == 'R') {
    my -= 0.02;
  }
}
