#include <Servo.h>
Servo thruster_LU;    //电机控制变量
Servo thruster_LD;
Servo thruster_RU;
Servo thruster_RD;

// const int button1 = 8;    // UP black-orange
const int button2 = 5;    // FORWARD purple
const int button3 = 4;    // LEFT orange
const int button4 = 3;    // RIGHT black-yellow
const int button5 = 2;    // UP white

// HIGH: OPEN CIRCUIT; lOW: CLOSE CIRCUIT
int lastButtonState1 = HIGH;
int lastButtonState2 = HIGH;
int lastButtonState3 = HIGH;
int lastButtonState4 = HIGH;
int lastButtonState5 = HIGH;

int value1;    //LU
int value2;    //LD
int value3;    //RU
int value4 = 1000;    //RD

void setup() {
    Serial.begin(9600);

    // INPUT
    // pinMode(button1, INPUT_PULLUP);
    pinMode(button2, INPUT_PULLUP);
    pinMode(button3, INPUT_PULLUP);
    pinMode(button4, INPUT_PULLUP);
    pinMode(button5, INPUT_PULLUP);

    thruster_LU.attach(6);    //GREEN
    thruster_LD.attach(9);    //YELLOW
    thruster_RU.attach(10);    //BLUE
    thruster_RD.attach(11);    //RED

    thruster_LU.writeMicroseconds(1500);
    thruster_LD.writeMicroseconds(1500);
    thruster_RU.writeMicroseconds(1500);
    thruster_RD.writeMicroseconds(1500);
    delay(500);
}

void loop() {
  // while(Serial.available() > 0)
  // {
  //   value1 = Serial.parseInt();    //接收串口发来的整型数据
  //   value2 = Serial.parseInt();
  //   value3 = Serial.parseInt();
  //   value4 = Serial.parseInt();
  // }

    int buttonValue2 = digitalRead(button2);
    int buttonValue3 = digitalRead(button3);
    int buttonValue4 = digitalRead(button4);
    int buttonValue5 = digitalRead(button5);

    if (buttonValue5 == LOW) {
        // Serial.println("Up button pressed");
        // delay(500);
        value1=1000;
        // delay(500); 
        value3=1000;
    } else if (buttonValue2 == LOW) {
        // Serial.println("Forward button pressed");
        // delay(500); 
        value2=1000;
        // delay(500); 
        value4=1000;
    } else if (buttonValue3 == LOW) {
        // Serial.println("Left button pressed");
        // delay(500); 
        value4=1000;
    } else if (buttonValue4 == LOW) {
        // Serial.println("Right button pressed");
        // delay(500); 
        value2=1000;
    } else {
      thruster_LU.writeMicroseconds(1500);
      thruster_RU.writeMicroseconds(1500);
      thruster_LD.writeMicroseconds(1500);
      thruster_RD.writeMicroseconds(1500);
      value1=500;
      value2=500;
      value3=500;
      value4=500;        
    }
    
    Serial.println(value2);
    thruster_LU.writeMicroseconds(value1);
    thruster_LD.writeMicroseconds(value2);
    thruster_RU.writeMicroseconds(value3);
    thruster_RD.writeMicroseconds(value4);
}

// void controlThrusters(int LU, int LD, int RU, int RD) {
//     // UPDATE THRUSTER STATE
//     thruster_LU_state = LU;
//     thruster_LD_state = LD;
//     thruster_RU_state = RU;
//     thruster_RD_state = RD;

//     digitalWrite(thruster_LU, thruster_LU_state);
//     digitalWrite(thruster_LD, thruster_LD_state);
//     digitalWrite(thruster_RU, thruster_RU_state);
//     digitalWrite(thruster_RD, thruster_RD_state);
// }


// void loop() {
//     int reading1 = digitalRead(button1);
//     int reading2 = digitalRead(button2);
//     int reading3 = digitalRead(button3);
//     int reading4 = digitalRead(button4);

//       if (reading1 == LOW && lastButtonState1 == HIGH) {
//           Serial.println("Up button pressed");
//           controlThrusters(HIGH, LOW, HIGH, LOW);
//       } else if (reading1 == HIGH && lastButtonState1 == LOW) {
//           Serial.println("Up button released");
//           controlThrusters(LOW, LOW, LOW, LOW);
//       }

//       if (reading2 == LOW && lastButtonState2 == HIGH) {
//           Serial.println("Down button pressed");
//           controlThrusters(LOW, HIGH, LOW, HIGH);
//       } else if (reading2 == HIGH && lastButtonState2 == LOW) {
//           Serial.println("Down button released");
//           controlThrusters(LOW, LOW, LOW, LOW);
//       }

//       if (reading3 == LOW && lastButtonState3 == HIGH) {
//           Serial.println("Left button pressed");
//           controlThrusters(LOW, LOW, LOW, HIGH);
//       } else if (reading3 == HIGH && lastButtonState3 == LOW) {
//           Serial.println("Left button released");
//           controlThrusters(LOW, LOW, LOW, LOW);
//       }

//       if (reading4 == LOW && lastButtonState4 == HIGH) {
//           Serial.println("Right button pressed");
//           controlThrusters(LOW, HIGH, LOW, LOW);
//       } else if (reading4 == HIGH && lastButtonState4 == LOW) {
//           Serial.println("Right button released");
//           controlThrusters(LOW, LOW, LOW, LOW);
//       }

//     lastButtonState1 = reading1;
//     lastButtonState2 = reading2;
//     lastButtonState3 = reading3;
//     lastButtonState4 = reading4;
// }


