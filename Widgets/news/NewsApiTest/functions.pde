// The duplicates of makeNewsUrl() are INTENTIONAL; this structure makes selecting a sort method optional.
String makeNewsUrl(String source, String apiKey, String sortMethod) {
  return("https://newsapi.org/v1/articles?source=" + source + "&sortBy=" + sortMethod + "&apiKey=" + apiKey);
}
String makeNewsUrl(String source, String apiKey) {
  return("https://newsapi.org/v1/articles?source=" + source + "&apiKey=" + apiKey);
}

// Sometimes article arrays have a null or empty value; this function prevents that
String getStringExceptNull(JSONObject object, String string) {
  if(object.get(string).equals(null) || object.get(string).equals("")) {
    return("None");
  } else {
    return(object.getString(string));
  }
}