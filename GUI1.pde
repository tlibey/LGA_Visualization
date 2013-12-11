class GUI
{
 ArrayList<Button> buttons = new ArrayList<Button>(); 
 float xGUIStart;
 float yGUIStart;

 float buttonH;
 float buttonW;
 int buffer;
 int lastPress = 0;
 int fontSize;
 int runSpeed = 10; //number of frames to skip between particle updates, decreas # to increase speed %%%%%%%
 boolean gridOn = true;
  GUI()
  {
    
    xGUIStart = 0;
    yGUIStart = height-height/8;
    buffer = height/200;
    buttonH = height/30;
    buttonW = (width-2*buffer)/8;
    fontSize = height/50;
    setupButtons();
    
  }
  void updateGUI()
  {
    if(gridOn)
     this.drawGrid();
     
    this.showButtons();
    this.checkButtons(); 
    
  }
  
  void drawGrid()
{
  stroke(0); 
   strokeWeight(1);

  int sp = scale;
  for(int ii = sp; ii< height; ii+=sp)
    {
      line(4,ii,width,ii);
    }
   pushMatrix();
   rotate(PI*60/180);
    for(int ii = -2*height; ii< height; ii+=sp)
    {
      line(4,ii,2*width,ii);
    }
   popMatrix();
     pushMatrix();
   rotate(-PI*60/180);
    for(int ii = 0; ii< 2*height; ii+=sp)
    {
      line(-width,ii,2*width,ii);
    }
   popMatrix();
  
  
}

  void setupButtons()
  {
    buttons.add(new Button(xGUIStart+buffer,yGUIStart+buffer+buttonH,buttonW,buttonH,"TogDrawMode"));
    buttons.add(new Button(xGUIStart+buffer+buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"OneStep"));
    buttons.add(new Button(xGUIStart+buffer+2*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"SaveAll"));
    buttons.add(new Button(xGUIStart+buffer+3*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"loadAll"));
    buttons.add(new Button(xGUIStart+buffer+4*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"changeFile"));
    buttons.add(new Button(xGUIStart+buffer+5*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"exportLGA"));
    buttons.add(new Button(xGUIStart+buffer+6*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"run"));
    buttons.add(new Button(xGUIStart+buffer+7*buttonW,yGUIStart+buffer+buttonH,buttonW,buttonH,"clearAll"));

    buttons.add(new Button(xGUIStart+buffer,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"reverseParticles"));
    buttons.add(new Button(xGUIStart+buffer+buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"rotateParticle"));
    buttons.add(new Button(xGUIStart+buffer+2*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"rotateWall"));
    buttons.add(new Button(xGUIStart+buffer+3*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"toggleGrid"));
    buttons.add(new Button(xGUIStart+buffer+4*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"changeScale"));
    buttons.add(new Button(xGUIStart+buffer+5*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"runSpeedUp"));
    buttons.add(new Button(xGUIStart+buffer+6*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"runSpeedDown"));
    buttons.add(new Button(xGUIStart+buffer+7*buttonW,yGUIStart+buffer+2*buttonH,buttonW,buttonH,"togRevSnk"));
    buttons.add(new Button(xGUIStart+buffer+buttonW,yGUIStart+buffer+3*buttonH,buttonW,buttonH,"rotateSource"));
    
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
  void showButtons()
  {
    fill(255);
    stroke(0);
    rect(xGUIStart,yGUIStart,width,height-buffer);
    textFont(font,fontSize);
    fill(0);
    String modeDisp = "Particle";
    if(modeToggle==0)
        modeDisp = "Wall";
    else if(modeToggle == 2)
        modeDisp = "Rev/Snk";
    else if(modeToggle == 3)
        modeDisp = "Source";
    textAlign(LEFT);
    text("Mode: " + modeDisp, buffer, yGUIStart + 4*buffer);
    textAlign(CENTER);
    text("Time: "+ps.time,width/2,yGUIStart+4*buffer);
    textAlign(RIGHT);
    text("CurrentFile: "+workingFile,width-buffer,yGUIStart+4*buffer);
   for(int ii= 0; ii<buttons.size(); ii ++)
  {
    buttons.get(ii).showButton();
  } 
  }
  
  void checkButtons()
  {
    String pressed = "";
   for(int ii = 0; ii<buttons.size(); ii ++)
  {
   if(buttons.get(ii).isPressed())
   {
     pressed = buttons.get(ii).bText;
   }
  } 
  if(pressed!= "" && lastPress<millis()-300)
  {
   lastPress = millis();
   if(pressed=="TogDrawMode"){
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
   else if(pressed == "OneStep"){
    ps.updateParticles(ws);
  
   }
   else if(pressed == "SaveAll")
   {
    saveAll();
     
   }
    else if(pressed == "loadAll")
   {
    ws.clearWalls();
    ps.clearParticles();
    rws.clearWalls();
    srcs.clearSources();
    loadFile();
    ps.time = 0;
    ps.timeStep = 1;
     
   }
   else if(pressed == "changeFile")
   {
    gettingString = true; 
    stringbuffer = "";
     
   } 
   else if(pressed == "exportLGA")
   {
    lgaExport();
   }
   else if(pressed == "run")
   {
    runContinuously = !runContinuously; 
   } 
   else if(pressed == "clearAll")
   {
    ws.clearWalls();
    ps.clearParticles();
    rws.clearWalls();
    srcs.clearSources();

   }
   else if(pressed == "reverseParticles")
   {
     
    ps.reverseDirection(); 
   }
   else if(pressed == "rotateParticle")
   {
     
   ps.changeDrawDirection(); 
   }
   else if(pressed == "rotateWall")
   {
     
   ws.changeDrawDirection(); 
   } 
   else if(pressed == "rotateSource")
   {
     
   srcs.changeSourceDirection(); 
   }
   else if(pressed == "toggleGrid")
   {
     this.gridOn = !this.gridOn;     
   }
   else if(pressed == "changeScale")
   {
     scale = scale/2;
     if(scale<20)
        scale = 40;     
   }
   else if(pressed == "runSpeedUp")
   {
     this.runSpeed--; 
  if(runSpeed<1)
      runSpeed = 1;  
   }
   else if(pressed == "runSpeedDown")
   {
     this.runSpeed++;    
   }
   else if(pressed == "togRevSnk")
   {
     rws.toggleType();   
   }    
     
     
   
  } 
  }
   
  

}
