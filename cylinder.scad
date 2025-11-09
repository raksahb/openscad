// --- Configuration ---

// Total height of the entire part is 2 inches
total_height_in = 2;

// Lip height is 2mm as requested
// We will use this as the radius for the rounded-over edge.
lip_height_mm = 2;
roundover_radius_mm = lip_height_mm;

// Diameters
lip_dia_in   = 2 + 1/4;  // 2.25"
main_dia_in  = 1 + 3/4;  // 1.75"
inner_dia_in = 1 + 3/8;  // 1.375" (the hole)

// Conversion factor
inch_to_mm = 25.4;

// --- Calculations (convert to mm) ---
total_height_mm = total_height_in * inch_to_mm;
lip_radius_mm     = (lip_dia_in * inch_to_mm) / 2;
main_radius_mm    = (main_dia_in * inch_to_mm) / 2;
inner_dia_mm    = inner_dia_in * inch_to_mm;

// Calculate main body height
main_height_mm = total_height_mm - lip_height_mm;

// Check if radius is possible
if (roundover_radius_mm > (lip_radius_mm - main_radius_mm)) {
     echo("Error: Lip height (roundover) is larger than the lip's overhang!");
}

// --- 3D Model ---

difference() {
    
    // 1. Create the solid outer shape
    rotate_extrude($fn = 100) {
        
        // Define the 2D cross-section
        polygon( points = [
            [0, 0], // Start at center-bottom
            [main_radius_mm, 0], // Main body bottom-outer
            
            // This creates the straight vertical wall
            // of the main body.
            [main_radius_mm, main_height_mm], 
            
            // This creates the FLAT UNDERSIDE of the lip
            [lip_radius_mm, main_height_mm], 
            
            // This point starts the roundover
            [lip_radius_mm, total_height_mm - roundover_radius_mm], 
            
            // This 'for' loop generates the 90-degree
            // convex (dome) curve on the top-outer edge.
            for (a = [0 : 5 : 90]) [
                (lip_radius_mm - roundover_radius_mm) + roundover_radius_mm*cos(a), 
                (total_height_mm - roundover_radius_mm) + roundover_radius_mm*sin(a)
            ],
            
            // This creates the FLAT TOP of the lip
            [0, total_height_mm], // Center-top
            
            [0, 0] // Close path at center-bottom
        ]);
    }
    
    // 2. Subtract the straight inner hole
    translate([0, 0, -1]) {
        cylinder(h = total_height_mm + 2, d = inner_dia_mm, $fn = 100);
    }
}