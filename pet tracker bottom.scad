// file: pet tracker bottom.scad
// desc: OpenSCAD file for Heltec Wireless Tracker Case
// author: Matthew Clark, mclark@gorges.us
// website: https://gorges.us
// github: https://github.com/GORGES
// license: Attribution-ShareAlike (mention author, keep license)
// initial date: 8/14/2024
// modified date: 8/18/2024

// global settings

$fs = 0.03;   // set to 0.01 for higher definition curves

// variables

$skin_thickness = 1.4;
$antenna_radius = 3.3;
$antenna_rail = 5.0;
$chip_height = 15.0;
$chip_length = 67.0;
$chip_width = 28.4;
$clasp_extra = 0.15;
$clasp_offset = 2.5;
$clasp_radius = 2.0;
$clasp_screw = 0.7; // 0.1 less than top
$extra = 2;
$inside_radius = 1.0;
$lip_height = 2.0;
$lip_inset = $skin_thickness / 2;
$outside_radius = 2.8;
$rail_height = $chip_height - 1.2;
$rail_thickness = 1.6;
$strap_angle = 8;
$strap_inset = 5.2;
$strap_offset = 3.3;
$strap_radius = 2.2;
$trough_radius = 2.2;
$usb_height = 3.5;
$usb_offset = 1.6;
$usb_width = 9;

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
                        rotate(a = rotate)
                        cylinder(h = 2 * radius, r = radius, center = true);
                    }
                }
            }
        }
    }
}

// bottom of case

union() {
    difference() {
        difference() {
            union() {
                // box
                roundedcube(
                    size = [
                        $chip_length + 2 * $skin_thickness,
                        $chip_width + 2 * $skin_thickness,
                        $skin_thickness + $chip_height],
                    radius = $outside_radius,
                    zmin = true
                );
                // lip
                translate([
                  $lip_inset,
                  $lip_inset,
                  $skin_thickness + $chip_height  / 2
                ])
                roundedcube(
                    size = [
                        $chip_length + 2 * ($skin_thickness - $lip_inset),
                        $chip_width + 2 * ($skin_thickness - $lip_inset),
                        $chip_height / 2 + $lip_height],
                    radius = $outside_radius,
                    zmin = true
                );
                // usb extra
                translate([
                    0,
                    $skin_thickness + ($chip_width - $usb_width) / 2,
                    $skin_thickness + $chip_height
                ])
                cube([
                    $skin_thickness,
                    $usb_width,
                    $lip_height
                ]);
            };
            union() {
                // chip cutout
                translate([
                    2 * $skin_thickness,
                    $skin_thickness,
                    $skin_thickness + $rail_height
                ])
                cube([
                    $chip_length - 2 * $skin_thickness,
                    $chip_width,
                    $chip_height - $rail_height + $extra
                ]);
                // antenna hole
                translate([
                    $chip_length - 2 * $extra,
                    $skin_thickness + $chip_width / 2,
                    $skin_thickness + $rail_height / 2
                ])
                rotate([0, 90, 0])
                cylinder(h = $skin_thickness + 6 * $extra, r = $antenna_radius);
                // clasp end holes
                for (offset_y = [$chip_width / 4, 3 * $chip_width / 4]) {
                    translate([
                        -$extra,
                        $skin_thickness + offset_y - $clasp_radius,
                        $skin_thickness + $chip_height - $clasp_offset
                    ])
                    cube([
                        $skin_thickness + $extra + $clasp_extra,
                        2 * $clasp_radius,
                        $clasp_offset + $clasp_radius + $extra
                    ]);
                    translate([
                        -$extra,
                        $skin_thickness + offset_y,
                        $skin_thickness + $chip_height - $clasp_offset
                    ])
                    rotate([0, 90, 0])
                    cylinder(h = 2 * $skin_thickness + 2 * $extra, r = $clasp_radius + $clasp_extra);
                }
                // clasp end hole
                translate([
                    $skin_thickness + $chip_length - $clasp_extra,
                    $skin_thickness + $chip_width / 2 - $clasp_radius,
                    $skin_thickness + $chip_height - $clasp_offset
                ])
                cube([
                    $skin_thickness + $clasp_extra + $extra,
                    2 * $clasp_radius,
                    $clasp_offset + $clasp_radius + $extra
                ]);
                translate([
                    $skin_thickness + $chip_length - $clasp_extra,
                    $skin_thickness + $chip_width / 2,
                    $skin_thickness + $chip_height - $clasp_offset
                ])
                rotate([0, 90, 0])
                cylinder(h = $skin_thickness + $clasp_extra + 2 * $extra, r = $clasp_radius + $clasp_extra);
                translate([
                    $skin_thickness + $chip_length - $skin_thickness - $extra,
                    $skin_thickness + $chip_width / 2,
                    $skin_thickness + $chip_height - $clasp_offset
                ])
                rotate([0, 90, 0])
                cylinder(h = $skin_thickness + 2 * $extra, r = $clasp_screw);
            }
        }
        union() {
            // center void
            translate([
                2 * $skin_thickness,
                $skin_thickness,
                $skin_thickness
            ])
            roundedcube(
                size = [
                    $chip_length - 2 * $skin_thickness,
                    $chip_width,
                    $skin_thickness + $chip_height + $lip_height + $extra],
                radius = $inside_radius,
            );
            // usb port
            translate([
                -$extra,
                $skin_thickness + ($chip_width - $usb_width) / 2,
                $skin_thickness + $chip_height + $lip_height - $usb_offset
            ])
            roundedcube(
                size = [
                    2 * $extra + $skin_thickness,
                    $usb_width,
                    $usb_height],
                radius = 0.8,
                x = true
            );
            // strap holes
            for (offset_x = [0, 2 * $skin_thickness + $chip_length]) {
                for (offset_y = [0, 2 * $skin_thickness + $chip_width]) {
                    translate([offset_x, offset_y, $skin_thickness + $strap_offset])
                    rotate_extrude(angle = 360)
                    translate([$skin_thickness + $strap_inset, 0, 0])
                    circle(r = $strap_radius);
                }
            }
        }
    }

