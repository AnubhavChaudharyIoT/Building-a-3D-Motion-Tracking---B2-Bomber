# 🛩️ B2 Bomber Real-Time 3D Simulator
### Sensor-Controlled Visualization Using ESP8266 & MPU6050  

![Processing 3D Demo](https://img.shields.io/badge/Processing-3D-blue)  
![Arduino](https://img.shields.io/badge/Arduino-IDE-green)  
![ESP8266](https://img.shields.io/badge/ESP8266-IoT-orange)  
![License](https://img.shields.io/badge/License-MIT-brightgreen)  

---

## 🌌 Storytelling Intro  
Ever wondered what it feels like to **hold an aircraft in your hand**?  
With just a tiny sensor and a bit of code, every tilt of your hand comes alive as the **B2 Bomber moves in 3D, real-time**.  
This project isn’t just a simulation — it’s **technology made visible**, bridging physics, imagination, and innovation.  

---

## 📌 Overview  
This project demonstrates a **real-time 3D visualization of a B2 Bomber aircraft model**, controlled by motion data captured from an **MPU6050 IMU sensor** connected to an **ESP8266 microcontroller**.  

Every tilt, roll, and movement of the sensor is **instantly mirrored** in a 3D aircraft simulation built with **Processing 3**, creating an **interactive, immersive, and educational visualization tool**.  

💡 Perfect for **IoT portfolios, interactive demos, classrooms, and robotics showcases**.  

---

## ✨ Key Features  
- 📡 **Real-Time Sensor Integration** – MPU6050 provides roll, pitch, yaw, and positional data.  
- ⚡ **Low-Latency Data Transfer** – ESP8266 sends data as JSON at 460800 baud.  
- 🎨 **3D Rendering with Processing** – Live manipulation of a B2 Bomber `.obj` model.  
- 🎚️ **Interactive UI** – ControlP5 sliders for trimming position, rotation, zoom, and scale.  
- 🖥️ **Fullscreen Immersion** – Optimized for ultra-wide displays (3840×1080).  
- 🔄 **Smooth Motion** – Lerp interpolation ensures stable animations.  

---

## 🛠️ Technologies Used  
**Hardware**  
- ESP8266 (NodeMCU)  
- MPU6050 (Accelerometer + Gyroscope)  

**Software & Libraries**  
- Arduino IDE (C++)  
- Processing 3 (Java-based GUI & 3D rendering)  
- Adafruit MPU6050 & Sensor Libraries (Arduino)  
- ControlP5 (Processing UI Library)  

**Data Format**  
- JSON (e.g., `{"posX":0.12,"posY":-0.45,"posZ":0.78,"roll":12.34,"pitch":-5.67,"yaw":8.90}`)  

---

## 🚀 How It Works  
1. **Sensor Data Acquisition** – MPU6050 reads raw accelerometer & gyro data.  
2. **Microcontroller Processing** – ESP8266 applies a complementary filter and outputs roll, pitch, yaw, and position.  
3. **Data Transmission** – JSON packets are sent via Serial (~100 Hz).  
4. **3D Visualization** – Processing parses the data and animates the aircraft model.  
5. **User Control** – Sliders enable real-time adjustments for trimming & calibration.  

---

## 📷 Demo Preview  
*(Replace with your own screenshots or GIFs)*  

![Demo Screenshot](video.mp4)  

---

## 🖥️ Setup & Installation  

### 🔧 Hardware Setup  
- Connect **MPU6050** to **ESP8266 (NodeMCU)** via I2C.  
- Use a USB cable to connect ESP8266 to PC.  

### ⚙️ Software Setup  
**Arduino IDE**  
```bash
# Install ESP8266 Board
File > Preferences > Additional Board Manager URLs
http://arduino.esp8266.com/stable/package_esp8266com_index.json

# Install Libraries
Adafruit MPU6050
Adafruit Unified Sensor
```
Upload `sketch_aug30a.ino` to ESP8266.  

**Processing 3**  
```bash
# Install Processing 3 from https://processing.org
# Add ControlP5 library (via Library Manager)
```
Place `b2.obj` in your Processing sketch folder and run `B2_bomber_veiw.pde`.  

---

## ▶️ Running the Project  
1. Upload Arduino sketch to ESP8266.  
2. Close Arduino Serial Monitor.  
3. Run the Processing sketch.  
4. Move the MPU6050 sensor → Watch the B2 Bomber move in sync!  

---

## ⚡ Challenges & Solutions  
- **Jittery Motion** → Fixed using **lerp-based smoothing**.  
- **Model Rotation Offset** → Corrected with **bounding box centering**.  
- **Wide-Screen Rendering** → Used `fullScreen(P3D, SPAN)` for immersive view.  

---

## 🌟 Future Improvements  
- ✅ Wireless UDP data transmission.  
- ✅ Advanced sensor fusion (Kalman Filter).  
- ✅ VR/AR immersive integration.  
- ✅ Export standalone app for non-technical demos.  

---

## 📂 Repository Structure  
```
📁 B2-Bomber-Simulator
 ├── Arduino/
 │   └── sketch_aug30a.ino   # ESP8266 + MPU6050 firmware
 ├── Processing/
 │   └── B2_bomber_veiw.pde # 3D Visualization
 ├── model/
 │   └── b2.obj              # Aircraft 3D model
 ├── demo.png / demo.gif     # Screenshots/preview
 └── README.md               # This file
```

---

## 🤝 Contributing  
Pull requests are welcome! For major changes, open an issue first to discuss what you’d like to add.  

---

## 📜 License  
This project is licensed under the **MIT License** – feel free to use, modify, and share.  

---

## 🔗 Connect With Me  
🌍 [LinkedIn](https://linkedin.com/) | 💻 [Portfolio](https://github.com/) | ✉️ Email: *yourmail@example.com*  

---

👉 This project isn’t just about code — it’s about **making invisible motion visible**.  
