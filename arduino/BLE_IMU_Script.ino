#include <MPU9250.h>

/*Code taken from Kris Winer's "MPU Basic Example Code,
 * Created: 1 April, 2014
 * Licensed: Beeware - open for any use.
 * Modified by: Brent Wilkins on 19 July, 2016
 * 
 * And combined with snippets from:
 * "Temp_and_Time_Bluetooth"
 * Sensor code parts by: BARRAGAN
 * And Arduino samples.
 * https://github.com/Seven7au/Arduino_datalogging/blob/master/Temp_and_Time_Bluetooth
 */

/* Hardware setup:
  MPU9250 Breakout --------- nRF52832 Breakout
  VCC ---------------------- 3.3V
  SDA ----------------------- 05/A3
  SCL ----------------------- 04/A2
  GND ---------------------- GND
  AD0 ---------------------- GND
  FSYNC -------------------- GND
*/

//--------------------LIBRARIES-------------------------//
//BLEPeripheral depends on SPI

#include <SPI.h>
#include <BLEPeripheral.h>
#include <Time.h>
#include "quaternionFilters.h"
#include "MPU9250.h"


#define AHRS true         // Set to false for basic data read
#define SerialDebug true  // Set to true to get Serial output for debugging

//-----------------BLE ADVERTISEMENTS--------------------//
const char * localName = "nRF52832 Gyro";
BLEPeripheral blePeriph;
BLEService gyroService = BLEService("1234");
BLEFloatCharacteristic GyroX = BLEFloatCharacteristic("1234", BLERead | BLENotify);
//BLEFloatCharacteristic GyroY = BLEFloatCharacteristic("1234", BLERead | BLENotify);
BLEService accelService = BLEService("1235");
BLEFloatCharacteristic AccX = BLEFloatCharacteristic("1235", BLERead | BLENotify);
//BLEFloatCharacteristic AccY = BLEFloatCharacteristic("1235", BLERead | BLENotify);
BLEService testService = BLEService("1236");
BLEFloatCharacteristic testX = BLEFloatCharacteristic("1236", BLERead | BLENotify);

//--------------------HARDWARE-------------------------//
// Pin definitions
#define intPin      2


//--------------------VARIABLES-------------------------//
float TestGyroX = 90.0;
float pitch = 0;
float roll = 0;

//MPU I2C Setup
//MPU9250 myIMU;
MPU9250 mpu;

//--------------------SETUP-------------------------//
void setup() {
  Wire.begin();

  Serial.begin(115200);
  while (!Serial) {}

  // Set up the interrupt pin, its set as active high, push-pull
  pinMode(intPin, INPUT);
  digitalWrite(intPin, LOW);

  setupBLE();
  //setupMPU();
  mpu.setup();
  
}

//--------------------MAIN LOOP-------------------------//

void loop() {
  blePeriph.poll();
 // readMPU();
  mpu.update();
  mpu.print();
  
  Serial.print("roll  (x-forward (north)) : ");
  Serial.println(mpu.getRoll());
  roll = mpu.getRoll();
  Serial.print("pitch (y-right (east))    : ");
  Serial.println(mpu.getPitch());
  //pitch = mpu.getPitch();
  Serial.print("yaw   (z-down (down))     : ");
  Serial.println(mpu.getYaw());


  Serial.print("Setting Value \n");
  Serial.print(roll);
  GyroX.setValue(roll);
  /GyroY.setValue(roll);
  //AccX.setValue(roll);
  //AccY.setValue(roll);
  delay(500);
  
}

//--------------------FUNCTIONS-------------------------//
void setupBLE()
{
  // Advertise name and service:
  blePeriph.setDeviceName(localName);
  blePeriph.setLocalName(localName);

  //Service 1
  blePeriph.setAdvertisedServiceUuid(gyroService.uuid());
  // Add service
  blePeriph.addAttribute(gyroService);
  // Add characteristics
  blePeriph.addAttribute(GyroX);
  //blePeriph.addAttribute(GyroY);

  //Service 2
  blePeriph.setAdvertisedServiceUuid(accelService.uuid());
  // Add service
  blePeriph.addAttribute(accelService);
  // Add characteristics
  blePeriph.addAttribute(AccX);
  //blePeriph.addAttribute(AccY);

  //Service 3
    blePeriph.setAdvertisedServiceUuid(testService.uuid());
  // Add service
  blePeriph.addAttribute(testService);
  // Add characteristics
  blePeriph.addAttribute(testX);
  

  // initialize BLE:
  blePeriph.begin();
}

//---------------------------------------------------------//

