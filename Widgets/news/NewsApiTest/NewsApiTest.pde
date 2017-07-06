// Wrapper for https://newsapi.org/

String newsApiKey = "";
// Setting DEBUG to true parses a file in the local directory instead of grabbing live data. This limits API calls
// The file in the local directory must be named "ResponseCache.json" to use this option
Boolean DEBUG = true;

void setup() {
  
  String apiUrl;
  
  if(DEBUG) {
    apiUrl = "TestResponse.json";
    println("DEBUG Variable set to true, using local response cache");
  } else {
    apiUrl = makeNewsUrl("hacker-news", newsApiKey);
    println("Generated GET URL: " + apiUrl);
  }
  
  JSONObject newsApiResult = loadJSONObject(apiUrl);
  JSONArray articles = newsApiResult.getJSONArray("articles");
  
  for (int i = 0; i < articles.size(); i++) {
    
    JSONObject story = articles.getJSONObject(i); 
    
    String author = getStringExceptNull(story, "author");
    String title = getStringExceptNull(story, "title");
    String description = getStringExceptNull(story, "description");
    String url = getStringExceptNull(story, "url");
    
    // Formats and prints to console
    println("\nStory " + (i+1) + " Info");
    println("====================");
    println("Author: " + author + "\nTitle: " + title + "\nDescription: " + description + "\nStory URL: " + url);
  }
}