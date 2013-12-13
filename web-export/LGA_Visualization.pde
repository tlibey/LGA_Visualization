/* 
Please feel free to modify this code in any way you like and/or send me your thoughts/comments/improvements. 
If there is a feature you would like me to implement, let me know and I can see what I can do. Play around with 
the buttons, but hopefully the titles are relatively self explanatory. Mainly: toggle between particle/wall draw modes.
take "one step" at a time or "run" continuously.Changing the file name can be a pain since the text entry method is 
not the best - press the change file button, type your new working file name, and then press enter. You can then load 
that file or press save to create/overwrite it. There is not a set file extension(not even needed), but using .txt(or a text editor extension)
saves some time. Exporting spits out a text file with self.lga.drawpoint based lines that you need to copy/paste into an lga py file. 
Toggle continuous save when you have your file name set to get a running save of your work (overwrites same file). 
Again, send me any comments you might have!
Thanks!


*/

//Ideas for improvement
/*
Better file I/O: load window, better text entry, and a history (git based?) file to go back to previously set states
Zoom/Scroll functions: Allow for larger workspaces within the visualization
Direct python lga calling: function in python that calls multiple gates out of a set folder and places them in set locations
Better statistical options: Current functionality is limited but easy to implement custom code to place numbers in button boxes(see template in gui)


Limitations
**take care to set your r1 and c1 values to match your refl walls based on your drawing. 
   setting r1/c1 to odd numbers usually works if the top wall is a refl wall.
   if the top is a rev wall or a particle, this may change

instructions/shortcuts
Change the size parameter in setup if you would like to change the display width or height (seems to need to be divisible by 20)
t = toggle between wall/particle/RevSnk/Source drawing modes
r = rotate drawing direction based on current mode or toggle between Rev walls and Snks
d or left click, while mouse is within grid = draw a new object near mouse position based on current mode
e or right click, while mouse is within grid = erase nearest particles/walls (not robust/ may take multiple clicks)
CTRL + R = reverse all particle directions
CRTL + Z = erase last drawn wall/particle/RevSNK/Source based on mode
SPACE = take one step
k = draw line of 10 REV walls or randomly directed particles(based on mode) from mouse point to the right
l = draw line of 10 REV walls or randomly directed particles(based on mode) from mouse point to the bottom
**ESC == EXIT program!! make sure it is saved!
*/


int scale = 40; // hexagonal lattice with lines "scale" px long, toggled in code but toggle values can be changed directly
Particles ps = new Particles(); //global class set defining particles
Walls ws = new Walls(); //global class set defining reflective walls
revWalls rws = new revWalls(); //global class set defining REV walls AND SINKS
Sources srcs = new Sources(); //global class set defining sources
int modeToggle = 0; // 0 wall mode, 1 particle mode, 2 rwalls, 3 sources
PFont font; //font class for gui output
GUI gui; // global gui class; includes specific buttons and grid drawing
String workingFile = "default.txt"; //starting save/load file, can be changed here or in program
boolean runContinuously = false; //boolean flag for draw() loop. can be changed in program. updates particles continuously based on frame limiter
boolean continuousSave = false; //boolean control flag for draw() loop. can be changed in program. saves every 100 frames to prevent data loss
void setup()
{
 size(700,500); //change here to find a display that works for you! divisible by 20 seems to keep grid alligned, but may be different
  font = createFont("Arial",16,true); //setting up fontsize and type, 16 designates default font size which is normally overwritten in code
  ps.setup2parMatrix(); // calls the Particles() function that sets up the 2 dimensional state matrix for 2 particle collisions
gui = new GUI(); //initializes Gui
}
void draw()
{
 
  background(255); //set background color to white(also serves to refresh the frame)
  gui.updateGUI(); //calls check buttons and show buttons in gui class, if button is pressed near function call will execute function of button
  ps.drawDrawingParameters(); // draws the template particle in top left corner
  ws.drawDrawingParameters(); // draws the template wall in top left corner
  if(runContinuously && frameCount % gui.runSpeed == 0) //runs continuously if enabled
  {
   ps.updateParticles(); //move particles, check for collisions, drawparticles
  }
  //if not continuous then just draw everything:
   ps.drawParticles(); 
   ws.drawWalls();
   rws.drawWalls();
   srcs.drawSources();
   
   if(continuousSave && frameCount % 100 == 0)//saves file every 100 frames
   {
    saveAll(); 
   }

 if(gettingString) // variable defined in input.pde file. control loop parameter that allows for text entry for file names
  {
   workingFile = stringbuffer; //updates working file in real time 
   stringFunction(); // function in input.pde that allows for text entry
  }
  else{
  handleInput(); //shortcut access (see rules above or function in input.pde)
  }
}

//this file(GUI1.pde) defines the graphical user interface seen by the program
class GUI
{
 ArrayList<Button> buttons = new ArrayList<Button>(); //stores all buttons
 //control pannel locations
 float xGUIStart; 
 float yGUIStart;

 float buttonH; //button height
 float buttonW; //button width
 int buffer; //spacing around buttons, not super effective
 int lastPress = 0; //prevents overclicking of buttons, 
 int fontSize; //gui fontsize based on height of display
 int runSpeed = 10; //number of frames to skip between particle updates, decreas # to increase speed %%%%%%%
 boolean gridOn = true; //control loop flag determining whether to draw grid
  GUI()
  {
    
    xGUIStart = 0;
    yGUIStart = height-height/8;
    buffer = height/200;
    buttonH = height/30;
    buttonW = (width-2*buffer)/8;
    fontSize = height/50;
    setupButtons(); //initializes all buttons, this is the function to change to add buttons
    
  }
  void updateGUI()
  {
    if(gridOn)
     this.drawGrid();
     
    this.showButtons(); //display all buttons
    this.checkButtons(); //if button is pressed, execute function
    
  }
  
  void drawGrid()
{
  stroke(0); //black lines
   strokeWeight(1); //thin lines
  //draw lines based on set scale
  for(int ii = scale; ii< height; ii+=scale)
    {
      line(4,ii,width,ii);
    }
   pushMatrix();
   rotate(PI*60/180);
    for(int ii = -2*height; ii< height; ii+=scale)
    {
      line(4,ii,2*width,ii);
    }
   popMatrix();
     pushMatrix();
   rotate(-PI*60/180);
    for(int ii = 0; ii< 2*height; ii+=scale)
    {
      line(-width,ii,2*width,ii);
    }
   popMatrix();
  
  
}

