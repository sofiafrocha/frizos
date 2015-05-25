import controlP5.*;
ControlP5 cp5;

import javax.swing.*; 
SecondApplet s;

String texto1 = "Pierrot dorme sobre a relva junto ao lago.";
String texto2 = "Os cisnes junto d'elle passam sêde, não n'o acordem ao beber.";
String texto3 = "Uma andorinha travêssa, linda como todas, avôa brincando rente á relva e beija ao passar o nariz de Pierrot.";

String texto4 = "Elle accorda e a andorinha, fugindo a muito, olha de medo atraz, não venha o Pierrot de zangado persegui-la pelos campos.";
String texto5 = "E a andorinha perdia-se nos montes, mas, porque elle se queda";
String texto6 = " de nôvo volta em zig-zags travêssos e chilreios de troça.";

String worker;
Boolean forShow = true;

// Window sizes
int widthSmall = 400;
int heightSmall = 350;

int widthLarge = widthSmall*3;
int heightLarge = heightSmall*2;

// Offsets for moving the drawn area in the full window
int offsetX = 0;
int offsetY = 0;

// Margins
int marginX = 20;
int marginY = 20;

// Typography
int textSize = 13;
int betweenLines = 6;
int heigthTextTotal = textSize + betweenLines;

// Brushes
int brushSize;
int brushSizeDefault = 4;
int maxBrushSize = 12;
boolean brushRandomize = false;
int lockX;
int lockY;

// Limitations
boolean lock = false;

void setup() {
  size(widthSmall, heightSmall);
  PFrame f = new PFrame(widthLarge, heightLarge);
  
  frame.setTitle("draw here");
  f.setTitle("here is the full thing");
  
  fill(0);
  
  stroke(255);
  
  strokeWeight(brushSizeDefault);
  
  smooth();
  background(198, 59, 80);
  
  
  cp5 = new ControlP5(this);
  cp5.addButton("Menu").setPosition(20,marginY).setSize(50,20).setId(0);
  cp5.addButton("Exit").setPosition(70,marginY).setSize(50,20).setId(1);
  cp5.addButton("Export").setPosition(120,marginY).setSize(50,20).setId(2);
  cp5.addButton("Next").setPosition(170,marginY).setSize(50,20).setId(3);
  cp5.addButton("Reset").setPosition(220,marginY).setSize(50,20).setId(4);
  
  PFont font;
  // The font must be located in the sketch's 
  // "data" directory to load successfully
  font = loadFont("Raleway-48.vlw");
  textFont(font, 15);
}

void draw() {
  //ellipse(mouseX, mouseY, 10, 10);
  s.setPGhostCursor(pmouseX, pmouseY);
  s.setGhostCursor(mouseX, mouseY);
  
  if (brushRandomize == true) {
    brushSize = int(random(0,maxBrushSize));
    strokeWeight(brushSize);
  }
  
  if (keyPressed) {
    
    if (lock == true) {
      lockX = mouseX;
      lockY = mouseY;
      lock = false;
    }
    
    if (key == 'a' || key == 'A') {
      //println("free draw");
      
      line(mouseX, mouseY, pmouseX, pmouseY);
      s.ifIsDrawing();
      //print("risco ligado");
    }
    if (key == 'x' || key == 'X') {
      //println("lock x");
      
      line(mouseX, lockY, pmouseX, lockY);
      s.setPGhostCursor(pmouseX, lockY);
      s.setGhostCursor(mouseX, lockY);
      s.ifIsDrawing();
    }
    if (key == 'y' || key == 'Y') {
      //println("lock y");
      
      line(lockX, mouseY, lockX, pmouseY);
      s.setPGhostCursor(lockX, pmouseY);
      s.setGhostCursor(lockX, mouseY);
      s.ifIsDrawing();
    }
    
    if (key == 'r' || key == 'R') {
      brushRandomize = !brushRandomize;
      
      if (brushRandomize == false) {
        brushSize = brushSizeDefault;
      }
    }
  }
 
  
  if (forShow == true) {
    text(texto1, marginX, heightSmall - heigthTextTotal * 3);
    text(texto2, marginX, heightSmall - heigthTextTotal * 2);
    text(texto3, marginX, heightSmall - heigthTextTotal * 1);
  } else {
    text(texto4, marginX, heightSmall - heigthTextTotal * 3);
    text(texto5, marginX, heightSmall - heigthTextTotal * 2);
    text(texto6, marginX, heightSmall - heigthTextTotal * 1);
  }
  
  fill(255,255,255);
  
}

