import java.lang.Math;

int time;
Grid grid;

void setup() {
  size(600, 600);
  grid = new Grid(100);
  grid.initialize();
  time = millis();
}

void draw() {
  background(255, 255, 255);
  if (millis() > time + 10) {
    if (isSimulating) grid.update();
    time = millis();
  }
  grid.drawGrid();
}