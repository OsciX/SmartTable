long pix = 32050;
long h = 500;
long w = 500;

void setup() {
  size(1280,720);
  noLoop();
  println(width);
}

void draw() {
  PVector corner = coordFromPixel(pix, true);
  rect(corner.x, corner.y, 200, 200);
}

PVector coordFromPixel(long pixelNumber) {
  long x = pixelNumber % width;
  long y = (pixelNumber - x) / width;
  return new PVector(x, y);
}

PVector coordFromPixel(long pixelNumber, Boolean DEBUG) {
  long x = pixelNumber % width;
  long y = (pixelNumber - x) / width;
  
  if (DEBUG == true) {
    println("X-Coordinate of Corner: ", x);
    println("Y-Coordinate of Corner: ", y);
  }
  
  return new PVector(x, y);
}