  void setupButtons()
  {
    //create all of the buttons and add them to the arraylist called "buttons" offset in x by #*buttonW, similar in y
    //button name here must be the same as in checkButtons() to ensure it will be called
    buttons.add(new Button(xGUIStart+buffer+0*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"TogDrawMode"));
    buttons.add(new Button(xGUIStart+buffer+1*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"rotateParticle"));
    buttons.add(new Button(xGUIStart+buffer+2*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"rotateWall"));
    buttons.add(new Button(xGUIStart+buffer+3*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"togRevSnk"));
    buttons.add(new Button(xGUIStart+buffer+4*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"rotateSource"));
    buttons.add(new Button(xGUIStart+buffer+5*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"reverseParticles"));
    buttons.add(new Button(xGUIStart+buffer+6*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"changeScale"));
    buttons.add(new Button(xGUIStart+buffer+7*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"clearAll"));

    buttons.add(new Button(xGUIStart+buffer+0*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"OneStep"));
    buttons.add(new Button(xGUIStart+buffer+1*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"run"));
    buttons.add(new Button(xGUIStart+buffer+2*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"runSpeedUp"));
    buttons.add(new Button(xGUIStart+buffer+3*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"runSpeedDown"));
    buttons.add(new Button(xGUIStart+buffer+4*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"changeFile"));
    buttons.add(new Button(xGUIStart+buffer+5*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"SaveAll"));
    buttons.add(new Button(xGUIStart+buffer+6*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"loadAll"));
    buttons.add(new Button(xGUIStart+buffer+7*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"exportLGA"));
        
    buttons.add(new Button(xGUIStart+buffer+0*buttonW,yGUIStart+buffer+3*buttonH,buttonW,buttonH,"toggleGrid"));
    //functional buttons (have to be last added since name of button changes to display a value)
    buttons.add(new Button(xGUIStart+buffer+1*buttonW,yGUIStart+buffer+3*buttonH,buttonW,buttonH,"ContSave"+continuousSave));
    //stat buttons these display particle counts, but feasibly any stat could be displayed here if it is calculated
    buttons.add(new Button(xGUIStart+buffer+2*buttonW,yGUIStart+buffer+3*buttonH,buttonW,buttonH,"particleCount"));
    buttons.add(new Button(xGUIStart+buffer+3*buttonW,yGUIStart+buffer+3*buttonH,buttonW,buttonH,"leftCount"));
    buttons.add(new Button(xGUIStart+buffer+4*buttonW,yGUIStart+buffer+3*buttonH,buttonW,buttonH,"rightCount"));

  }
  boolean isinGUI() //used to ensure that particles/walls are not placed within the gui;
  {
    int x = mouseX; int y = mouseY;
    if(mouseX >xGUIStart && mouseX < width-buffer && mouseY > yGUIStart && mouseY<height-buffer)
    {
      return true;
    }
    return false;
  }
  void showButtons() //displays all buttons
  {
    fill(255);
    stroke(0);
    rect(xGUIStart,yGUIStart,width,height-buffer); //gui space (overwrites drawgrid with white rectangle
    textFont(font,fontSize);
    fill(0);
    //display the current mode in top left of gui
    String modeDisp = "Particle";
    if(modeToggle==0)
        modeDisp = "Wall";
    else if(modeToggle == 2)
        modeDisp = "Rev/Snk";
    else if(modeToggle == 3)
        modeDisp = "Source";
    textAlign(LEFT);
    text("Mode: " + modeDisp, buffer, yGUIStart + 4*buffer);
    //display the current number of time steps in center of gui
    textAlign(CENTER);
    text("Time: "+ps.time,width/2,yGUIStart+4*buffer);
    //display current working file in top right of gui
    textAlign(RIGHT);
    text("CurrentFile: "+workingFile,width-buffer,yGUIStart+4*buffer);
    calculateStatText(); //called separately for organization, updates text of stat buttons
   for(int ii= 0; ii<buttons.size(); ii ++)
  {
    buttons.get(ii).showButton();
  } 
  }
  
  void calculateStatText()
  {
      buttons.get(buttons.size()-3).bText = "all par"+ps.pars.size(); //but the total number of particles in the textbox
      int lefts = 0;
      int rights = 0;
      for(int ii = 0; ii<ps.pars.size();ii++) //itterate over all particles
      {
       if(ps.pars.get(ii).xPos>24) //if particles are further right than column 24 add to the right count
      {
       rights++;
      } 
      else if(ps.pars.get(ii).xPos<20)//if particles are further left than column 20 add to the left count
      {
       lefts++; 
      }
      }
      buttons.get(buttons.size()-2).bText = "Left par"+lefts;
      buttons.get(buttons.size()-1).bText = "Right par"+rights;

    
  }
  
  void checkButtons() 
  {
    String pressed = "";
   for(int ii = 0; ii<buttons.size(); ii ++)
  {
   if(buttons.get(ii).isPressed()) //isPressed defined in button class in input.pde file
   {
     pressed = buttons.get(ii).bText;
   }
  } 
  if(pressed!= "" && lastPress<millis()-300) //ensures buttons are not double pressed or blank
  {
   lastPress = millis(); //reset lastPress
   if(pressed=="TogDrawMode"){ //alternate between drawmodes
         modeToggle ++;
         if(modeToggle>3)
            modeToggle = 0; 
         if(modeToggle==0)
         {println("wallMode");}
        else if(modeToggle ==1)
         {println("particleMode");}
        else if(modeToggle ==2)
        {println("Rev/SnkMode");}
        else if(modeToggle ==3)
        {println("SrcMode");}
   }
   else if(pressed == "OneStep"){ //time++; moves particles, checks collisions and draws particles
    ps.updateParticles();
  
   }
   else if(pressed == "SaveAll") //saves all objects to current working file name
   {
    saveAll();
     
   }
    else if(pressed == "loadAll") //clears current display and loads all objects from file with the current working file name
   {
    ws.clearWalls();
    ps.clearParticles();
    rws.clearWalls();
    srcs.clearSources();
    loadFile();
    ps.time = 0;
    ps.timeStep = 1;
     
   }
   else if(pressed == "changeFile") //initiates text input functionality so file name can be changed
   {
    gettingString = true; 
    stringbuffer = "";
     
   } 
   else if(pressed == "exportLGA") //creates lga export file to current working file name(adds _exp) before file extension
   {
    lgaExport();
   }
   else if(pressed == "run") //toggles boolean trigger that allows the program to run continously
   {
    runContinuously = !runContinuously; 
   } 
   else if(pressed == "clearAll") //clears all objects
   {
    ws.clearWalls();
    ps.clearParticles();
    rws.clearWalls();
    srcs.clearSources();

   }
   else if(pressed == "reverseParticles") //reverses all particle directions such that process is reversible 
   //**see notes in lgaArrayObjects file under reverseParticles function in the Particles Class
   {
     
    ps.reverseDirection(); 
   }
   else if(pressed == "rotateParticle") //changes the particle drawing direction
   {
     
   ps.changeDrawDirection(); 
   }
   else if(pressed == "rotateWall") //changes the wall drawing direction
   {
     
   ws.changeDrawDirection(); 
   } 
   else if(pressed == "rotateSource")//changes the source drawing direction
   {
     
   srcs.changeSourceDirection(); 
   }
    else if(pressed == "togRevSnk") //toggles between drawing REV walls and SNKs
   {
     rws.toggleType();   
   } 
   else if(pressed == "toggleGrid") //determines whether or not to draw background hexagonal lattice grid
   {
     this.gridOn = !this.gridOn;     
   }
   else if(pressed == "changeScale") //alternates between 40px and 20px grid sizes, additional options commented out below
   {
     //setting scale to 30 does not work on my machines, but may add additional options
     scale = scale/2;
     if(scale<20)
        scale = 40;  
     
     //3 size scale system, for good monitors
     scale = scale/2;
     if(scale<10)
       scale = 40;
        
   }
   else if(pressed == "runSpeedUp") //skip less frames when running continuously
   {
     this.runSpeed--; 
  if(runSpeed<1)
      runSpeed = 1;  
   }
   else if(pressed == "runSpeedDown") //skip more frames when running continuously
   {
     this.runSpeed++;    
   }
  
   else if(pressed.equals("ContSave"+continuousSave)) //toggles continuous save mode
   {
     continuousSave = !continuousSave;
     buttons.get(buttons.size()-4).bText = "ContSave"+continuousSave;
    println("ContSave"+continuousSave);
   }
   
     
     
   
  } 
  }
   
  

}
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
/*This file (lgaArrayObjects.pde) defines the following classes and associated functionality
Sources
RevWalls (includes sinks)
Walls (reflective walls)
Particles

and the primitives:
Particle (one particle): sets parameters and draws the particle
Wall (one wall): sets parameters and draws the wall
ArrayObject: inherited base class; could probably be removed if necessary; 
*/

