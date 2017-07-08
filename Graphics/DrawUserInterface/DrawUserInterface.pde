import g4p_controls.*;

GWindow clockWindow, weatherWindow;
public void setup() {
  
  fullScreen();
  createWindows();
  createTimers();
}

public void draw() {
  background(0,0,0);
  // windowName.getSurface().setSize(x,y);
}

public void createWindows() {
    clockWindow = GWindow.getWindow(this, "", 200, 200, 400, 400, JAVA2D);
    clockWindow.setAlwaysOnTop(true);
    clockWindow.addDrawHandler(this, "clockDraw");
    
    weatherWindow = GWindow.getWindow(this, "", 700, 200, 400, 400, JAVA2D);
    weatherWindow.setAlwaysOnTop(true);
    weatherWindow.addDrawHandler(this, "weatherDraw");

}

public void createTimers() {
  /*
  Timer locationApi = new Timer();
  locationApi.schedule(new locationApiCall(), 0, 43200*1000);
  */
  
  Timer weatherApi = new Timer();
  weatherApi.schedule(new weatherApiCall(), 0, 120*1000);
}

PVector coordFromPixel(long pixelNumber) {
  long x = pixelNumber % width;
  long y = (pixelNumber - x) / width;
  return new PVector(x, y);
}

long getSystemEpoch() {
  return (long) (System.currentTimeMillis() / 1000L);
}