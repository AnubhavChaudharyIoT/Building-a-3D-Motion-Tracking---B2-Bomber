import processing.serial.*;
import controlP5.*;

Serial myPort;
PShape b2;
ControlP5 cp5;

// Sensor values from ESP8266
float sensorRoll = 0, sensorPitch = 0, sensorYaw = 0;
float sensorPosX = 0, sensorPosY = 0, sensorPosZ = 0;

// UI trim and transforms
float uiRoll = 0, uiPitch = 0, uiYaw = 0;
float uiPosX = 0, uiPosY = 0, uiPosZ = 0;
float uiZoom = 1.0;
float uiScale = 1.0;
float lerpAmt = 0.15; // Smoothing

// Camera and model
float camZ = -1500;
PVector modelCenter;
String serialPortName = "COM11"; // Change to your ESP8266 COM port

// Displayed position/rotation (smoothed)
float showRoll = 0, showPitch = 0, showYaw = 0;
float showX = 0, showY = 0, showZ = 0;

void setup() {
  fullScreen(P3D, SPAN);
  println("Available serial ports:");
  printArray(Serial.list());
  myPort = new Serial(this, serialPortName, 460800);
  myPort.bufferUntil('\n');

  b2 = loadShape("b2.obj");
  if (b2 == null) {
    println("Model not found in sketch folder!");
    exit();
  }
  modelCenter = getShapeCenter(b2);
  println("Model center: " + modelCenter);

  cp5 = new ControlP5(this);
  int y = 40;
  cp5.addSlider("uiPosX").setPosition(40, y).setSize(200, 20).setRange(-500, 500).setValue(0); y+=40;
  cp5.addSlider("uiPosY").setPosition(40, y).setSize(200, 20).setRange(-500, 500).setValue(0); y+=40;
  cp5.addSlider("uiPosZ").setPosition(40, y).setSize(200, 20).setRange(-500, 500).setValue(0); y+=40;
  cp5.addSlider("uiRoll").setPosition(40, y).setSize(200, 20).setRange(-180, 180).setValue(0); y+=40;
  cp5.addSlider("uiPitch").setPosition(40, y).setSize(200, 20).setRange(-180, 180).setValue(0); y+=40;
  cp5.addSlider("uiYaw").setPosition(40, y).setSize(200, 20).setRange(-180, 180).setValue(0); y+=40;
  cp5.addSlider("uiZoom").setPosition(40, y).setSize(200, 20).setRange(0.5, 3).setValue(1.0); y+=40;
  cp5.addSlider("uiScale").setPosition(40, y).setSize(200, 20).setRange(0.1, 5).setValue(1.0);
}

void draw() {
  background(15);
  lights();
  
  // Lerp for smooth onscreen movement/rotation
  showX = lerp(showX, sensorPosX*50 + uiPosX, lerpAmt);
  showY = lerp(showY, -sensorPosY*50 + uiPosY, lerpAmt); // flip Y if needed for orientation
  showZ = lerp(showZ, sensorPosZ*50 + uiPosZ, lerpAmt);
  showRoll = lerp(showRoll, sensorRoll + uiRoll, lerpAmt);
  showPitch = lerp(showPitch, sensorPitch + uiPitch, lerpAmt);
  showYaw = lerp(showYaw, sensorYaw + uiYaw, lerpAmt);

  pushMatrix();
  // Move to screen center and camera depth
  translate(width/2, height/2, camZ);
  scale(uiZoom);

  // Center the model geometry
  translate(-modelCenter.x, -modelCenter.y, -modelCenter.z);

  // Aircraft movement/trim
  translate(
    constrain(showX, -600, 600), 
    constrain(showY, -400, 400), 
    constrain(showZ, -600, 600)
  );

  // Aircraft orientation/trim
  rotateZ(radians(showRoll));
  rotateX(radians(showPitch));
  rotateY(radians(showYaw));

  // Model scale (from UI)
  scale(uiScale);

  shape(b2);
  popMatrix();

  // UI overlay always on top
  hint(DISABLE_DEPTH_TEST);
  cp5.draw();
  fill(255);
  textSize(18);
  text("ESP8266 Aircraft - Real-time Visualization", 40, 400);
  text("Raw Sensor Values (rounded):", 40, 430);
  text("posX: " + nf(sensorPosX, 1, 3) +
       "  posY: " + nf(sensorPosY, 1, 3) +
       "  posZ: " + nf(sensorPosZ, 1, 3), 40, 450);
  text("roll: " + nf(sensorRoll, 1, 2) +
       "  pitch: " + nf(sensorPitch, 1, 2) +
       "  yaw: " + nf(sensorYaw, 1, 2), 40, 470);
  hint(ENABLE_DEPTH_TEST);
}

// Compute model bounding box center (for precise centering)
PVector getShapeCenter(PShape shp) {
  float minX = Float.MAX_VALUE, minY = Float.MAX_VALUE, minZ = Float.MAX_VALUE;
  float maxX = -Float.MAX_VALUE, maxY = -Float.MAX_VALUE, maxZ = -Float.MAX_VALUE;
  for (int i = 0; i < shp.getVertexCount(); i++) {
    PVector v = shp.getVertex(i);
    if (v.x < minX) minX = v.x;
    if (v.y < minY) minY = v.y;
    if (v.z < minZ) minZ = v.z;
    if (v.x > maxX) maxX = v.x;
    if (v.y > maxY) maxY = v.y;
    if (v.z > maxZ) maxZ = v.z;
  }
  return new PVector((minX+maxX)*0.5, (minY+maxY)*0.5, (minZ+maxZ)*0.5);
}

// Serial event: read JSON and update sensor variables
void serialEvent(Serial p){
  String data = p.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    try {
      JSONObject json = parseJSONObject(data);
      if (json != null) {
        sensorPosX  = json.getFloat("posX");
        sensorPosY  = json.getFloat("posY");
        sensorPosZ  = json.getFloat("posZ");
        sensorRoll  = json.getFloat("roll");
        sensorPitch = json.getFloat("pitch");
        sensorYaw   = json.getFloat("yaw");
      }
    } catch(Exception e) {
      println("JSON parse error: " + e.getMessage());
    }
  }
}
