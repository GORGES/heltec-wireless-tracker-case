// file: pet tracker top.scad
// desc: OpenSCAD file for Heltec Wireless Tracker Case
// author: Matthew Clark, mclark@gorges.us
// website: https://gorges.us
// github: https://github.com/GORGES
// license: Attribution-ShareAlike (mention author, keep license)
// date: 8/14/2024

// global settings

$fs = 0.03;   // set to 0.01 for higher definition curves

// variables

$skin_thickness = 1.4;
$chip_length = 66.2;
$chip_width = 28.4;
$clasp_extra = 0.05;
$clasp_hole = 3.2;
$display_lip = 1;
$extra = 2;
$gps_depth = $skin_thickness / 2;
$gps_offset = 54.3;
$gps_width = 21;
$inside_radius = 2;
$lip_height = 2.3;
$lip_inset = $skin_thickness / 2;
$logo_depth = 0.6;
$logo_line = 5;
$logo_start = 42;
$logo_width = 0.8;
$outside_radius = 3;
$screen_height = 12.0;
$screen_offset = 24.2;
$screen_radius = 1;
$screen_width = 23;
$spring_inset = 3.2;
$spring_offset = 22.1;
$spring_radius = 2.5;
$top_height = 4.8;
$usb_height = 4.3;
$usb_offset = 0.7;
$usb_width = 9;
$user_apart = 0.8;
$user_depth = 0.2;
$user_height = 1.6;
$user_length = 5;
$user_offset = 5.0;
$user_path = 0.4;
$user_radius = 3;
$user_remain = 1;
$user_separation = 7.8;
$user_start = 1;

// rounded-cube function

module roundedcube(
    size = [1, 1, 1], radius = 1.0,
    x = false, y = false, z = false,
    xmin = false, ymin = false, zmin = false,
    xmax = false, ymax = false, zmax = false
) {
	// if single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;
    all = !x && !xmin && !xmax && !y && !ymin && !ymax && !z && !zmin && !zmax;
    hull() {
        for (translate_x = [radius, size[0] - radius]) {
            x_at = (translate_x == radius) ? "min" : "max";
            for (translate_y = [radius, size[1] - radius]) {
                y_at = (translate_y == radius) ? "min" : "max";
                for (translate_z = [radius, size[2] - radius]) {
                    z_at = (translate_z == radius) ? "min" : "max";
                    translate(v = [translate_x, translate_y, translate_z])
                    if (all ||
                        x || (xmin && x_at == "min") || (xmax && x_at == "max") ||
                        y || (ymin && y_at == "min") || (ymax && y_at == "max") ||
                        (zmin && z_at == "min") || (zmax && z_at == "max")
                    ) {
                        sphere(r = radius);
                    } else {
                        rotate =
                            (x || xmin || xmax) ? [0, 90, 0] : (
                            (y || ymin || ymax) ? [90, 90, 0] :
                            [0, 0, 0]
                        );
                        translate([0, 0, 0])
                        rotate(a = rotate)
                        cylinder(h = 2 * radius, r = radius, center = true);
                    }
                }
            }
        }
    }
}

// top of case

