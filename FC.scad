$fn=80;

boardheight = 5/3;
boardsize = 35;
cornerradius=3;

module board()
{
    #translate([boardsize/2+3,0,0]) square(3,true);
    //translate([-boardsize/2,-boardsize/2])
    {
    translate([0,0,-boardheight/2])
    {
        color("DimGrey")
        translate([cornerradius,cornerradius])
        {
            squareCorner = boardsize-(cornerradius*2);
            
            difference()
            {
                minkowski()
                {
                    cylinder(r=cornerradius,h=boardheight/2);
                    cube([squareCorner,squareCorner,boardheight/2]);
                };
                CornerHoles(squareCorner);
            }
            
            

            #CornerHoles(squareCorner);
        }
    }
    topComponents();
    bottomComponents();
}
}

module topComponents ()
{
    translate([0,0,boardheight/2])
    {
        translate([11.4,0,0]) JSTSH(8);
        mirror([0,1,0]) translate([11.4,-boardsize,0]) JSTSH(8);
        translate([0,boardsize/2,0]) rotate([0,0,270]) 
        {
            MicroUSB();
            translate([5.2,0,0])
            JSTSH(4);
            translate([-5.2,0,0]) mirror([1,0,0]) JSTSH(4);
        }
        color("Silver")
        {
            translate([10.7,7.3,0])
                cube([14.6,21,1]);
            translate([7.3,13.4,0])
                cube([3.4, 8.9 ,1]);
        }
    }
}
module bottomComponents ()
{
    translate([0,0,-boardheight/2])
    mirror([0,0,-1])
    {
        translate([0,boardsize/2,0]) rotate([0,0,270]) 
        {
            translate([5.2,0,0])
            JSTSH(4);
            translate([-5.2,0,0]) mirror([1,0,0]) JSTSH(4);
        }
        color("Silver")
        {
            translate([9.3,4.5,0])
                cube([17, boardsize-9 ,1]);
            translate([13.8,0,0])
            {
                cube([5.4, 4.5 ,1]);
                translate([0,boardsize-4.5,0])
                    cube([5.4, 4.5 ,1]);
            }
        }
    }
}
module CornerHoles(squareCorner)
{
        CornerHole(squareCorner,[1,1]);
        CornerHole(squareCorner,[0,1]);
        CornerHole(squareCorner,[1,0]);
        CornerHole(squareCorner,[0,0]);
}

module CornerHole(squareCorner,pos)
{
    translate([squareCorner*pos[0],squareCorner*pos[1],-boardheight/2]) cylinder(d=3, h=2*boardheight);
}

module socketAndConnector(socketSize,socketPos,connectorSize)
{
    translate(-socketPos) 
    {
       cube(socketSize);
       mirror([0,1,0])
       translate([socketSize[0]-connectorSize[0],0,socketSize[2]-connectorSize[2]]/2) 
        #cube(connectorSize);
    }
}

module JSTSH(pins, pos=[0,0,0])
{    
    translate(pos)
    {
       // cube([2+pins,4.7,3]);
        socketSize = [2+pins,4.7,3];
        socketPos = [0,0,0];
        connectorSize = [socketSize[0]+1,2.5,socketSize[2]];
        
        socketAndConnector(socketSize,socketPos,connectorSize);
    }
}



module MicroUSB(pos=[0,0,0])
{
    translate(pos)
    {
        socketSize = [9,6.3,3];
        socketPos = [4.5,1.3,0];
        connectorSize = [11,17,7];
        
        socketAndConnector(socketSize,socketPos,connectorSize);
    }
}

//MicroUSB();

board();