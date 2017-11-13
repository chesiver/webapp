// Snapping a picture
import processing.pdf.*;    // to save screen shots as PDFs
boolean snapPic=false;
String PicturesOutputPath="data/PDFimages";
int pictureCounter=0;
//void snapPicture() {saveFrame("PICTURES/P"+nf(pictureCounter++,3)+".jpg"); }

// Filming
boolean filming=false;  // when true frames are captured in FRAMES for a movie
int frameCounter=0;     // count of frames captured (used for naming the image files)
boolean change=false;   // true when the user has presed a key or moved the mouse