//This code creates a basic lego block with 4 connector dots

//Lego block body
difference() {
    color("red") cube(15);
    translate([1.5, 1.5, -1.5]) color("green") cube(12);
}

//Inner cylinder in block
difference() {
    translate([7.5, 7.5, 0]) cylinder(13, 3, 3, $fn=64);
    translate([7.5, 7.5, -1]) cylinder(13, 2.5, 2.5, $fn=64);
}

//Top Connector dots
translate([5, 10, 15]) cylinder(2, 2, 2, $fn=64);
translate([10, 10, 15]) cylinder(2, 2, 2, $fn=64);
translate([10, 5, 15]) cylinder(2, 2, 2, $fn=64);
translate([5, 5, 15]) cylinder(2, 2, 2, $fn=64);
