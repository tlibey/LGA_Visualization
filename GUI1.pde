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
