# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )
VALA_MIN_API_VERSION="0.30"
VALA_USE_DEPEND="vapigen"
DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1
GNOME2_ECLASS_ICONS=1
GNOME2_ECLASS_GLIB_SCHEMAS=1

inherit gnome2 python-single-r1 vala virtualx readme.gentoo-r1 meson

DESCRIPTION="Builder attempts to be an IDE for writing software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

# FIXME: Review licenses at some point
LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang +git sysprof vala webkit +cmake deviced gdb go +python +meson rust valgrind spell"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=x11-libs/gtk+-3.22.1:3[introspection]
	>=dev-libs/glib-2.50.0:2[dbus]
	>=x11-libs/gtksourceview-3.22.0:3.0[introspection,vala]
	>=dev-libs/gobject-introspection-1.48.0:=
	>=dev-python/pygobject-3.22.0:3
	>=dev-libs/libxml2-2.9.0
	>=x11-libs/pango-1.38.0
	>=dev-libs/libpeas-1.21[python,${PYTHON_USEDEP}]
	>=dev-libs/json-glib-1.2.0
	spell? (
		>=app-text/gspell-1.2.0
		>=app-text/enchant-2
	)
	webkit? ( >=net-libs/webkit-gtk-2.12.0:4=[introspection] )
	clang? ( sys-devel/clang:= )
	git? (
		dev-libs/libgit2[ssh,threads]
		>=dev-libs/libgit2-glib-0.25.0[ssh] )
	>=x11-libs/vte-0.46:2.91
	sysprof? ( >=dev-util/sysprof-3.23.91[gtk] )
	dev-libs/libpcre:3
	${PYTHON_DEPS}
	vala? ( $(vala_depend) )
	>=x11-libs/libdazzle-3.27
	>=dev-libs/template-glib-3.25
	>=dev-libs/jsonrpc-glib-3.25
	dev-util/devhelp
	cmake? ( dev-util/cmake )
	gdb? ( sys-devel/gdb )
	go? ( dev-lang/go )
	python? ( dev-python/jedi )
	meson? ( dev-util/meson )
	rust? ( dev-util/cargo )
	valgrind? ( dev-util/valgrind )
"
# desktop-file-utils for desktop-file-validate check in configure for 3.22.4
# mm-common due to not fully clean --disable-idemm behaviour, recheck on bump
DEPEND="${RDEPEND}
	dev-cpp/mm-common
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	!<sys-apps/sandbox-2.10-r3
"

# Tests fail if all plugins aren't enabled (webkit, clang, devhelp, perhaps more)
RESTRICT="test"

DOC_CONTENTS='gnome-builder can use various other dependencies on runtime to provide
extra capabilities beyond these expressed via USE flags. Some of these
that are currently available with packages include:

* dev-util/ctags with exuberant-ctags selected via "eselect ctags" for
  C, C++, Python, JavaScript, CSS, HTML and Ruby autocompletion, semantic
  highlighting and symbol resolving support.
* dev-python/jedi and dev-python/lxml for more accurate Python
  autocompletion support.
* dev-util/valgrind for integration with valgrind.
* dev-util/meson for integration with the Meson build system.
* dev-util/cargo for integration with the Rust Cargo build system.
'
# FIXME: Package gnome-code-assistance and mention here, or maybe USE flag and default enable because it's rather important
# eslint for additional diagnostics in JavaScript files
# jhbuild support
# rust language server via rls
# autotools stuff for autotools plugin; gtkmm/autoconf-archive for C++ template
# mono/PHPize stuff

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-D with_editorconfig=true
		-D with_vala_pack=$(usex vala true false)
		-D with_webkit=$(usex webkit true false)
		-D with_html_preview=$(usex webkit true false)
		-D with_html_completion=$(usex webkit true false)
		-D with_clang=$(usex clang true false)
		-D with_cmake=$(usex cmake true false)
		-D with_git=$(usex git true false)
		-D with_sysprof=$(usex sysprof true false)
		-D with_flatpak=false
		-D with_terminal=true
		-D with_gettext=true
		-D with_gdb=$(usex gdb true false)
		-D with_color_picker=true
		-D with_code_index=true
		-D with_command_bar=true
		-D with_comment_code=true
		-D with_create_project=true
		-D with_ctags=true
		-D with_documentation_card=true
		-D with_devhelp=true
		-D with_deviced=$(usex deviced true false)
		-D with_eslint=true
		-D with_file_search=true
		-D with_find_other_file=true
		-D with_gcc=true
		-D with_gjs_symbols=true
		-D with_gnome_code_assistance=true
		-D with_go_langserv=$(usex go true false)
		-D with_history=true
		-D with_jedi=$(usex python true false)
		-D with_jhbuild=false
		-D with_make=true
		-D with_meson=$(usex meson true false)
		-D with_meson_templates=$(usex meson true false)
		-D with_mono=false
		-D with_notification=true
		-D with_newcomers=true
		-D with_npm=false
		-D with_phpize=false
		-D with_project_tree=true
		-D with_python_gi_imports_completion=$(usex python true false)
		-D with_python_pack=$(usex python true false)
		-D with_quick_highlight=true
		-D with_retab=true
		-D with_rust_langserv=$(usex rust true false)
		-D with_rustup=$(usex rust true false)
		-D with_spellcheck=$(usex spell true false)
		-D with_support=true
		-D with_symbol_tree=true
		-D with_sysmon=true
		-D with_todo=true
		-D with_valgrind=$(usex valgrind true false)
		-D with_xml_pack=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data/gsettings" || die
}
