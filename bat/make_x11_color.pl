#!/usr/bin/perl

open(IN, "rgb.txt");

print <<__EOF__;
#ifndef __CVUT_COLOR_X11__
#define __CVUT_COLOR_X11__ 1

namespace cvut{
	class Color{
	public:
		uint8_t b, g, r;
		cv::Vec3b vec3b;
		cv::Vec3s vec3s;
		cv::Vec3i vec3i;
		cv::Vec3f vec3f;
		cv::Vec3d vec3d;
		cv::Vec4b vec4b;
		cv::Vec4s vec4s;
		cv::Vec4i vec4i;
		cv::Vec4f vec4f;
		cv::Vec4d vec4d;

		Color(uint8_t b, uint8_t g, uint8_t r)
			: b(b), g(g), r(r)
			, vec3b(b, g, r)
			, vec3s(b * 255, g * 255, r * 255)
			, vec3i(b * 255, g * 255, r * 255)
			, vec3f(b / 255.0f, g / 255.0f, r / 255.0f)
			, vec3d(b / 255.0,  g / 255.0,  r / 255.0 )
			, vec4b(vec3b[0], vec3b[1], vec3b[2], 0)
			, vec4i(vec3i[0], vec3i[1], vec3i[2], 0)
			, vec4f(vec3f[0], vec3f[1], vec3f[2], 0)
			, vec4d(vec3d[0], vec3d[1], vec3d[2], 0)
		{
		}

		operator const cv::Vec3b&() const{return vec3b;}
		operator const cv::Vec3s&() const{return vec3s;}
		operator const cv::Vec3i&() const{return vec3i;}
		operator const cv::Vec3f&() const{return vec3f;}
		operator const cv::Vec3d&() const{return vec3d;}
		operator const cv::Vec4b&() const{return vec4b;}
		operator const cv::Vec4s&() const{return vec4s;}
		operator const cv::Vec4i&() const{return vec4i;}
		operator const cv::Vec4f&() const{return vec4f;}
		operator const cv::Vec4d&() const{return vec4d;}


		template <typename _T>
		operator const cv::Point3_<_T>&() const{
			return reinterpret_cast<const cv::Point3_<_T>&>(static_cast<cv::Vec<_T,3>>(*this));
		}
	};
	namespace color{
__EOF__

my @colors = <IN>;
my $name;
my $def;

foreach (@colors) {
    chomp;
    next if ( /^#/ );
    next if (! m/(\d+)\s+(\d+)\s+(\d+)\s+(.*)/);

#    $name .= "static const olor " . uc($4) . "\n";
    $def  .= sprintf "    static const Color %s%s(0x%02X, 0x%02X, 0x%02X);\n",
		 uc($4), ' ' x (24 - length($4)), $3, $2, $1;
}

print $def;

print <<__EOF__;
  }
}
#endif
__EOF__

