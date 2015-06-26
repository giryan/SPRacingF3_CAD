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
caseSize = boardsize + 0.5;
caseInterior = [caseSize, caseSize, 8];
caseExterior = caseInterior+[casethickness,casethickness,casethickness];


module BareCase()
{
    difference()
    {
        cube(caseExterior,true);
        
        {    
            translate([0,0,caseInterior[2]/2+0.5])
                SPRacingF3Text();
        cube(caseInterior,true);                     
            
        }
    }
}
module CornerMountCubes(top)
{

    module CornerCube()
    {
        cubePos = boardsize/2-2;
        mountcubeheight = caseInterior[2]/2;
        translate([cubePos,cubePos,mountcubeheight/2]) cube([ 6,6, mountcubeheight], true);
    }
    cubetrans = top ?
                    boardheight/2 :
                    (-caseInterior[2]/2) - (boardheight/2)
                    ;
    
    translate([0,0, cubetrans])
    union()
    {
        CornerCube();
        mirror([1,0,0]) CornerCube();
        mirror([0,1,0])
        {
           CornerCube();
           mirror([1,0,0]) CornerCube();
        }
    }
}

module Case(servoPins, top)
{
    cutheight = 0;//boardheight/2;

    module CaseHalf()
    {
        intersection()
        {
            union()
            {
                difference()
                {
                    BareCase();
                    board(servoPins,true);
                }
                CornerMountCubes(top);
            }
                       
            CaseHalfBox(cutheight, top);
        }
    }

    if(top)
    {
        difference()
        {
            CaseHalf();
            CornerHoles([(boardsize-5)/2,boardheight*2], false);
        }
    }    
    else
    {
        CaseHalf();
        CornerHoles([(boardsize-5)/2 , 2.5, boardheight*2], false);
    }
}


module CaseHalfBox(cutheight, top)
{    
    translate([0,0,cutheight])
    if(top)
    {
        CaseHalfBox = [caseExterior[0], caseExterior[1], (caseExterior[2]) - cutheight];

        translate([0,0,caseExterior[2]/2]) cube(CaseHalfBox, true);
    }
    else
    {
       CaseHalfBox = [caseExterior[0], caseExterior[1], (caseExterior[2]) + cutheight];

       translate([0,0,-caseExterior[2]/2]) cube(CaseHalfBox, true);
    }
}


//board(5,false);

//intersection()
translate([0,0,5]) Case(5, true);
/*#board(5,false);

translate([0,0,-20])
{
    Case(5, false);
    #board(5,false);
}

*/