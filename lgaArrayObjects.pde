class Sources
{
 ArrayList<Wall> srcs = new ArrayList<Wall>();
 int srcdir = -360;
 Wall srcDraw = new Wall(0,1,srcdir);
 Sources()
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
  for(int ii = 0; ii<srcs.size();ii++)
  {
    if(srcs.get(ii).xPos == x && srcs.get(ii).yPos == y)
    {
      alreadyExists = true;
    }
  }
  if(!alreadyExists)
  {
  srcs.add(new Wall(x,y,srcdir));
  }
   
 }
 void clearSources()
 {
  srcs.clear(); 
 }
 void drawSources()
 {
    for(int ii = 0; ii<srcs.size();ii++)
 {
  srcs.get(ii).drawWall();
  
 }
 srcDraw.drawWall();
 }
  void changeSourceDirection()
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
   
    srcDraw.dir = srcdir;

 }
 void eraseAtMouse()
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
 void removeLast()
 {
   if(srcs.size()>0)
  srcs.remove(srcs.size()-1); 
   
 }
 void handleSources()
 {
  for(int ii = 0; ii<srcs.size(); ii++)
 { 
   if(srcs.get(ii).dir == -3)
   {
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,0));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,60));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,120));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,180));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,240));
    ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,300));

   }
   else{
   int pdir = -srcs.get(ii).dir;
   if(pdir==360)
     pdir = 0;
  ps.pars.add(new Particle((int)srcs.get(ii).xPos,(int)srcs.get(ii).yPos,pdir));
   }
 } 
 }
  
}

class revWalls //and snks
{
 ArrayList<Wall> rwalls = new ArrayList<Wall>();
 int type = -1;
 Wall drawingrWall = new Wall(0,.2,type);

 revWalls()
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
   if(type == -1)
   {
    type = -2; 
   }
   else
    type = -1;
   
   drawingrWall.dir = type;
 }
 
}
  
  


class Walls 
{
 ArrayList<Wall> walls = new ArrayList<Wall>();
 int drawDirectionW = 0;
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

class Wall extends arrayObject
{
  int dir = 0; //wall direction(angle in degrees) 0 = EEEE, 30 = EENE
  int drawColor = color(0,0,255);
  int drawColor2 = color(255,40,40);
  int drawColor3 = color(0,255,0);
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
    float scale2 = scale/sin(PI/3);//length of lattice lines
   float startX = xPos*scale2;
   if(yPos%2!=0)
       startX+=scale2/2;
   float startY = yPos*scale2*sin(PI/3);
    
    if(dir == -1)
  {
    pushMatrix();
   translate(startX,startY);
   rectMode(CENTER);
   rect(0,0,scale/5,scale/5);
   popMatrix();
   rectMode(CORNER);
  }
  else if(dir == -2)
  {
   stroke(drawColor2);
   pushMatrix();
   translate(startX,startY);
   rectMode(CENTER);
   rect(0,0,scale/5,scale/5);
   popMatrix();
   rectMode(CORNER);
  }
  else if(dir == -3)
  {
   stroke(drawColor3);
   pushMatrix();
   translate(startX,startY);
   rectMode(CENTER);
   rect(0,0,scale/5,scale/5);
   popMatrix();
   rectMode(CORNER);
  }
  else if(dir <=-60)
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
  else{
    
   pushMatrix();
   translate(startX,startY);
   rotate(radians(-dir));
   line(-scale/4,0,scale/4,0);
   popMatrix();
  }
  }
  
  
}


