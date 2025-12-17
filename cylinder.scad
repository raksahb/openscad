// --- Configuration ---

// Conversion factor (must be first)
inch_to_mm = 25.4;

// Total height of the entire part is 2 inches
total_height_in = 2;

// Lip height is 2mm as requested
lip_height_mm = 2;

// Dome parameters
dome_radius_in = 2;  // Sphere radius
dome_radius_mm = dome_radius_in * inch_to_mm;
dome_extension_in = 0.5;  // Extends 0.5" beyond main radius
dome_extension_mm = dome_extension_in * inch_to_mm;

// Diameters
lip_dia_in   = 2 + 1/4;  // 2.25"
main_dia_in  = 1 + 3/4;  // 1.75"
inner_dia_in = 1 + 3/8;  // 1.375" (the hole)

// --- Calculations (convert to mm) ---
total_height_mm = total_height_in * inch_to_mm;
lip_radius_mm     = (lip_dia_in * inch_to_mm) / 2;
main_radius_mm    = (main_dia_in * inch_to_mm) / 2;
inner_dia_mm    = inner_dia_in * inch_to_mm;

// Calculate main body height
main_height_mm = total_height_mm - lip_height_mm;

// Calculate dome geometry
// Edge radius of the dome at the flat underside plane
dome_edge_radius_mm = main_radius_mm + dome_extension_mm;
// Sphere center along Z so the plane z=main_height_mm cuts a circle of radius dome_edge_radius_mm
dome_center_z = main_height_mm - sqrt(dome_radius_mm*dome_radius_mm - dome_edge_radius_mm*dome_edge_radius_mm);
// Size used to clip the sphere into a cap (keeps only z >= main_height_mm)
cap_clip_size = 4 * dome_radius_mm;
// Top of the model (to ensure the inner hole reaches past the dome)
model_top_z = max(main_height_mm, dome_center_z + dome_radius_mm);
hole_height_mm = model_top_z + 20; // include margin and start below zero

// --- 3D Model ---

difference() {
    union() {
        // 1. Create the main cylinder body
        rotate_extrude($fn = 100) {
            polygon( points = [
                [0, 0], // Start at center-bottom
                [main_radius_mm, 0], // Main body bottom-outer
                [main_radius_mm, main_height_mm], // Main body top
                [0, main_height_mm], // Back to center
                [0, 0] // Close path
            ]);
        }

        // 2. Add the spherical cap on top (slice of a 2" radius sphere)
        intersection() {
            translate([0, 0, dome_center_z])
                sphere(r = dome_radius_mm, $fn = 100);
            // Keep only the portion above the flat underside plane z=main_height_mm
            translate([-cap_clip_size/2, -cap_clip_size/2, main_height_mm])
                cube([cap_clip_size, cap_clip_size, cap_clip_size], center = false);
        }
    }

    // 3. Subtract the straight inner hole through cylinder and dome
    translate([0, 0, -10]) {
        cylinder(h = hole_height_mm, d = inner_dia_mm, $fn = 100);
    }
}