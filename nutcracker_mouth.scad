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
            [5, 15],         // Mid-section start
            [0, 15],         // Mid-section end
            [0, 0]           // Close the shape
        ]);
    }
    
    // Mid-section (5mm width) - GREEN
    color("green") {
        linear_extrude(height = 4)
        polygon(points = [
            [0, 15],         // Bottom-left of mid-section
            [5, 15],         // Bottom-right of mid-section
            [6.5, 20],       // Top-right (6.5mm width)
            [0, 20],         // Top-left (end of mid-section)
            [0, 15]          // Close the shape
        ]);
    }
    
    // Top section (6.5mm width) - BLUE
    color("blue") {
        linear_extrude(height = 4)
        polygon(points = [
            [0, 20],         // Bottom-left
            [6.5, 20],       // Bottom-right
            [6.5, 25],       // Extend further up if needed
            [0, 25],         // Top-left
            [0, 20]          // Close the shape
        ]);
    }
    
}

// Render the lever handle
lever_handle();

