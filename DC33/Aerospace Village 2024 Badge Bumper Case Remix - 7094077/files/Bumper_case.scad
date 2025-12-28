// // // //
// INCLUDES
// // // //

// https://github.com/JohK/nutsnbolts
include <nutsnbolts/cyl_head_bolt.scad>;


// // // //
// PARAMETERS
// // // //

// Minimum angle for a fragment. The default value is 12 (i.e. 30 fragments
// for a full circle). The minimum allowed value is 0.01.
$fa = 1;
// Minimum size of a fragment. The default value is 2 so very small circles
// have a smaller number of fragments than specified using $fa. The minimum
// allowed value is 0.01.
$fs = 0.5;
// Number of fragments in a full circle. When this variable has a value
// greater than zero, the other two variables are ignored, and a full circle
// is rendered using this number of fragments.
$fn = 0;


// // // //
// FUNCTIONS
// // // //

// Two formulas have been identified for modifying the dimensions of
// hole diameters. To use these formulas, the x value is your desired
// diameter (for example 4 mm) and the y value is the adjusted diameter
// for your CAD model (in this case 4.34 mm). Use the vertical hole
// formula if the axis of the hole is parallel with the Z axis of the
// build plate and the horizontal hole formula if the axis of the hole
// is parallel with the X or Y axes. Both of these formulas are in
// millimeters.
//   y = 1.0155x + 0.2795 vertical
//   y = 0.9927x + 0.3602 horizontal
function dah(diameter, vertical = true) = vertical == true ? (1.0155 * diameter) + 0.2795 : (0.9927 * diameter) + 0.3602;


// // // //
// MODULES
// // // //

module fillet(r, h) {
    translate([r / 2, r / 2, 0]) {
        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r / 2, r / 2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
    }
}

module hsi(d, h) {
    union() {
        translate([0, 0, -(1.8 * h + 1) / 2 + 1])
            cylinder(d = dah(d), h = 1.8 * h + 1, center = true);

        cylinder(d1 = dah(d), d2 = dah(d) + 2, h = 2, center = true);
    }
}


// // // //
// MAIN
// // // //

$component = 1;

difference() {
    union() {
        if ($component & 1) {
            import("Aerospace Village 2024 Badge Case - Top.stl");
        }

        if ($component & 2) {
            union() {
                %import("Aerospace Village 2024 Badge Case - Base.stl");

                translate([47.4, -72.3, 8 / 2]) {
                    difference() {
                        cube([6, 6, 8], center = true);

                        translate([-6 / 2, 6 / 2, 0])
                            rotate([0, 0, -90])
                                fillet(2, 9);
                    }
                }
                translate([-47.4, -72.3, 8 / 2]) {
                    difference() {
                        cube([6, 6, 8], center = true);

                        translate([6 / 2, 6 / 2, 0])
                            rotate([0, 0, 180])
                                fillet(2, 9);
                    }
                }
            }
        }
    }
 
    // Lanyard holes
    translate([0, 67.65, 3]) {
        translate([41.1, 0, 0])
            cylinder(h = 20, d = 4.5, center = true);
        translate([-41.1, 0, 0])
            cylinder(h = 20, d = 4.5, center = true);
    }

    // SAO relief cut
    translate([-49.25, 35, 10 / 2 + 10])
        cube([3, 15, 10], center = true);
    intersection() {
        translate([-49.25, 35, 10 / 2 + 10])
            cube([3, 21, 10], center = true);

        union() {
            translate([-48.4, 35 + 15 / 2, 10 / 2 + 10])
                rotate([0, 0, 90])
                    fillet(4, 10);
            translate([-48.4, 35 - 15 / 2, 10 / 2 + 10])
                rotate([0, 0, 180])
                    fillet(4, 10);
        }
    }
    
    // RF connector relief cut
    translate([-56, 55.25, 10]) {
        rotate([0, 90, 0])
            cylinder(h = 20, d = 15, center = true);
        // chamfer
        translate([-1.2, 0, 0])
            rotate([0, 90, 0])
                cylinder(h = 10, d1 = 20, d2 = 1, center = true);
    }

    // FEL / RST relief cut
    translate([44.4, -29, 0])
        cube([12, 10, 10], center = true);

    // SD card relief cut
    translate([49 + 2.5, 0, 7.5])
        cube([3, 14, 5], center = true);

    // USB-C connector relief cut
    translate([-55.5, -14.75, 10 - 3.5]) {
        hull() {
            rotate([0, 90, 0]) {
                translate([0, 10 / 2 - 1, 0])
                    cylinder(h = 20, d = 10, center = true);
                translate([0, -10 / 2 + 1, 0])
                    cylinder(h = 20, d = 10, center = true);
            }
        }
        // chamfer
        translate([-3, 0, 0]) {
            hull() {
                rotate([0, 90, 0]) {
                    translate([0, 10 / 2 - 1, 0])
                        cylinder(h = 5, d1 = 13, d2 = 2, center = true);
                    translate([0, -10 / 2 + 1, 0])
                        cylinder(h = 5, d1 = 13, d2 = 2, center = true);
                }
            }
        }
    }
}