    union() {
        // chip rails
        translate([
            $skin_thickness,
            $skin_thickness,
            $skin_thickness + $rail_height
        ])
        rotate([0, 90, 0])
        linear_extrude(height = $chip_length)
        polygon(points = [
            [0, 0],
            [2 * $rail_thickness, 0],
            [0, $rail_thickness]
        ]);
        translate([
            $skin_thickness,
            $skin_thickness + $chip_width,
            $skin_thickness + $rail_height
        ])
        rotate([0, 90, 0])
        linear_extrude(height = $chip_length)
        polygon(points = [
            [0, 0],
            [2 * $rail_thickness, 0],
            [0, -$rail_thickness]
        ]);
        // antenna block
        difference() {
            translate([
                $chip_length - $antenna_rail,
                $skin_thickness + $chip_width / 2 - ($antenna_radius + $skin_thickness),
                0
            ])
            roundedcube(
                size = [
                    $antenna_rail + $clasp_extra,
                    2 * ($skin_thickness + $antenna_radius),
                    $skin_thickness + $rail_height
                ],
                radius = 0.8,
                xmin = true
            );
            // antenna hole & screw hole
            union() {
                translate([
                    $skin_thickness + $chip_length - $antenna_rail - $extra,
                    $skin_thickness + $chip_width / 2,
                    $skin_thickness + $rail_height / 2
                ])
                rotate([0, 90, 0])
                cylinder(h = $antenna_rail + 2 * $extra, r = $antenna_radius);
                // screw hole
                translate([
                    $skin_thickness + $chip_length - $antenna_rail - $extra,
                    $skin_thickness + $chip_width / 2,
                    $skin_thickness + $chip_height - $clasp_offset
                ])
                rotate([0, 90, 0])
                cylinder(h = $antenna_rail + $skin_thickness + 2 * $extra, r = $clasp_screw);
            };
        };
        // strap tubes
        for (offset_x = [0, 2 * $skin_thickness + $chip_length]) {
            for (offset_y = [0, 2 * $skin_thickness + $chip_width]) {
                translate([offset_x, offset_y, $skin_thickness + $strap_offset])
                rotate([
                    0,
                    0,
                    (offset_x
                        ? (offset_y ? 180 + $strap_angle : 90 + $strap_angle)
                        : (offset_y ? -90 + $strap_angle : $strap_angle))
                ])
                rotate_extrude(angle = 90 - 2 * $strap_angle)
                translate([$skin_thickness + $strap_inset, 0, 0])
                difference() {
                    circle(r = $skin_thickness + $strap_radius);
                    circle(r = $strap_radius);
                };
            }
        }
    }
}
