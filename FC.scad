$fn=80;


boardheight = 5/3;
boardsize = 35;
cornerradius=1.5;
squareCorner = boardsize-(cornerradius*2);

connectorColour = [1,0,0,0.7];
componentHeight = 1.5;

module board(numServoConnectors, connectors=false)
{
    //translate([boardsize/2+3,0,0]) square(3,true);
    translate([-boardsize/2,-boardsize/2])
    {
        //color("DimGrey") 
        BareCircuitBoard();
        TopComponents(connectors, numServoConnectors);
        BottomComponents(connectors);
    }
    if(connectors)
    {
        ServoConnectors(numServoConnectors, false, 3);
    }
    if(connectors)
    {
        color(connectorColour)
            _CornerHoles(mountHole, true);
    }
}


module BareCircuitBoard()
{
    difference()
    {
        translate([0,0,-boardheight/2])
        {
                
            translate([cornerradius,cornerradius])
            {
                minkowski()
                {
                    cylinder(r=cornerradius,h=boardheight/2);
                    cube([squareCorner,squareCorner,boardheight/2]);
                }
            }
        }
        translate([boardsize/2,boardsize/2])
        CornerHoles([(boardsize-5)/2,3, boardheight]);
    }
    
}

module TopComponents (connectors, numServoConnectors, verticalServo)
{
    translate([0,0,boardheight/2])
    {
        JSTSH(8, [11.4,0,0], connectors);
        translate([0,boardsize,0]) mirror([0,1,0]) JSTSH(8, [11.4,0,0], connectors);
        rotate([0,0,270]) translate([-boardsize/2,0,0])
        {
            MicroUSB([0,0,0], connectors);
            JSTSH(4, [5.2,0,0], connectors);
            mirror([1,0,0]) JSTSH(4, [5.2,0,0], connectors);
        }
        color("Silver")
        {
            translate([10.7,7.3,0])
                cube([14.6,21,componentHeight]);
            translate([7.3,13.4,0])
                cube([3.4, 8.9 ,componentHeight]);
        }
    }
}
module BottomComponents (connectors)
{
    translate([0,0,-boardheight/2])
    mirror([0,0,-1])
    {
        rotate([0,0,270]) translate([-boardsize/2,0,0])
        {
            JSTSH(4, [5.2,0,0], connectors);
            mirror([1,0,0]) JSTSH(4, [5.2,0,0], connectors);
        }
        color("Silver")
        {
            translate([9.3,4.5,0])
                cube([17, boardsize-9 ,componentHeight]);
            translate([13.8,0,0])
            {
                cube([5.4, 4.5 ,componentHeight]);
                translate([0,boardsize-4.5,0])
                    cube([5.4, 4.5 ,componentHeight]);
            }
        }
    }
}

module ServoConnectors(numPins, vertical, pinRows)
{
    color(connectorColour)
    {
        servoConnectorWidth = 8*2.54;
        servoConnectorDepth = 0.4+3*2.54;

        pinCube = [10, numPins*2.54, 0.4+pinRows*2.54];
        if(vertical)
        {
            pinCube = [0.4+pinRows*2.54, numPins*2.54, 10];
        }
        
        translate([boardsize/2-servoConnectorDepth,-servoConnectorWidth/2,0])
            translate([0,0,boardheight/2])
                    cube(pinCube);
    }
}

module CornerHoles(mountHole_)
{
    translate([0,0,-mountHole_[2]/2])
    {
    translate([mountHole_[0],mountHole_[0]])
        cylinder(d=mountHole_[1], h=mountHole_[2]);
    translate([-mountHole_[0],mountHole_[0]])
        cylinder(d=mountHole_[1], h=mountHole_[2]);
    translate([mountHole_[0],-mountHole_[0]])
        cylinder(d=mountHole_[1], h=mountHole_[2]);
    translate([-mountHole_[0],-mountHole_[0]])
        cylinder(d=mountHole_[1], h=mountHole_[2]);
    }
}

module CornerMount(mountHole_,pos)
{
    mountsquaresize = 5;
    corner = boardsize-mountsquaresize;
    corners = [corner*pos[0],corner*pos[1]]/2;
    translate(corners) 
        translate([-mountsquaresize/2,-mountsquaresize/2,boardheight/2])
            cube([mountsquaresize,mountsquaresize,mountsquaresize-0.5-boardheight/2]);
}

module socketAndConnector(socketSize,socketPos,connectorSize, connectors)
{
    translate(-socketPos) 
    {
       cube(socketSize);
        
        if(connectors)
        {
            color(connectorColour)
            mirror([0,1,0]) translate([socketSize[0]-connectorSize[0],0,socketSize[2]-connectorSize[2]]/2) 
            cube(connectorSize);
        }
    }
}

module JSTSH(pins, pos=[0,0,0], connectors)
{    
    translate(pos)
    {
        socketSize = [2+pins,4.7,3];
        socketPos = [0,0,0];
        connectorSize = [socketSize[0]+1.4,12.5,socketSize[2]];
        
        socketAndConnector(socketSize,socketPos,connectorSize, connectors);
    }
}



module MicroUSB(pos=[0,0,0], connectors)
{
    translate(pos)
    {
        socketSize = [9,6.3,3];
        socketPos = [4.5,1.3,0];
        connectorSize = [11,17,7];
        
        socketAndConnector(socketSize,socketPos,connectorSize, connectors);
    }
}

