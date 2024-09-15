// Parametric Box for Circuit Project with Clickable Lid

// Box dimensions
box_length = 100; // Adjust as needed
box_width = 80;   // Adjust as needed
box_height = 40;  // Adjust as needed
wall_thickness = 2;

// Lid specifications
lid_height = 5;
lid_tolerance = 0.5; // Adjust for tighter/looser fit

// Barrel jack specifications
barrel_jack_diameter = 5.5;
barrel_jack_depth = wall_thickness + 25; // Ensure it's longer than the wall thickness

// Mounting post specifications
post_height = 5;
post_diameter = 5;
screw_hole_diameter = 2;

// Create the main box
module main_box() {
    difference() {
        cube([box_length, box_width, box_height]);
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([box_length - 2*wall_thickness, 
                  box_width - 2*wall_thickness, 
                  box_height]);
    }
}

// Create the lid
module lid() {
    difference() {
        union() {
            // Main lid body
            cube([box_length, box_width, lid_height]);
            
            // Inner lip for clicking in
            translate([wall_thickness + lid_tolerance, wall_thickness + lid_tolerance, lid_height])
                cube([box_length - 2*(wall_thickness + lid_tolerance), 
                      box_width - 2*(wall_thickness + lid_tolerance), 
                      wall_thickness]);
        }
        // Hollow out the lid
        translate([wall_thickness, wall_thickness, -1])
            cube([box_length - 2*wall_thickness, 
                  box_width - 2*wall_thickness, 
                  lid_height - wall_thickness + 1]);
    }
}

// Create a barrel jack hole
module barrel_jack_hole() {
    cylinder(h = barrel_jack_depth, d = barrel_jack_diameter, $fn=32, center=true);
}

// Create a mounting post
module mounting_post() {
    difference() {
        cylinder(h = post_height, d = post_diameter, $fn=32);
        translate([0, 0, -1])
            cylinder(h = post_height + 2, d = screw_hole_diameter, $fn=32);
    }
}

// Main assembly
module assembly() {
    difference() {
        main_box();
        
        // West side barrel jack (centered vertically)
        translate([-1, box_width/2, box_height/2])
            rotate([0, 90, 0])
                barrel_jack_hole();
        
        // North side barrel jacks
        for (i = [1:5]) {
            translate([box_length * i/6, -1, box_height/2])
                rotate([90, 0, 0])
                    barrel_jack_hole();
        }
    }
    
    // Add mounting posts
    post_offset = 5;
    translate([post_offset, post_offset, wall_thickness]) mounting_post();
    translate([box_length - post_offset, post_offset, wall_thickness]) mounting_post();
    translate([post_offset, box_width - post_offset, wall_thickness]) mounting_post();
    translate([box_length - post_offset, box_width - post_offset, wall_thickness]) mounting_post();
}

// Render the assembly
assembly();

// Render the lid (uncomment to view/export separately)
translate([0, box_width + 10, 0]) lid();