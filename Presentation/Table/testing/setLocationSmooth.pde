void setLocationSmooth(PSurface movedSurface, float newX, float newY, float moveMs) {
  float currentX = getJFrame(movedSurface).getX();
  float currentY = getJFrame(movedSurface).getY();
  
  float deltaX = newX - currentX;
  float deltaY = newY - currentY;
  
  float xDir = deltaX / abs(deltaX);
  float yDir = deltaY / abs(deltaY);
  
  float xPerStep = 2;
  float yPerStep;
  
  int steps = (int)(abs(deltaX) / xPerStep);
  yPerStep = abs(deltaY) / steps;
  println(steps + "; " + xPerStep + ", " + yPerStep);
  for (float i = 0; i < steps; i++) {
    currentX = currentX + (xPerStep*xDir);
    currentY = (float)(currentY + (yPerStep*yDir));
    movedSurface.setLocation((int)currentX, (int)currentY);
    delay((int)(moveMs / steps));
  }
  movedSurface.setLocation((int)newX, (int)newY);
}

static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}  