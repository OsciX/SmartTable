import org.openkinect.freenect.*;
import org.openkinect.processing.*;
Kinect kinect;
int[] depthValue = new int[307201]; //saved depth map
int[] newDepthValue = new int[307201]; //current depth map
IntList changedPixels = new IntList(); //list of pixels that differ from the original height value
IntList usedPixels = new IntList(); //list of pixels that are being projected onto
int x; //projection corner x
int y; //projection corner y
boolean first; //calbration bool
boolean true1; //frist corner
boolean true2;
int[] calibrationCompare = new int[307201]; //calibration depth map comparison

int firstCorner; //top left corner for calibration  
int secondCorner; //bottom right corner for calibration
int projectWidth; // projection height
int projectHeight; //projection width
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



void setup() {
  size(640, 480); //draw screen kinect sized
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableMirror(false);
} // declares new kinect and activates depth camera

void keyPressed(){
 if(key == ' '){
    println("Starting");
    arrayCopy(kinect.getRawDepth(), depthValue); 
    first = true;
    true1 = false;
    true2 = false;   //pressing Space creates an array of pixels that show change in depth, resets screen
  }
  if(key == '1') {
    println("Drawing first corner");
      arrayCopy(kinect.getRawDepth(), calibrationCompare); 
      for(int i = 307200; i > 1; i -= 10) {
         if(((abs(depthValue[i] - calibrationCompare[i]) > 20))  &&  ((abs(depthValue[i - 25] - calibrationCompare[i - 25]) > 20)) &&  ((abs(depthValue[i - 50] - calibrationCompare[i - 50]) > 20))) {
           firstCorner = i;
           true1 = true;
           break;
         }
      }
    }  //draws an ellipse at the location of a change in depth, ideally a person's hand. Starts at bottom right corner and goes up to the top left
  
  
   if(key == '2') {

      arrayCopy(kinect.getRawDepth(), calibrationCompare); 
      for(int i = 307200; i > 1; i -= 10) {
         if(((abs(depthValue[i] - calibrationCompare[i]) > 20))  && ((abs(depthValue[i - 25] - calibrationCompare[i - 25]) > 20)) && ((abs(depthValue[i - 50] - calibrationCompare[i - 50]) > 20))) {
           secondCorner = i;
           println(i);
           true2 = true;
           break;
         }         
      }
  } //draws an ellipse at the location of a change in depth, ideally a person's hand. Starts at the bottom right corner and goes up to the left
  
  if(key == '3'){
    firstCorner = 23100;
    secondCorner = 300630;
    true1 = true;
    true2 = true;
  }
} 
//used to designate a rectangular screen without using your hands for calibration


