//------------------------------------------------------------------------
// OpenSCAD models of miscellaneous components and devices:
// various Raspberry Pi models, SainSmart Relays, PCD8544 LCD, etc.
//
// Author:      Niccolo Rigacci <niccolo@rigacci.org>
// Version:     1.0 2017-12-14
// License:     GNU General Public License v3.0
// Modified:    by Richard Jelbert 5th January 2021 for RPi 4
//              https://www.thingiverse.com/thing:4712611
// Modified:    by David Forrest 2022-09-23 to add IO clearance/carving features 
//              https://www.thingiverse.com/thing:5527415
//              
//------------------------------------------------------------------------


stl=0; // 0,1,2,3 for:  bare RPi4; RPi4 with IO clearange features;
       // RPI & IO carved out of a block; RPi & IO carved out of a sphere
       // 4: a hole-shaped part
       // 5: carved block with RPi4 inside and IO sticking out

// Interference for 3D union(), difference() and intersection();
// used to avoid the manifold problem.
interf = 0.2;

//------------------------------------------------------------------------
// Matrix of 2.54 mm pins.
//------------------------------------------------------------------------
module pin_headers(cols, rows) {
    w = 2.54; h = 2.54; p = 0.65;
    for(x = [0 : (cols -1)]) {
        for(y = [0 : (rows  - 1)]) {
            translate([w * x, w * y, 0]) {
                union() {
                    color("black") cube([w, w, h]);
                    color("gold")  translate([(w - p) / 2, (w - p) / 2, -3]) cube([p, p, 11.54]);
                }
            }
        }
    }
}

//------------------------------------------------------------------------
// Sub-models for the Raspberry Pi 4 Model
//------------------------------------------------------------------------

module ethernet_connector(x, y, z) {
    color("silver") cube([x, y, z]);
}
module usb_connector(x, y, z) {
    f = 0.6; // Flange
    color("silver") cube([x, y, z]);
    translate([-f, y - f, -f])
        color("silver") cube([x + f * 2, f, z + f * 2]);
}
module hdmi_connector(x, y, z) {
    color("silver") cube([x, y, z]);
}
module usbc_connector(x, y, z) {
    color("silver") cube([x, y, z]);
}
module capacitor(d, h) {
    color("silver") cylinder(r=(d / 2), h=h);
}
module micro_sd_card() {
    color("silver")   translate([1.5,  0.0, -1.5]) cube([12, 12.5, 1.5]);
    color("orange") translate([2, -3.2, -1.0]) cube([11, 15, 1.0]);
}
module audio_video(size_x) {
    fn = 64;
    color([58/255, 58/255, 58/255]) {
        cube([size_x, 7, 5.6]);
        translate([size_x, 7 / 2, 5.6 / 2]) rotate([0,90,0]) cylinder(d=5.6, h=2.6, $fn = fn);
    }
}

module cpu() {
    color("silver")
    cube([15,15,2.4]);
}

module ram() {
    color("black")
    cube([15,10.2,1]);
}

module wifi(){
    color("silver")
    cube([12,10,1.5]); 
}   

module cameracon(){
    color("black")
    cube([22,2.5,5.5]);
}


