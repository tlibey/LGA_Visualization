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
 

