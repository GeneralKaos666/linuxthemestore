project('linuxthemestore', 'rust', version: '0.1.0')

dependency('glib-2.0')
dependency('gio-2.0')
dependency('gtk4')
dependency('libadwaita-1')

gnome = import('gnome')
cargo = find_program('cargo', required: true)
sources = [
    'src/main.rs',
]

cargo_script = find_program(join_paths(meson.project_source_root(), 'build-aux/cargo.sh'))
cargo_release = custom_target(
  'cargo-build',
  build_by_default: true,
  input: sources,
  output: meson.project_name(),
  console: true,
  install: true,
  install_dir: get_option('bindir'),
  command: [
    cargo_script,
    meson.project_build_root(),
    meson.project_source_root(),
    '@OUTPUT@',
    get_option('buildtype'),
    meson.project_name(),
  ]
)


# Install the app icon
install_data(
  'assets/io.github.debasish_patra_1987.linuxthemestore.svg',
  install_dir: join_paths(get_option('datadir'), 'icons/hicolor/scalable/apps'),
)

install_data(
  'assets/io.github.debasish_patra_1987.linuxthemestore.desktop',
  install_dir: join_paths(get_option('datadir'), 'applications'),
  install_mode: ['rw-r--r--']
)

install_data('assets/io.github.debasish_patra_1987.linuxthemestore.metainfo.xml',
  install_dir: join_paths(get_option('datadir'), 'metainfo'),
  install_mode: ['rw-r--r--']
)

gnome.post_install(
    gtk_update_icon_cache: true,
    update_desktop_database: true,
)
