#include <glib.h>

#include <rofi/mode-private.h>
#include <rofi/mode.h>

extern Mode mode;

void *mode_get_private_data(const Mode *switcher) {
  return switcher->private_data;
}

void mode_set_private_data(Mode *switcher, void *data) {
  switcher->private_data = data;
}

static void assert_display(const char *input, const char *expected) {
  char *processed = mode._preprocess_input(&mode, input);
  g_assert_cmpstr(processed, ==, input);
  g_free(processed);

  int state = 0;
  char *display = mode._get_display_value(&mode, 0, &state, NULL, TRUE);
  g_assert_cmpstr(display, ==, expected);
  g_free(display);
}

int main(void) {
  g_setenv("ROFI_USD_MXN_RATE", "17.3952", TRUE);
  g_setenv("ROFI_USD_MXN_RATE_DATE", "test time", TRUE);
  g_setenv("ROFI_USD_MXN_CACHED", "1", TRUE);

  g_assert_true(mode._init(&mode));
  g_assert_cmpuint(mode._get_num_entries(&mode), ==, 1);

  int state = 0;
  char *initial = mode._get_display_value(&mode, 0, &state, NULL, TRUE);
  g_assert_cmpstr(initial, ==, "1.00 USD  →  17.40 MXN");
  g_free(initial);

  assert_display("25", "25.00 USD  →  434.88 MXN");
  assert_display("$1,234.50 USD", "1,234.50 USD  →  21,474.37 MXN");
  assert_display("not money", "Enter a numeric USD amount");

  char *input = g_strdup("25");
  ModeMode result = mode._result(&mode, MENU_CUSTOM_COMMAND, &input, 0);
  g_assert_cmpint(result, ==, RELOAD_DIALOG);
  int reverse_state = 0;
  char *reverse = mode._get_display_value(&mode, 0, &reverse_state, NULL, TRUE);
  g_assert_cmpstr(reverse, ==, "25.00 MXN  →  1.44 USD");
  g_free(reverse);

  result = mode._result(&mode, MENU_CUSTOM_COMMAND, &input, 0);
  g_assert_cmpint(result, ==, RELOAD_DIALOG);
  assert_display("25", "25.00 USD  →  434.88 MXN");
  g_free(input);

  char *message = mode._get_message(&mode);
  g_assert_nonnull(strstr(message, "1 USD = 17.3952 MXN"));
  g_assert_nonnull(strstr(message, "USD → MXN"));
  g_assert_nonnull(strstr(message, "cached"));
  g_free(message);

  mode._destroy(&mode);
  g_assert_null(mode.private_data);
  return 0;
}
