class Creature {
  Vector position = new Vector();
  Vector velocity = new Vector();
  float r = 2;
  Creature() {}
  Creature(Vector position, Vector velocity) {this.position = position; this.velocity = velocity;}
  
  void drawCreature() {
    //ellipse(position.x * width, (1 - position.y) * height, 5, 5);
    float theta = atan2(velocity.y, velocity.x) + radians(90);
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x * width, position.y * height);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r * 2);
    vertex(-r, r * 2);
    vertex(r, r * 2);
    endShape();
    popMatrix();
  }
}

class CreatureList {
  final static int maxNum = 100;
  public CreatureList(){}
  
  Creature[] creatures = new Creature[maxNum];
  float delta_t = 1.0;
  float maxForce = 0.005;
  float maxSpeed = 0.05;
  int num = 0;
  
  void initialize(int initNum) {
    num = initNum;
    for(int i = 0; i < num; ++i) {
      creatures[i] = new Creature();
      //creatures[i].position = new Vector(random.nextFloat(), random.nextFloat());
      creatures[i].position = new Vector(0.5, 0.5);
      creatures[i].velocity = new Vector((random(0, 1) - 0.5)/ 50, (random(0, 1) - 0.5)/ 50);
      pathList[i] = new ArrayList<Vector>();
    }
  }
  
  void addCreature(float x, float y) {
    if(num == maxNum) return;
    creatures[num] = new Creature();
    creatures[num].position = new Vector(x, y);
    creatures[num].velocity = new Vector(random(0, 1) - 0.5, random(0, 1) - 0.5);
    ++num;
  }
  
/*--------centering--------------*/
  final static float centeringDistance = 0.1;
  Vector[] centering() {
    Vector[] centeringForces = new Vector[num];
    for(int i = 0; i < num; ++i) {
      //centeringForces[i] = V(scale, V(avgPositions[i], -1, creatures[i].position));
      //centeringForces[i] = new Vector();
      Vector avgPosition = new Vector();
      int count = 0;
      for(int j = 0; j < num; ++j) {
        float d = Dist(creatures[i].position, creatures[j].position);
        if(d > 0 && d < centeringDistance) {
          avgPosition.add(creatures[j].position);
          ++count;
        }
      }
      if(count > 0) {
        avgPosition.divide(count);
        Vector centeringVelocity = sub(avgPosition, creatures[i].position);
        centeringForces[i] = sub(centeringVelocity, creatures[i].velocity);
        centeringForces[i].limit(maxForce);
      }
      else {
        centeringForces[i] = new Vector(0, 0);
      }
    }
    return centeringForces;
  }
/*--------separation--------------*/
  final static float separatedDistance = 0.05, separatedScale = 0.001;
  Vector[] separation() {
    Vector[] separationForces = new Vector[num];
    for(int i = 0; i < num; ++i) {
      Vector separate = new Vector();
      int count = 0;
      for(int j = 0; j < num; ++j) {
        float d = Dist(creatures[i].position, creatures[j].position);
        if(d > 0 && d < separatedDistance) {
          Vector diff = V(creatures[i].position, -1, creatures[j].position);
          diff.normalize();
          diff.divide(d);
          diff.mult(separatedScale);
          separate.add(diff);
          ++count;
        }
      }
      if(count > 0) {
        separate.divide(count);
        separate.normalize();
        separate.mult(maxSpeed);
        separate.sub(creatures[i].velocity);
        separate.limit(maxForce);
        separationForces[i] = separate;
        //println("separationForce: " + separationForces[i].x + " " + separationForces[i].y);
      }
      else {
        separationForces[i] = new Vector();
      }
    }
    return separationForces;
  }
/*--------alignment--------------*/
final static float alignedDistance = 0.1;
  Vector[] alignment() {
    Vector[] alignmentForces = new Vector[num];
    for(int i = 0; i < num; ++i) {
      Vector alignVelocity = new Vector();
      int count = 0;
      for(int j = 0; j < num; ++j) {
        float d = Dist(creatures[i].position, creatures[j].position);
        if(d > 0 && d < alignedDistance) {
          alignVelocity.add(creatures[j].velocity);
          ++count;
        }
      }
      if(count > 0) {
        alignVelocity.divide(count);
        alignVelocity.normalize();
        alignVelocity.mult(maxSpeed);
        alignmentForces[i] = sub(alignVelocity, creatures[i].velocity);
        alignmentForces[i].limit(maxForce);
      }
      else {
        alignmentForces[i] = new Vector();
      }
    }
    return alignmentForces;
  }
/*--------wandering--------------*/
  Vector[] wandering() {
    Vector[] wanderingForces = new Vector[num];
    for(int i = 0; i < num; ++i) {
      float scale = 0.005;
      Vector v = new Vector(random(0, 1) - 0.5, random(0, 1) - 0.5);
      v.mult(scale);
      wanderingForces[i] = v;
    }
    return wanderingForces;
  }
/*--------attraction or repulsion--------------*/
  final static float mouseDistance = 0.25;
  Vector[] mouseForces() {
    float x = 1.0 * mouseX / width, y = 1.0 * mouseY / height;
    //println("x:" + x + " y:" + y);
    Vector[] mouseForces = new Vector[num];
    Vector mousePosition = new Vector(x, y);
    for(int i = 0; i < num; ++i) {
      float d = Dist(mousePosition, creatures[i].position);
      if(d < mouseDistance) {
        Vector diff;
        if(isAttract) {
          diff = sub(mousePosition, creatures[i].position);
        }
        else {
          diff = sub(creatures[i].position, mousePosition);
        }
        diff.normalize();
        diff.mult(maxSpeed);
        mouseForces[i] = diff;
      }
      else {
        mouseForces[i] = new Vector();
      }
    }
    return mouseForces;
  }
/*--------scatter-------------*/
  void scatter() {
    for(int i = 0; i < num; ++i) {
      creatures[i].position = new Vector(random(0, 1), random(0, 1));
    }
  }
/*--------leave path-------------*/
  ArrayList<Vector>[] pathList = new ArrayList[maxNum];
  void drawCreatures() {
    fill(red); noStroke();
    for(int i = 0; i < num; ++i) {
      creatures[i].drawCreature();
      //fill(red); noStroke();
      //for(int j = 0; j < pathList[i].size(); ++j) {
      //  Vector v = pathList[i].get(j);
      //  ellipse(v.x * width, v.y * height, 2, 2);
      //}
      //pathList[i].add(new Vector(creatures[i].position));
    }
  }
  
