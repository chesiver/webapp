int time;
CreatureList creatureList;

void setup() {
  size(500, 500);
  creatureList = new CreatureList();
  creatureList.initialize(50);
  background(0, 0, 0); 
  time = millis();
}

void draw() {
  if(!isLeavingPath) background(0, 0, 0);
  if (millis() > time + 100) {
    if(isSimulating) {
      //println("time: " + time); 
      creatureList.update();
    }
    time = millis();
  }
  creatureList.drawCreatures();
}