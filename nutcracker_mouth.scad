use <dotscad/pie.scad>;

// Updated Nutcracker Lever Handle Replacement with Color Debugging
module lever_handle() {
    // curved bottom section of handle
    translate([0,3.5,0]) rotate([0,0,270]) pie(3.5, 90, 4);
    
    // Bottom section (3.5mm width) - RED
    color("red") {
        linear_extrude(height = 4)
        polygon(points = [
            [0, 3.5],          // Bottom-left
            [3.5, 3.5],        // Bottom-right
            [5, 18],         // Mid-section start
            [0, 18],         // Mid-section end
        ]);
    }
    
//    // Mid-section (5mm width) - GREEN
    color("green") {
        linear_extrude(height = 4)
        polygon(points = [
            [0, 18],         // Bottom-left of mid-section
            [5, 18],         // Bottom-right of mid-section
            [10, 21],       // Top-right (6.5mm width)
            [0, 21],         // Top-left (end of mid-section)
            [0, 18]          // Close the shape
        ]);
    }
    
    // Top section (6.5mm width) - BLUE
    color("blue") {
        linear_extrude(height = 4)
        polygon(points = [
            [0, 21],         // Bottom-left
            [10, 21],       // Bottom-right
            [14, 23],       // Bottom-right
            [14, 26.5],
            [4, 26.5],       // Extend further up if needed
            [0, 21]          // Close the shape
        ]);
    }

    color("orange") {
        linear_extrude(height = 4)
        polygon(points = [
            [4, 26.5],       // Bottom-left
            [17.5, 26.5],       // Bottom-right
            [17.5, 31.5],
            [4, 26.5]          // Close the shape
        ]);
    }
    
    color("pink") translate([14,26.5,0]) rotate([0,0,270]) pie(3.5, 90, 4);
}

// Render the lever handle
//lever_handle();

module lever_handle_with_hole() {
    difference() {
    // Include the original lever handle code
    lever_handle();

    // Add the hole (1.5mm diameter)
    color("black")  // To visualize the hole
    translate([9.5, 22.5, -2])  // Position the hole (z = -2 ensures it cuts through)
//    rotate([90, 0, 0])  // Align the cylinder vertically
    cylinder(d = 1.5, h = 10, $fn = 100);  // Diameter = 1.5mm, Height = 10mm (ensures it cuts fully)
            // Notch to slide onto the pin
            translate([8.75, 18.5, -2])  // Offset to create the notch
            cube([1.5, 4, 8]);  // Width = 1.5mm, Height = 5mm, Depth = 4mm
        
    }
}

// Render the lever handle with the hole
lever_handle_with_hole();