//SOURCES//
/*
Emulates sources as they exist in the lga model. Direction changes increase particle/source direction by 60 degrees
at end of 360 degrees of rotating through source directions cycles to an omnidirectional source. directions are set to
-(source angle) so they can be distinguished from normal wall directions.
*/
class Sources 
{
 ArrayList<Wall> srcs = new ArrayList<Wall>();
 int srcdir = -360; //starting source direction
 Wall srcDraw = new Wall(0,1,srcdir); //drawing template source in top left corner
 Sources() 
{
 //no construction parameters
}
void addNew() //add new source at mouse coordinates
 {  
  float scale2 = scale/sin(PI/3);// defines difference between columns, based on trig of hexagonal lattice
  int y = round(mouseY/float(scale)); //scales y position of mouse to row position of lga objects
  int x = round(mouseX/scale2); //same for x/columns
   if(y%2!=0)
     {x = floor(mouseX/scale2);} //if y is an odd row then x is shifted over
     boolean alreadyExists = false; //flag to ensure a source does not exist at that location before creation
  for(int ii = 0; ii<srcs.size();ii++)
  {
    if(srcs.get(ii).xPos == x && srcs.get(ii).yPos == y)
    {
      alreadyExists = true; //source does exist
    }
  }
  if(!alreadyExists) //only create if one doesn't exist already
  {
  srcs.add(new Wall(x,y,srcdir));
  }
   
 }
 void clearSources() //clears all src objects from srs arrayList
 {
  srcs.clear(); 
 }
 void drawSources() //draws all the sources. drawWall() changes the drawing format based on the direction,
// since directions are negative, they will draw differently than the reflective walls
 {
    for(int ii = 0; ii<srcs.size();ii++)
 {
  srcs.get(ii).drawWall();
  
 }
 srcDraw.drawWall(); //draw the template src in the top left corner
 }
  void changeSourceDirection() //cycle through source directions
 { //-360, -60,-120, -180, -240, - 300, -3, -360
  if(srcdir==-360)
  {
   srcdir = -60;
  }
  else if(srcdir == -300)
  {
   srcdir = -3; 
  }
  else if(srcdir == -3)
  {srcdir=-360;
  }
  else{
   srcdir-=60; 
  }
   
    srcDraw.dir = srcdir; //update drawing template to be the same as the current src direction

 }
 void eraseAtMouse() //similar to adding, calculates mouse position in row/column coordinates and removes the src at that spot
 {
    float scale2 = scale/sin(PI/3);//
   int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
  for(int ii = 0; ii<srcs.size();ii++)
 {
   
   if(srcs.get(ii).xPos == x && srcs.get(ii).yPos == y)
   {
    srcs.remove(ii);
    break;
   }
 }
 }
 void removeLast() //remove the last added source
 {
   if(srcs.size()>0)
  srcs.remove(srcs.size()-1); 
   
 }
 void handleSources() //generates particles based on the source direction
 {
  for(int ii = 0; ii<srcs.size(); ii++)
 { 
   if(srcs.get(ii).dir == -3) //omnidirectional source, adds sources in all directions
   {
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,0));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,60));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,120));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,180));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,240));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,300));

   }
   else{
   int pdir = -srcs.get(ii).dir; //change src dir into par dir
   if(pdir==360)
     pdir = 0;
  ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,pdir)); //add particles
   }
 } 
 }
  
}


//REVWALLS and SINKS//
/*
this class is very similar to the src class. adding, removing, and drawing functionality is the same, 
differences are described when present
*/
class revWalls //and snks
{
 ArrayList<Wall> rwalls = new ArrayList<Wall>();
 int type = -1; //-1 for reversing wall and -2 for Sink
 Wall drawingrWall = new Wall(0,.2,type); //drawing template

 revWalls()
{
 
}
void addWallLine10x() //creates a line of 10 rev walls from mouse position going down
{
  float scale2 = scale/sin(PI/3);//
  int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
   if(y%2!=0)
     {x = floor(mouseX/scale2);}
  for(int jj = x; jj<x+10;jj++) //loop defining changes in x position
  {
         boolean alreadyExists = false;
  for(int ii = 0; ii<rwalls.size();ii++)
  {
  if(rwalls.get(ii).xPos == jj && rwalls.get(ii).yPos == y)
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
  rwalls.add(new Wall(jj,y,-1));
  }
    
  }
}
void addWallLine10y() //creates a line of 10 rev walls from mouse position going right
{
  float scale2 = scale/sin(PI/3);//
  int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
   if(y%2!=0)
     {x = floor(mouseX/scale2);}
  for(int jj = y; jj<y+10;jj++) //loop defining changes in y position
  {
         boolean alreadyExists = false;
  for(int ii = 0; ii<rwalls.size();ii++)
  {
  if(rwalls.get(ii).xPos == x && rwalls.get(ii).yPos == jj)
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
  rwalls.add(new Wall(x,jj,-1));
  }
    
  }
}
void addNew()
 {  
  float scale2 = scale/sin(PI/3);//
  int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
   if(y%2!=0)
     {x = floor(mouseX/scale2);}
     boolean alreadyExists = false;
  for(int ii = 0; ii<rwalls.size();ii++)
  {
    if(rwalls.get(ii).xPos == x && rwalls.get(ii).yPos == y)
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
  rwalls.add(new Wall(x,y,type));
  }
   
 }
 void clearWalls()
 {
  rwalls.clear(); 
 }
 void drawWalls()
 {
    for(int ii = 0; ii<rwalls.size();ii++)
 {
  rwalls.get(ii).drawWall();
  
 }
 drawingrWall.drawWall();
 }
 
 void eraseAtMouse()
 {
    float scale2 = scale/sin(PI/3);//
   int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
  for(int ii = 0; ii<rwalls.size();ii++)
 {
   
   if(rwalls.get(ii).xPos == x && rwalls.get(ii).yPos == y)
   {
    rwalls.remove(ii);
    break;
   }
 }
 }
 void removeLast()
 {
   if(rwalls.size()>0)
  rwalls.remove(rwalls.size()-1); 
   
 }
 void toggleType() 
 {
   if(type == -1) //-1 = rev
   {
    type = -2; //-2 = snk
   }
   else
    type = -1;
   
   drawingrWall.dir = type; //update template
 }
 
}
  
