project(
  'rofi-usd-mxn',
  'c',
  version: '1.0.0',
  default_options: ['warning_level=3'],
)

rofi = dependency('rofi', version: '>=2.0.0')

shared_module(
  'usd-mxn',
  'src/usd-mxn.c',
  dependencies: [
    rofi,
    dependency('glib-2.0'),
    dependency('gmodule-2.0'),
    dependency('cairo'),
  ],
  install: true,
  install_dir: rofi.get_variable('pluginsdir'),
  name_prefix: '',
)

usd_mxn_test = executable(
  'test-usd-mxn',
  ['tests/test-usd-mxn.c', 'src/usd-mxn.c'],
  dependencies: [
    rofi,
    dependency('glib-2.0'),
    dependency('gmodule-2.0'),
    dependency('cairo'),
  ],
)

test('usd-mxn', usd_mxn_test)
