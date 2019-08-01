import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture video;
OpenCV opencv;

//for video effect
float x,y;
int movingX;
  
void captureEvent(Capture video){
  video.read();
}

void setup(){
  size(1280,960);
  video = new Capture(this,640,480);
  video.start();
  opencv = new OpenCV(this,640,480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  

}

boolean isvalid_face = true;

void draw(){
  
 if(isvalid_face){
   scale(2); 
   opencv.loadImage(video);
   
   image(video,0,0);
   
   pushMatrix();
     rectMode(CENTER);
     rect(width/4, height/4, 300,300);
   popMatrix();
   
   //fill(255,30,70);
   noFill();
   stroke(255,30,70);
   strokeWeight(3);
   Rectangle[] faces = opencv.detect();
   boolean flag = false;
   for(int i=0; i<faces.length;i++){
     rectMode(CORNER);
     rect(faces[i].x,faces[i].y, faces[i].width, faces[i].height);
     
     if(faces[i].x > (width/4-150) && (faces[i].x+faces[i].width) <(width/4+150) 
         && faces[i].y > (height/4-150) && (faces[i].y+ faces[i].height) < (height/4+150)){
           print("hihi");
           delay(3000);
           saveFrame("face.png");
           //delay(10000);
           flag = true;
           //isvalid_face = false;
         }
         else flag = false;
   }
   if(flag) isvalid_face = false;
 }
 else{
   background(0);
 }
}

void keyPressed() {
  if (keyCode == RIGHT) isvalid_face = true;
    
}  
