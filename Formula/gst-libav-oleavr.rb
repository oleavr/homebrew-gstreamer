# Based on the formula from homebrew-core.

class GstLibavOleavr < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "git://github.com/oleavr/gst-libav.git"
  version "1.12.0.r30.gc97d498"

  bottle do
    root_url "https://github.com/oleavr/gst-libav/releases/download/1.12.0.r30"
    sha256 "e821b93c5f2128a5f5f35ccb97428d88a598109a0ddf18dd6ad3398062cfa513" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "gst-plugins-base-oleavr"
  depends_on "xz" # For LZMA

  conflicts_with "gst-libav"

  def install
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh"

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
