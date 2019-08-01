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
  int k = (int)random(200)-50;

void draw(){
 scale(2);

 opencv.loadImage(video);
 
 image(video,0,0);
 
 fill(255,30,70);
 noStroke();
 strokeWeight(3);
 Rectangle[] faces = opencv.detect();


 for(int i=0; i<faces.length;i++){
   //rect(faces[i].x,faces[i].y, faces[i].width, faces[i].height);
    videoEffect(faces[i].x,faces[i].y);
     // videoEffect(faces[i].x+,faces[i].y);
     //for(int j=0; j< faces[i].width; j++)
     //videoEffect(faces[i].x+j*2,faces[i].y);
 }
  for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+100,faces[i].y+10);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+30,faces[i].y+10);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+160,faces[i].y+100);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+210,faces[i].y+100);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+270,faces[i].y+100);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-150,faces[i].y+150);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+-100,faces[i].y+200);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-80,faces[i].y+80);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+250,faces[i].y+250);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-250,faces[i].y+250);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-50,faces[i].y+250);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-100,faces[i].y+250);
 }
}

void videoEffect(float x, float y){
    movingX ++;
  movingX %= 360;
  int radius = 10;


  float value = sin(radians(movingX))*40;
  
  pushMatrix();
   
  ellipse((x+ value)-radius/2,(y - movingX)-radius,radius,radius);
  ellipse((x+ value)+radius/2,(y - movingX)-radius,radius,radius);
  ellipse((x+ value),(y - movingX)-radius/1.5,radius/1.5,radius/1.5);
  triangle((x+ value),(y-movingX)+radius/10, (x+ value)-radius/1.15, (y - movingX)-radius/1.6, (x+ value)+radius/1.15, (y - movingX)-radius/1.6);
   popMatrix();
}import processing.video.*;
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
  int k = (int)random(200)-50;

void draw(){
 scale(2);

 opencv.loadImage(video);
 
 image(video,0,0);
 
 fill(255,30,70);
 noStroke();
 strokeWeight(3);
 Rectangle[] faces = opencv.detect();


 for(int i=0; i<faces.length;i++){
   //rect(faces[i].x,faces[i].y, faces[i].width, faces[i].height);
    videoEffect(faces[i].x,faces[i].y);
     // videoEffect(faces[i].x+,faces[i].y);
     //for(int j=0; j< faces[i].width; j++)
     //videoEffect(faces[i].x+j*2,faces[i].y);
 }
  for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+100,faces[i].y+10);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+30,faces[i].y+10);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+160,faces[i].y+100);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+210,faces[i].y+100);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+270,faces[i].y+100);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-150,faces[i].y+150);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+-100,faces[i].y+200);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-80,faces[i].y+80);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x+250,faces[i].y+250);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-250,faces[i].y+250);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-50,faces[i].y+250);
 }
 for(int i=0; i<faces.length;i++){
    videoEffect(faces[i].x-100,faces[i].y+250);
 }
}

void videoEffect(float x, float y){
    movingX ++;
  movingX %= 360;
  int radius = 10;


  float value = sin(radians(movingX))*40;
  
  pushMatrix();
   
  ellipse((x+ value)-radius/2,(y - movingX)-radius,radius,radius);
  ellipse((x+ value)+radius/2,(y - movingX)-radius,radius,radius);
  ellipse((x+ value),(y - movingX)-radius/1.5,radius/1.5,radius/1.5);
  triangle((x+ value),(y-movingX)+radius/10, (x+ value)-radius/1.15, (y - movingX)-radius/1.6, (x+ value)+radius/1.15, (y - movingX)-radius/1.6);
   popMatrix();
}
