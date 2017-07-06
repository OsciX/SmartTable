PShape icon;

void setup() {
  dataPath("/SVG");
  size(640, 360);
  // The file "bot1.svg" must be in the data folder
  // of the current sketch to load successfully
  icon = loadShape("/SVG/icon1.svg");
} 

void draw(){
  background(102);
  shape(icon, 110, 90, 200, 200);  // Draw at coordinate (110, 90) at size 100 x 100
  shape(icon, 280, 40);            // Draw at coordinate (280, 40) at the default size
}