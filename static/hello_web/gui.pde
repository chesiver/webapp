boolean isAttract = true;
boolean isCentering = true;
boolean isSeparating = true;
boolean isAligning = true;
boolean isWandering = true;
boolean isLeavingPath = false;
boolean isSimulating = true;

void keyPressed(){
  switch(key) {
    case 'a': case 'A': isAttract = true; break;
    case 'r': case 'R': isAttract = false; break;
    case 's': creatureList.scatter(); break;
    case 'p': case 'P': isLeavingPath = !isLeavingPath; break;
    case 'c': case 'C': clear(); break;
    case '1': isCentering = !isCentering; break;
    case '2': isAligning = !isAligning; break;
    case '3': isSeparating = !isSeparating; break;
    case '4': isWandering = !isWandering; break;
    case '+': case '=': creatureList.addCreature(1.0 * mouseX / width, 1.0 * mouseY / height); break;
    case '-': if(creatureList.num > 0) --creatureList.num; break;
    case ' ': isSimulating = !isSimulating; break;
  }
  println("key pressed: " + key);
}