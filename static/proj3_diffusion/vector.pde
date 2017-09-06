class Vector {
  float x = 0, y = 0;
  Vector(){}
  Vector(float x, float y) {this.x = x; this.y = y; }
  Vector(Vector other) {this.x = other.x; this.y = other.y; }
  void add(Vector other) {this.x += other.x; this.y += other.y; }
  void sub(Vector other) {this.x -= other.x; this.y -= other.y;}
  void mult(float a) {this.x *= a; this.y *= a;}
  void div(float a) {this.x /= a; this.y /= a; }
  float norm(){return sqrt(sq(x) + sq(y)); }
  void normalize() { float n = norm(); this.x /= n; this.y /= n; }
  void limit(float maxNorm) { float n = norm(); if(n > maxNorm) div(n / maxNorm); }
}


Vector V(float s, Vector v1) { return new Vector(s * v1.x, s * v1.y);}
Vector V(Vector v1, float s, Vector v2) { return new Vector(v1.x + s * v2.x, v1.y + s * v2.y);}
Vector add(Vector v1, Vector v2) { return new Vector(v1.x + v2.x, v1.y + v2.y);}
Vector sub(Vector v1, Vector v2) { return new Vector(v1.x - v2.x, v1.y - v2.y);}

float Dist(Vector v1, Vector v2) {
  float dx = v2.x - v1.x, dy = v2.y - v1.y;
  return sqrt(dx * dx + dy * dy);
}