class Particles
{
 ArrayList<Particle> pars = new ArrayList<Particle>();
 ArrayList<Particle> phantomPars = new ArrayList<Particle>();
 int drawDirection = 0;
 int twoParticleCollisionDirection = 60;
 Particle drawingTemplate = new Particle(0,1,drawDirection);
 int time = 0;
 int timeStep = 1;
 int[][] par2Collisions;
 Particles()
 {
     //set up 2 particle collision rule memory
   
   
 }
 void setup2parMatrix()
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
  time = 0;
  timeStep = 1;
  setup2parMatrix();
 }
 void drawDrawingParameters()
 {
  drawingTemplate.drawParticle(); 
 }
 
 void changeDrawDirection()
 {
  drawDirection+=60;
  if(drawDirection>=360)
  {
   drawDirection-=360;
  } 
    drawingTemplate.dir = drawDirection;

 }
 
 void addNew()
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
 
 void updateParticles(Walls ws)
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
 
 void reverseDirection() //needs to update 2particle collision matrix
 {
   
   if(srcs.srcs.size()>0)
   {
    println("WARNING: srcs are not generally reversible"); 
   }
   if(rws.rwalls.size()>0)
   {
    println("REMINDER: if you are using snks, this processing is irreversible"); 
   }
   
 
   timeStep = -timeStep;
   int[] change = {};
   int[] par2xchange = {};
   int[] par2ychange = {};
  for(int ii = 0; ii< pars.size(); ii++)
 {
   change = append(change,1);
   boolean hitWall = false;
   int collisionCount3 = 0; 
   int collisionCount2 = 0; 

   for(int jj = 0; jj<ws.walls.size();jj++)
   {
    if(pars.get(ii).xPos == ws.walls.get(jj).xPos && pars.get(ii).yPos == ws.walls.get(jj).yPos && (pars.get(ii).dir-ws.walls.get(jj).dir)%180 != 0)
   {
    hitWall = true;
   } 
   }
   for(int jj = 0; jj<rws.rwalls.size();jj++)
   {
    if(pars.get(ii).xPos == rws.rwalls.get(jj).xPos && pars.get(ii).yPos == rws.rwalls.get(jj).yPos)
   {
    hitWall = true;
   } 
   }
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
     if(abs(pars.get(ii).dir - pars.get(jjarray[jj]).dir) % 180 == 0)
      {
        collisionCount2++;
        //println("cc3:"+collisionCount3);
      }
     }
   }
   
   if(hitWall || collisionCount3==3)
   {
     change[ii] = 0;
   }
   else if(collisionCount2 == 2)
   {
     change[ii] = 2;

     par2xchange = append(par2xchange,(int)pars.get(ii).xPos);
     par2ychange = append(par2ychange,(int)pars.get(ii).yPos);  

     /*
     boolean changex = true;
     boolean changey = true;
     for(int ii = 0; ii<par2xchange.length;ii++)
     {
       if(par2xchange[ii] = (int)pars.get(ii).xPos)
       {
        changex = false; 
       }
     }
     par2xchange = append(par2xchange,(int)pars.get(ii).xPos);
     par2ychange = append(par2ychange,(int)pars.get(ii).yPos);
*/
     
   }
 }
  for(int ii = 0;ii<pars.size();ii++)
  {
   if(change[ii]==1)
      {
       pars.get(ii).dir +=180;
       }
    else if(change[ii] == 2)
    {
     println(pars.get(ii).dir);
     switch(par2Collisions[(int)pars.get(ii).xPos][(int)pars.get(ii).yPos])
     {
      case 1:
       //par2Collisions[(int)pars.get(ii).xPos][(int)pars.get(ii).yPos] = 4;
       pars.get(ii).dir+=120;
      break;
      case 2:
    // par2Collisions[(int)pars.get(ii).xPos][(int)pars.get(ii).yPos]--;
      pars.get(ii).dir+=120;
      break; 
       case 3:
     //par2Collisions[(int)pars.get(ii).xPos][(int)pars.get(ii).yPos]--;
      pars.get(ii).dir-=120;
      break;
       case 4:
    // par2Collisions[(int)pars.get(ii).xPos][(int)pars.get(ii).yPos]--;
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
    pars.get(ii).newdir = pars.get(ii).dir;
  } 
  
  //super messy way to ensure the 2 particle collision table is changed and the 
  //collisions are reversible
  boolean[] changepar2 = new boolean[par2xchange.length];
  for(int ii = 0; ii<par2xchange.length;ii++)
  {
   changepar2[ii] = true; 
  }
  for(int ii = 0; ii<par2xchange.length;ii++)
  {
   for(int jj = ii+1; jj<par2xchange.length;jj++)
    {
     if(par2xchange[ii] == par2xchange[jj] && par2ychange[ii] == par2ychange[jj])
     {
      changepar2[jj] = false; 
     }
     
    } 
  }
  for(int ii = 0; ii<changepar2.length;ii++)
  {
   if(changepar2[ii])
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
 

 
 void checkCollisions() 
 {
        //int test = 60*(int)random(1,3); // handles randomness of two particle collisions, for a given timestep all collisions will rotate by the same (may want to change);
        // int test = 120;
    for(int ii = 0; ii<pars.size();ii++) //<>//
 {
   boolean hitWall = false;
   //pars.get(ii).collisionFactor = 0;
   for(int kk = 0; kk<ws.walls.size();kk++)
   {
     if(pars.get(ii).xPos == ws.walls.get(kk).xPos && pars.get(ii).yPos == ws.walls.get(kk).yPos)
     {
      hitWall = true;
     // println("wall Collision at: "+ pars.get(ii).xPos + "," + pars.get(ii).yPos);
     //handle wall 
     //println(wallTable(ws.walls.get(kk).dir,pars.get(ii).dir));
     pars.get(ii).newdir = wallTable(ws.walls.get(kk).dir,pars.get(ii).dir);
    
     }
   }
   for(int kk = 0; kk<rws.rwalls.size();kk++)
   {
     
     if(pars.get(ii).xPos == rws.rwalls.get(kk).xPos && pars.get(ii).yPos == rws.rwalls.get(kk).yPos)
     {
      hitWall = true;
      println("rwall Collision at: "+ pars.get(ii).xPos + "," + pars.get(ii).yPos);
     //handle wall 
     //println(wallTable(rws.rwalls.get(kk).dir,pars.get(ii).dir));
     
     if(rws.rwalls.get(kk).dir == -1)
     {
     pars.get(ii).newdir = pars.get(ii).dir+180;
     if(pars.get(ii).newdir>=360)
     {
      pars.get(ii).newdir-=360; 
     }
     }
     else if(rws.rwalls.get(kk).dir == -2)
     {
      pars.get(ii).newdir=-1; 
     }
     }
   }
   for(int kk = 0; kk<srcs.srcs.size();kk++)
   {
     
     if(pars.get(ii).xPos == srcs.srcs.get(kk).xPos && pars.get(ii).yPos == srcs.srcs.get(kk).yPos)
     {
      hitWall = true;
      println("source Collision at: "+ pars.get(ii).xPos + "," + pars.get(ii).yPos);
     //handle src collision removal 
      pars.get(ii).newdir=-1; 
     }
   }
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

   if(collisionCount3 == 3)
   {
    pars.get(ii).newdir = pars.get(ii).dir+180; 
    if(pars.get(ii).newdir >=360)
    {
     pars.get(ii).newdir -= 360; 
    }
    println("3 Particle Collision at" + pars.get(ii).xPos + "," +pars.get(ii).yPos );
   }
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
    println("2 Particle Collision at" + pars.get(ii).xPos + "," +pars.get(ii).yPos );
   }
}
 }
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
 
  
  


class Particle extends arrayObject
{
  int dir = 0; //particle direction(angle in degrees) 0 = EE, 60 = NE
  int newdir;
  int drawColor = color(255,0,0);
  int collisionFactor = 0; //2 means 2 particle collision, 9 means 3 particle collision
  Particle(int x, int y, int a)
  {
    xPos = x;
    yPos = y;
    type = "particle";
    dir = a;
    newdir = dir;
  }
   Particle(int x, int y, int a, int c)
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
