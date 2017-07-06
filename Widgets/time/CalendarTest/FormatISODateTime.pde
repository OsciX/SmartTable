import java.util.*;
import org.joda.time.*;

// Function to convert ISO8601 time string into human-readable format
// Set outputType to false to return time, true to return date
String formatISOString(String input, Boolean showTime, Boolean showDate) {
  // Set input pattern so parser knows the format of the input
  String pattern = "yyyy-MM-dd'T'HH:mm:ssZZ";
  // Parse input in UTC in order to grab timezone
  DateTime dt = DateTime.parse(input, DateTimeFormat.forPattern(pattern));
  // Get timezone from previous parsing
  DateTimeZone zone = DateTimeZone.forID(dt.toString("ZZZ"));
  // Reassign dt to contain offset time
  dt = DateTime.parse(input, DateTimeFormat.forPattern(pattern)).withZone(zone);

  String outputString = "";

  if (showTime) {
    if (parseInt(dt.toString("hh")) < 10) {
      outputString = dt.toString("h:mm aa");
    } else {
      outputString = dt.toString("hh:mm aa");
    }
  }

  if (showTime && showDate) {
    outputString = outputString + ", ";
  }

  if (showDate) {
    String numberSuffix;
    int dayNum = parseInt(dt.toString("dd"));
    if (dayNum > 13) {
      dayNum = dayNum % 10;
    }
    switch (dayNum) {
    case 1:
      numberSuffix = "st";
      break;
    case 2:
      numberSuffix = "nd";
      break;
    case 3:
      numberSuffix = "rd";
      break;
    default:
      numberSuffix = "th";
      break;
    }


    if (parseInt(dt.toString("dd")) < 10) {
      outputString = outputString + dt.toString("EEE, MMMM d");
    } else {
      outputString = outputString + dt.toString("EEE, MMMM dd");
    }
    outputString = outputString + numberSuffix;
  }
  return outputString;
}

DateTime ISODateTime(String input) {
  // Set input pattern so parser knows the format of the input
  String pattern = "yyyy-MM-dd'T'HH:mm:ssZZ";
  // Parse input in UTC in order to grab timezone
  DateTime dt = DateTime.parse(input, DateTimeFormat.forPattern(pattern));
  // Get timezone from previous parsing
  DateTimeZone zone = DateTimeZone.forID(dt.toString("ZZZ"));
  // Reassign dt to contain offset time
  dt = DateTime.parse(input, DateTimeFormat.forPattern(pattern)).withZone(zone);
  return (dt);
}

String getCurrentISODateTime() {
  DateTime dateTime = new DateTime();
  DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ssZZ");
  return (fmt.print(dateTime));
}