//WALLS//
//Reflecting walls class. add,erase,clear etc are same as in code for sources. differences described below
class Walls 
{
 ArrayList<Wall> walls = new ArrayList<Wall>();
 int drawDirectionW = 0; //0 = EEEE, 30 = EENE, 60 = NENE, etc
 Wall drawingWall = new Wall(0,1,drawDirectionW);

 Walls()
{
 
} 
void addNew()
 {  
  float scale2 = scale/sin(PI/3);//
  int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
   if(y%2!=0)
     {x = floor(mouseX/scale2);}
     boolean alreadyExists = false;
  for(int ii = 0; ii<walls.size();ii++)
  {
    if(walls.get(ii).xPos == x && walls.get(ii).yPos == y )
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
  walls.add(new Wall(x,y,drawDirectionW));
  }
   
 }
 void clearWalls()
 {
  walls.clear(); 
 }
 void drawWalls()
 {
    for(int ii = 0; ii<walls.size();ii++)
 {
  walls.get(ii).drawWall();
  
 }
 }
 void drawDrawingParameters()
 {
  noFill();
  stroke(0,255,0);
  strokeWeight(4);
  rect(0,0,scale,scale*2);
  drawingWall.drawWall(); 
 }
   void changeDrawDirection()
 {
  drawDirectionW+=30;
  if(drawDirectionW>=180)
  {
   drawDirectionW-=180;
  } 
    drawingWall.dir = drawDirectionW;

 }
 void eraseAtMouse()
 {
    float scale2 = scale/sin(PI/3);//
   int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
  for(int ii = 0; ii<walls.size();ii++)
 {
   
   if(walls.get(ii).xPos == x && walls.get(ii).yPos == y)
   {
    walls.remove(ii);
    break;
   }
 }
 }
 void removeLast()
 {
   if(walls.size()>0)
  walls.remove(walls.size()-1); 
   
 }
 
}

//WALL//
/*
Base class for source, revWall, and refl wall based classes(above); 
parameter class that also handles the draw visualization
*/
class Wall extends arrayObject
{
  int dir = 0; //wall direction(angle in degrees) 0 = EEEE, 30 = EENE
  int drawColor = color(0,0,255); //blue revwalls and refl walls
  int drawColor2 = color(255,40,40); //redish snks
  int drawColor3 = color(0,255,0); //green sources
  Wall(float x, float y, int a)
  {
    xPos = x;
    yPos = y;
    type = "wall";
    dir = a;
  }
  void drawWall()
  {
    stroke(drawColor);
    strokeWeight(4);
    //translate x and y positions to pixel space for line drawing
    float scale2 = scale/sin(PI/3);//length of lattice lines
   float startX = xPos*scale2;
   if(yPos%2!=0)
       startX+=scale2/2;
   float startY = yPos*scale2*sin(PI/3);
    
    if(dir == -1) //reversing walls
  {
    pushMatrix();
   translate(startX,startY);
   rectMode(CENTER); //draws rectangles from center
   rect(0,0,scale/5,scale/5);
   popMatrix();
   rectMode(CORNER); //draws them from top left corner, reinitialized here as default for other code
  }
  else if(dir == -2) //Sinks
  {
   stroke(drawColor2);
   pushMatrix();
   translate(startX,startY);
   rectMode(CENTER);
   rect(0,0,scale/5,scale/5);
   popMatrix();
   rectMode(CORNER);
  }
  else if(dir == -3) //omnidirectional source
  {
   stroke(drawColor3);
   pushMatrix();
   translate(startX,startY);
   rectMode(CENTER);
   rect(0,0,scale/5,scale/5);
   popMatrix();
   rectMode(CORNER);
  }
  else if(dir <=-60) //regular sources
  {
   stroke(drawColor3);
   pushMatrix();
   translate(startX,startY);
   rotate(radians(dir));
   line(0,0,scale/5,0);
   strokeWeight(1);
   line(scale/3, 0, scale/5 - scale/9, -scale/7);
   line(scale/3, 0, scale/5 - scale/9, scale/7);
   popMatrix();;
  }
  else{ //reflective walls 
    
   pushMatrix();
   translate(startX,startY);
   rotate(radians(-dir));
   line(-scale/4,0,scale/4,0);
   popMatrix();
  }
  }
  
  
}

//PARTICLES//
/*
Most complex class. Lots of functionality was dumped here for simplicity. 
Includes code for reversing particle directions, detecting collisions with walls and other particles
as well as the basic drawing, removing, and moving particles
*/

class Particles
{
 ArrayList<Particle> pars = new ArrayList<Particle>();
 int drawDirection = 0; //initial draw direction 0 = EE, 60 = NE, 120 = NW, etc
 Particle drawingTemplate = new Particle(0,1,drawDirection);
 int time = 0; //number for times particles have moved
 int timeStep = 1; //direction counter, 1 for forward becomes -1 when particle direction is reversed
 int[][] par2Collisions; //2d array for holding the state of the two particle collisions at each point in lga space
 Particles()
 {    
 }
 void setup2parMatrix() //creates the 2d collision state array. places a 1 at each point in array, # scheme explained later
 {
   float scale2 = scale/sin(PI/3);
   int col = ceil(3*width/scale);
   int row = ceil(3*height/scale2);
   par2Collisions = new int[col][row];
     for(int ii = 0; ii < col; ii ++)
     {
      for(int jj = 0; jj <row; jj++)
     {
      par2Collisions[ii][jj]=1;
     } 
     }
 }
 void clearParticles()
 {
  pars.clear(); 
  time = 0; //reset time step
  timeStep = 1; //reset timestep direction if it had been reversed
  setup2parMatrix(); //reinitialize the 2d collision state array
 }
 void drawDrawingParameters()
 {
  drawingTemplate.drawParticle(); 
 }
 
 void changeDrawDirection() //cycle through particle directions
 {
  drawDirection+=60;
  if(drawDirection>=360)
  {
   drawDirection-=360;
  } 
    drawingTemplate.dir = drawDirection;

 }
 
 void addNew() //same as in sources, but allows for more than one particle at a location if the directions are different
 {
  //add check to make sure particle does not exist at that location in the same orientation
  
  float scale2 = scale/sin(PI/3);//
  int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
   if(y%2!=0)
     {x = floor(mouseX/scale2);}
  
  boolean alreadyExists = false;
  for(int ii = 0; ii<pars.size();ii++)
  {
    if(pars.get(ii).xPos == x && pars.get(ii).yPos == y && pars.get(ii).dir == drawDirection)
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
  pars.add(new Particle(x,y,drawDirection));
  }
   
 }
 void addParLine10x() //adds a line of random direction particles at mouse going to the right
{
  float scale2 = scale/sin(PI/3);//
  int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
   if(y%2!=0)
     {x = floor(mouseX/scale2);}
  for(int jj = x; jj<x+10;jj++)
  {
         boolean alreadyExists = false;
  for(int ii = 0; ii<pars.size();ii++)
  {
  if(pars.get(ii).xPos == jj && pars.get(ii).yPos == y)
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
    int newdirs = 60*(int)random(0,7);
  pars.add(new Particle(jj,y,newdirs));
  }
    
  }
}
void addParLine10y()  //adds a line of random direction particles at mouse going down
{
  float scale2 = scale/sin(PI/3);//
  int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
   if(y%2!=0)
     {x = floor(mouseX/scale2);}
  for(int jj = y; jj<y+10;jj++)
  {
         boolean alreadyExists = false;
  for(int ii = 0; ii<pars.size();ii++)
  {
  if(pars.get(ii).xPos == x && pars.get(ii).yPos == jj)
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
   int newdirs = 60*(int)random(0,7);
  pars.add(new Particle(x,jj,newdirs));
  }
    
  }
}
 void eraseAtMouse()
 {
    float scale2 = scale/sin(PI/3);//
   int y = round(mouseY/float(scale));
  int x = round(mouseX/scale2); 
  for(int ii = 0; ii<pars.size();ii++)
 {
   
   if(pars.get(ii).xPos == x && pars.get(ii).yPos == y)
   {
    pars.remove(ii);
    break;
   }
 }
 }
 void removeLast()
 {
   if(pars.size()>0)
  pars.remove(pars.size()-1); 
   
 }
 
