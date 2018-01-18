ArrayList<Lines> vectorField = new ArrayList<Lines>();
ArrayList<Interaction> interactionField = new ArrayList<Interaction>();
int lineSize = 20;

float viscosity = 0.02;
float IntCoeff = 0.01;
int w = 800;
int h = 800;

// emulateMouse
boolean emulate = false;
boolean mousePressedBool = false;
float emulateMouseX;
float emulateMouseY;
float pemulateMouseX;
float pemulateMouseY;

void setup() {
  size(800,800,P3D);
  background(255);
  for (int i = 0; i < w/lineSize; i++) {
    for (int j = 0; j < h/lineSize; j++) {
      Lines l = new Lines(i*lineSize,j*lineSize);
      vectorField.add(l);
    }
  }
  for (Lines l : vectorField) {
    for (Lines k : vectorField) {
      if (l.ax <= k.ax + lineSize && l.ax >= k.ax - lineSize && 
          l.ay <= k.ay + lineSize && l.ay >= k.ay - lineSize) {
            Interaction a = new Interaction(l,k);    
            interactionField.add(a);
          }
    }
  }
}

void draw() {
  stroke(255);
  background(255);
  emulateMouse();
  for (Lines l : vectorField) {
    l.update();
    //l.display();
  }
  for (Interaction I : interactionField) {
    I.update();
    I.display();
  }
  //saveFrame("interaction_sticks_white-####.png");
}

class Lines {
  float ax,ay,dx,dy;
  float arot, arotspeedX,arotspeedY;
  color colorStroke = 255;
  float speedCoeff = 0.45;
  
  Lines(float x1, float y1) {
    ax = x1;
    ay = y1;
  }
  
  void update() {
    
    if (mousePressedBool) {
      if (emulateMouseX < ax + lineSize/2 && emulateMouseX > ax - lineSize/2 && 
          emulateMouseY < ay + lineSize/2 && emulateMouseY > ay - lineSize/2) {        
          arotspeedX = speedCoeff*((emulateMouseX - pemulateMouseX));  
          arotspeedY = speedCoeff*((emulateMouseY - pemulateMouseY));
          //arot = speedCoeff*(abs(emulateMouseX - pemulateMouseX)) +  
          //       speedCoeff*(abs(emulateMouseY - pemulateMouseY));
          
      }
    }
    arotspeedX -= arotspeedX*viscosity;
    arotspeedY -= arotspeedY*viscosity;
    //arot -= arot*viscosity;
    dx += arotspeedX;
    dy += arotspeedY;
    //dx +=arot;
  }
  
  void display() {
    float colorIntens = map((abs(arotspeedX)+abs(arotspeedX)),0,5,200,0);
    //float colorIntens = map(abs(arot),0,5,200,0);
    
    colorStroke = color(colorIntens,colorIntens,255);
    fill(colorStroke);
    //strokeWeight(5);
    noStroke();
    //stroke(0,0,colorIntens);
    pushMatrix();
    translate(ax,ay);
    //translate(ax,ay,dx);
    translate(dx,dy);
    rect(0,0,0.8*lineSize,0.8*lineSize);
    //ellipse(0,0,0.8*lineSize,0.8*lineSize);
    //line(-lineSize/2,0,lineSize/2,0);
    popMatrix();
  }
}



class Interaction {
  Lines l1;
  Lines l2;

  float maxNoInteraction = 0.05;
  
  Interaction(Lines Line1, Lines Line2) {
    l1 = Line1;
    l2 = Line2;
  }
  
  void update() {
    if ((l1.dx - l2.dx) > maxNoInteraction || (l1.dy - l2.dy) > maxNoInteraction) {
      
      l1.arotspeedX += IntCoeff*(l2.dx - l1.dx);
      l2.arotspeedX += IntCoeff*(l1.dx - l2.dx);
      l1.arotspeedY += IntCoeff*(l2.dy - l1.dy);
      l2.arotspeedY += IntCoeff*(l1.dy - l2.dy);
      
      //l1.arot += IntCoeff*(l2.dx - l1.dx);
      //l2.arot += IntCoeff*(l1.dx - l2.dx);
      }
  }
  
  void display() {
    stroke(255,0,0);
    line(l1.ax + l1.dx,l1.dy + l1.ay,l2.ax + l2.dx,l2.dy + l2.ay);
    //beginShape();
    //vertex(l1.ax + l1.dx,l1.dy + l1.ay);
    //vertex(l2.ax + l2.dx,l1.dy + l1.ay);
    //endShape();
  }
}

void emulateMouse() {

  emulateMouseX = map(mouseX,0,width,0,w);
  emulateMouseY = map(mouseY,0,height,0,h);
  pemulateMouseX = map(pmouseX,0,width,0,w);
  pemulateMouseY = map(pmouseY,0,height,0,h);
  if (mousePressed) {
    mousePressedBool = true;
  } else {
    mousePressedBool = false;
  }

}