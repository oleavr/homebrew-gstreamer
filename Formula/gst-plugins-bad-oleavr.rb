# Based on the formula from homebrew-core.

class GstPluginsBadOleavr < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "git://github.com/oleavr/gst-plugins-bad.git"
  version "1.12.0.r579.gb9634580c"

  bottle do
    root_url "https://github.com/oleavr/gst-plugins-bad/releases/download/1.12.0.r579"
    sha256 "bac4328741a378caa1db0af67b4a6b1ec662dca77980d0a9a74e8a315143e18a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base-oleavr"
  depends_on "libnice-oleavr"
  depends_on "openssl"
  depends_on "jpeg" => :recommended
  depends_on "orc" => :recommended
  depends_on "dirac" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "gnutls" => :optional
  depends_on "gtk+3" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libexif" => :optional
  depends_on "libmms" => :optional
  depends_on "opencv@2" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sound-touch" => :optional
  depends_on "srtp@1.6" => :optional
  depends_on "libvo-aacenc" => :optional

  conflicts_with "gst-plugins-bad"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-examples
      --disable-debug
      --disable-dependency-tracking
    ]

    args << "--with-gtk=3.0" if build.with? "gtk+3"

    # autogen is invoked in "stable" build because we patch configure.ac
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
