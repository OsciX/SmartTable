public void kinectDraw(PApplet appc, GWinData data) {
  PImage depthImage = kinect.getDepthImage();
  kinectWindow.image(depthImage, 0, 0); //shows image of table 
  if (true1 == true && true2 == true) { //if both corners exist

    kinectX = firstCorner%640; //sets top left corner of table x coord
    kinectY = (firstCorner-(firstCorner%640))/640; //sets top left corner of table y coord
    projectWidth = (abs(secondCorner%640 - firstCorner%640)); //sets width of projection
    projectHeight = (abs((firstCorner-(firstCorner%640))/640 - (secondCorner-(secondCorner%640))/640)); //sets height of projection
    uiX = 2*kinectX + offsetX;
    uiY = int(2*kinectY+offsetY);
    uiWidth = 2*projectWidth;
    uiHeight = int(2*projectHeight);
      kinectWindow.fill(#ffffff, 0);
     kinectWindow.stroke(#00ff00);
     kinectWindow.rect(kinectX, kinectY, projectWidth, projectHeight); //draws rectangle where projection is defined 
   /*  fill(#ffffff, 0);
     stroke(#00ff00);
     rect(uiX, uiY, uiWidth, uiHeight); //draws rectangle where projection is defined */
  } else if (true1 == true) {
    kinectWindow.stroke(#ffffff);
    kinectWindow.fill(#ffffff);
    kinectWindow.ellipse(firstCorner%640, (firstCorner-(firstCorner%640))/640, 10, 10);
  } else if (true2 == true) {
    kinectWindow.stroke(#ffffff);
    kinectWindow.fill(#ffffff);
    kinectWindow.ellipse(secondCorner%640, (secondCorner-(secondCorner%640))/640, 10, 10);
  }
}