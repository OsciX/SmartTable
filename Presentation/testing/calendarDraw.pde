String eventsString;

String lineBreak = "\n────────────────────────────────────────────────────────────────────";
public void calendarDraw(PApplet appc, GWinData data) {
 
  
  String[] dayDisplay = split(formatISOString(getCurrentISODateTime(), false, true), ' ');
  calendarWindow.background(0, 0, 0);
  calendarWindow.fill(255, 0, 0);
  calendarWindow.rect(calendarWindow.width*0.8, 0, calendarWindow.width*0.2, calendarWindow.height*0.2);

  calendarWindow.fill(255, 255, 255);

// Window title
  calendarWindow.textSize(calendarWindow.height*0.14);
  calendarWindow.textAlign(LEFT, BOTTOM);
  calendarWindow.text("Calendar", calendarWindow.width/20, calendarWindow.height*0.18);

// Calendar Linebreak
  calendarWindow.textSize(calendarWindow.height*0.16);
  calendarWindow.textLeading(0);
  calendarWindow.textAlign(LEFT, CENTER);
  calendarWindow.text(lineBreak, 0, calendarWindow.height*0.17);

// DayOfWk, Month
  calendarWindow.textSize(calendarWindow.height*0.06);
  calendarWindow.textAlign(CENTER, TOP);
  calendarWindow.text(dayDisplay[0] + " " + dayDisplay[1], calendarWindow.width*0.9, calendarWindow.height*0.02);

// Date
  calendarWindow.textSize(calendarWindow.height*0.08);
  calendarWindow.textAlign(CENTER, BOTTOM);
  calendarWindow.text(dayDisplay[2], calendarWindow.width*0.9, calendarWindow.height*0.18);

  try {
    //EventsString
    // calendarWindow.textSize(calendarWindow.height*0.04);
    calendarWindow.textLeading(20);
    calendarWindow.textAlign(TOP, LEFT);
    calendarWindow.textSize(calendarWindow.height*0.04);
    calendarWindow.text(eventsString, 0, calendarWindow.height*0.22);
  } 
  catch (NullPointerException e) {
    println("NullPointerException; manually calling calendar API");
    calendarApiCall manualCalendarCall = new calendarApiCall();
    manualCalendarCall.run();
  }
}