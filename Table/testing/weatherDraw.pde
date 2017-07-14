import java.text.DecimalFormat;

FIOCurrently currentData;
FIODataPoint currentWeather;
GeoCoords currentLocation;
Boolean svgLoaded = false;
PShape weatherIcon = new PShape();

public void weatherDraw(PApplet appc, GWinData data) {
  String textToDisplay = "";
  String svgPath = "";
  String formattedSummary = "";
  String formattedLocation = "";
  Double temperature = (double)0.0;
  weatherWindow.background(0);

  try {
    svgPath = "data/svg/" + currentWeather.icon().replaceAll("\"", "") + ".svg";
    formattedSummary = currentWeather.summary().replaceAll("\"", "");
    formattedLocation = currentLocation.city() + ", " + currentLocation.regionCode();
    temperature = (double)Math.round(currentWeather.temperature()*10)/10;
    textToDisplay = formattedSummary + "\n" + temperature + "° F" + "\n" + formattedLocation;

    if (!svgLoaded) {
      weatherIcon = loadShape(svgPath);
      svgLoaded = true;
    }
  } 
  catch (NullPointerException e) {
    println("NullPointerException; manually calling weather API");
    weatherApiCall manualWeatherCall = new weatherApiCall();
    manualWeatherCall.run();
  }


  weatherWindow.fill(#ffffff);
  weatherWindow.strokeWeight(0);
  weatherWindow.textSize(weatherWindow.height*0.07);
  weatherWindow.textAlign(TOP);
  weatherWindow.textAlign(CENTER);
  weatherWindow.text(textToDisplay, weatherWindow.width/2, 2*weatherWindow.height/3);
  
  weatherIcon.disableStyle();
  weatherWindow.shapeMode(CENTER);
  weatherWindow.shape(weatherIcon, weatherWindow.width/2, weatherWindow.height/3, min(weatherWindow.width/2.5,weatherWindow.height/2.5), min(weatherWindow.width/2.5,weatherWindow.height/2.5));
  

  /*
    println("\nCurrent Data as of " + currentWeather.time());
   println("Summary: " + formattedSummary); 
   println("Temperature: " + currentWeather.temperature() + "° F");
   println("Displayed weatherIcon: " + formattedweatherIconName);
   println("Location: " + currentLocation.city() + ", " + currentLocation.regionCode());
   */
}