 void updateParticles() //main particle function call, moves each particle, checks if there was a collision, draws all particles
 //creates new particles from the sources, and increments the time counter
 {
  for(int ii = 0; ii<pars.size();ii++)
 {
  pars.get(ii).moveParticle();
  
  
 }
 this.checkCollisions();
 this.drawParticles();
 srcs.handleSources();
 time+=timeStep;
 } 
 void drawParticles()
 {
    for(int ii = 0; ii<pars.size();ii++)
 {
  pars.get(ii).drawParticle();
  
 }
 }
 
 //the reverse direction function reverses all particle directions in order to make the system "reversible"
 //in some cases, the particle directions are flipped ie + 180 degrees.
 //if the there was previously a collision with a wall this functionality changes by either not reversing the particle
 //as in the case for a 180 degree collision with a refl wall or a collision with a rev wall, 
 //or the reversed refl wall collision rule is called to put the particle back on track.
 //Similarly, if there was a 3 particle collision the particles are not reversed(since they are already back on the original track
 //In the 2 particle collision case both the particles and the 2d collision array are modified to make the system fully reversible
 //It is important to note that sources and sinks are not generally reversible objects. Warnings are raised to remind the 
 //user of this, and particles that exist at a source are not reversed. Particles that came from a source are still reversed
 //since it would be difficult to track which particles have/have not had some sort of collision/effect on the whole system
 void reverseDirection() 
 {
   
   if(srcs.srcs.size()>0) //if sources exist
   {
    println("WARNING: srcs are not generally reversible"); 
   }
   if(rws.rwalls.size()>0) //Sinks might exists, so throw warning anyway
   {
    println("REMINDER: if you are using snks, this processing is irreversible"); 
   }
   
 
   timeStep = -timeStep; //change the way time is incremented
   int[] change = {}; //set up an array that tells how to change each particle. 
   //if they are changed immediately it can have an effect on determining how to change the other particles
   //the next two lines set up arrays that track where the two particle collisions occurred. This makes sure the 
   //matrix is only updated once per site.
   int[] par2xchange = {};
   int[] par2ychange = {};
  for(int ii = 0; ii< pars.size(); ii++)
 {
   change = append(change,1);//add a new element to the array for each particle
   boolean hitWall = false; //if there is a wall collision then certain calculations are skipped
   int collisionCount3 = 0; //used to determine if there is a 3 particle collision
   int collisionCount2 = 0; //used to determine if there is a 2 particle collision

//this loop goes through all the reflective walls and determines if there was a reflective collision, if there was
//then change the direction based on the wall rule table (in ruleTables.pde)
   for(int jj = 0; jj<ws.walls.size();jj++) 
   {
    if(pars.get(ii).xPos == ws.walls.get(jj).xPos && pars.get(ii).yPos == ws.walls.get(jj).yPos && (pars.get(ii).dir-ws.walls.get(jj).dir)%180 != 0)
   {
    hitWall = true; //set flag so don't bother looking at particle collisions
    int revpardir = pars.get(ii).dir+180; //if the particle was going the other direction what would the resulting collision be
    if(revpardir>=360)
      {
       revpardir -=360; 
      }
    pars.get(ii).dir = wallTable(ws.walls.get(jj).dir,revpardir); //lookup new direction

   } 
   }
   for(int jj = 0; jj<rws.rwalls.size();jj++) //no need to reverse rev wall particles, set hitwall = true
   {
    if(pars.get(ii).xPos == rws.rwalls.get(jj).xPos && pars.get(ii).yPos == rws.rwalls.get(jj).yPos)
   {
    hitWall = true;
   } 
   }
   for(int jj = 0; jj<srcs.srcs.size();jj++) //also do not change sources
   {
    if(pars.get(ii).xPos == srcs.srcs.get(jj).xPos && pars.get(ii).yPos == srcs.srcs.get(jj).yPos)
   {
    hitWall = true;
   } 
   }
   
   //the next sections go through determining whether there was a 2 or 3 particle collision at that site
   //first counts the numbers of particles at the site and if the number is three then determines whether
   //or not they are at the correct angles from each other. does the same for 2particle collisions
    int pcount = 0; //number of particles that are also at the same site as this particle
   int[] jjarray = {}; //tracks the index of the other particles at that site for angle comparisons
   for(int jj = 0; jj<pars.size();jj++) //go through all particles to compare to this particle
   {
     if(pars.get(ii).xPos == pars.get(jj).xPos && pars.get(ii).yPos == pars.get(jj).yPos) //if same location
    {
     pcount++; 
     jjarray = append(jjarray,jj);
    }
   }
   if(pcount == 3) //if there are 3 particles
   {
     for(int jj = 0; jj <jjarray.length; jj++)
     {
     if(abs(pars.get(ii).dir - pars.get(jjarray[jj]).dir) % 120 == 0) //and those 3 particles are 120 degrees from each other
      {
        collisionCount3++; //increment this counter (should get to 3, ie 3 particles total at this spot)
      }
     }
   }
    if(pcount == 2) //same for 2 particles
   {
     for(int jj = 0; jj <jjarray.length; jj++)
     {
     if(abs(pars.get(ii).dir - pars.get(jjarray[jj]).dir) % 180 == 0)
      {
        collisionCount2++;
      }
     }
   }
   if(hitWall || collisionCount3==3)
   {
     change[ii] = 0; //if three particle collision or it hit a wall, do not change the particle direction
   }
   else if(collisionCount2 == 2)
   {
     change[ii] = 2; //if there is a 2 particle collision, then it will need to be changed, code = 2 for later

     par2xchange = append(par2xchange,(int)pars.get(ii).xPos); //add this x and y positions for later
     par2ychange = append(par2ychange,(int)pars.get(ii).yPos);  

   }
 }
  for(int ii = 0;ii<pars.size();ii++) //go through all particles and update them based on the changes above
  {
   if(change[ii]==1) //default change for particles that did not hit a wall or another particle
      {
       pars.get(ii).dir +=180;
       }
    else if(change[ii] == 2) //2 particle collision change
    {
     switch(par2Collisions[(int)pars.get(ii).xPos][(int)pars.get(ii).yPos]) //change particle direction based on 2d collision array
     {
      case 1:
       pars.get(ii).dir+=120;
      break;
      case 2:
      pars.get(ii).dir+=120;
      break; 
       case 3:
      pars.get(ii).dir-=120;
      break;
       case 4:
      pars.get(ii).dir-=120;
      break;
     }
    
    }
   if(pars.get(ii).dir>=360)
      {
       pars.get(ii).dir -=360; 
      }
      else if(pars.get(ii).dir<0)
      {
       pars.get(ii).dir +=360; 
      }
    pars.get(ii).newdir = pars.get(ii).dir; //set newdir same so it isn't changed later
  } 
  
  //super messy way to ensure the 2 particle collision table is changed and the 
  //collisions are reversible
  boolean[] changepar2 = new boolean[par2xchange.length]; //flag set for whether or not to change 2d array at x,y position
  for(int ii = 0; ii<par2xchange.length;ii++)
  {
   changepar2[ii] = true; //initalize all to true;
  }
  for(int ii = 0; ii<par2xchange.length;ii++)
  {
   for(int jj = ii+1; jj<par2xchange.length;jj++)
    {
     if(par2xchange[ii] == par2xchange[jj] && par2ychange[ii] == par2ychange[jj])
     {
      changepar2[jj] = false; //if there is a duplicate position, then set it to false so it isn't changed
     }
     
    } 
  }
  for(int ii = 0; ii<changepar2.length;ii++)
  {
   if(changepar2[ii]) //if this is not the duplicate then change the collision state
  {
   par2Collisions[par2xchange[ii]][par2ychange[ii]]-=2;
   if(par2Collisions[par2xchange[ii]][par2ychange[ii]]<1)
   {
    par2Collisions[par2xchange[ii]][par2ychange[ii]] = 3; 
   }
  } 
  }
  //end 2particle collision matrix update
 
 }
 
//this function (checkCollisions()) goes through all the particles and determines if it hit something
//based on what it hit, this function will update the particle's direction value
 
