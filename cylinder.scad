// --- Configuration ---

// Total height of the entire part is 2 inches
total_height_in = 2;

// SET YOUR LIP HEIGHT HERE (in inches)
// This is the thickness of the 2 1/4" diameter lip.
lip_height_in = 1/4;   // Example: 1/4 inch thick lip

// Diameters from your drawing
lip_dia_in   = 2 + 1/4;  // 2.25"
main_dia_in  = 1 + 3/4;  // 1.75"
inner_dia_in = 1 + 3/8;  // 1.375" (the hole)

// Conversion factor
inch_to_mm = 25.4;

// --- Calculations (convert inches to mm) ---

// Calculate main height
main_height_in = total_height_in - lip_height_in;

if (main_height_in <= 0) {
    echo("Error: Lip height is >= total height!");
}

// Convert all dimensions to mm
main_height_mm = main_height_in * inch_to_mm;
lip_height_mm  = lip_height_in * inch_to_mm;
lip_dia_mm     = lip_dia_in * inch_to_mm;
main_dia_mm    = main_dia_in * inch_to_mm;
inner_dia_mm   = inner_dia_in * inch_to_mm;
total_height_mm = total_height_in * inch_to_mm;

// --- 3D Model ---

difference() {
    
    // 1. Combine the solid parts (lip + main body)
    union() {
        
        // The Lip (sits on the "floor" at Z=0)
        // We do NOT use center=true here.
        cylinder(h = lip_height_mm, d = lip_dia_mm);
        
        // The Main Body (sits on top of the lip)
        // We translate it up by the lip's height.
        translate([0, 0, lip_height_mm]) {
            cylinder(h = main_height_mm, d = main_dia_mm);
        }
    }
    
    // 2. Subtract the hole all the way through
    // We start the hole 1mm *below* the part (z=-1)
    // and make it 2mm *taller* than the total height
    // to guarantee it cuts cleanly through the top and bottom.
    translate([0, 0, -1]) {
        cylinder(h = total_height_mm + 2, d = inner_dia_mm);
    }
}