int currentAnimation = 0;


//*********** TO BE PROVIDED BY STUDENTS    
// computes current values of parameters x, y, r, b, d for animation parameter t
// so as to produce a smooth and aesthetically pleasing animation
// that conveys a specific emotion/enthusiasm of the moving shape
void computeParametersForAnimationTime(float t) // computes parameters x, y, r, b, d for current t value
{
  if (currentAnimation == 0) animateDefault(t);
  if (currentAnimation == 1) animateHappy(t);
  if (currentAnimation == 2) animateDriven(t);
  if (currentAnimation == 3) animateDiscouraged(t);
  if (currentAnimation == 4) animateAfraid(t);
  if (currentAnimation == 5) animateAgitated(t);
  if (currentAnimation == 6) animateLazy(t);
}

void initDefault() { currentAnimation=0; float seconds=3.33; dt=1.0/(seconds*targetFrameRate); }
void animateDefault(float t)
{
  r = r0;                               // Head radius
  x = x0 + t*(x1-x0);                   // Head x position
  y = y0 - y0*0.3*sqrt(abs(sin(PI*t))); // Head y position
  b = b0 + b0*0.8*sqrt(abs(sin(PI*t))); // Distance from bottom-left of dress to x
  d = d0 - d0*0.4*sqrt(abs(sin(PI*t))); // Distance from x to bottom-right of dress
}

// Idea:
// We want believability, not realism. 
// Just try to follow listed principles, do not get stuck on details.

void initHappy() { currentAnimation=1; float seconds=3; dt=1.0/(seconds*targetFrameRate); }
void animateHappy(float t)
{
  // Light, bouncy, dancing
  // Head up high, backward arch
  // High energy
  
  r = r0 + 5*pow(sin(PI*t*2),2);
  x = hermite_2(x0,0, x1,0, t);
  y = y0 + 20*pow(sin(PI*t*2),2) + 5*sin(2*PI*t*6) - bezier_3(0,0, .5,20, 1,0, t);
  b = b0 + 80*sin(PI*t*2);
  d = d0 - 80*sin(PI*t*2);
  
  //r = bezier(r0, r0+5, r0, t);
  //b = bezier(b0, b0-20, b0, t);
  //d = bezier(d0, d0+30, d0, t);
}

void initDriven() { currentAnimation=2; float seconds=1.5; dt=1.0/(seconds*targetFrameRate); }
void animateDriven(float t)
{
  // Determined
  // Lean forward (reach towards goal)
  // Not much vertical motion, focus on what's ahead
  
  r = r0;
  x = hermite_3(x0,-500, x1,1000, x1,0, t);
  y = hermite_3(y0,-500, y0,100, y0,0, t);
  b = bezier_3_0(b0, b0+80, b0, t);
  d = bezier_3_0(d0, d0-80, d0, t);
}

void initDiscouraged() { currentAnimation=3; float seconds=3.33; dt=1.0/(seconds*targetFrameRate); }
void animateDiscouraged(float t)
{
  //decelerate, head leaned forward
  float A = 16.0 / 7.0, B = 27.0 / 28.0;
  r = r0 + 5 * pow(sin(2 * PI * t), 2);
  x = x0 + (x1 - x0) * ( A * pow(t - 0.75, 3) + B) - 5 * bezier_3(0, 0, .5,20, 1,0, t);
  y = hermite_3(y0,-500, y0,100, y0,0, t);
  b = b0 + 100 * sin(PI * t);
  d = d0 - 100 * sin(PI * t);
}

void initAfraid() { currentAnimation=4; float seconds=3.33; dt=1.0/(seconds*targetFrameRate); }
void animateAfraid(float t)
{
  //decelerate, head leaned backward
  r = r0 + 5 * pow(sin(PI * t), 2);
  x = x0 + (x1 - x0) * (log(1 + 5 * t) / log(6));
  y = hermite_3(y0, -100, y0,100, y0,0, t);
  b = b0 - 100 * sin(PI * t);
  d = d0 + 100 * sin(PI * t);
}

void initAgitated() { currentAnimation=5; float seconds=3.33; dt=1.0/(seconds*targetFrameRate); }
void animateAgitated(float t)
{
  // Not as easy as the others. Probably hunched forward like driven, but with a significant amount
  // of vertical motion. Should appear like stomping. Need a high energy downward motion.
}

void initLazy() { currentAnimation=6; float seconds=3.33; dt=1.0/(seconds*targetFrameRate); }
void animateLazy(float t)
{
  
}
  
  

//*********** TO BE PROVIDED BY STUDENTS  
// compute blend radius tangent to x-axis at point (0,0) and circle of center (b,y) and radius r   
float blendRadius(float b, float y, float r) 
{
  return (sq(y) + sq(b) - sq(r)) / (2 * y + 2 * r);
}




float lerp_2(float a, float A, float b, float B, float t) { return lerp(A, B, (t-a)/(b-a)); }
float bezier_3(float a, float A, float b, float B, float c, float C, float t) { return lerp_2(a, lerp_2(a,A,b,B,t), c, lerp_2(b,B,c,C,t), t); }
float bezier_4(float a, float A, float b, float B, float c, float C, float d, float D, float t) { return lerp_2(a, bezier_3(a,A,b,B,c,C,t), d, bezier_3(b,B,c,C,d,D,t), t); }

float bezier_3_0(float A, float B, float C, float t) { return bezier_3(0,A,.5,B,1,C,t); }
float bezier_4_0(float A, float B, float C, float D, float t) { return bezier_4(0,A,.333,B,.666,C,1,D,t); }

float hermite_2(float P0, float T0, float P1, float T1, float t) { 
  return (2*t*t*t-3*t*t+1)*P0+(t*t*t-2*t*t+t)*T0+(-2*t*t*t+3*t*t)*P1+(t*t*t-t*t)*T1;
}
float hermite_3(float P0, float T0, float P1, float T1, float P2, float T2, float t) {
  if (t < 0.5) return hermite_2(P0,T0,P1,T1,t*2);
  else return hermite_2(P1,T1,P2,T2,(t-.5)*2);
}

float timedHermite(float a, float P0, float T0, float b, float P1, float T1, float t) { return hermite_2(P0,T0,P1,T1,(t-a)/(b-a)); }