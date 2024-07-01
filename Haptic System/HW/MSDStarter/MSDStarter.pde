// MAE 207 Winter 2021
// HW6_P2 Starter code


import processing.serial.*;

Serial myPort;        // The serial port

//initialize all variables
float inByte = 0; //current value of the first variable in the string
float lastByte = 0; //previous value of the first variable in the string
float inByte2 = 0; //current value of the second variable in the string
float lastByte2 = 0; //previous value of the second variable in the string
float myValue = 0;
float myValue1 = 0;

void setup () {
  // set the window size:
  size(600, 400);        

  // List all the available serial ports
  println(Serial.list());
  // Check the listed serial ports in your machine
  // and use the correct index number in Serial.list()[].

  //note you may need to change port number, it is 9 for me
  myPort = new Serial(this, Serial.list()[1], 38400);  // also make sure baud rate matches Arduino
  

  // A serialEvent() is generated when a newline character is received :
  myPort.bufferUntil('\n');
  background(0);      // set inital background:
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String string = myPort.readStringUntil(' ');   //hand position
  if (string != null){
    string = trim(string);
    myValue = float(string);
    println (string);
  } 
  String string1 = myPort.readStringUntil('\n');   //mass position
  if (string1 != null){
    string1 = trim(string1);
    myValue1 = float(string1);
    println (string1);
  } 
  
  //For Mass Spring Damper
  // make sure to match variable names with what has been declared above in lines 10-13 (or change the original variable names if you wish)
  
  // read the first part of the input string
  // HINT: use myPort.readStringUntil(' ') 
  // trim and convert string to a number
  // if: the number is NaN, set current value to previous value
  // otherwise: map the new value to the screen width
  //           & update previous value variable
  
  // HINT: use map(myValue, minValueIn, maxValueIn, minValueOut, maxValueOut) to map from units of your Arduino simulation to pixels 
  
  // repeat for second part of the input string, this time using myPort.readStringUntil('\n')
  
  //STOP EDITING HERE
  
}

void draw () {
  // everything happens in the serialEvent()
  background(0); //uncomment if you want to control a ball
  stroke(127,34,255);     //stroke color
  strokeWeight(4);        //stroke wider
  
  //START EDITING HERE
  //stroke(r,g,b);     //stroke color
  //strokeWeight(num);        //stroke wider
  
  
  // Mass Spring Damper
  float x = map(myValue, -0.05, 0.05, 0, 600);
  float y = 200;
  rect(580, 0, 30, 400);     //draw the wall
  float x_m = map(myValue1, -0.05, 0.05, 0, 600);
  if (abs(x_m - x) < 30){
  x_m = x + 30;
  }
  line(x_m,y,580,y);     //draw a line from the wall to the xMass
  ellipse(x_m, y, 30, 60);
  //draw an ellipse to represent the mass of the spring-mass-damper
  ellipse(x, y, 30, 30);
  //draw an ellipse to represent the user
  

}
