import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import g4p_controls.*;
Kinect kinect;
GWindow clockWindow, weatherWindow, kinectWindow, calendarWindow, newsWindow;
int[] depthValue = new int[307211]; //saved depth map
int[] newDepthValue = new int[307211]; //current depth map
IntList changedPixels = new IntList(); //list of pixels that differ from the original height value
IntList usedPixels = new IntList(); //list of pixels that are being projected onto
IntList clockPixels = new IntList();
IntList weatherPixels = new IntList();
IntList calendarPixels = new IntList();
IntList newsPixels = new IntList();
int minSize = 155;
int uiX;
int uiY;
int kinectX;
int kinectY;
int offsetX = -50;
int offsetY = 0;
int uiWidth;
int uiHeight;
int timer = 0;
int movePixel;
boolean first; //calbration bool
boolean true1; //frist corner
boolean true2;
boolean true3;
boolean true4;
boolean changed = true;
boolean widgetMoved = true;
boolean widgetSNM = false;
boolean shrinkAll = false;
boolean shrinkAllMore = false;
boolean destroy;
boolean object;
int loops = 0;

PVector moved;
int[] calibrationCompare = new int[307201]; //calibration depth map comparison
int test;

int firstCorner; //top left corner for calibration  
int secondCorner; //bottom right corner for calibration
int projectWidth; // projection height
int projectHeight; //projection width
int movingWidgetWidth;
int movingWidgetHeight;


char movingWidget;
//widget sizes

//TL = Top Left, TR = Top Right, BL = Bottom Left, BR = Bottom Right
//0 = Top Left
//1 = Top Right
//2 = Bottom Left
//3 = Bottom Right
//4 = X
//5 = Y
//6 = Width
//7 = Height
int[] clockInfo = new int[8];
int[] weather1Info = new int[8];
int[] weather2Info = new int[8];
int[] calendarInfo = new int[8];
int[] newsInfo = new int[8];


int line; //line counter for usedPixels