 void checkCollisions() 
 {
    for(int ii = 0; ii<pars.size();ii++) 
 {
   boolean hitWall = false;
   for(int kk = 0; kk<ws.walls.size();kk++) //go through all the reflective walls and change based on rule table
   {
     if(pars.get(ii).xPos == ws.walls.get(kk).xPos && pars.get(ii).yPos == ws.walls.get(kk).yPos)
     {
      hitWall = true;
      pars.get(ii).newdir = wallTable(ws.walls.get(kk).dir,pars.get(ii).dir);
    
     }
   }
   for(int kk = 0; kk<rws.rwalls.size();kk++) //go through all the rev walls and sinks and change
   {
     
     if(pars.get(ii).xPos == rws.rwalls.get(kk).xPos && pars.get(ii).yPos == rws.rwalls.get(kk).yPos)
     {
      hitWall = true;   
     if(rws.rwalls.get(kk).dir == -1) //if it is a rev wall, then reverse direction
     {
     pars.get(ii).newdir = pars.get(ii).dir+180;
     if(pars.get(ii).newdir>=360)
     {
      pars.get(ii).newdir-=360; 
     }
     }
     else if(rws.rwalls.get(kk).dir == -2) //if it is a sink, set the newdir to -1 so it can be erased later;
     //not erased now since it would change the indexes of the particles left in the loop
     {
      pars.get(ii).newdir=-1; 
     }
     }
   }
   for(int kk = 0; kk<srcs.srcs.size();kk++) //go through sources. 
   //similar to sinks since particles cannot exist at sinks unless they are in the src direction
   {
     
     if(pars.get(ii).xPos == srcs.srcs.get(kk).xPos && pars.get(ii).yPos == srcs.srcs.get(kk).yPos)
     {
      hitWall = true;
      pars.get(ii).newdir=-1; 
     }
   }
   //the next few lines handle the particle collisions
   //particles at each site are counted and the angles are checked in a similar way to the reverse particle function above
   int collisionCount3 = 0; 
   int collisionCount2 = 0;
if(!hitWall)
{
  int pcount = 0;
  int[] jjarray = {};
   for(int jj = 0; jj<pars.size();jj++)
   {
     if(pars.get(ii).xPos == pars.get(jj).xPos && pars.get(ii).yPos == pars.get(jj).yPos)
    {
     pcount++; 
     jjarray = append(jjarray,jj);
    }
   }
   if(pcount == 3)
   {
     for(int jj = 0; jj <jjarray.length; jj++)
     {
     if(abs(pars.get(ii).dir - pars.get(jjarray[jj]).dir) % 120 == 0)
      {
        collisionCount3++;
        //println("cc3:"+collisionCount3);
      }
     }
   }
   if(pcount == 2)
   { 
      for(int jj = 0; jj <jjarray.length; jj++)
     {
     if(abs(pars.get(ii).dir - pars.get(jjarray[jj]).dir)%180 == 0)
      {
        collisionCount2++;
        //println("cc2:"+collisionCount2);
      }
     }
   }

   if(collisionCount3 == 3) //3 particle collision
   {
    pars.get(ii).newdir = pars.get(ii).dir+180;  //reverse particles
    if(pars.get(ii).newdir >=360)
    {
     pars.get(ii).newdir -= 360; 
    }
    //println("3 Particle Collision at" + pars.get(ii).xPos + "," +pars.get(ii).yPos );
   }
   
   //the two particle collision set is a bit different, the particle directions are updated but the 2d collision array
   //is also updated. since there will be two particles colliding at each 2 particle collision site, the value of the 
   //2d collision array ranges from 1-4, with 1,2 being the first collision(2 particles hitting) and 3,4 being the 
   //second collision. 
   if(collisionCount2 == 2)
   {
     int xindex = (int)pars.get(ii).xPos;
     int yindex = (int)pars.get(ii).yPos;
     switch(par2Collisions[xindex][yindex]){
      case(1):
           pars.get(ii).newdir = pars.get(ii).dir + 120;
           par2Collisions[xindex][yindex]++;
           break; 
           case(2):
           pars.get(ii).newdir = pars.get(ii).dir + 120;
           par2Collisions[xindex][yindex]++;
           break; 
           case(3):
           pars.get(ii).newdir = pars.get(ii).dir - 120;
           par2Collisions[xindex][yindex]++;
           break; 
           case(4):
           pars.get(ii).newdir = pars.get(ii).dir - 120;
           par2Collisions[xindex][yindex] = 1;
           break; 
     }
   
     if(pars.get(ii).newdir >=360)
    {
     pars.get(ii).newdir -= 360; 
    }
    else if(pars.get(ii).newdir<0)
    {
      pars.get(ii).newdir += 360;
    }
    //println("2 Particle Collision at" + pars.get(ii).xPos + "," +pars.get(ii).yPos );
   }
}
 }
 //go through all of the particles(newest to oldest) and determine if they need to be removed or the directions have changed
 for(int ii = pars.size()-1; ii>=0;ii--)
 {
   if(pars.get(ii).newdir == -1)
   {
    pars.remove(ii); 
   }
  else if(pars.get(ii).newdir!=pars.get(ii).dir)
    {
     pars.get(ii).dir = pars.get(ii).newdir; 
    }
    
 } 
 }
}
 
  
 //this is the base particle class which defines the functions for drawing and moving the particles 


class Particle extends arrayObject
{
  int dir = 0; //particle direction(angle in degrees) 0 = EE, 60 = NE
  int newdir; //used for collisions and reversing functions in Particles() class
  int drawColor = color(255,0,0); //red
  Particle(int x, int y, int a)
  {
    xPos = x;
    yPos = y;
    type = "particle";
    dir = a;
    newdir = dir;
  }
   Particle(int x, int y, int a, int c) //not used
  {
    xPos = x;
    yPos = y;
    type = "particle";
    dir = a;
    newdir = dir;
    drawColor = c;
  }
  