difference() {
    // top box with lip
    roundedcube(
        size = [
            $chip_length + 2 * $skin_thickness,
            $chip_width + 2 * $skin_thickness,
            $skin_thickness + $top_height + 4 * $extra],
        radius = $outside_radius,
        zmin = true
    );
    union() {
        // clear the top
        translate([-$extra, -$extra, $skin_thickness + $top_height])
        cube([
            2 * $skin_thickness + $chip_length + 2 * $extra,
            2 * $skin_thickness + $chip_width + 2 * $extra,
            $skin_thickness + $top_height + 5 * $extra
        ]);
        // center void
        translate([
            $skin_thickness,
            $skin_thickness,
            $skin_thickness
        ]) {
            roundedcube(
                size = [
                    $chip_length,
                    $chip_width,
                    $skin_thickness + $top_height + $extra],
                radius = $inside_radius
            );
        };
        // lip void
        translate([
            $skin_thickness - $lip_inset,
            $skin_thickness - $lip_inset,
            $skin_thickness + $top_height - $lip_height,
        ]) {
            roundedcube(
                size = [
                    $chip_length + 2 * $lip_inset,
                    $chip_width + 2 * $lip_inset,
                    $lip_height + 2 * $inside_radius],
                radius = $inside_radius,
                z = true
            );
        };
        // screen hole
        translate([
            $skin_thickness + $screen_offset - $screen_width / 2,
            $skin_thickness + ($chip_width - $screen_height) / 2,
            -$extra
        ]) {
            roundedcube(
                size = [
                    $screen_width,
                    $screen_height,
                    $skin_thickness + 2 * $extra],
                radius = $screen_radius
            );
        }
        translate([
            $skin_thickness + $screen_offset - $screen_width / 2 - $screen_radius,
            $skin_thickness + ($chip_width - $screen_height) / 2 - $screen_radius,
            -4 * $extra
        ]) {
            roundedcube(
                size = [
                    $screen_width + 2 * $screen_radius,
                    $screen_height + 2 * $screen_radius,
                    $skin_thickness + 4 * $extra],
                radius = $screen_radius
            );
        }
        // gps hole
        translate([
            $skin_thickness + $gps_offset - $gps_width / 2,
            $skin_thickness + ($chip_width - $gps_width) / 2,
            $skin_thickness - $gps_depth
        ]) {
            cube([$gps_width, $gps_width, $gps_depth + $extra]);
        }
        // usb port
        translate([
            -$extra,
            $skin_thickness + ($chip_width - $usb_width) / 2,
            $skin_thickness + $usb_offset
        ]) {
            roundedcube(
                size = [
                    2 * $extra + $skin_thickness,
                    $usb_width,
                    $usb_height],
                radius = 0.8,
                x = true
            );
        }
        // meshtastic logo
        /*
        translate([$logo_start, $skin_thickness + $chip_width / 2, 0]) {
            translate([0, 2.4, 0])
            rotate([0, 0, 32])
            cube([$logo_line, $logo_width, $logo_depth], center = true);
            translate([0, 0, 0])
            rotate([0, 0, 32])
            cube([$logo_line, $logo_width, $logo_depth], center = true);
            translate([0, -2.4, 0])
            rotate([0, 0, -32])
            cube([$logo_line, $logo_width, $logo_depth], center = true);
        }
        */
        // user buttons
        translate([
            $skin_thickness + $user_offset,
            $skin_thickness + $chip_width / 2,
            0
        ]) {
            difference() {
                union() {
                    for (separation = [-$user_separation, $user_separation]) {
                        translate([0, separation, -$extra]) {
                            cylinder(h = $skin_thickness + 2 * $extra, r = $user_radius);
                        }
                    }
                    translate([
                        -$user_path / 2,
                        -$user_separation,
                        0
                    ]) {
                        for (apart = [-$user_apart, $user_apart]) {
                            translate([apart, 0, 0])
                                cube([
                                    $user_path,
                                    2 * $user_separation,
                                    $skin_thickness + 2 * $extra
                                ]);
                        }

                    }
                };
                union() {
                    translate([
                        -$user_apart + $user_path / 2,
                        -$user_separation,
                        0
                    ]) {
                        cube([
                            2 * $user_apart - $user_path,
                            2 * $user_separation,
                            $skin_thickness
                        ]);
                    };
                    translate([
                        -$user_apart - $user_path,
                        -$user_remain,
                        0
                    ]) {
                        cube([
                            2 * $user_apart + 2 * $user_path,
                            2 * $user_remain,
                            $skin_thickness
                        ]);
                    }
                };
            }
        }
        // spring antenna
        translate([
            $skin_thickness + $spring_offset,
            $skin_thickness + $spring_inset,
            $gps_depth
        ])
            cylinder(
                h = $skin_thickness + 2 * $extra,
                r = $spring_radius
            );
    }
}

// user buttons

translate([
    $skin_thickness + $user_offset,
    $skin_thickness + $chip_width / 2,
    0
]) {
    for (separation = [-$user_separation, $user_separation]) {
        translate([0, separation, 0])
            cylinder(
                h = $skin_thickness + $user_height,
                r1 = $user_radius - $user_depth,
                r2 = $user_radius - $user_depth - 0.75);
    }
}

// clasps

for (offset_x = [$chip_length / 3, 2 * $chip_length / 3]) {
    translate([
        $skin_thickness + offset_x - $clasp_hole / 2 - $clasp_extra,
        $lip_inset,
        $skin_thickness + $top_height
    ])
    rotate([0, 90, 0])
    linear_extrude(height = $clasp_hole - 2 * $clasp_extra)
    polygon(points = [
        [0, 0],
        [2 * $lip_inset - $clasp_extra, 0],
        [2 * $lip_inset - $clasp_extra, $lip_inset + $clasp_extra ]
    ]);
    translate([
        $skin_thickness + offset_x - $clasp_hole / 2 - $clasp_extra,
        $skin_thickness + $chip_width,
        $skin_thickness + $top_height
    ])
    rotate([0, 90, 0])
    linear_extrude(height = $clasp_hole - 2 * $clasp_extra)
    polygon(points = [
        [0, $lip_inset - $clasp_extra],
        [2 * $lip_inset - $clasp_extra, 0],
        [2 * $lip_inset - $clasp_extra, $lip_inset + $clasp_extra]
    ]);
}

