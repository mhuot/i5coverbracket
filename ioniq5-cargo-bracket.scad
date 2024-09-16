thickness = 2;
innerx = 45;
innery = 47;
innerz = 34;
facets = 80;
offset = 10; // Offset for screw holes
headdiam = 8.5;

// The `polyhole` module is adapted from code by Nophead (of RepRap fame).
// Original code licensed under Creative Commons Attribution 3.0 Unported.
// https://creativecommons.org/licenses/by/3.0/
// Original source: https://github.com/nophead
module polyhole(h, d=0, r=0, center=false) {
    _r = (r == 0 ? d / 2 : r);
    _d = (d == 0 ? r * 2 : d);
    n = max(round(2 * _d), 3);

    rotate([0, 0, 180])
        cylinder(h=h, r=(_d / 2) / cos(180 / n), $fn=80, center=center);
}

// from https://gist.github.com/Stemer114/af8ef63b8d10287c825f
module screw_countersunk(l=20, dh=8.5, lh=7, ds=3.7) {
    union() {
        cylinder(h=lh, r1=dh / 2, r2=ds / 2, $fn=80);
        polyhole(h=l, d=ds);
    }
}

module screw_inset(d=8.5, h=2, facets=80) {
    cylinder(h=h, r=d / 2, $fn=facets);
}

module screw_with_inset(x, y, z) {
    translate([x, y, z]) {
        rotate([-90, 0, 0]) {
            screw_countersunk();
            translate([0, 0, -1.01])  // Slight adjustment for inset depth
                screw_inset();
        }
    }
}

difference() {
    // Main body structure
    union() {
        translate([0, thickness + innery, 0])
            color("blue", 1.0)
            cube([(thickness * 2) + innerx, 8, innerz + thickness]);

        cube([innerx + (2 * thickness), innery + (2 * thickness), innerz + thickness]);
    }

    // Inner cavity
    translate([thickness, thickness, thickness])
        cube([innerx, innery, innerz + thickness]);

    // Bottom cutout
    translate([(innerx + (2 * thickness)) / 2, (innery + (2 * thickness)) / 2, 0])
        cylinder(h=thickness + 0.1, r=(innerx / 2) - 2);

    // Slant the top
    translate([-1, 0, 8])
        rotate([30, 0, 0])
        cube([2 + innerx + (2 * thickness), 1 + innery + (2 * thickness) + 10, innerz + thickness]);
        
    // Screws with insets
    screw_with_inset(innerx - offset + thickness, innery + 3, 12);
    screw_with_inset(offset + thickness, innery + 3, 12);
    screw_with_inset(offset + thickness, innery + 3, innerz - 4);
    screw_with_inset(innerx - offset + thickness, innery + 3, innerz - 4);
}
