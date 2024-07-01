/**
 * project
 * 俯视：x方向两条竖杠+两个方形滑块，y方向一条横着+1个方滑块+1一个圆
 * 正视：x方向两个方块不动，y方向一个竖条上下动
 */
 
// https://processing.org/tutorials/coordinatesystemandshapes
// https://processing.org/tutorials/color

float mx;    //圆的位置
float my;
float mxl;    //左滑块位置
float myl;
float mxr;    //右滑块位置
float myr;
float mxa;    //x方向滑轨位置
float mya;
int radius = 15;    //圆的半径
int edge = 100;    

void setup() {
  size(1280, 640);     //屏幕大小
  noStroke();    // no outline
  ellipseMode(RADIUS);     //圆的大小 
}

void draw() { 
  background(51);    // bg color
  
  //限制框
  fill(76);
  rectMode(CENTER);
  rect(width/4, height/2, width/2-2*edge, height-2*edge);
  
  // 左右滑轨控制y方向 draw a rectangle with two points (the top left corner and the bottom right corner)
  fill(255);
  rectMode(CORNERS);
  rect(edge-30, edge, edge, width/2-edge);
  fill(255);
  rectMode(CORNERS);
  rect(width/2-edge, edge, width/2-edge+30, width/2-edge);

  //滑轨控制x方向
  mxa = width/4;
  mya = constrain(mouseY,edge+radius,height-edge-2*radius);
  fill(255);
  rectMode(CENTER);
  rect(mxa, mya, 500, 30);
  
  //左滑块
  mxl = constrain(mouseX, edge-15,edge-15);   
  myl = constrain(mouseY, edge+radius,height-edge-2*radius);
  fill(200);
  rectMode(CENTER);
  rect(mxl, myl, 30,30);
  
  //右滑块
  mxr = constrain(mouseX, width/2-edge+15,width/2-edge+15);   
  myr = constrain(mouseY, edge+radius,height-edge-2*radius);
  fill(200);
  rectMode(CENTER);
  rect(mxr, myr, 30,30);
  
  //x方向滑块和圆
  mx = constrain(mouseX,edge+radius,height-edge-radius);    
  my = constrain(mouseY,edge+radius,height-edge-2*radius);
  fill(200);    
  rectMode(CENTER);
  rect(mx, my, 30,30);
  ellipse(mx, my+15, radius, radius);
}
