// Pro_Graph2.pde
/*
 Based on the Arduining example which is based on the Tom Igoe example.
 Mofified by Cara Nunez 5/1/2019:
  -A wider line was used. strokeWeight(4);
  -Continuous line instead of vertical lines.
  -Bigger Window size 600x400.
 Last Modified by Tania Morimoto 2/14/2023:
  - more detailed comments/instructions
-------------------------------------------------------------------------------
This program takes ASCII-encoded strings
from the serial port at 38400 baud and graphs them. It expects values in the
range 0 to 1023, followed by a newline, or newline and carriage return


*/

import processing.serial.*;

Serial myPort;        // The serial port

//initialize variables
float inByte = 0;
float lastByte = 0;
float myValue = 0;
float myValue_old = 0.0;

void setup () {
  // set the window size:
  size(600, 400);        

  // List all the available serial ports
  println(Serial.list());
  
  // Check the listed serial ports in your machine
  // and use the correct index number in Serial.list()[] below.
  // Note that these are indexed from 0, and you are looking for the same port as your ardunio.
  myPort = new Serial(this, Serial.list()[1], 38400);  //make sure baud rate matches Arduino

  // A serialEvent() is generated when a newline character is received :
  myPort.bufferUntil('\n');
  background(0);      // set inital background:
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  //myValue != NaN  Float.isNaN(myValue)   myPort.readStringUntil('\n')
  String string = myPort.readStringUntil('\n');
  if (string != null){
    string = trim(string);
    myValue = float(string);
    println (string);
  } 


  // read the input string
  // HINT: use myPort.readStringUntil('\n')  (https://processing.org/reference/libraries/serial/Serial_readStringUntil_.html)
  // if: the number is NaN, set current value to previous value
  // otherwise: 
  // 1. trim using trim()
  // 2. convert string to a number (i.e. a float)
  // 3. update previous value variable
  
  //STOP EDITING HERE
}

void draw () {
  // everything happens in the serialEvent()
  background(0); //uncomment if you want to control a ball
  stroke(127,34,255);     //stroke color
  strokeWeight(4);        //stroke wider
  
  // START EDITING HERE
  float x = map(myValue, -0.05, 0.05, 0, 600);
  float y = 200;
  line(300 + 300*0.005/0.05, 0, 300 + 300*0.005/0.05, 400);
  if (x > 300 + 300*0.005/0.05 - 15){
  x = 300 + 300*0.005/0.05 - 15;
  }
  ellipse(x, y, 30, 30);
  //println (x);
  
  // Virtual Wall
  // map the wall position from units of Arduino simulation to the screen width.
  // HINT: use map(myValue, minValueIn, maxValueIn, minValueOut, maxValueOut) to map from units of your Arduino simulation to pixels
  // draw the wall as a line (use "line" function: line(x1, y1, x2, y2))
  // draw an ellipse to represent user position (ellipse(x-coord, y-coord, ellipse width, ellipse height))
}
