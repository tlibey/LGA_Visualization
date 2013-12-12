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
















