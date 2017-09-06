boolean isSimulating = true;
boolean isReactionDiffusion = true;
boolean isSpatiallyVarying = false;

void keyPressed(){
  switch(key) {
    case 'i': case 'I': grid.initialize(); break;
    case ' ': isSimulating = !isSimulating; break;
    case 'u': case 'U': grid.grid = grid.U; break;
    case 'v': case 'V': grid.grid = grid.V; break;
    case 'd': case 'D': isReactionDiffusion = !isReactionDiffusion; break;
    case '1': grid.k = 0.0625; grid.f = 0.035; break;
    case '2': grid.k = 0.06; grid.f = 0.035; break;
    case '3': grid.k = 0.0475; grid.f = 0.0118; break;
    case '4': grid.k = 0.05; grid.f = 0.025; break;
    case 'p': isSpatiallyVarying = !isSpatiallyVarying; break;
  }
  println("press key: " + key);
}

void mouseClicked() {
  grid.printValues();
}