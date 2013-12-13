//this file (input.pde) has code for:
//1)checking if a key is pressed, 2) defining the Button class, 3)getting string based input for updating the filename and
//4) handling shortcut keys for the program

//defines an array set that can be checked to see if key is currently pressed, allows for multiple keys to be pressed at once(ie CTRL + R)
boolean[] keys = new boolean[526];
long lastKeyPress = 0;
boolean checkKey(int k)
{
  if (keys.length >= k) {
    return keys[k];  
  }
  
  return false;
}
 
void keyPressed()
{ 
  keys[keyCode] = true;
}
 
void keyReleased()
{ 
  keys[keyCode] = false; 
}

boolean KeyPressLock(float t)
{
  if(millis()-t>lastKeyPress)
  {
    lastKeyPress = millis();
     return true;
  }
  return false;
}

//Button class! parameters set by GUI class in GUI1.pde file
//takes in constructor parameters, shows buttons on screen based on parameters, and determines if mouse is clicked and within the button
class Button
{
 float xPos;
 float yPos;
 float pxWidth;
 float pxHeight;
 String bText;
 int bColor = color(196,188,188);
 
 Button(float x, float y, float w, float h, String t)
 {
  xPos = x;
  yPos = y;
  pxWidth = w;
  pxHeight = h;
  bText = t; 
   
 }
 
 void showButton()
 {
  stroke(0);
  fill(bColor); 
  rect(xPos,yPos,pxWidth,pxHeight); 
  textFont(font,pxHeight/2);
  //text("Welcome!!",width/2 - 100,50);
  fill(0);
  textAlign(CENTER);
  text(bText, xPos+pxWidth/2, yPos+pxHeight/2); 
 }
 
 
 boolean isPressed()
 {
  if(mouseX > xPos && mouseX < xPos+pxWidth && mouseY > yPos && mouseY<yPos+pxHeight && mousePressed)
  {
   bColor = color(121,120,120); 
   return true; 
  }
   bColor = color(196,188,188);
   return false;
    
 }
  
  
  
}

boolean gettingString = false; //global toggled true by changeFile button
String stringbuffer = "";//global buffer used to update workingFile
void stringFunction()
{
   //text inputs 
   if(keyPressed && ((key>='A' && key <= 'z') || (key>='0' && key<='9') || key == '.'))
      {
      stringbuffer = stringbuffer+key;
      delay(100);
      }
// } 
 else if(checkKey(DELETE)) //clear all text
 {
  stringbuffer = ""; 
 }
 else if(checkKey(ENTER)) //confirm text entry
 {
  gettingString = false; 
 }
 else if(checkKey(BACKSPACE)) //delete last entered character
 {
   if(stringbuffer.length()>0)
   {
   stringbuffer = stringbuffer.substring(0,stringbuffer.length() - 1);
   delay(100);
   }
 }
 
}
void handleInput() //see instructions at beggining of LGA_Visualization.pde file
{
  if(checkKey(' ') && KeyPressLock(500))
  {
   ps.updateParticles(); 
  }
  if(checkKey('T') && KeyPressLock(500))
  {
    modeToggle ++;
    if(modeToggle>3)
        modeToggle = 0;  
  }
  if(checkKey(CONTROL) && checkKey('R') && KeyPressLock(500))
  {
   ps.reverseDirection();
  println("reverse Particles"); 
  }
  if(modeToggle==1) // particles
  {
 if(checkKey('D') || (mousePressed && mouseButton == LEFT && !gui.isinGUI()) && KeyPressLock(1000))
  {
   ps.addNew(); 
  }
   if(checkKey('E')|| (mousePressed && mouseButton == RIGHT && !gui.isinGUI()) && KeyPressLock(1000))
  {
   ps.eraseAtMouse(); 
  }
  if(checkKey('R') && !checkKey(CONTROL) && KeyPressLock(500))
  {
   ps.changeDrawDirection(); 
  }
  
  if(checkKey('Z') && checkKey(CONTROL) && KeyPressLock(1000))
  {
   ps.removeLast(); 
  }
    if(checkKey('L') && KeyPressLock(500))
  {
   ps.addParLine10x(); 
  }if(checkKey('K') && KeyPressLock(500))
  {
   ps.addParLine10y(); 
  }
  
  }
  else if(modeToggle == 0) //wall drawing
  {
    if(checkKey('D')|| (mousePressed && mouseButton == LEFT && !gui.isinGUI())  && KeyPressLock(1000))
  {
   ws.addNew(); 
  }
   if(checkKey('E') || (mousePressed && mouseButton == RIGHT && !gui.isinGUI()) && KeyPressLock(1000))
  {
   ws.eraseAtMouse(); 
  } 
  if(checkKey('R') && !checkKey(CONTROL) && KeyPressLock(500))
  {
   ws.changeDrawDirection(); 
  }
  
  if(checkKey('Z') && checkKey(CONTROL) && KeyPressLock(1000))
  {
   ws.removeLast(); 
  }
 
  }
  else if(modeToggle == 2) //rev/snk
  {
      if(checkKey('D')|| (mousePressed && mouseButton == LEFT && !gui.isinGUI())  && KeyPressLock(1000))
  {
   rws.addNew(); 
  }
   if(checkKey('E') || (mousePressed && mouseButton == RIGHT && !gui.isinGUI()) && KeyPressLock(1000))
  {
   rws.eraseAtMouse(); 
  }

  if(checkKey('Z') && checkKey(CONTROL) && KeyPressLock(1000))
  {
   rws.removeLast(); 
  }
  if(checkKey('R') && !checkKey(CONTROL) && KeyPressLock(500))
  {
   rws.toggleType(); 
  }
  if(checkKey('L') && KeyPressLock(500))
  {
   rws.addWallLine10x(); 
  }if(checkKey('K') && KeyPressLock(500))
  {
   rws.addWallLine10y(); 
  }
    
    
    
  }
  if(modeToggle==3) // sources
  {
 if(checkKey('D') || (mousePressed && mouseButton == LEFT && !gui.isinGUI()) && KeyPressLock(1000))
  {
   srcs.addNew(); 
  }
   if(checkKey('E')|| (mousePressed && mouseButton == RIGHT && !gui.isinGUI()) && KeyPressLock(1000))
  {
   srcs.eraseAtMouse(); 
  }
  if(checkKey('R') && !checkKey(CONTROL) && KeyPressLock(500))
  {
   srcs.changeSourceDirection(); 
  }
  
  if(checkKey('Z') && checkKey(CONTROL) && KeyPressLock(1000))
  {
   srcs.removeLast(); 
  }
  }
    
  
  
}
