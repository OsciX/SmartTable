final class GeoCoords {
    private final String latitude;
    private final String longitude;

    public GeoCoords(String latitude, String longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public String latitude() {
        return latitude;
    }

    public String longitude() {
        return longitude;
    }
}

GeoCoords getCoords() {
  JSONObject ipLocation = loadJSONObject("http://www.freegeoip.net/json/");
  float currentLat = ipLocation.getFloat("latitude");
  float currentLong = ipLocation.getFloat("longitude");
  return new GeoCoords(str(currentLat), str(currentLong));
}