PFont LibSansBold;
void setup() {
  
  fullScreen(2); //draw screen kinect sized
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableMirror(true);

  background(#000000);
  LibSansBold = createFont("data/LiberationSans-Bold.ttf", 32);
  createWindows();
  textFont(LibSansBold);

  weatherWindow.textFont(LibSansBold);
  calendarWindow.textFont(LibSansBold);
  clockWindow.textFont(LibSansBold);
  newsWindow.textFont(LibSansBold);
  
      println("Starting");
    arrayCopy(kinect.getRawDepth(), depthValue); 
    clockWindow.setVisible(false);
    weatherWindow.setVisible(false);
    calendarWindow.setVisible(false);
    newsWindow.setVisible(false);
    first = true;
    true1 = false;
    true2 = false;   //pressing Space creates an array of pixels that show change in depth, resets screen
    true3 = false;
} // declares new kinect and activates depth camera


void keyPressed() {

  if (key == ' ') {
    println("Starting");
    arrayCopy(kinect.getRawDepth(), depthValue); 
    clockWindow.setVisible(false);
    weatherWindow.setVisible(false);
    calendarWindow.setVisible(false);
    newsWindow.setVisible(false);
    first = true;
    true1 = false;
    true2 = false;   //pressing Space creates an array of pixels that show change in depth, resets screen
    true3 = false;
  }
  
  if (key == '1') {
    println("Drawing first corner");
    arrayCopy(kinect.getRawDepth(), calibrationCompare); 
    for (int i = 307200; i > 1; i -= 10) {
      if (((abs(depthValue[i] - calibrationCompare[i]) > 20))  &&  ((abs(depthValue[i - 25] - calibrationCompare[i - 25]) > 20)) &&  ((abs(depthValue[i - 50] - calibrationCompare[i - 50]) > 20))) {
        firstCorner = i;
        println(i);
        true1 = true;
        break;
      }
    }
  }  //draws an ellipse at the location of a change in depth, ideally a person's hand. Starts at bottom right corner and goes up to the top left


  if (key == '2') {
    println("Drawing second3 corner");
    arrayCopy(kinect.getRawDepth(), calibrationCompare); 
    for (int i = 307200; i > 1; i -= 10) {
      if (((abs(depthValue[i] - calibrationCompare[i]) > 20))  && ((abs(depthValue[i - 25] - calibrationCompare[i - 25]) > 20)) && ((abs(depthValue[i - 50] - calibrationCompare[i - 50]) > 20))) {
        secondCorner = i;
        println(i);
        true2 = true;
        break;
      }
    }
  } //draws an ellipse at the location of a change in depth, ideally a person's hand. Starts at the bottom right corner and goes up to the left

  if (key == '3') {
    firstCorner = 11630;
    secondCorner = 149680;
    true1 = true;
    true2 = true;
  }
} 
//used to designate a rectangular screen without using your hands for calibration
void draw() {
  //PImage depthImage = kinect.getDepthImage();
  //image(depthImage, 0, 0); //shows image of table 
  if (true1 == true && true2 == true) { //if both corners exist
    if (true3 == false) {
      if (uiWidth >= uiHeight) { //for tables that are wider than they are long, draws squares where widgets will be. All measures are parametric based on the size of the screen
        //0 = Top Left
        //1 = Top Right
        //2 = Bottom Left
        //3 = Bottom Right
        //4 = X
        //5 = Y 
        //6 = Width
        //7 = Height
        if (uiWidth >= uiHeight*2) { //extreme case if width is much greater than height
          if (int(.33*uiWidth) < minSize) {
            calendarInfo[6] = minSize;
          } else {
            calendarInfo[6] = int(.33*uiWidth); //set prameters relative to projection size
          }
          if (int(.5*uiHeight) < minSize) {
            calendarInfo[7] = minSize;
          } else {
            calendarInfo[7] = int(.5*uiHeight);
          }
          if (uiWidth < minSize) {
            newsInfo[6] = minSize;
          } else {
            newsInfo[6] = uiWidth;
          }
          if (int(.125*uiHeight) < minSize) {
            newsInfo[7] = minSize;
          } else {
            newsInfo[7] = int(.125*uiHeight);
          }
          if (int(.4*uiHeight) < minSize) {
            clockInfo[6] = minSize;
            clockInfo[7] = minSize;
          } else {
            clockInfo[6] = int(.4*uiHeight);
            clockInfo[7] = int(.4*uiHeight);
          }
          if (int(.4*uiHeight) < minSize) {
            weather1Info[6] = minSize;
            weather1Info[7] = minSize;
          } else {
            weather1Info[6] = int(.4*uiHeight);
            weather1Info[7] = int(.4*uiHeight);
          }

          
          clockInfo[4] = int(uiX+ .05*uiWidth);
          clockInfo[5] = int(uiY+ .25*uiHeight);
          clockInfo[0] = clockInfo[4] + clockInfo[5]*1280; 
          clockInfo[1] = clockInfo[0] + clockInfo[6]; 
          clockInfo[2] = clockInfo[0] + clockInfo[7]*1280;
          clockInfo[3] = clockInfo[1] + clockInfo[7]*1280;

          weather1Info[4] = int(uiX+ .35*uiWidth);
          weather1Info[5] = int(uiY+ .08*uiHeight);
          weather1Info[0] = weather1Info[4] + weather1Info[5]*1280;
          weather1Info[1] = weather1Info[0] + weather1Info[6];
          weather1Info[2] = weather1Info[0] + weather1Info[7]*1280;
          weather1Info[3] = weather1Info[1] + weather1Info[7]*1280;

          calendarInfo[4] = int(uiX+ .67*uiWidth);
          calendarInfo[5] = int(uiY+ .375*uiHeight);
          calendarInfo[0] = calendarInfo[4] + calendarInfo[5]*1280;
          calendarInfo[1] = calendarInfo[0] + calendarInfo[6];
          calendarInfo[2] = calendarInfo[0] + calendarInfo[7]*1280;
          calendarInfo[3] = calendarInfo[1] + calendarInfo[7]*1280;

          newsInfo[4] =uiX;
          newsInfo[5] = int(uiY+ .875*uiHeight);

          newsInfo[0] = newsInfo[4] + newsInfo[5]*1280;
          newsInfo[1] = newsInfo[0] + newsInfo[6];
          newsInfo[2] = newsInfo[0] + newsInfo[7]*1280;
          newsInfo[3] = newsInfo[1] + newsInfo[7]*1280;
        } else { //if normal
          if (calendarInfo[6] < 100) {
            calendarInfo[6] = 100;
          } else {
            calendarInfo[6] = int(.33*uiWidth); //does the same thing, but for abnormally wide rectangles
          }
          if (calendarInfo[7] < 100) {
            calendarInfo[7] = 100;
          } else {
            calendarInfo[7] = int(.5*uiHeight); //set prameters relative to projection size
          }
          if (newsInfo[6] < 100) {
            newsInfo[6] = 100;
          } else {
            newsInfo[6] = uiWidth;
          }
          if (newsInfo[7] < 100) {
            newsInfo[7] = 100;
          } else {
            newsInfo[7] = int(.125*uiHeight);
          }
          if (clockInfo[6] < 100) {
            clockInfo[6] = 100;
            clockInfo[7] = 100;
          } else {
            clockInfo[6] = int(.25*uiHeight);
            clockInfo[7] = int(.25*uiHeight);
          }
          if (weather1Info[6] < 100) {
            weather1Info[6] = 100;
            weather1Info[7] = 100;
          } else {
            weather1Info[6] = int(.25*uiHeight);
            weather1Info[7] = int(.25*uiHeight);
          }

          clockInfo[4] = int(uiX+ .05*uiWidth);
          clockInfo[5] = int(uiY+ .25*uiHeight);
          clockInfo[0] = clockInfo[4] + clockInfo[5]*640; 
          clockInfo[1] = clockInfo[0] + clockInfo[6]; 
          clockInfo[2] = clockInfo[0] + clockInfo[7]*640;
          clockInfo[3] = clockInfo[1] + clockInfo[7]*640;

          weather1Info[4] = int(uiX+ .35*uiWidth);
          weather1Info[5] = int(uiY+ .08*uiHeight);
          weather1Info[0] = weather1Info[4] + weather1Info[5]*640;
          weather1Info[1] = weather1Info[0] + weather1Info[6];
          weather1Info[2] = weather1Info[0] + weather1Info[7]*640;
          weather1Info[3] = weather1Info[1] + weather1Info[7]*640;

          calendarInfo[4] = int(uiX+ .67*uiWidth);
          calendarInfo[5] = int(uiY+ .375*uiHeight);
          calendarInfo[0] = calendarInfo[4] + calendarInfo[5]*640;
          calendarInfo[1] = calendarInfo[0] + calendarInfo[6];
          calendarInfo[2] = calendarInfo[0] + calendarInfo[7]*640;
          calendarInfo[3] = calendarInfo[1] + calendarInfo[7]*640;

          newsInfo[4] =uiX;
          newsInfo[5] = int(uiY+ .875*uiHeight);
          newsInfo[0] = newsInfo[4] + newsInfo[5]*640;
          newsInfo[1] = newsInfo[0] + newsInfo[6];
          newsInfo[2] = newsInfo[0] + newsInfo[7]*640;
          newsInfo[3] = newsInfo[1] + newsInfo[7]*640;
        }
      } else if (uiHeight > uiWidth) { //same thing, but for rectangles that are taller than they are wide
        //0 = Top Left
        //1 = Top Right
        //2 = Bottom Left
        //3 = Bottom Right
        //4 = X
        //5 = Y
        //6 = Width
        //7 = Height
        if (calendarInfo[6] < 100) {
          calendarInfo[6] = 100;
        } else {
          calendarInfo[6] = int(.5*uiWidth); //set prameters relative to projection size
        }
        if (calendarInfo[7] < 100) {
          calendarInfo[7] = 100;
        } else {
          calendarInfo[7] = int(.375*uiHeight);
        }
        if (newsInfo[6] < 100) {
          newsInfo[6] = 100;
        } else {
          newsInfo[6] = uiWidth;
        }
        if (newsInfo[7] < 100) {
          newsInfo[7] = 100;
        } else {
          newsInfo[7] = int(.125*uiHeight);
        }
        if (clockInfo[6] < 100) {
          clockInfo[6] = 100;
          clockInfo[7] = 100;
        } else {
          clockInfo[6] = int(.35*uiWidth);
          clockInfo[7] = int(.35*uiWidth);
        }
        if (weather1Info[6] < 100) {
          weather1Info[6] = 100;
          weather1Info[7] = 100;
        } else {
          weather1Info[6] = int(.4*uiWidth);
          weather1Info[7] = int(.4*uiWidth);
        }

        println("ClockX" + clockInfo[4]);
        clockInfo[4] = int(uiX+ .1*uiWidth);
        clockInfo[5] = int(uiY+ .45*uiHeight);


        clockInfo[0] = clockInfo[4] + clockInfo[5]*640; 
        clockInfo[1] = clockInfo[0] + clockInfo[6]; //this is not important, jk
        clockInfo[2] = clockInfo[0] + clockInfo[7]*640;
        clockInfo[3] = clockInfo[1] + clockInfo[7]*640;


        weather1Info[4] = int(uiX+ .6*uiWidth);
        weather1Info[5] = int(uiY+ .3*uiHeight);


        weather1Info[0] = weather1Info[4] + weather1Info[5]*640;
        weather1Info[1] = weather1Info[0] + weather1Info[6];
        weather1Info[2] = weather1Info[0] + weather1Info[7]*640;
        weather1Info[3] = weather1Info[1] + weather1Info[7]*640;


        calendarInfo[4] =uiX;
        calendarInfo[5] =uiY;

        calendarInfo[0] = calendarInfo[4] + calendarInfo[5]*640;
        calendarInfo[1] = calendarInfo[0] + calendarInfo[6];
        calendarInfo[2] = calendarInfo[0] + calendarInfo[7]*640;
        calendarInfo[3] = calendarInfo[1] + calendarInfo[7]*640;



        newsInfo[4] =uiX;
        newsInfo[5] = int(uiY+ .875*uiHeight);

        newsInfo[0] = newsInfo[4] + newsInfo[5]*640;
        newsInfo[1] = newsInfo[0] + newsInfo[6];
        newsInfo[2] = newsInfo[0] + newsInfo[7]*640;
        newsInfo[3] = newsInfo[1] + newsInfo[7]*640;
      }
      clockWindow.getSurface().setSize(clockInfo[6], clockInfo[7]);
      clockWindow.setLocation(1920+clockInfo[4], clockInfo[5]);
      clockWindow.setVisible(true);
      getUsedPixels();
      weatherWindow.getSurface().setSize(weather1Info[6], weather1Info[7]);
      weatherWindow.setLocation(1920+weather1Info[4], weather1Info[5]);
      weatherWindow.setVisible(true);
      calendarWindow.getSurface().setSize(calendarInfo[6], calendarInfo[7]);
      calendarWindow.setLocation(1920+calendarInfo[4], calendarInfo[5]);
      calendarWindow.setVisible(true);
      newsWindow.getSurface().setSize(newsInfo[6], newsInfo[7]);
      newsWindow.setLocation(1920+newsInfo[4], newsInfo[5]);
      newsWindow.setVisible(true);
      true3 = true;
    }
    arrayCopy(kinect.getRawDepth(), newDepthValue);
    changedPixels.clear();
    loadPixels();
    kinectWindow.loadPixels();
    for (int i = kinectY; i < (projectHeight +kinectY); i+= 5) {
      for (int j = kinectX; j < (projectWidth + kinectX); j+= 20) {
        if ((abs(newDepthValue[j + i*640] - depthValue[j + i*640]) > 20) && ((abs(newDepthValue[j+10 + i*640] - depthValue[j+10 + i*640]) > 20) || (abs(newDepthValue[j-10 + i*640] - depthValue[j-10 + i*640]) > 20) || (abs(newDepthValue[j + (i+10)*640] - depthValue[j + (i+10)*640]) > 20) || (abs(newDepthValue[j + (i-10)*640] - depthValue[j + (i-10)*640]) > 20) ) ) {
          changedPixels.append(j*2 + offsetX + (i*2+offsetY)*1280);
          kinectWindow.pixels[j+i*640] = (#00ff00);
        }
        else{
          kinectWindow.pixels[j+i*640] = (#000000);
        }
      }
    }
    updatePixels();
    kinectWindow.updatePixels();
    changedPixels.sort();
    if (changedPixels.size() > 0) {
      if (millis() - timer > 1000) {
        for (int k = 0; k < changedPixels.size(); k++) {
          if (usedPixels.hasValue(changedPixels.get(k))) {
            widgetMoved = false;
            if (clockPixels.hasValue(changedPixels.get(k))) {
              movingWidgetWidth = clockInfo[6];
              movingWidgetHeight = clockInfo[7];
              movingWidget = 'c';
              print(movingWidget); 
              println(" " + test);
              test++;
              break;
            } else if (weatherPixels.hasValue(changedPixels.get(k))) {
              movingWidgetWidth = weather1Info[6];
              movingWidgetHeight = weather1Info[7];
              movingWidget = 'w';
              print(movingWidget); 
              println(" " + test);
              test++;
              break;
            } else if (calendarPixels.hasValue(changedPixels.get(k))) {
              movingWidgetWidth = calendarInfo[6];
              movingWidgetHeight = calendarInfo[7];
              movingWidget = 'a';
              print(movingWidget); 
              println(" " + test);
              test++;
              break;
            } else if (newsPixels.hasValue(changedPixels.get(k))) {
              widgetMoved = true;
              break;
            }
          }
        }
        timer = millis();
      }
    }

    while (widgetMoved == false) {
      loops++;
      if (movingWidgetWidth < minSize || movingWidgetHeight < minSize || destroy == true) {
        println("achieved min size");
        usedPixels.clear();
        switch(movingWidget) {
        case 'c':
          clockWindow.setVisible(false);
          for (int i = weather1Info[5]; i < weather1Info[7] + weather1Info[5]; i++) {
            for ( int j = weather1Info[4]; j < weather1Info[6] + weather1Info[4]; j++) {
              weatherPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
          for (int i = calendarInfo[5]; i < calendarInfo[7]+ calendarInfo[5]; i++) {
            for (int j = calendarInfo[4]; j < calendarInfo[6] + calendarInfo[4]; j++) {
              //   kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#ffff00);
              calendarPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
          for (int i = newsInfo[5]; i < newsInfo[7]+ newsInfo[5]; i++) {
            for (int j = newsInfo[4]; j < newsInfo[6] + newsInfo[4]; j++) {
              //  kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#ff7f00);
              newsPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }

        case 'w':
          weatherWindow.setVisible(false);
          for (int i = clockInfo[5]; i < clockInfo[7] + clockInfo[5]; i++) {
            for (int j = clockInfo[4]; j < clockInfo[6]/2 + clockInfo[4]; j++) {
              //   kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#ff0000);
              clockPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
          for (int i = calendarInfo[5]; i < calendarInfo[7]+ calendarInfo[5]; i++) {
            for (int j = calendarInfo[4]; j < calendarInfo[6] + calendarInfo[4]; j++) {
              //   kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#ffff00);
              calendarPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
          for (int i = newsInfo[5]; i < newsInfo[7] + newsInfo[5]; i++) {
            for (int j = newsInfo[4]; j < newsInfo[6] + newsInfo[4]; j++) {
              //  kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#ff7f00);
              newsPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
        case 'a':
          for (int i = clockInfo[5]; i < clockInfo[7] + clockInfo[5]; i++) {
            for (int j = clockInfo[4]; j < clockInfo[6] + clockInfo[4]; j++) {
              //   kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#ff0000);
              clockPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
          for (int i = weather1Info[5]; i < weather1Info[7] + weather1Info[5]; i++) {
            for (int j = weather1Info[4]; j < weather1Info[6] + weather1Info[4]; j++) {
              //  kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#00ff00);
              weatherPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
          for (int i = newsInfo[5]; i < newsInfo[7] + newsInfo[5]; i++) {
            for (int j = newsInfo[4]; j < newsInfo[6] + newsInfo[4]; j++) {
              //  kinectWindow.pixels[int(j/2 + i*640/2.1333)] = (#ff7f00);
              newsPixels.append(j+i*1280);
              usedPixels.append(j+i*1280);
            }
          }
          calendarWindow.setVisible(false);
        }
        usedPixels.sort(); //sort pixels
        widgetMoved = true;
        break;
      }
      println(loops + " Cannot destroy");
      for (int i = uiY; i < uiY + uiHeight; i+=10) {
        if (widgetMoved == true) {
          println("breaking2");
          break;
        }
        for (int j = uiX; j < uiX+uiWidth; j+=10) {
          movePixel = j+ i *1280;
          if (!usedPixels.hasValue(movePixel) && !usedPixels.hasValue(movePixel + 40 + movingWidgetWidth) && !usedPixels.hasValue(movePixel+ 40 + movingWidgetWidth + movingWidgetHeight * 1280) && !usedPixels.hasValue(movePixel+ movingWidgetHeight * 1280) && !usedPixels.hasValue(movePixel+ 40 + movingWidgetWidth + movingWidgetHeight * 640) && !usedPixels.hasValue(movePixel+ 40 + movingWidgetHeight * 640) /*&& !usedPixels.hasValue(movePixel + 40 + movingWidgetWidth/2) && !usedPixels.hasValue(movePixel+ 40 + movingWidgetWidth/2 + movingWidgetHeight * 1280)*/) {
            switch(movingWidget) {
            case 'c':
              clockInfo[4] = j;
              clockInfo[5] = i;
              clockInfo[6] = movingWidgetWidth;
              clockInfo[7] = movingWidgetHeight;
              break;
            case 'w':
              weather1Info[4] = j;
              weather1Info[5] = i;
              weather1Info[6] = movingWidgetWidth;
              weather1Info[7] = movingWidgetHeight;
              break;
            case 'a':
              calendarInfo[4] = j;
              calendarInfo[5] = i;
              calendarInfo[6] = movingWidgetWidth;
              calendarInfo[7] = movingWidgetHeight;
              break;
            }
            println(movingWidget + " Move Successful");
            widgetMoved = true;
            clockWindow.getSurface().setSize(clockInfo[6], clockInfo[7]);
            clockWindow.setLocation(clockInfo[4] + 1920, clockInfo[5]);
            
            weatherWindow.getSurface().setSize(weather1Info[6], weather1Info[7]);
            weatherWindow.setLocation(weather1Info[4] + 1920, weather1Info[5]);

            calendarWindow.getSurface().setSize(calendarInfo[6], calendarInfo[7]);
            calendarWindow.setLocation(calendarInfo[4] + 1920, calendarInfo[5]);
            getUsedPixels();
            break;
          }
        }
      }
      if (widgetMoved == true) {
        println("breaking");
        movingWidget = ' ';
        break;
      }
      println(loops + " Cannot move");
      if (widgetSNM) {
        println("widgetSNM");
        movingWidgetHeight = int(0.6 * movingWidgetHeight);
        movingWidgetWidth = int(0.6 * movingWidgetWidth); 
        getUsedPixels();
      } 
      if (widgetSNM == true && widgetMoved == false && loops == 2) {
        shrinkAll = true;
      }
      if (widgetMoved == false) {
        println("First Shrink");
        movingWidgetHeight = int(0.8 * movingWidgetHeight);
        movingWidgetWidth = int(0.8 * movingWidgetWidth);
        getUsedPixels();
        widgetSNM = true;
      }
      if (shrinkAllMore == true) {
        println("Shirnk All More");
        clockInfo[7] = int(clockInfo[7] * 0.6);
        clockInfo[6] = int(clockInfo[6] * 0.6);
        if (clockInfo[6] < minSize) {
          clockInfo[6] = minSize;
          clockInfo[7] = minSize;
          destroy = true;
        }
        calendarInfo[7] = int(calendarInfo[7] * 0.6);
        if (calendarInfo[7] < minSize) {
          calendarInfo[7] = minSize;
          destroy = true;
        }
        calendarInfo[6] = int(calendarInfo[6] * 0.6);
        if (calendarInfo[6] < minSize) {
          calendarInfo[6] = minSize;
          destroy = true;
        }
        weather1Info[7] = int(weather1Info[7] * 0.6);
        weather1Info[6] = int(weather1Info[6] * 0.6);
        if (weather1Info[6] < minSize) {
          weather1Info[6] = minSize;
          weather1Info[7] = minSize;
          destroy = true;
        }
        getUsedPixels();
      }  
      if (shrinkAll) {
        println("Shrink All");
        clockInfo[7] = int(clockInfo[7] * 0.8);
        clockInfo[6] = int(clockInfo[6] * 0.8);
        if (clockInfo[6] < minSize) {
          clockInfo[6] = minSize;
          clockInfo[7] = minSize;
          destroy = true;
        }
        calendarInfo[7] = int(calendarInfo[7] * 0.8);
        if (calendarInfo[7] < minSize) {
          calendarInfo[7] = minSize;
          destroy = true;
        }
        calendarInfo[6] = int(calendarInfo[6] * 0.8);
        if (calendarInfo[6] < minSize) {
          calendarInfo[6] = minSize;
          destroy = true;
        }
        weather1Info[7] = int(weather1Info[7] * 0.8);
        weather1Info[6] = int(weather1Info[6] * 0.8);
        if (weather1Info[6] < minSize) {
          weather1Info[6] = minSize;
          weather1Info[7] = minSize;
          destroy = true;
        }
      } else  if (shrinkAll && widgetSNM) { 
        shrinkAllMore = true;
      } 
    }
    loops = 0;
  } else if (true1 == true) {
    stroke(#ffffff);
    fill(#ffffff);
    ellipse((firstCorner%640)*2 + offsetX, (firstCorner-(firstCorner%640))/1280, 10, 10 + offsetY); //draws first ellipse
  } else if (true2 == true) {
    stroke(#ffffff);
    fill(#ffffff);
    ellipse((secondCorner%640)*2 + offsetX, int((secondCorner-(secondCorner%640))/1280) + offsetY, 10, 10); //draws second ellipse
  } else {
    background(0);
    stroke(#ffffff);
    fill(#ffffff);
  }
}



public void createWindows() {
  clockWindow = GWindow.getWindow(this, "Clock", 0, 0, 25, 25, JAVA2D);
  clockWindow.setVisible(false);
  clockWindow.setAlwaysOnTop(true);
  clockWindow.addDrawHandler(this, "clockDraw");
  clockWindow.frameRate(4);


  weatherWindow = GWindow.getWindow(this, "Weather", 0, 0, 25, 25, JAVA2D);
  weatherWindow.setAlwaysOnTop(true);
  weatherWindow.setVisible(false);
  weatherWindow.addDrawHandler(this, "weatherDraw");
  weatherWindow.frameRate(1);

  calendarWindow = GWindow.getWindow(this, "Calendar", 0, 0, 10, 10, JAVA2D);
  calendarWindow.setAlwaysOnTop(true);
  calendarWindow.setVisible(false);
  calendarWindow.addDrawHandler(this, "calendarDraw");
  calendarWindow.frameRate(1);

  newsWindow = GWindow.getWindow(this, "News", 0, 0, 10, 10, JAVA2D);
  newsWindow.setAlwaysOnTop(true); 
  newsWindow.setVisible(false);
  newsWindow.addDrawHandler(this, "newsDraw");

  kinectWindow = GWindow.getWindow(this, "Kinect", 0, 0, 640, 480, JAVA2D);   
  kinectWindow.addDrawHandler(this, "kinectDraw");
}

public void getUsedPixels() {
  loadPixels();
  usedPixels.clear();
  for (int i = clockInfo[5]; i < clockInfo[7] + clockInfo[5]; i++) {
    for (int j = clockInfo[4]; j < clockInfo[6] + clockInfo[4]; j++) {
      clockPixels.append(j+i*1280);
      usedPixels.append(j+i*1280);
    }
  }
  for (int i = weather1Info[5]; i < weather1Info[7] + weather1Info[5]; i++) {
    for (int j = weather1Info[4]; j < weather1Info[6] + weather1Info[4]; j++) {
      weatherPixels.append(j+i*1280);
      usedPixels.append(j+i*1280);
    }
  }
  for (int i = calendarInfo[5]; i <calendarInfo[7]+ calendarInfo[5]; i++) {
    for (int j = calendarInfo[4]; j < calendarInfo[6] + calendarInfo[4]; j++) {
      calendarPixels.append(j+i*1280);
      usedPixels.append(j+i*1280);
    }
  }
  for (int i = newsInfo[5]; i < newsInfo[7] + newsInfo[5]; i++) {
    for (int j = newsInfo[4]; j < newsInfo[6] + newsInfo[4]; j++) {
      newsPixels.append(j+i*1280);
      usedPixels.append(j+i*1280);
    }
  } 
  usedPixels.sort(); //sort pixels
  updatePixels();
}

public void createTimers() {
  /*
  Timer locationApi = new Timer();
   locationApi.schedule(new locationApiCall(), 0, 43200*1000);
   */

  Timer weatherApi = new Timer();
  weatherApi.schedule(new weatherApiCall(), 0, 120*1000);

  Timer calendarApi = new Timer();
  calendarApi.schedule(new calendarApiCall(), 0, 60*1000);

  Timer newsApi = new Timer();
  newsApi.schedule(new newsApiCall(), 0, 600*1000);
}