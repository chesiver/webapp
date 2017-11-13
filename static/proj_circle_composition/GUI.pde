// show Mouse and key pressed
void showGUI()
{
  noFill(); stroke(155,155,0);
  if(mousePressed) strokeWeight(3); else strokeWeight(1);
  ellipse(mouseX,mouseY,30,30);
  if(keyPressed) {fill(155,155,0); strokeWeight(2); text(key,mouseX-6,mouseY);}
  strokeWeight(1);
}



void keyPressed()
{
  if(key=='0') initDefault();
  if(key=='1') initHappy();
  if(key=='2') initDriven();
  if(key=='3') initDiscouraged();
  if(key=='4') initAfraid();
  if(key=='5') initAgitated();
  if(key=='6') initLazy();
  
  if(key=='`') snapPic=true; // to snap an image of the canvas and save as zoomable a PDF
  if(key=='~') filming=!filming;  // filming on/off capture frames into folder FRAMES 
  if(key=='.') computingBlendRadii=!computingBlendRadii; // toggles computing radii automatically
  if(key=='f') showControlFrames=!showControlFrames;
  //if(key=='c') showConstruction=!showConstruction;
  if(key=='s') showStrobeFrames=!showStrobeFrames;
  if(key=='a') {
    animating=true; // start animation 
    t=0;
  }
  if(key==' ') animating=!animating;
  change=true; // reset to render movie frames for which something changes
}
  
  
  
void mouseMoved() // press and hold the key you want and then move the mouse (do not press any mouse button)
{
  if(keyPressed)
  {
    if(key=='r') r+=mouseX-pmouseX;
    if(key=='x') {x+=mouseX-pmouseX; y-=mouseY-pmouseY;}
    if(key=='b') {b-=mouseX-pmouseX; _p-=mouseY-pmouseY;}
    if(key=='d') {d+=mouseX-pmouseX; _q-=mouseY-pmouseY;}
  }
  change=true; // reset to render movie frames for which something changes
}