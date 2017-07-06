import g4p_controls.*;

GWindow clockWindow;
public void setup() {
  fullScreen();
  createWindows();
}

public void draw() {
  background(0,0,0);
}

public void createWindows() {
    clockWindow = GWindow.getWindow(this, "", 200, 200, 480, 480, P2D);
    clockWindow.setAlwaysOnTop(true);
    clockWindow.addDrawHandler(this, "clockDraw");
}

PVector coordFromPixel(long pixelNumber) {
  long x = pixelNumber % width;
  long y = (pixelNumber - x) / width;
  return new PVector(x, y);
}