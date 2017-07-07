/*
import java.util.Timer;
import java.util.TimerTask;

static Boolean DEBUG = false;
static String darkSkyApiKey = "";

FIOCurrently currentData;
FIODataPoint currentWeather;

class weatherApiCall extends TimerTask {
  public void run() {
    ForecastIO fio = new ForecastIO(darkSkyApiKey);
    fio.setUnits(ForecastIO.UNITS_US);
    fio.setLang(ForecastIO.LANG_ENGLISH);
    GeoCoords currentLocation = getCoords();

    if (DEBUG) {
      fio.getForecast(loadStrings("data/UnformattedTestResponse.json")[0]);
    } else { 
      fio.getForecast(currentLocation.latitude, currentLocation.longitude);
    }

    currentData = new FIOCurrently(fio);
    currentWeather = currentData.get();

    // FIODataPoint returns strings with an extra set of quotation marks. By appending .replaceAll("\"","") to a request, these are removed.
    String formattedSummary = currentWeather.summary().replaceAll("\"", "");
    String formattedIconName = currentWeather.icon().replaceAll("\"", "");
    
    println("\nCurrent Data as of " + currentWeather.time());
    println("Summary: " + formattedSummary); 
    println("Temperature: " + currentWeather.temperature() + "° F");
    println("Displayed Icon: " + formattedIconName);
    println("Location: " + currentLocation.city() + ", " + currentLocation.regionCode());
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
*/