// --- Configuration ---

// Total height of the entire part is 2 inches
total_height_in = 2;

// Lip height is now 2mm as requested
lip_height_mm = 2;

// SET YOUR FILLET RADIUS (the curve)
// This is the radius of the curve connecting the
// main body to the lip. It must be smaller than
// the lip's flat edge (which is ~6.35mm).
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
inner_dia_mm    = inner_dia_in * inch_to_mm;

// --- 3D Model ---

// We create the solid shape with rotate_extrude()
// and then cut the hole with difference().
difference() {
    
    // 1. Create the solid outer shape by rotating a 2D polygon
    rotate_extrude($fn = 100) {
        
        polygon( points = [
            [0, 0], // Start at center-bottom
            [lip_radius_mm, 0], // Lip outer-bottom edge
            [lip_radius_mm, lip_height_mm], // Lip outer-top edge
            
            // This is the flat part of the lip
            [main_radius_mm + fillet_radius_mm, lip_height_mm], 
            
            // This 'for' loop generates the curve (the fillet)
            for (a = [270 : -5 : 180]) [
                main_radius_mm + fillet_radius_mm * (1 + cos(a)), 
                lip_height_mm + fillet_radius_mm * (1 + sin(a))
            ],
            
            // Main body
            [main_radius_mm, total_height_mm], // Main body top-left
            [0, total_height_mm], // Center-top
            [0, 0] // Close path at center-bottom
        ]);
    }
    
    // 2. Subtract the hole all the way through
    // We start it 1mm below and make it 2mm taller
    // to ensure a clean cut.
    translate([0, 0, -1]) {
        cylinder(h = total_height_mm + 2, d = inner_dia_mm, $fn = 100);
    }
}