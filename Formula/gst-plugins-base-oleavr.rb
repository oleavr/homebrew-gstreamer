# Based on the formula from homebrew-core.

class GstPluginsBaseOleavr < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "git://github.com/oleavr/gst-plugins-base.git"
  version "1.12.0.r218.gb9aaa7f4f"

  bottle do
    root_url "https://github.com/oleavr/gst-plugins-base/releases/download/1.12.0.r218"
    sha256 "5ee40d04cd594d0181816017b200ee1fab3fb1a1367c2db46e4725c5af4da97d" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer-oleavr"

  # The set of optional dependencies is based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-base/tree/REQUIREMENTS
  # and Homebrew formulae
  depends_on "gobject-introspection"
  depends_on "orc" => :recommended
  depends_on "libogg" => :optional
  depends_on "opus" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional

  conflicts_with "gst-plugins-base"

  def install
    # gnome-vfs turned off due to lack of formula for it.
    args = %W[
      --prefix=#{prefix}
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=yes
    ]

    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin volume")
    assert_match version.to_s, output
  end
end
