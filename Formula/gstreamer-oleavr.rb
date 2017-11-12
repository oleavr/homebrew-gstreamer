# Based on the formula from homebrew-core.

class GstreamerOleavr < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "git://github.com/oleavr/gstreamer.git"
  version "1.12.0.r189.ge1f039b7f"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "gobject-introspection"
  depends_on "gettext"
  depends_on "glib"
  depends_on "bison"

  conflicts_with "gstreamer"

  def install
    args = %W[
      --prefix=#{prefix}
      --buildtype release
      --strip
      -Ddisable_gst_debug=true
      -Ddisable_gtkdoc=true
      -Ddisable_introspection=false
    ]

    # Ban trying to chown to root.
    # https://bugzilla.gnome.org/show_bug.cgi?id=750367
    args << "-Dwith-ptp-helper-permissions=none"

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "meson.build", /cdata\.set_quoted\('PLUGINDIR', [^\n]+/,
      "cdata.set_quoted('PLUGINDIR', '#{HOMEBREW_PREFIX}/lib/gstreamer-1.0')"

    system "meson", *args, "_build", "."
    system "ninja", "-C", "_build", "install"
  end

  test do
    system bin/"gst-inspect-1.0"
  end
end
