logoDotRadius = 2.5;
logoDotDiameter = logoDotRadius * 2;
logoDotPadding = 1.5;
legoDotSide = logoDotDiameter + (logoDotPadding * 2);
legoDotHeight = 2;

module legoDot() {
    union() {
        translate([legoDotSide/2, legoDotSide/2, 0]) cylinder(legoDotHeight, logoDotRadius, logoDotRadius, $fn=64);
        translate([0, 0, -0.5]) cube([legoDotSide, legoDotSide, 0.5]);
    }
}

legoHeight = 10;
legoWidth = 16;

module LegoBlock() {
    legoWallThickness = 0.5;
    legoTopWallThickness = 1;
    legoInnerHeight = legoHeight;
    legoInnerWidth = legoWidth - (2 * legoWallThickness);
    legoInnerCylinderHeight = legoInnerHeight;
    legoInnerCylinderRadius = 3;
    legoInnerCylinderThickness = 0.5;
    legoInnerCylinder2Radius = legoInnerCylinderRadius - legoInnerCylinderThickness;
    legoInnerCyclinderCenter = legoWidth/2;
    union() {
        difference() {
            color("red") cube([legoWidth, legoWidth, legoHeight]);
            color("green") translate([legoWallThickness, legoWallThickness, -legoTopWallThickness]) cube([legoInnerWidth, legoInnerWidth, legoInnerHeight]);
        }

        difference() {
            translate([legoInnerCyclinderCenter, legoInnerCyclinderCenter, 0]) 
                cylinder(legoInnerCylinderHeight, legoInnerCylinderRadius, legoInnerCylinderRadius, $fn=64);
            translate([legoInnerCyclinderCenter, legoInnerCyclinderCenter, -1]) 
                cylinder(legoInnerCylinderHeight, legoInnerCylinder2Radius, legoInnerCylinder2Radius, $fn=64);
        }
        translate([0, 0, legoHeight]) legoDot();
        translate([legoDotSide, 0, legoHeight]) legoDot();
        translate([0, legoDotSide, legoHeight]) legoDot();
        translate([legoDotSide, legoDotSide, legoHeight]) legoDot();
    }
}

for (x =[0:2]) {
    translate([x * (10 + legoWidth), 0, 0]) LegoBlock();
}



