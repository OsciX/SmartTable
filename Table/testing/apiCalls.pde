import java.util.*;
import org.joda.time.*;
import com.temboo.core.*;
import com.temboo.Library.Google.Calendar.*;

static String darkSkyApiKey = "77c70449e845cbccd09b1ab2112d01c9";
static String newsApiKey = "32ee148a68a04751bcb6eeff06c2d399";
// Create session using your Temboo account application details
TembooSession session = new TembooSession("trialaccount555", "myFirstApp", "IXkdDk8iPDfqESMbWTi0FDFPwnsmFhq8");


static Boolean DEBUG = false;

class weatherApiCall extends TimerTask {
  public void run() {
    ForecastIO fio = new ForecastIO(darkSkyApiKey);
    fio.setUnits(ForecastIO.UNITS_US);
    fio.setLang(ForecastIO.LANG_ENGLISH);
    currentLocation = getCoords();

    if (DEBUG) {
      fio.getForecast(loadStrings("data/WeatherResponseCache.json")[0]);
    } else { 
      fio.getForecast(currentLocation.latitude, currentLocation.longitude);
    }
    
    println(hour() + ":" + minute() + ":" + second()+" Updating weather data...");
    
    currentData = new FIOCurrently(fio);
    currentWeather = currentData.get();

    svgLoaded = false;
    /*
    // FIODataPoint returns strings with an extra set of quotation marks. By appending .replaceAll("\"","") to a request, these are removed.
     String formattedSummary = currentWeather.summary().replaceAll("\"", "");
     String formattedIconName = currentWeather.icon().replaceAll("\"", "");
     
     println("\nCurrent Data as of " + currentWeather.time());
     println("Summary: " + formattedSummary); 
     println("Temperature: " + currentWeather.temperature() + "° F");
     println("Displayed Icon: " + formattedIconName);
     println("Location: " + currentLocation.city() + ", " + currentLocation.regionCode());
     */
  }
}

class calendarApiCall extends TimerTask {
  public void run() {
    eventsString = "";
    // Create the Choreo object using your Temboo session
    SearchEvents searchEventsChoreo = new SearchEvents(session);

    // Set credentials
    searchEventsChoreo.setCredential("SmartTable");

    // Set inputs
    searchEventsChoreo.setOrderBy("startTime");
    searchEventsChoreo.setSingleEvent("1");
    searchEventsChoreo.setCalendarID("r8bj4reu9369hb7vd20hnm7lc8@group.calendar.google.com");

    // Run the Choreo and store the results
    SearchEventsResultSet searchEventsResults = searchEventsChoreo.run();

    JSONObject apiResult = parseJSONObject(searchEventsResults.getResponse());
    JSONArray eventList = apiResult.getJSONArray("items");
    
    println(hour() + ":" + minute() + ":" + second()+" Updating calendar data...");
    
    for (int i = 0; i < eventList.size(); i++) {

      JSONObject event = eventList.getJSONObject(i);

      String summary = "\n" + event.getString("summary");
      String startTimeRaw = event.getJSONObject("start").getString("dateTime");
      String endTimeRaw = event.getJSONObject("end").getString("dateTime");
      String startTime = formatISOString(startTimeRaw, true, false);
      String endTime = formatISOString(endTimeRaw, true, false);

      LocalDate currentDate = ISODateTime(getCurrentISODateTime()).toLocalDate();
      LocalDate startDate = ISODateTime(startTimeRaw).toLocalDate();
      LocalDate endDate = ISODateTime(endTimeRaw).toLocalDate();

      

      if (currentDate.isEqual(startDate)) {
        String times = "\n(" + startTime + " - " + endTime + ")";
        times = times.replaceAll(" AM","a");
        times = times.replaceAll(" PM","p");
        eventsString = eventsString + summary + times + lineBreak;
      }
    }
  }
}

class newsApiCall extends TimerTask {
  public void run() {

    String apiUrl;

    if (DEBUG) {
      apiUrl = "data/NewsResponseCache.json";
    } else {
      apiUrl = makeNewsUrl("associated-press", newsApiKey);
    }
    println(hour() + ":" + minute() + ":" + second()+" Updating news data...");
    JSONObject newsApiResult = loadJSONObject(apiUrl);
    JSONArray articles = newsApiResult.getJSONArray("articles");
    String[] newsTitleArray = new String [articles.size()];


    for (int i = 0; i < articles.size(); i++) {

      JSONObject story = articles.getJSONObject(i); 
      newsTitleArray[i] = story.getString("title");
    }
    tickerArray = newsTitleArray;
  }
}

final class GeoCoords {
  private final String latitude, longitude, city, regionCode;

  public GeoCoords(String latitude, String longitude, String city, String regionCode) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.city = city;
    this.regionCode = regionCode;
  }

  public String latitude() {
    return latitude;
  }

  public String longitude() {
    return longitude;
  }

  public String city() {
    return city;
  }

  public String regionCode() {
    return regionCode;
  }
}


GeoCoords getCoords() {
  JSONObject ipLocation = loadJSONObject("http://www.freegeoip.net/json/");
  float currentLat = ipLocation.getFloat("latitude");
  float currentLong = ipLocation.getFloat("longitude");
  String city = ipLocation.getString("city");
  String regionCode = ipLocation.getString("region_code");
  return new GeoCoords(str(currentLat), str(currentLong), city, regionCode);
}

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
      outputString = outputString + dt.toString("EEE, MMM d");
    } else {
      outputString = outputString + dt.toString("EEE, MMM dd");
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