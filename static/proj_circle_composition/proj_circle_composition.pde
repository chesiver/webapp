// Base code for Cae 2017 Project 3 on Animation Aesthetics

// Variables to control display
//boolean showConstruction=false;  // show construction edges and circles
boolean showControlFrames=true; // show start and end poses
boolean showStrobeFrames=false; // shows 5 frames of animation
boolean computingBlendRadii=true; // toggles whether blend radii are computed or adjusted with mouse ('b' or 'd' with vertical mouse moves)

// Constants
float g = 350;            // ground height measured downward from top of canvas
float x0 = 160, x1 = 850; // initial & final coordinate of disk center 
float y0 = 200;           // initial & final vertical coordinate of disk center above ground (y is up) 
float r0 = 50;            // initial & final disk radius
float b0 = 100, d0 = 130; // initial & final values of the width of bottom of dress (on both sides of x)

// Variables that control animated shape
float x = x0, y = y0;     // current coordinates of disk center
float r = r0;             // current disk radius
float b = b0, d = d0;     // current values of the width of bottom of dress (on both sides of x)

// Computed or user controlled
float _p = b0, _q = d0;   // global values of the radii of the left and right arcs of the dress (user edited)

// Animation
boolean animating = true; // animation status: running/stopped
float t=0.0;               // current animaiton time
float dt=0.01;              // change in t per frame
float targetFrameRate=30;


void setup()
{ 
  // Variables to control display
  ////showConstruction=false;  // show construction edges and circles
  ////showControlFrames=true; // show start and end poses
  //showStrobeFrames=false; // shows 5 frames of animation 
  //computingBlendRadii=true; // toggles whether blend radii are computed or adjusted with mouse ('b' or 'd' with vertical mouse moves)
  //// Constants
  //g = 350;            // ground height measured downward from top of canvas
  //x0 = 160; x1 = 850; // initial & final coordinate of disk center 
  //y0 = 200;           // initial & final vertical coordinate of disk center above ground (y is up) 
  //r0 = 50;            // initial & final disk radius
  //b0 = 100; d0 = 130; // initial & final values of the width of bottom of dress (on both sides of x)

  //// Variables that control animated shape
  //x = x0; y = y0;     // current coordinates of disk center
  //r = r0;             // current disk radius
  //b = b0; d = d0;     // current values of the width of bottom of dress (on both sides of x)

  //// Computed or user controlled
  //_p = b0; _q = d0;   // global values of the radii of the left and right arcs of the dress (user edited)

  //// Animation
  //animating = true; // animation status: running/stopped
  ////t=0.0;               // current animaiton time
  ////dt=.01;              // change in t per frame
  //targetFrameRate=30;
  
  size(1000, 400, P2D); 
  frameRate(targetFrameRate);        // draws new frame 30 times a second
  initHappy();
}
 
void draw()
{
  if(snapPic) beginRecord(PDF,PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); // start recording for PDF image capture
  
  background(255);      // erase canvas at each frame
  
  stroke(0);            // change drawing color to black
  line(0, g, width, g); // draws gound
  
  noStroke(); 
  if(showControlFrames) {fill(0,255,255); paintShape(x0,y0,r0,b0,d0); fill(255,0,255); paintShape(x1,y0,r0,b0,d0);}
  
  if(showStrobeFrames) 
  {
    float xx=x, yy=y, rr=r, bb=b, dd=d;
    int n = 10;  // original: 7
    for(int j=0; j<n; j++)
    {
      fill(255-(200.*j)/n,(200.*j)/n,155); 
      float tt = (float)j / (n-1);  // println("j="+j+", t="+t);
      computeParametersForAnimationTime(tt);
      paintShape(x,y,r,b,d); 
    }
    println();
    x=xx; y=yy; r=rr; b=bb; d=dd;
  }
  
  if(animating) computeParametersForAnimationTime(t);
  
  noStroke();
  fill(0); paintShape(x,y,r,b,d); // displays current shape
  
  //if(showConstruction) {noFill(); showConstruction(x,y,r,b,d);} // displays blend construction lines and circles
  
  if(showStrobeFrames)
  {
    // Show head path
    noFill(); stroke(0,255,0); strokeWeight(2);
    beginShape();
    for (float tt=0; tt<1.0001; tt+=.01) {
      computeParametersForAnimationTime(tt);
      vertex(x,g-y);
    }
    endShape();
    computeParametersForAnimationTime(t);
  }
  
  showGUI(); // shows mouse location and key pressed
  
  if(snapPic) {endRecord(); snapPic=false;} // end saving a .pdf of the screen
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif"); // saves a movie frame 
  if(animating) {
    t+=dt; 
    if(t>=1) {
      t=1; 
      animating=false;
      computeParametersForAnimationTime(t);
    }
  } // increments timing and stops when animation is complete
  
  change=false; // reset to avoid rendering movie frames for which nothing changes
}



// display shape defined by the 5 parameters (and by _p and _q when these are not to be recomputed automatically
void paintShape(float x, float y, float r, float b, float d)
{
  float p=_p, q=_q; // use global values (user controlled) in case we do not want to recompute them automatically
  if(computingBlendRadii)
  {
    p=blendRadius(b,y,r);
    q=blendRadius(d,y,r);
  }

  int n = 30; // number of samples
  
  beginShape(); // starts drawing shape
 
  // sampling the left arc
  float u0=-PI/2, u1 = atan2(y-p,b); 
  float du = (u1-u0)/(n-1);
  for (int i=0; i<n; i++) // loop to sample left arc
  {
    float s=u0+du*i;
    vertex(x-b+p*cos(s),g-p-p*sin(s)); 
  }

  // sampling the right arc
  float v0=-PI/2, v1 = atan2(y-q,d); 
  float dv = (v1-v0)/(n-1);
  for (int i=n-1; i>=0; i--) // loop to sample let arc
  {
    float s=v0+dv*i;
    vertex(x+d-q*cos(s),g-q-q*sin(s));
  }

  endShape(CLOSE);  // Closes the shape 
  
  ellipse(x,g-y,r*2,r*2);  // draw disk
}

// shows construction lines for shape defined by the 5 parameters (and by _p and _q when these are not to be recomputed automatically
void showConstruction(float x, float y, float r, float b, float d) 
{
  // compute blend radii
  float p=_p, q=_q; // use gobal values (user controlled) in case we do not want to recompute them automatically
  if(computingBlendRadii)
  {
    p=blendRadius(b,y,r);
    q=blendRadius(d,y,r);
  }
  
  strokeWeight(2);  
  // draw left arc
  stroke(200,0,0);      // change line  color to red
  line(x-b,g,x-b,g-p);  // draw vertical edge to center of left circle
  line(x-b,g-p,x,g-y);  // draw diagonal edge from center of left circle to center of disk
  ellipse(x-b,g-p,p*2,p*2);  // draw left circle

  // draw right arc
  stroke(0,150,0);      // change line color to darker green
  line(x+d,g,x+d,g-q);  // draw vertical edge to center of right circle
  line(x+d,g-q,x,g-y);  // draw diagonal edge from center of right circle to center of disk
  ellipse(x+d,g-q,q*2,q*2);  // draw left circle
}