//------------------------------------------------------------------------
// Raspberry Pi 4 Model B
//------------------------------------------------------------------------
module board_raspberrypi_4_model_b(clearance = 0,IO_clear=1) {
    fn = 64;
    x  = 56;     y = 85;    z = 1.40;  // Measured PCB size
    ex = 15.9; ey = 21.5; ez = 13.5;   // Ethernet port size
    ux = 13.1; uy = 17.1; uz = 15.5;   // Measured USB connector size
    hx = 7.80; hy = 6.5; hz = 3;  // Measured micro HDMI connector size
    mx =  7.60; my =  9; mz = 3.20;  // Measured USB-C power connector size
    // The origin is the lower face of PCB.
    //IO_clear = 1;// Clearance around IO
    translate([0, 0, z]) {
        
        translate([56-32.5-7.5,3.5+25.75-7.5,0])  cpu();
        translate([56-32.5-7.5,3.5+43.75-7.5,0])  ram();
        translate([7,6.5,0])    wifi();
        translate([(56/2)-12,(4-1.25),0]) cameracon();
        translate([(56)-22.3,(45),0]) cameracon();
        translate([1.0, 7.1, 0])    pin_headers(2, 20);
        
        //
        translate([x-(ex/2)-45.75, y - ey + 2.1, 0])    ethernet_connector(ex, ey, ez);
        translate([x-(ux/2)-27, 85 - uy + 2.1, 0])  usb_connector(ux, uy, uz);
        translate([x-(ux/2)-9, 85 - uy + 2.1, 0])   usb_connector(ux, uy, uz);
        translate([x - hx + 1.8, (3.5+7.7+14.8-(hy/2)), 0]) hdmi_connector(hx, hy, hz);
        translate([x - hx + 1.8, (3.5+7.7+14.8+13.5-(hy/2)), 0])    hdmi_connector(hx, hy, hz);
        translate([x - 12.8, 50, 0])    audio_video(12.8);
        translate([x - mx + 1, (3.5+7.7-(my/2)), 0])    usbc_connector(mx, my, mz);
        translate([20.5, 0.8, -z])  micro_sd_card();
        translate([0, 0, -z]) {
            color("green") linear_extrude(height=z)
                difference() {
                    hull() {
                        translate([  3,   3]) circle(r=3, $fn = fn);
                        translate([x-3,   3]) circle(r=3, $fn = fn);
                        translate([x-3, y-3]) circle(r=3, $fn = fn);
                        translate([  3, y-3]) circle(r=3, $fn = fn);
                    }
                    raspberrypi_4_model_b_holes();
                }
        }
        if(clearance >0 ){ // render clearance holes
          //  echo("doing clearance");
          //  echo(clearance);
            //RHS:
            translate([53,0,-IO_clear])rotate([0,0,90])rotate([90,0,0])
              color("purple",0.5){
              linear_extrude(clearance){
                translate([6.5,0,z-IO_clear])square([mx+2*IO_clear,mz+2*IO_clear]); //USBC
                translate([(3.5+7.7+14.8-(hy/2)-IO_clear),0,0])
                  square([hy+2*IO_clear,hz+2*IO_clear]); // HDMI 1
                translate([(3.5+7.7+14.8+13.5-(hy/2))-IO_clear,0,0])
                  square([hy+2*IO_clear,hz+2*IO_clear]); //HDMI 2
                translate([50+7/2,7/2,])circle(d=5.6+2*IO_clear); //AV
              }
            }
        
            //LHS-top:
            //translate([0,0,-IO_clear])//rotate([0,0,90])//rotate([90,0,0])
              translate([0,y,0])rotate([0,0,-90])
              color("purple",0.5){
              linear_extrude(clearance){
                translate([27-IO_clear,1-IO_clear,0])square([20*2.54+2*IO_clear,2.54*2+2*IO_clear]); // GPIO
                translate([y-45-2.5-1*IO_clear,((56)-22.3-IO_clear),0])square([2.5+2*IO_clear,22+2*IO_clear]); //camera
              }
            }

            //front/SD:
            rotate([90,0])
              color("purple",0.5){
              linear_extrude(clearance){
                translate([20.5+2-IO_clear,-z-1-IO_clear,0])square([11+2*IO_clear,1+2*IO_clear]); // GPIO
              }
            }

            //back/USB:
            //translate([0,0,-IO_clear])//rotate([0,0,90])//rotate([90,0,0])
            //  translate([0,y,0])
            translate([x,y,0])rotate([0,0,180])rotate([90,0,0])
              color("purple",0.5){
                  // USB 1,2
              linear_extrude(clearance){
                translate([9-ux/2-IO_clear,0-IO_clear,0])square([ux+2*IO_clear,uz+2*IO_clear]);                  // USB 3,4
                translate([27-ux/2-IO_clear,0-IO_clear,0])square([ux+2*IO_clear,uz+2*IO_clear]);
                  // Ethernet
                translate([45.75-ex/2-IO_clear,0-IO_clear,0])square([ex+2*IO_clear,ez+2*IO_clear]);
              }
            }

        } //
    }
}

//------------------------------------------------------------------------
// Holes for Raspberry Pi 4 Model B
//------------------------------------------------------------------------
module raspberrypi_4_model_b_holes() {
    x = 56;
    fn = 64;
    translate([3.5, 3.5])            circle(r=(2.75 / 2), $fn=fn);
    translate([(x - 3.5), 3.5])      circle(r=(2.75 / 2), $fn=fn);
    translate([3.5, 3.5 + 58])       circle(r=(2.75 / 2), $fn=fn);
    translate([(x - 3.5), 3.5 + 58]) circle(r=(2.75 / 2), $fn=fn);
}

    
module carvedBox(){    
    translate([0,0,0])    
        difference(){
            cube([70,90,25]); // outer box
            translate([2,2,3]) Rp4ShapedHole();
        }
 }

module carvedSphere(){    
    translate([0,0,0])    
        difference(){
            sphere(d=110); // outer shape
            translate([-56/2,-85/2,0]) Rp4ShapedHole();
        }
 }


module Rp4ShapedHole(){
    union(){
        board_raspberrypi_4_model_b(clearance = 50,IO_clear=1);
        translate([0,0,-1.4-1.5*0-1.0])cube([56,85,15.5+1.4+1.5+1]);
    }
}



if (stl == 0){
    board_raspberrypi_4_model_b();
}
if (stl == 1){
    board_raspberrypi_4_model_b(clearance = 30,IO_clear=1);
}
if (stl == 2){
     carvedBox();
}
if (stl == 3){
     carvedSphere();
}


if (stl == 4){
     Rp4ShapedHole();
}

if (stl == 5){
    
    carvedBox();
    translate([2,2,3])
       #board_raspberrypi_4_model_b(clearance = 50,IO_clear=1);
}


