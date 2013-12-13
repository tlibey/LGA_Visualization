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

