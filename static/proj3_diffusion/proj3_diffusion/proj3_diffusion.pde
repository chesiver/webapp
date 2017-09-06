static final int w = 600, h = 600;
int time = millis();
Grid grid;

void settings() {
  size(w, h);
  grid = new Grid(100);
  grid.initialize();
}

void draw() {
  background(255, 255, 255);
  if (millis() > time + 10) {
    if (isSimulating) grid.update();
    time = millis();
  }
  grid.drawGrid();
}