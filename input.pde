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

boolean gettingString = false;
String stringbuffer = "";
void stringFunction()
{
 // for(char test = 'A'; test<'z'; test++)
 //{
   if(keyPressed && ((key>='A' && key <= 'z') || (key>='0' && key<='9') || key == '.'))
      {
      stringbuffer = stringbuffer+key;
      delay(100);
      }
// } 
 else if(checkKey(DELETE))
 {
  stringbuffer = ""; 
 }
 else if(checkKey(ENTER))
 {
  gettingString = false; 
 }
 else if(checkKey(BACKSPACE))
 {
   if(stringbuffer.length()>0)
   {
   stringbuffer = stringbuffer.substring(0,stringbuffer.length() - 1);
   delay(100);
   }
 }
 
}
