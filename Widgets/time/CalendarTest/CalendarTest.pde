void setup() {
  JSONObject apiResult = parseJSONObject(refreshEvents());
  JSONArray eventList = apiResult.getJSONArray("items");

  println("Current Date & Time: " + formatISOString(getCurrentISODateTime(), true, true) + "\n");

  println("Event List:");
  println("========================");
  int previousEvents = 0;
  for (int i = 0; i < eventList.size(); i++) {

    JSONObject event = eventList.getJSONObject(i);

    String summary = event.getString("summary");
    String startTimeRaw = event.getJSONObject("start").getString("dateTime");
    String endTimeRaw = event.getJSONObject("end").getString("dateTime");
    String startTime = "";
    String endTime = "";

    if (ISODateTime(endTimeRaw).isAfterNow()) {
      if (previousEvents > 0) {
        println("\n" + previousEvents + " previous event(s) omitted.");
        previousEvents = 0;
      }

      if ((ISODateTime(startTimeRaw).isBeforeNow()) && (ISODateTime(endTimeRaw).isAfterNow())) {
        println("\nEVENT IN PROGRESS!");
        startTime = formatISOString(startTimeRaw, true, true);
        endTime = formatISOString(endTimeRaw, true, true);
        println("Event Name: " + summary + "\n\tStart Time: " + startTime + "\n\tEnd Time: " + endTime);
      } else {

        startTime = formatISOString(startTimeRaw, true, true);
        endTime = formatISOString(endTimeRaw, true, true);
        println("\nEvent Name: " + summary + "\n\tStart Time: " + startTime + "\n\tEnd Time: " + endTime);
      }
    } else {
      previousEvents++;
    }
  }
}