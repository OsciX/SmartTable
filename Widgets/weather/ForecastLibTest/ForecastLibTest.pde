static Boolean DEBUG = false;
static String darkSkyApiKey = "";

void setup() {
  ForecastIO fio = new ForecastIO(darkSkyApiKey);
  fio.setUnits(ForecastIO.UNITS_US);
  fio.setLang(ForecastIO.LANG_ENGLISH);
  
  if (DEBUG) {
    fio.getForecast(loadStrings("UnformattedTestResponse.json")[0]); 
  } else { 
    GeoCoords currentLocation = getCoords();
    fio.getForecast(currentLocation.latitude, currentLocation.longitude); 
  }
  
    FIOCurrently currentData = new FIOCurrently(fio);
    FIODataPoint currently = currentData.get();
    
    // FIODataPoint returns strings with an extra set of quotation marks. By appending .replaceAll("\"","") to a request, these are removed.
    String formattedSummary = currently.summary().replaceAll("\"","");
    String formattedIconName = currently.icon().replaceAll("\"","");
    
    println("Current Data as of " + currently.time());
    println("Summary: " + formattedSummary); 
    println("Temperature: " + currently.temperature() + "° F");
    println("Displayed Icon: " + formattedIconName);
}