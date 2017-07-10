import g4p_controls.*;

GWindow clockWindow, weatherWindow, calendarWindow, newsWindow;
public void setup() {

  fullScreen();
  createWindows();
  createTimers();

  if (DEBUG) {
    println("DEBUG Variable set to true, using local response cache");
  }
}

public void draw() {
  background(0, 0, 0);
  // windowName.getSurface().setSize(x,y);
}

public void createWindows() {
  clockWindow = GWindow.getWindow(this, "", 200, 200, 400, 400, JAVA2D);
  clockWindow.setAlwaysOnTop(true);
  clockWindow.addDrawHandler(this, "clockDraw");

  weatherWindow = GWindow.getWindow(this, "", 700, 200, 400, 400, JAVA2D);
  weatherWindow.setAlwaysOnTop(true);
  weatherWindow.addDrawHandler(this, "weatherDraw");

  calendarWindow = GWindow.getWindow(this, "", 1200, 200, 400, 400, JAVA2D);
  calendarWindow.setAlwaysOnTop(true);
  calendarWindow.addDrawHandler(this, "calendarDraw");

  newsWindow = GWindow.getWindow(this, "", 450, 700, 900, 130, JAVA2D);
  newsWindow.setAlwaysOnTop(true);
  newsWindow.addDrawHandler(this, "newsDraw");
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

PVector coordFromPixel(long pixelNumber) {
  long x = pixelNumber % width;
  long y = (pixelNumber - x) / width;
  return new PVector(x, y);
}

long getSystemEpoch() {
  return (long) (System.currentTimeMillis() / 1000L);
}