  void checkWall(Creature creature) {
    if(creature.position.x < 0 || creature.position.x > 1) {
      creature.velocity.x = -creature.velocity.x;
      creature.position.x += 2 * delta_t * creature.velocity.x;
    }
    if(creature.position.y < 0 || creature.position.y > 1) {
      creature.velocity.y = -creature.velocity.y;
      creature.position.y += 2 * delta_t * creature.velocity.y;
    }
  }
  void update() {
    Vector[] centeringForces = centering();
    Vector[] separationForces = separation();
    Vector[] alignmentForces = alignment();
    Vector[] wanderingForces = wandering();
    //Vector[] mouseForces = mouseForces();
    for(int i = 0; i < num; ++i) {
      //println("centering force: " + centeringForces[i].x + " " + centeringForces[i].y);
      if(isCentering) creatures[i].velocity.add(centeringForces[i]);
      if(isSeparating) creatures[i].velocity.add(separationForces[i]);
      if(isAligning) creatures[i].velocity.add(alignmentForces[i]);
      if(isWandering) creatures[i].velocity.add(wanderingForces[i]);
      //if(mousePressed) creatures[i].velocity.add(mouseForces[i]);
      creatures[i].velocity.limit(maxSpeed);
      creatures[i].position = V(creatures[i].position, delta_t, creatures[i].velocity);
      checkWall(creatures[i]);
    }
  }
}