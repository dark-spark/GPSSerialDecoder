import processing.serial.*;

Serial myPort;
boolean serial;
int dollarPos, starPos;
String gprmc[] = new String[20];
String gpgga[] = new String[20];

void setup() {
  size(800, 600);
  serial = startSerial();
}

void draw() {
  background(255);    
  
  for (int i = 0; i < gprmc.length; i++) {
    textSize(32);
    fill(0);
    text(gprmc[i], 10, 30 + (i * 30));
  }
  
  for (int i = 0; i < gpgga.length; i++) {
    textSize(32);
    fill(0);
    text(gpgga[i], 250, 30 + (i * 30));
  }
}



boolean startSerial() {

  println(Serial.list());

  if (Serial.list().length > 0) {
    myPort = new Serial(this, Serial.list()[0], 115200);
    myPort.bufferUntil('\n');
    myPort.clear();
    return true;
  } else {
    return false;
  }
}



void serialEvent (Serial myPort) {

  String inString = myPort.readStringUntil('\n');

  if (checksum(inString)) {
    if (inString.substring(0, 6).equals("$GPRMC")) {
      gprmc = split(inString, ',');
    } else if (inString.substring(0, 6).equals("$GPGGA")) {
      gpgga = split(inString, ',');
    }
  }
}



boolean checksum (String string) {
  int cksum = 0; 
  int dollarPos = string.indexOf("$");
  int starPos = string.indexOf("*");

  for (int i = dollarPos + 1; i < starPos; i++) {
    cksum ^= string.charAt(i);
  }

  if (hex(cksum, 2).equals(string.substring(starPos+1, starPos + 3))) {
    return true;
  } else {
    return false;
  }
}
