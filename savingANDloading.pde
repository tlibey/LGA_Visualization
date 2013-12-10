//modifies global variables


void saveAll()
{
  String fName = workingFile;
  String[] gateSet = {};
  //adding walls to string, one String object per wall
  for(int ii = 0; ii < ws.walls.size(); ii++)
  {
    Wall wall = ws.walls.get(ii);
   String thisWall = "W," + wall.xPos + "," + wall.yPos + "," + wall.dir; 
  gateSet = append(gateSet,thisWall);
  }
  for(int ii = 0; ii<ps.pars.size(); ii ++)
  {
   Particle par = ps.pars.get(ii);
  String thisPar = "P," + par.xPos + "," + par.yPos + "," + par.dir; 
    gateSet = append(gateSet,thisPar);
  }
  for(int ii = 0; ii<rws.rwalls.size(); ii ++)
  {
   Wall wall = rws.rwalls.get(ii);
  String thisWall = "rW," + wall.xPos + "," + wall.yPos + "," + wall.dir; 
  gateSet = append(gateSet,thisWall);
  }
  println("saving...");
  saveStrings(fName,gateSet);
  println("saved");
}


void loadFile()
{
  //clear old data
  ws.walls.clear();
  ps.pars.clear();
  rws.rwalls.clear();
  try{
  String[] gateSet = loadStrings(workingFile);
  for(int ii = 0; ii<gateSet.length; ii++)
  {
   String[] thisGate = split(gateSet[ii], ","); 
   int x = (int)Double.parseDouble(thisGate[1]);
   int y = (int)Double.parseDouble(thisGate[2]); 
   int d = Integer.parseInt(thisGate[3]);
   if(thisGate[0].equals("W"))
  {
   ws.walls.add(new Wall(x,y,d));
   println("Loaded wall at: " + x + "," + y + " @" + d + "degrees");
  }
   if(thisGate[0].equals("rW"))
  {
   rws.rwalls.add(new Wall(x,y,d));
   println("Loaded rwall at: " + x + "," + y + " @" + d + "degrees");
  }
 else if(thisGate[0].equals("P"))
  {
      ps.pars.add(new Particle(x,y,d));
      println("Loaded particle at: " + x + "," + y + " @" + d + "degrees");

   
  } 
  }
  }
  catch(Exception e)
  {
   println("cannot find file" + e); 
  }
  
  
}

void lgaExport() //saving last line!!
{
  //find top left most point
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
  //
  String[] fName = split(workingFile,'.');
  String expName = fName[0] + "_exp." + fName[1]; 
  String[] gateSet = {};
  gateSet = append(gateSet,"r1 = 1");
  gateSet = append(gateSet,"c1 = 1");
  //adding walls to string, one String object per wall
  float[] xSet = {};
  float[] ySet = {};
  String[] dirSet = {};
  int[] keep = {};
  for(int ii = 0; ii < ws.walls.size(); ii++)
  {
    Wall wall = ws.walls.get(ii);
    xSet = append(xSet,wall.xPos);
    ySet = append(ySet,wall.yPos);
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
  for(int ii = 0; ii<ps.pars.size(); ii ++)
  {
   Particle par = ps.pars.get(ii);
   xSet = append(xSet,par.xPos);
    ySet = append(ySet,par.yPos);
    String thisDir = (checkDir(par.dir,1));
    dirSet = append(dirSet,thisDir);
    keep = append(keep,1);
  }
  //go through and combine
  for(int ii = 0; ii<xSet.length;ii++)
  {
    println(dirSet[ii]+"x");
    if(ii!=xSet.length-1)
    {
    for(int jj = ii+1; jj<xSet.length;jj++)
    {
     if(xSet[ii] == xSet[jj] && ySet[ii] == ySet[jj] && keep[jj]==1)
     {
      dirSet[ii] += " + " + dirSet[jj];
      dirSet[jj] = ""; 
      keep[jj] = 0;
     }
      
    }
    }
    if(!dirSet[ii].equals(""))
    {
     float xx = xSet[ii]-xS;
     float yy = ySet[ii]-yS;
     String thisPoint = "self.lga.DrawPoint(r1+" + yy+ ",c1+" + xx + "," + dirSet[ii] + ")";
     gateSet = append(gateSet,thisPoint); 
    }
  }
  //   String thisWall = "self.DrawPoint(r1+" + wall.xPos-xS + ",c1+" + wall.yPos-yS + "," + wall.dir; 
//  gateSet = append(gateSet,thisWall);

  println("exporting...");
  saveStrings(expName,gateSet);
  println("exported");
  
  //self.lga.DrawPoint(r1+12,c1,EENE + NE)
}

String checkDir(int dir,int wORp)
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
