void draw() {
  PImage depthImage = kinect.getDepthImage();
  image(depthImage, 0, 0); //shows image of table 
  if(first == true){
    changedPixels.clear(); //reset changed pixels
    arrayCopy(kinect.getRawDepth(), newDepthValue); //copy depth map to array
    loadPixels(); 
    for(int i = 1; i < 307201; i += 50) { //see if any pixels are changed
      if((abs(newDepthValue[i] - depthValue[i]) > 20)) {
        pixels[i] = color(#ff0000);
        changedPixels.append(i); //add if changed
      }
      else {
      pixels[i] = color(#000000);
      }
    }
  
    updatePixels();
  }
  if(true1 == true){
    stroke(#00ff00);
     ellipse(firstCorner%640, (firstCorner-(firstCorner%640))/640, 10, 10); //draws first ellipse
  }
  if(true2 == true){
    stroke(#00ff00);
     ellipse(secondCorner%640, (secondCorner-(secondCorner%640))/640, 10, 10); //draws second ellipse
  }
  if(true1 == true && true2 == true){ //if both corners exist
  usedPixels.clear();
  background(#000000, 0);
    fill(#ffffff,0);
    x = firstCorner%640; //sets top left corner of table x coord
    y = (firstCorner-(firstCorner%640))/640; //sets top left corner of table y coord
    projectWidth = (abs(secondCorner%640 - firstCorner%640)); //sets width of projection
    projectHeight = (abs((firstCorner-(firstCorner%640))/640 - (secondCorner-(secondCorner%640))/640)); //sets height of projection
    rect(x, y, projectWidth, projectHeight); //draws rectangle where projection is defined
   
    if(projectWidth >= projectHeight) { //for tables that are wider than they are long, draws squares where widgets will be. All measures are parametric based on the size of the screen
      //0 = Top Left
      //1 = Top Right
      //2 = Bottom Left
      //3 = Bottom Right
      //4 = X
      //5 = Y
      //6 = Width
      //7 = Height
      if(projectWidth >= projectHeight*2){ //extreme case if width is much greater than height
        calendarInfo[6] = int(.33*projectWidth); //set prameters relative to projection size
        calendarInfo[7] = int(.5*projectHeight);
        newsInfo[6] = projectWidth;
        newsInfo[7] = int(.125*projectHeight);
        clockInfo[6] = int(.25*projectHeight);
        clockInfo[7] = int(.25*projectHeight);
        weather1Info[6] = int(.25*projectHeight);
        weather1Info[7] = int(.25*projectHeight);
        weather2Info[6] = int(.25*projectHeight);
        weather2Info[7] = int(.25*projectHeight);
        
        stroke(#ff0000);//clock
        clockInfo[4] = int(x + .05*projectWidth);
        clockInfo[5] = int(y + .25*projectHeight);
        rect(clockInfo[4], clockInfo[5], clockInfo[6], clockInfo[7]); //set corners and draw
        clockInfo[0] = clockInfo[4] + clockInfo[5]*640; 
        clockInfo[1] = clockInfo[0] + clockInfo[6]; 
        clockInfo[2] = clockInfo[0] + clockInfo[7]*640;
        clockInfo[3] = clockInfo[1] + clockInfo[7]*640;
        
        stroke(#0000ff);//weather1
        weather1Info[4] = int(x + .35*projectWidth);
        weather1Info[5] = int(y + .08*projectHeight);
        rect(weather1Info[4], weather1Info[5], weather1Info[6], weather1Info[7]); //set corners and draw
        weather1Info[0] = weather1Info[4] + weather1Info[5]*640;
        weather1Info[1] = weather1Info[0] + weather1Info[6];
        weather1Info[2] = weather1Info[0] + weather1Info[7]*640;
        weather1Info[3] = weather1Info[1] + weather1Info[7]*640;
      
        stroke(#ffff00);//weather2
        weather2Info[4] = int(x + .35*projectWidth);
        weather2Info[5] = int(y + .5*projectHeight);
        rect(weather2Info[4], weather2Info[5], weather2Info[6], weather2Info[7]); //set corners and draw
        weather2Info[0] = weather2Info[4] + weather2Info[5]*640;
        weather2Info[1] = weather2Info[0] + weather2Info[6];
        weather2Info[2] = weather2Info[0] + weather2Info[7]*640;
        weather2Info[3] = weather2Info[1] + weather2Info[7]*640;
        
        stroke(#ff00ff);//calendar 
        calendarInfo[4] = int(x + .67*projectWidth);
        calendarInfo[5] = int(y + .375*projectHeight);
        rect(calendarInfo[4], calendarInfo[5], calendarInfo[6], calendarInfo[7]); //set corners and draw
        calendarInfo[0] = calendarInfo[4] + calendarInfo[5]*640;
        calendarInfo[1] = calendarInfo[0] + calendarInfo[6];
        calendarInfo[2] = calendarInfo[0] + calendarInfo[7]*640;
        calendarInfo[3] = calendarInfo[1] + calendarInfo[7]*640;
        
        stroke(#ff7f00);//news
        newsInfo[4] = x;
        newsInfo[5] = int(y + .875*projectHeight);
        rect(newsInfo[4], newsInfo[5], newsInfo[6], newsInfo[7]); //set corners and draw
        newsInfo[0] = newsInfo[4] + newsInfo[5]*640;
        newsInfo[1] = newsInfo[0] + newsInfo[6];
        newsInfo[2] = newsInfo[0] + newsInfo[7]*640;
        newsInfo[3] = newsInfo[1] + newsInfo[7]*640;
      }
        else{ //if normal
          calendarInfo[6] = int(.33*projectWidth); //does the same thing, but for abnormally wide rectangles
          calendarInfo[7] = int(.5*projectHeight); //set prameters relative to projection size
          newsInfo[6] = projectWidth;
          newsInfo[7] = int(.125*projectHeight);
          clockInfo[6] = int(.25*projectWidth);
          clockInfo[7] = int(.25*projectWidth);
          weather1Info[6] = int(.25*projectWidth);
          weather1Info[7] = int(.25*projectWidth);
          weather2Info[6] = int(.25*projectWidth);
          weather2Info[7] = int(.25*projectWidth);
          
          stroke(#ff0000);//clock
          clockInfo[4] = int(x + .05*projectWidth);
          clockInfo[5] = int(y + .25*projectHeight);
          rect(clockInfo[4], clockInfo[5], clockInfo[6], clockInfo[7]); //set corners and draw
          clockInfo[0] = clockInfo[4] + clockInfo[5]*640; 
          clockInfo[1] = clockInfo[0] + clockInfo[6]; 
          clockInfo[2] = clockInfo[0] + clockInfo[7]*640;
          clockInfo[3] = clockInfo[1] + clockInfo[7]*640;
      
          stroke(#0000ff);//weather1
          weather1Info[4] = int(x + .35*projectWidth);
          weather1Info[5] = int(y + .08*projectHeight);
          rect(weather1Info[4], weather1Info[5], weather1Info[6], weather1Info[7]); //set corners and draw
          weather1Info[0] = weather1Info[4] + weather1Info[5]*640;
          weather1Info[1] = weather1Info[0] + weather1Info[6];
          weather1Info[2] = weather1Info[0] + weather1Info[7]*640;
          weather1Info[3] = weather1Info[1] + weather1Info[7]*640;
      
          stroke(#ffff00);//weather2
          weather2Info[4] = int(x + .35*projectWidth);
          weather2Info[5] = int(y + .5*projectHeight);
          rect(weather2Info[4], weather2Info[5], weather2Info[6], weather2Info[7]); //set corners and draw
          weather2Info[0] = weather2Info[4] + weather2Info[5]*640;
          weather2Info[1] = weather2Info[0] + weather2Info[6];
          weather2Info[2] = weather2Info[0] + weather2Info[7]*640;
          weather2Info[3] = weather2Info[1] + weather2Info[7]*640;
          
          stroke(#ff00ff);//calendar
          calendarInfo[4] = int(x + .67*projectWidth);
          calendarInfo[5] = int(y + .375*projectHeight);
          rect(calendarInfo[4], calendarInfo[5], calendarInfo[6], calendarInfo[7]); //set corners and draw
          calendarInfo[0] = calendarInfo[4] + calendarInfo[5]*640;
          calendarInfo[1] = calendarInfo[0] + calendarInfo[6];
          calendarInfo[2] = calendarInfo[0] + calendarInfo[7]*640;
          calendarInfo[3] = calendarInfo[1] + calendarInfo[7]*640;
          
          stroke(#ff7f00);//news
          newsInfo[4] = x;
          newsInfo[5] = int(y + .875*projectHeight);
          rect(newsInfo[4], newsInfo[5], newsInfo[6], newsInfo[7]); //set corners and draw
          newsInfo[0] = newsInfo[4] + newsInfo[5]*640;
          newsInfo[1] = newsInfo[0] + newsInfo[6];
          newsInfo[2] = newsInfo[0] + newsInfo[7]*640;
          newsInfo[3] = newsInfo[1] + newsInfo[7]*640;
      }
            
    }
    else if(projectHeight > projectWidth) { //same thing, but for rectangles that are taller than they are wide
      //0 = Top Left
      //1 = Top Right
      //2 = Bottom Left
      //3 = Bottom Right
      //4 = X
      //5 = Y
      //6 = Width
      //7 = Height
      calendarInfo[6] = int(.5*projectWidth); //set prameters relative to projection size
      calendarInfo[7] = int(.375*projectHeight);
      newsInfo[6] = projectWidth;
      newsInfo[7] = int(.125*projectHeight);
      clockInfo[6] = int(.35*projectWidth);
      clockInfo[7] = int(.35*projectWidth);
      weather1Info[6] = int(.25*projectWidth);
      weather1Info[7] = int(.25*projectWidth);
      weather2Info[6] = int(.25*projectWidth);
      weather2Info[7] = int(.25*projectWidth);
      
      
      stroke(#ff0000);//clock
      fill(#ffffff,0);
      clockInfo[4] = int(x + .1*projectWidth);
      clockInfo[5] = int(y + .45*projectHeight);
      rect(clockInfo[4], clockInfo[5], clockInfo[6], clockInfo[7]); //set corners and draw
      clockInfo[0] = clockInfo[4] + clockInfo[5]*640; 
      clockInfo[1] = clockInfo[0] + clockInfo[6]; //this is not important, jk
      clockInfo[2] = clockInfo[0] + clockInfo[7]*640;
      clockInfo[3] = clockInfo[1] + clockInfo[7]*640;
      
      stroke(#0000ff);//weather1
      fill(#ffffff,0);
      weather1Info[4] = int(x + .6*projectWidth);
      weather1Info[5] = int(y + .3*projectHeight);
      rect(weather1Info[4], weather1Info[5], weather1Info[6], weather1Info[7]); //set corners and draw
      stroke(#ffffff);
      fill(#000000);
      weather1Info[0] = weather1Info[4] + weather1Info[5]*640;
      weather1Info[1] = weather1Info[0] + weather1Info[6];
      weather1Info[2] = weather1Info[0] + weather1Info[7]*640;
      weather1Info[3] = weather1Info[1] + weather1Info[7]*640;
      
      
      stroke(#ffff00);//weather2
      fill(#ffffff,0);
      weather2Info[4] = int(x + .6*projectWidth);
      weather2Info[5] = int(y + .6*projectHeight);
      rect(weather2Info[4], weather2Info[5], weather2Info[6], weather2Info[7]); //set corners and draw
      weather2Info[0] = weather2Info[4] + weather2Info[5]*640;
      weather2Info[1] = weather2Info[0] + weather2Info[6];
      weather2Info[2] = weather2Info[0] + weather2Info[7]*640;
      weather2Info[3] = weather2Info[1] + weather2Info[7]*640;
      
      
      stroke(#ff00ff);//calendar
      fill(#ffffff,0);
      calendarInfo[4] = x;
      calendarInfo[5] = y;
      rect(calendarInfo[4], calendarInfo[5], calendarInfo[6], calendarInfo[7]); //set corners and draw
      calendarInfo[0] = calendarInfo[4] + calendarInfo[5]*640;
      calendarInfo[1] = calendarInfo[0] + calendarInfo[6];
      calendarInfo[2] = calendarInfo[0] + calendarInfo[7]*640;
      calendarInfo[3] = calendarInfo[1] + calendarInfo[7]*640;
      
      
      stroke(#ff7f00);//news
      fill(#ffffff,0);
      newsInfo[4] = x;
      newsInfo[5] = int(y + .875*projectHeight);
      rect(newsInfo[4], newsInfo[5], newsInfo[6], newsInfo[7]); //set corners and draw
      newsInfo[0] = newsInfo[4] + newsInfo[5]*640;
      newsInfo[1] = newsInfo[0] + newsInfo[6];
      newsInfo[2] = newsInfo[0] + newsInfo[7]*640;
      newsInfo[3] = newsInfo[1] + newsInfo[7]*640;
    }
    
    for(int i = clockInfo[5]; i < (clockInfo[7] + clockInfo[5]); i++){
        for(int j = clockInfo[4]; j < (clockInfo[6] + clockInfo[4]); j++){
          pixels[j + i*640] = (#ff0000);
          usedPixels.append(j + i*640);
        }
      }
      for(int i = weather1Info[5]; i < (weather1Info[7] + weather1Info[5]); i++){
        for(int j = weather1Info[4]; j < (weather1Info[6] + weather1Info[4]); j++){
          pixels[j + i*640] = (#00ff00);
          usedPixels.append(j + i*640);
        }
      }
      for(int i = weather2Info[5]; i < (weather2Info[7] + weather2Info[5]); i++){
        for(int j = weather2Info[4]; j < (weather2Info[6] + weather2Info[4]); j++){
          pixels[j + i*640] = (#0000ff);
          usedPixels.append(j + i*640);
        }
      }
      for(int i = calendarInfo[5]; i < (calendarInfo[7]+ calendarInfo[5]); i++){
        for(int j = calendarInfo[4]; j < (calendarInfo[6] + calendarInfo[4]); j++){
          pixels[j + i*640] = (#ffff00);
          usedPixels.append(j + i*640);
        }
      }
      for(int i = newsInfo[5]; i < (newsInfo[7] + newsInfo[5]); i++){
        for(int j = newsInfo[4]; j < (newsInfo[6] + newsInfo[4]); j++){
          pixels[j + i*640] = (#ff7f00);
          usedPixels.append(j + i*640);
        }
      }
      updatePixels();
      usedPixels.sort(); //sort pixels 
  } 
    
}