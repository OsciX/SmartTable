/*
 Demonstration of how to create and use multiple windows with
 the G4P library.
 
 
 Since each window has its own unique data set they can all 
 share the code needed for mouse handling and drawing.
 It is a complex example and it is recommended that you read
 a detailed explanation of the code used which can be found at:
 
 http://www.lagers.org.uk/g4p/applets/g4p_windowsstarter
 
 for Processing V3
 (c) 2015 Peter Lager
 
 */

import g4p_controls.*;

GWindow[] window;
int winX = 200;
int deltaX = 5;
public void setup() {
  fullScreen();
  createWindows();
}

/**
 * Draw for the main window
 */
public void draw() {
  background(0,0,0);
  for (int winNum = 0; winNum < 3; winNum++) {
    window[winNum].setLocation(winX, (250*winNum)+200);
  }
  winX = winX + deltaX;
  if (winX > 1520) { deltaX = -5; }
  if (winX < 200) { deltaX = 5; }
}

/**
 Create the three windows so that they share mouse handling 
 and drawing code.
 */
public void createWindows() {
  //int[] col = {color(200,0,0), color(0,200,0), color(0,0,200) };
  int col;
  window = new GWindow[3];
  for (int i = 0; i < 3; i++) {
    col = (128 << (i * 8)) | 0xff000000;
    window[i] = GWindow.getWindow(this, "", 70+i*220, 100+i*50, 200, 200, JAVA2D);
    
    
    //window[i].removeNotify(); window[i].setUndecorated(true); window[i].frame.addNotify();
    window[i].setLocation(1920/3, 300*i);
    window[i].addData(new MyWinData());      
    ((MyWinData)window[i].data).col = col;
    window[i].addDrawHandler(this, "windowDraw");
    window[i].addMouseHandler(this, "windowMouse");
  }
}

/**
 * Click the button to create the windows.
 * @param button
 */

/**
 * Handles mouse events for ALL GWindow objects
 *  
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 * @param event the mouse event
 */
public void windowMouse(PApplet appc, GWinData data, MouseEvent event) {
  MyWinData data2 = (MyWinData)data;
  switch(event.getAction()) {
  case MouseEvent.PRESS:
    data2.sx = data2.ex = appc.mouseX;
    data2.sy = data2.ey = appc.mouseY;
    data2.done = false;
    break;
  case MouseEvent.RELEASE:
    data2.ex = appc.mouseX;
    data2.ey = appc.mouseY;
    data2.done = true;
    break;
  case MouseEvent.DRAG:
    data2.ex = appc.mouseX;
    data2.ey = appc.mouseY;
    break;
  }
}

/**
 * Handles drawing to the windows PApplet area
 * 
 * @param appc the PApplet object embeded into the frame
 * @param data the data for the GWindow being used
 */
public void windowDraw(PApplet appc, GWinData data) {
  MyWinData data2 = (MyWinData)data;
  appc.background(data2.col);
  if (!(data2.sx == data2.ex && data2.ey == data2.ey)) {
    appc.stroke(255);
    appc.strokeWeight(2);
    appc.noFill();
    if (data2.done) {
      appc.fill(128);
    }
    appc.rectMode(CORNERS);
    appc.rect(data2.sx, data2.sy, data2.ex, data2.ey);
  }
}  

/**
 * Simple class that extends GWinData and holds the data 
 * that is specific to a particular window.
 * 
 * @author Peter Lager
 */
class MyWinData extends GWinData {
  int sx, sy, ex, ey;
  boolean done;
  int col;
}