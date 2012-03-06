#!/usr/bin/perl

open(IN, "/usr/X11/share/X11/rgb.txt");

print <<__EOF__;
#ifndef __CVUT_COLOR_X11__
#define __CVUT_COLOR_X11__ 1

__EOF__

foreach (<IN>) {
#    print; next;
    chomp;
    next if ( /^#/ );
    m/(\d+)\s+(\d+)\s+(\d+)\s+(.*)/;
    next if ( $4 =~ m/\s/ );
    my $def  = sprintf "cv::Vec3b(0x%02X, 0x%02X, 0x%02X)", $1, $2, $3;
    my $name = "CVUT_COLOR_" . uc($4);
    my $l = 25 - length($name);

#    print "#ifndef $name\n#define $name " . (" " x $l) . " $def\n#endif\n\n";
    print "#define $name " . (" " x $l) . " $def\n"
}

print <<__EOF__;

#endif
__EOF__

