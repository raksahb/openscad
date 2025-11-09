// --- Configuration ---

// Total height of the entire part is 2 inches
total_height_in = 2;

// Lip height is 2mm as requested
lip_height_mm = 2;

// SET YOUR FILLET RADIUS (the curve)
// This will be used for both the inner and outer curve.
fillet_radius_mm = 3; // Example: 3mm curve

// Diameters from your drawing
lip_dia_in   = 2 + 1/4;  // 2.25"
main_dia_in  = 1 + 3/4;  // 1.75"
inner_dia_in = 1 + 3/8;  // 1.375" (the hole)

// Conversion factor
inch_to_mm = 25.4;

// --- Calculations (convert to mm) ---
total_height_mm = total_height_in * inch_to_mm;
lip_radius_mm     = (lip_dia_in * inch_to_mm) / 2;
main_radius_mm    = (main_dia_in * inch_to_mm) / 2;
inner_radius_mm   = (inner_dia_in * inch_to_mm) / 2;

// Check if fillet is too large
if (fillet_radius_mm > (main_radius_mm - inner_radius_mm)) {
    echo("Error: Fillet radius is too large!");
}
if (fillet_radius_mm > (lip_radius_mm - main_radius_mm)) {
     echo("Error: Fillet radius is too large!");
}

// --- 3D Model ---

// We subtract the "inner hole" shape from the "outer solid" shape.
difference() {
    
    // 1. Create the solid outer shape
    rotate_extrude($fn = 100) {
        
        // Define the 2D cross-section from the center outwards
        polygon( points = [
            [0, 0], // Start at center-bottom
            [lip_radius_mm, 0], // Lip outer-bottom edge
            [lip_radius_mm, lip_height_mm], // Lip outer-top edge
            
            // This is the flat part of the lip
            [main_radius_mm + fillet_radius_mm, lip_height_mm], 
            
            // This 'for' loop generates the outer curve (concave fillet)
            for (a = [270 : -5 : 180]) [
                (main_radius_mm + fillet_radius_mm) + fillet_radius_mm * cos(a), 
                (lip_height_mm + fillet_radius_mm) + fillet_radius_mm * sin(a)
            ],
            
            // Main body
            [main_radius_mm, total_height_mm], // Main body top-outer
            [0, total_height_mm], // Center-top
            [0, 0] // Close path at center-bottom
        ]);
    }
    
    // 2. Create and subtract the inner "hole" shape
    rotate_extrude($fn = 100) {
        
        // Define the 2D cross-section of the hole
        polygon( points = [
            [0, -1], // Start below the part for a clean cut
            [inner_radius_mm - fillet_radius_mm, -1],
            [inner_radius_mm - fillet_radius_mm, lip_height_mm],
            
            // This 'for' loop generates the inner curve (concave fillet)
            for (a = [270 : 5 : 360]) [
                (inner_radius_mm - fillet_radius_mm) + fillet_radius_mm * cos(a), 
                (lip_height_mm + fillet_radius_mm) + fillet_radius_mm * sin(a)
            ],
            
            // Main inner wall
            [inner_radius_mm, total_height_mm + 1], // End above the part
            [0, total_height_mm + 1],
            [0, -1] // Close path
        ]);
    }
}