  void updateParticle()
  {
    
    drawParticle();
    moveParticle();
   
  }
  //this function updates the particle position based on its current direction
  //not the difference between the rule tables for the even rows and the odd rows
  void moveParticle()
  {
    //even
    if(this.yPos%2 == 0)
    {
     switch(dir)
    {
     case 0:
       xPos++;
       break;
     case 60:
       yPos--;
       break;
     case 120:
       xPos--;
       yPos--;
       break;
     case 180:
       xPos--;
       break;  
     case 240:
       xPos--;
       yPos++;
       break;
     case 300:
       yPos++;
       break;    
    }       
    }
    else
    {
         switch(dir)
    {
     case 0:
       xPos++;
       break;
     case 60:
       xPos++;
       yPos--;
       break;
     case 120:
       yPos--;
       break;
     case 180:
       xPos--;
       break;  
     case 240:
       yPos++;
       break;
     case 300:
       yPos++;
       xPos++;
       break;     
    }     
    }
  }
  
  void drawParticle()
  {
    stroke(drawColor);
    strokeWeight(4);
    float scale2 = scale/sin(PI/3);//length of lattice lines
   float startX = xPos*scale2;
   if(yPos%2!=0)
       startX+=scale2/2;
   float startY = yPos*scale2*sin(PI/3);

   pushMatrix();
   translate(startX,startY);
   rotate(radians(-dir));
   line(0,0,scale/3,0);
   strokeWeight(2);
   line(scale/3, 0, scale/3 - scale/7, -scale/5);
  line(scale/3, 0, scale/3 - scale/7, scale/5);
   popMatrix();
  }
  
  
}

//base of the base classes, was one of the first items added to ensure that the particles and walls are handled the same
//could likely be implemented directly in the particle and wall classes if wanted
class arrayObject
{
  float xPos;
  float yPos;
  String type;
  
  arrayObject()
  {
    xPos = 0;
    yPos =0;
    type = "";
  }
  
  arrayObject(float x, float y, String t)
  {
    xPos = x;
    yPos = y;
    type = t;
    
  }
  
  
}
//this file(ruleTables.pde) defines the rules behind refl wall collisions

 int wallTable(int wd,int pd)
 {
  switch(wd){
   case 0:
      switch(pd){
       case 240:
          return 120; 
       case 300:
          return 60;
       case 60:
          return 300;
       case 120:
          return 240;
         case 0:
            return 0;
         case 180:
            return 180; 
      } 
    case 30:
       switch(pd){
         case 0:
          return 60; 
       case 240:
          return 180;
       case 180:
          return 240;
       case 60:
          return 0; 
       case 300:
          return 120;
       case 120:
          return 300; 
         
       }
   case 60:
      switch(pd){
       case 300:
          return 180; 
       case 120:
          return 0;
       case 0:
          return 120;
       case 180:
          return 300; 
       case 60:
           return 60;
       case 240:
            return 240;
      }
    case 90:
       switch(pd){
         case 300:
          return 240; 
       case 60:
          return 120;
       case 120:
          return 60;
       case 240:
          return 300; 
       case 0:
          return 180;
       case 180:
          return 0;
          
        
         
       }
     case 120:
      switch(pd){
       case 0:
          return 240; 
       case 60:
          return 180;
       case 180:
          return 60;
       case 240:
          return 0;
       case 120:
          return 120;
       case 300:
           return 300;
       
      }
    case 150:
       switch(pd){
         case 0:
          return 300; 
       case 120:
          return 180;
       case 180:
          return 120;
       case 300:
          return 0; 
       case 240:
          return 60;
       case 60:
          return 240; 
         
       }
   
  } 
   return -1;
 }
 

//this file(savingANDloading.pde) saves, loads, and exports the lga objects based on their global variables

void saveAll()
{
  gettingString = false;   //if forgot to hit enter when changing file name
  String fName = "files/"+workingFile; //set file name
  String[] gateSet = {}; //initialize array of strings to save to file
  //objects are coded based on their type for loading purposes:
  // wall = W; particle = P; revWall/Snk = rW; source = sR;
  //adding walls to gateSet{}, one String object per wall
  for(int ii = 0; ii < ws.walls.size(); ii++)
  {
    Wall wall = ws.walls.get(ii);
   String thisWall = "W," + wall.xPos + "," + wall.yPos + "," + wall.dir; 
  gateSet = append(gateSet,thisWall);
  }
  //adding particles to gateSet{}, one String object per particle
  for(int ii = 0; ii<ps.pars.size(); ii ++)
  {
   Particle par = ps.pars.get(ii);
  String thisPar = "P," + par.xPos + "," + par.yPos + "," + par.dir; 
    gateSet = append(gateSet,thisPar);
  }
 //adding rev walls and snks to gateSet{}, one String object per revwall/snk
  for(int ii = 0; ii<rws.rwalls.size(); ii ++)
  {
   Wall wall = rws.rwalls.get(ii);
  String thisWall = "rW," + wall.xPos + "," + wall.yPos + "," + wall.dir; 
  gateSet = append(gateSet,thisWall);
  } 
  //adding sources to gateSet{}, one String object per source
  for(int ii = 0; ii<srcs.srcs.size(); ii ++)
  {
   Wall wall = srcs.srcs.get(ii);
  String thisWall = "sR," + wall.xPos + "," + wall.yPos + "," + wall.dir; 
  gateSet = append(gateSet,thisWall);
  }
  println("saving...");
  saveStrings(fName,gateSet); //saves string array gateSet{} to the designated filename
  println("saved");
}


void loadFile()
{
  
  gettingString = false; //if forgot to hit enter when changing file name
  //clear old data
  ws.walls.clear();
  ps.pars.clear();
  rws.rwalls.clear();
  String fName = "files/"+workingFile; //define file name to load from

  //try to load the file; if the file cannot be loaded raise exception to console
  try{
  String[] gateSet = loadStrings(fName);
  //itterate over the string array gateSet and for each line parse out the values
  for(int ii = 0; ii<gateSet.length; ii++)
  {
   String[] thisGate = split(gateSet[ii], ","); //split the line based on comma values, creating a new array of values
   int x = (int)Double.parseDouble(thisGate[1]); // get the x value from the first parsing
   int y = (int)Double.parseDouble(thisGate[2]); // same for y
   int d = Integer.parseInt(thisGate[3]); //same for the direction
   if(thisGate[0].equals("W")) //determines that loading a wall
  {
   ws.walls.add(new Wall(x,y,d)); //create the wall
   println("Loaded wall at: " + x + "," + y + " @" + d + "degrees");
  }
  else if(thisGate[0].equals("rW")) 
  {
   rws.rwalls.add(new Wall(x,y,d));
   println("Loaded rwall at: " + x + "," + y + " @" + d + "degrees");
  }
   else if(thisGate[0].equals("sR"))
  {
   srcs.srcs.add(new Wall(x,y,d));
   println("Loaded source at: " + x + "," + y + " @" + d + "degrees");
  }
 else if(thisGate[0].equals("P"))
  {
      ps.pars.add(new Particle(x,y,d));
      println("Loaded particle at: " + x + "," + y + " @" + d + "degrees");

   
  } 
  }
  }
  catch(Exception e) // exception if cannot load the file
  {
   println("cannot find file" + e); 
  }
  
  
}

