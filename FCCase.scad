include <FC.scad>

module SPRacingF3Text()
{
    linear_extrude(height =casethickness)
    rotate([0,0,-90]) 
    {
        translate([0,5,0])
            text("SP", size = 6, valign="center", halign="center");
        translate([0,-4,0])
            text("Racing", size = 6, valign="center", halign="center");
        translate([0,-12,0])
            text("F3", size = 6, valign="center", halign="center");
    }
}


casethickness = 3;
caseSize = boardsize + 0.25;
caseInterior = [caseSize, caseSize, 8];
caseExterior = caseInterior+[casethickness,casethickness,casethickness];

module Case(servoPins, top)
{
    
    cutheight = boardheight/2;
    union()
    {
        intersection()
        {
            union()
            {
                difference()
                {
                    cube(caseExterior,true);
                    
                    {    
                        translate([0,0,caseInterior[2]/2+0.5])
                            SPRacingF3Text();
                        
                        
                        scale([1.04,1.04,1.04], auto=true) hull() board(8,false);
                        
                        board(servoPins,true);
                    }
                }
                mountcubeheight = caseInterior[2];
                
                difference()
                {
            union()
                       {
                           cubePos= boardsize/2-2;
                           translate([cubePos,cubePos,0]) cube([ 6,6,mountcubeheight], true);
                           translate([cubePos,-cubePos,0]) cube([ 6,6,mountcubeheight], true);
                           translate([-cubePos,cubePos,0]) cube([ 6,6,mountcubeheight], true);
                           translate([-cubePos,-cubePos,0]) cube([ 6,6,mountcubeheight], true);
                       }
                    
                        board(servoPins,true);
                }
            }
            topHalf = [caseExterior[0],caseExterior[1],(caseExterior[2] / 2)];

           // halfOffset = 0;
           // if(top)
            //{
            //    halfOffset = topHalf[2];                
            //}
            //translate([0,0,(topHalf[2] / 2)]) cube(topHalf, true);
            
            CaseHalf(top);
            
        }
           
        if(!top)
        {
            CornerHoles([(boardsize-5)/2,2.85], false);
        }
    }
}

Case(5,true);
//#board(5,true);


module CaseHalf(cutheight, top)
{
      
    subsize = boardsize+3;

    translate([0,0,cutheight])
    mirror([0,0,0])
        translate([-subsize/2,-subsize/2,0])
          cube([subsize,subsize,10]);
  
}