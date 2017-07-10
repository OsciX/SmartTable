public void clockDraw(PApplet appc, GWinData data) {
  float cx, cy;
  float secondsRadius;
  float minutesRadius;
  float hoursRadius;
  float clockDiameter;
  String digitalReadout = hour() + ":0" + minute();
  
  
  clockWindow.stroke(255);
  
  float radius = min(clockWindow.width, clockWindow.height) / 2.3;
  secondsRadius = radius * 0.72;
  minutesRadius = radius * 0.60;
  hoursRadius = radius * 0.50;
  clockDiameter = radius * 1.8;
  
  cx = clockWindow.width / 2;
  cy = clockWindow.height / 2.3;
  
  clockWindow.background(0);
  
  // Draw the clock background
  clockWindow.fill(80);
  clockWindow.noStroke();
  clockWindow.ellipse(cx, cy, clockDiameter, clockDiameter);
  
  // Angles for sin() and cos() start at 3 o'clock;
  // subtract HALF_PI to make them start at the top
  float s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
  float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 
  float h = map(hour() + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
  
  // Draw the hands of the clock
  clockWindow.stroke(255);
  clockWindow.strokeWeight(1);
  clockWindow.line(cx, cy, cx + cos(s) * secondsRadius, cy + sin(s) * secondsRadius);
  clockWindow.strokeWeight(2);
  clockWindow.line(cx, cy, cx + cos(m) * minutesRadius, cy + sin(m) * minutesRadius);
  clockWindow.strokeWeight(4);
  clockWindow.line(cx, cy, cx + cos(h) * hoursRadius, cy + sin(h) * hoursRadius);
  
  // Draw the minute ticks
  clockWindow.strokeWeight(2);
  clockWindow.beginShape(POINTS);
  for (int a = 0; a < 360; a+=6) {
    float angle = radians(a);
    float x = cx + cos(angle) * secondsRadius;
    float y = cy + sin(angle) * secondsRadius;
    clockWindow.vertex(x, y);
  }
  clockWindow.endShape();
  
  int formattedHour = 0;
  String amPm = "";
  if (hour() > 12) {
    formattedHour = hour() - 12;
    amPm = " PM";
  } else {
    formattedHour = hour();
    amPm = " AM";
  }
  
  if (minute() < 10) {
    digitalReadout = formattedHour + ":0" + minute() + " PM";
  } else {
    digitalReadout = formattedHour + ":" + minute() + " PM";
  }
  
  clockWindow.textSize(clockWindow.height*0.08);
  clockWindow.fill(#ffffff);
  clockWindow.textAlign(CENTER, BOTTOM);
  clockWindow.text(digitalReadout,clockWindow.width/2,clockWindow.height*0.95);
}