void lgaExport() 
{
  gettingString = false;   //if forgot to hit enter when changing file name

  //find top left most point so that r1 and c1 are set appropriately for the lga simulator
  float xS = 1000;
  float yS = 1000;
  for(int ii = 0; ii <ws.walls.size();ii++)
  {
    if(ws.walls.get(ii).yPos<=yS)
    {
      yS = ws.walls.get(ii).yPos;
      
    }
    if(ws.walls.get(ii).xPos<=xS)
      {
       xS = ws.walls.get(ii).xPos; 
      }
      
  }
   for(int ii = 0; ii <rws.rwalls.size();ii++)
  {
    if(rws.rwalls.get(ii).yPos<=yS)
    {
      yS = rws.rwalls.get(ii).yPos;
      
    }
    if(rws.rwalls.get(ii).xPos<=xS)
      {
       xS = rws.rwalls.get(ii).xPos; 
      }
      
  } 
  for(int ii = 0; ii <srcs.srcs.size();ii++)
  {
    if(srcs.srcs.get(ii).yPos<=yS)
    {
      yS = srcs.srcs.get(ii).yPos;
      
    }
    if(srcs.srcs.get(ii).xPos<=xS)
      {
       xS = srcs.srcs.get(ii).xPos; 
      }
     
      
  } 
  for(int ii = 0; ii <ps.pars.size();ii++)
  {
    if(ps.pars.get(ii).yPos<=yS)
    {
      yS = ps.pars.get(ii).yPos;
      
    }
    if(ps.pars.get(ii).xPos<=xS)
      {
       xS = ps.pars.get(ii).xPos; 
      }
      
  }
  //end the finding of top left points
  //set the file name, split it around the file extension and add the _exp flag to differentiate it from the load file
  String fname = "files/"+workingFile;
  String[] fName = split(fname,'.');
  String expName = fName[0] + "_exp." + fName[1]; 
  //creates string arrays similar to save file function
  String[] gateSet = {};
  int srcCounter = 0; //used to determine if there are more that one src directions which will cause an error in lga
  gateSet = append(gateSet,"r1 = 1"); //add the start points for the lga
  gateSet = append(gateSet,"c1 = 1");
  
  //determines the SRCV direction based on existing sources.
  for(int ii = 0; ii<srcs.srcs.size();ii++)
  {
  int pdir = -srcs.srcs.get(ii).dir;
   if(pdir!=360 && pdir !=3){
    String srcSet = "self.lga.SRCVPARTICLES = " + checkDir(pdir,1);
    if(!gateSet[gateSet.length-1].equals(srcSet))
    {
      gateSet = append(gateSet,srcSet);
      srcCounter++;
    }} 
  }
  //if there is more than one SRCV direction (excluding EE(which is SRC by default) and SRCA(omnidirectional source))
  // then raise a warning and put that warning in the exported file as a reminder that the lga code will not work
  if(srcCounter>1)
  {
      String warning = "WARNING: LGA does not currently support MULTI directional sources";
      println(warning);
      gateSet = append(gateSet,warning);
  }
  
  //adding walls to string, one String object per lga object, same as saveAll function
  float[] xSet = {};
  float[] ySet = {};
  String[] dirSet = {};
  int[] keep = {}; //used in the combination of strings so the format self.lga.drawPoint(x,y,bit1+bit2+bit3) can be followed
  for(int ii = 0; ii < ws.walls.size(); ii++)
  {
    Wall wall = ws.walls.get(ii);
    xSet = append(xSet,wall.xPos);
    ySet = append(ySet,wall.yPos);
    //checkDir(wall.dir,flag) defined below, converts a dir to the appropriate string ie a 0 wall = EEEE
    String thisDir = (checkDir(wall.dir,0)); 
    dirSet = append(dirSet,thisDir);
    keep = append(keep,1);
  }
  for(int ii = 0; ii < rws.rwalls.size(); ii++)
  {
    Wall wall = rws.rwalls.get(ii);
    xSet = append(xSet,wall.xPos);
    ySet = append(ySet,wall.yPos);
    String thisDir = (checkDir(wall.dir,0));
    dirSet = append(dirSet,thisDir);
    keep = append(keep,1);
  }
  for(int ii = 0; ii < srcs.srcs.size(); ii++)
  {
    Wall wall = srcs.srcs.get(ii);
    xSet = append(xSet,wall.xPos);
    ySet = append(ySet,wall.yPos);
    String thisDir = (checkDir(wall.dir,0));
    dirSet = append(dirSet,thisDir);
    keep = append(keep,1);
  }
  for(int ii = 0; ii<ps.pars.size(); ii ++)
  {
   Particle par = ps.pars.get(ii);
   xSet = append(xSet,par.xPos);
    ySet = append(ySet,par.yPos);
    String thisDir = (checkDir(par.dir,1));
    dirSet = append(dirSet,thisDir);
    keep = append(keep,1);
  }
  //go through and combine strings of objects that are at the same x,y positions
  for(int ii = 0; ii<xSet.length;ii++)
  {
    if(ii!=xSet.length-1)
    {
    for(int jj = ii+1; jj<xSet.length;jj++)
    {
     if(xSet[ii] == xSet[jj] && ySet[ii] == ySet[jj] && keep[jj]==1)
     {
      dirSet[ii] += " + " + dirSet[jj]; //combine string objects
      dirSet[jj] = ""; //clear existing strings
      keep[jj] = 0; //dont repeat this index again
     }
      
    }
    }
    if(!dirSet[ii].equals("")) //only add the string to gateSet if it was not nullified above
    {
     float xx = xSet[ii]-xS; //set x based on left most point (c1+x) 
     float yy = ySet[ii]-yS; //similar for y
     String thisPoint = "self.lga.DrawPoint(r1+" + yy+ ",c1+" + xx + "," + dirSet[ii] + ")"; //example: self.lga.DrawPoint(r1+1,c1+4,EEEE+NE)
     gateSet = append(gateSet,thisPoint); 
    }
  }
  println("exporting...");
  saveStrings(expName,gateSet); //save it
  println("exported"); 
}

String checkDir(int dir,int wORp) //convert the dir code to the appropriate lga string based on if the object is a wall/src/snk(0) or a particle(1)
{
  if(wORp==0) //wall
  {
   switch(dir){
   case 0:
   return "EEEE";
   case 30:
   return "EENE";
   case 60:
   return "NENE";
   case 90:
   return "NENW";
   case 120:
   return "NWNW";
   case 150:
   return "WWNW"; 
   case -1:
   return "REV";
   case -2:
   return "SNK";
   case -3:
   return "SRCA";
   case -360:
   return "SRC";
   default:
   return "SRCV";
      
   } 
  }
else{
   switch(dir){
   case 0:
   return "EE";
   case 60:
   return "NE";
   case 120:
   return "NW";
   case 180:
   return "WW";
   case 240:
   return "SW";
   case 300:
   return "SE";  
  
  
 } 
  
}
 return ""; 
}

