void keyReleased() {
  //println("unlocked!");
  lock = true;
}

public class PFrame extends JFrame {
  public PFrame(int width, int height) {
    setBounds(0, 0, widthLarge, heightLarge + marginY);
    s = new SecondApplet();
    add(s);
    s.init();
    show();
  }
}

// segunda janela
public class SecondApplet extends PApplet {
  int ghostX, ghostY;
  int pGhostX, pGhostY;
  boolean toggle;
  
  public void setup() {
    background(198, 59, 80);
    //noStroke();
    stroke(255);
    strokeWeight(brushSizeDefault);
  }

  public void draw() {
    stroke(255);
    strokeWeight(brushSize);
   
    //ellipse(pGhostX-50, pGhostY-50, 5, 5);
    //if(toggle == true) {
      //line(ghostX, ghostY, pGhostX, pGhostY);
    //}
  }
  
  public void setGhostCursor(int ghostX, int ghostY) {
    this.ghostX = ghostX + offsetX;
    this.ghostY = ghostY + offsetY;
  }
  
  public void setPGhostCursor(int pGhostX, int pGhostY) {
    this.pGhostX = pGhostX + offsetX;
    this.pGhostY = pGhostY + offsetY;
  }
  
  public void ifIsDrawing() {
   line(ghostX, ghostY, pGhostX, pGhostY);
  }
  
  public void resetScreen() {
    fill(198, 59, 80);
    noStroke();
    rect(offsetX, offsetY, widthSmall, heightSmall);
  }
  
  //public void exportScreen() {
    //saveFrame(dataPath("testetesteFull2.png"));
    //print("saved!");
  //}
  
}

void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id "+theEvent.getController().getId());
  
  // If the "Export" button was pressed
  if (theEvent.getController().getId() == 2) {
    println("export!");
    //s.exportScreen();
    saveSmallFrame();
  }
  
  // If the "Next" button was pressed
  if (theEvent.getController().getId() == 3) {
    //println("this event was triggered by Controller último button");
    
    forShow = !forShow;
    
    //saveSmallFrame();
    background(217, 30, 24);
    
    println("offsetX: " + offsetX);
    println("widthSmall: " + widthSmall);
    
    if (offsetX == widthSmall * 2) {
      offsetX = 0;
      offsetY = heightSmall;
      
      println("chegou ao fim da linha");
    }
    else {
      offsetX = offsetX + widthSmall;
      println("ainda falta. andar mais uma casa.");
    }
  }
  
  // If the "Reset button was pressed
  if (theEvent.getController().getId() == 4) {
    background(217, 30, 24);
    s.resetScreen();
  }

  
}

public void saveSmallFrame() {
  println("saving");
  s.saveFrame(dataPath("cobaiaGrande.png"));
  
  for (int i = 0; i < 6; i++) {
    println("saving screen " + i);
    //saveFrame();
    PImage outgoing;
    
    if (i < 3) {
      println("i*widthSmall:  " + i*widthSmall);
      println("i*heightSmall:  " + i*heightSmall);
      
      outgoing = s.get(i*widthSmall, 0, widthSmall, heightSmall);
      println("grabbing top screen number " + i);
    }
    else {
      println("grabbing bottom screen number " + i);
      println("i-3: " + (i-3));
      println("(i-3)*widthSmall:  " + (i-3)*widthSmall);
      println("(i-3)*heightSmall:  " + (i-3)*heightSmall);
      
      outgoing = s.get((i-3)*widthSmall, heightSmall, widthSmall, heightSmall);
    }
    for (int i = 0; i < outgoing.pixels.length; i++) {
      
    
    outgoing.save(dataPath("cobaia" + i + ".png"));
    
    println();
  }
  
  /*File dir = new File(dataPath("")); 
  String[] list = dir.list();
  
  if (list == null) {
    println("Folder does not exist or cannot be accessed.");
  } else {
    println(list);
    
    for (int i = 0; i < list.length; i++) {
      println("print");
      println("png? " + list[i].substring(list[i].length() - 3, list[i].length()));
      worker = list[i].substring(list[i].length() - 3, list[i].length());
      if ( worker == ".png") {
        worker = list[i].substring(0, list[i].length() - 3);
        println(worker);
      }
    }
  }
  
  */
}
