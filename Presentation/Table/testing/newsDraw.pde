// Wrapper for https://newsapi.org/ //<>//

// newsTicker string to be updated by apiCalls every 10 minutes
String[] tickerArray;
float tickerX = 0.0;
int tickerIndex = 0;
public void newsDraw(PApplet appc, GWinData data) {

  newsWindow.background(0);
  newsWindow.textSize(0.15*newsWindow.height);        
  newsWindow.textAlign(LEFT);

  // Display headline at x  location       
  newsWindow.textAlign(LEFT);
  try {
      newsWindow.text(tickerArray[tickerIndex], tickerX, newsWindow.height/2); 
    }
  catch (NullPointerException e) {
    println("NullPointerException; manually calling news API");
    newsApiCall manualNewsCall = new newsApiCall();
    manualNewsCall.run();
  }


  // Decrement x
  tickerX = tickerX - 2;

  // If x is less than the negative width, 
  // then it is off the screen
  float w = textWidth(tickerArray[tickerIndex]);
  if (tickerX+(newsWindow.width/3) < -w) {
    tickerX = newsWindow.width; 
    tickerIndex = (tickerIndex + 1) % tickerArray.length;
  }
}

// The duplicates of makeNewsUrl() are INTENTIONAL; this structure makes selecting a sort method optional.
String makeNewsUrl(String source, String apiKey, String sortMethod) {
  return("https://newsapi.org/v1/articles?source=" + source + "&sortBy=" + sortMethod + "&apiKey=" + apiKey);
}
String makeNewsUrl(String source, String apiKey) {
  return("https://newsapi.org/v1/articles?source=" + source + "&apiKey=" + apiKey);
}