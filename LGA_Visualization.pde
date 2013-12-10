/* 
disclaimer!!!
Thus far I have only ever wrote code for personal use. The following code may not work on your machine 
and it definitely needs to be cleaned up. I welcome any general coding suggestions/advice as I am also 
mostly self-taught(not a cs type background). Please feel free to modify this code in any way you like 
and/or send me your thoughts/comments/improvements. If there is a feature you would like me to implement, 
let me know and I can see what I can do. Play around with the buttons, but hopefully they are relatively 
self explanatory. Mainly: toggle between particle/wall draw modes. take one step at a time or "run" continuously.
Changing the file name can be a pain since the text entry method is not the best - press the change file button, type your new
working file name, and then press enter. You can then load that file or press save to create/overwrite it. There
is not a set file extension(not even needed), but using .txt(or a text editor extension) saves some time. Exporting spits
out a text file with drawpoint based lines that you need to copy/paste into an lga py file. 
Again, send me any comments you might have!
Thanks!


*/

//To implement
/*
1) 2 particle collision matrix change during reversing
2) comments/clean code
4) srcs and visualization
7) cleaned up ui/button order
8) better text input or file load ui
9) better eraser fidelity

Limitations
**take care to set your r1 and c1 values to match your refl walls based on your drawing. 
   setting r1/c1 to odd numbers usually works if the top wall is a refl wall.
   if the top is a rev wall or a particle, this may change

instructions/shortcuts
Change the size parameter in setup if you would like to change the display width or height
t = toggle between wall and particle drawing modes
r = rotate drawing direction based on current mode
d or left click, while mouse is within grid = draw a new object near mouse position based on current mode
CTRL + R = reverse all particle directions (only works while in particle mode)
e or right click, while mouse is within grid = erase nearest particles/walls (not robust/ may take multiple clicks)
CRTL + Z = erase last drawn wall/particle based on mode
SPACE = take one step

*/


int scale = 40; // hexagonal lattice with lines "scale" px long
Particles ps = new Particles(); //global
Walls ws = new Walls(); //global
revWalls rws = new revWalls();
int modeToggle = 0; // 0 wall mode, 1 particle mode, 2 rwalls
PFont font;
GUI gui;
String workingFile = "default.txt";
boolean runContinuously = false;

void setup()
{
 size(500,500); //change here to find a display that works for you!
  font = createFont("Arial",16,true);
  ps.setup2parMatrix();
gui = new GUI(); 
}
void draw()
{
 
  background(255);
  gui.updateGUI();
  ps.drawDrawingParameters();
  ws.drawDrawingParameters();
  if(runContinuously && frameCount % gui.runSpeed == 0)
  {
   ps.updateParticles(ws); 
  }
 // if(checkKey(' ') && KeyPressLock(500))
 // {  
  
 //   ps.updateParticles(ws);

//  }
//  else
 // {
   ps.drawParticles(); 
   ws.drawWalls();
   rws.drawWalls();
//  }
 if(gettingString)
  {
   workingFile = stringbuffer; 
   stringFunction(); 
  }
  else{
  handleInput();
  }
}
void handleInput()
{
  if(checkKey(' ') && KeyPressLock(500))
  {
   ps.updateParticles(ws); 
  }
  if(checkKey('T') && KeyPressLock(500))
  {
    modeToggle ++;
    if(modeToggle>2)
        modeToggle = 0;  
  }
  if(checkKey(CONTROL) && checkKey('R') && KeyPressLock(500))
  {
   ps.reverseDirection();
  println("rever"); 
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
  else if(modeToggle == 2)
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
    
    
    
  }
    
  
  
}



