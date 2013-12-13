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
