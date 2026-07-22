#include <errno.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include <glib.h>
#include <gmodule.h>

#include <rofi/mode-private.h>
#include <rofi/mode.h>
#include <rofi/rofi-types.h>

G_MODULE_EXPORT Mode mode;

typedef struct {
  double rate;
  char *rate_text;
  char *rate_date;
  char *input;
  char *display;
  gboolean cached;
  gboolean mxn_to_usd;
  gboolean valid;
} UsdMxnModeData;

static gboolean parse_amount(const char *input, double *amount) {
  if (input == NULL) {
    return FALSE;
  }

  char *lower = g_ascii_strdown(input, -1);
  GString *clean = g_string_new(NULL);
  for (const char *cursor = lower; *cursor != '\0'; cursor++) {
    if (g_ascii_isspace(*cursor) || *cursor == ',' || *cursor == '$') {
      continue;
    }
    g_string_append_c(clean, *cursor);
  }
  g_free(lower);

  if (g_str_has_suffix(clean->str, "usd") ||
      g_str_has_suffix(clean->str, "mxn")) {
    g_string_truncate(clean, clean->len - 3);
  }

  errno = 0;
  char *end = NULL;
  double parsed = g_ascii_strtod(clean->str, &end);
  gboolean valid = clean->len > 0 && end != clean->str && *end == '\0' &&
                   errno != ERANGE && isfinite(parsed);
  g_string_free(clean, TRUE);

  if (valid) {
    *amount = parsed;
  }
  return valid;
}

static char *format_money(double value) {
  gboolean negative = signbit(value) && value != 0.0;
  char *plain = g_strdup_printf("%.2f", fabs(value));
  char **parts = g_strsplit(plain, ".", 2);
  gsize digits = strlen(parts[0]);
  GString *formatted = g_string_new(negative ? "-" : "");

  for (gsize index = 0; index < digits; index++) {
    if (index > 0 && (digits - index) % 3 == 0) {
      g_string_append_c(formatted, ',');
    }
    g_string_append_c(formatted, parts[0][index]);
  }
  g_string_append_c(formatted, '.');
  g_string_append(formatted, parts[1] != NULL ? parts[1] : "00");

  g_strfreev(parts);
  g_free(plain);
  return g_string_free(formatted, FALSE);
}

static void update_conversion(UsdMxnModeData *data, const char *input) {
  g_free(data->input);
  g_free(data->display);
  data->input = g_strdup(input != NULL ? input : "");

  double amount = 0.0;
  double converted = 0.0;
  data->valid = parse_amount(input, &amount);
  if (data->valid) {
    converted = data->mxn_to_usd ? amount / data->rate : amount * data->rate;
    data->valid = isfinite(converted);
  }

  if (!data->valid) {
    data->display = g_strdup("Enter a numeric USD amount");
    return;
  }

  char *amount_text = format_money(amount);
  char *converted_text = format_money(converted);
  data->display =
      data->mxn_to_usd
          ? g_strdup_printf("%s MXN  →  %s USD", amount_text, converted_text)
          : g_strdup_printf("%s USD  →  %s MXN", amount_text, converted_text);
  g_free(amount_text);
  g_free(converted_text);
}

static int usd_mxn_mode_init(Mode *switcher) {
  if (mode_get_private_data(switcher) != NULL) {
    return TRUE;
  }

  const char *rate_text = g_getenv("ROFI_USD_MXN_RATE");
  if (rate_text == NULL || *rate_text == '\0') {
    g_warning(
        "ROFI_USD_MXN_RATE is not set; launch this mode with rofi-usd-mxn");
    return FALSE;
  }

  errno = 0;
  char *end = NULL;
  double rate = g_ascii_strtod(rate_text, &end);
  if (end == rate_text || *end != '\0' || errno == ERANGE || !isfinite(rate) ||
      rate <= 0.0) {
    g_warning("ROFI_USD_MXN_RATE is invalid");
    return FALSE;
  }

  UsdMxnModeData *data = g_malloc0(sizeof(*data));
  const char *rate_date = g_getenv("ROFI_USD_MXN_RATE_DATE");
  data->rate = rate;
  data->rate_text = g_strdup(rate_text);
  data->rate_date = g_strdup(rate_date != NULL ? rate_date : "unknown time");
  data->cached = g_strcmp0(g_getenv("ROFI_USD_MXN_CACHED"), "1") == 0;
  update_conversion(data, "1");
  mode_set_private_data(switcher, data);
  return TRUE;
}

static unsigned int usd_mxn_num_entries(G_GNUC_UNUSED const Mode *switcher) {
  return 1;
}

static int usd_mxn_token_match(G_GNUC_UNUSED const Mode *switcher,
                               G_GNUC_UNUSED rofi_int_matcher **tokens,
                               G_GNUC_UNUSED unsigned int index) {
  return TRUE;
}

static char *usd_mxn_display(const Mode *switcher,
                             G_GNUC_UNUSED unsigned int selected_line,
                             G_GNUC_UNUSED int *state,
                             G_GNUC_UNUSED GList **attributes, int get_entry) {
  if (!get_entry) {
    return NULL;
  }
  const UsdMxnModeData *data = mode_get_private_data(switcher);
  return g_strdup(data->display);
}

static char *usd_mxn_preprocess(Mode *switcher, const char *input) {
  UsdMxnModeData *data = mode_get_private_data(switcher);
  update_conversion(data, input);
  return g_strdup(input);
}

static char *usd_mxn_message(const Mode *switcher) {
  const UsdMxnModeData *data = mode_get_private_data(switcher);
  return g_markup_printf_escaped(
      "Google Finance rate: <b>1 USD = %s MXN</b> · <b>%s</b> · Tab switches "
      "direction · updated %s%s",
      data->rate_text, data->mxn_to_usd ? "MXN → USD" : "USD → MXN",
      data->rate_date, data->cached ? " · cached" : "");
}

static gboolean copy_result(const UsdMxnModeData *data) {
  const char *helper = g_getenv("ROFI_USD_MXN_HELPER");
  char *default_helper = NULL;
  if (helper == NULL || *helper == '\0') {
    default_helper = g_build_filename(g_get_home_dir(), ".local", "bin",
                                      "rofi-usd-mxn", NULL);
    helper = default_helper;
  }

  char *arguments[] = {
      (char *)helper,
      "--copy",
      data->input,
      "--rate",
      data->rate_text,
      "--direction",
      data->mxn_to_usd ? "mxn-usd" : "usd-mxn",
      NULL,
  };
  GError *error = NULL;
  gboolean launched = g_spawn_async(NULL, arguments, NULL, G_SPAWN_SEARCH_PATH,
                                    NULL, NULL, NULL, &error);
  if (!launched) {
    g_warning("Could not copy USD/MXN conversion: %s", error->message);
    g_error_free(error);
  }
  g_free(default_helper);
  return launched;
}

static ModeMode usd_mxn_result(Mode *switcher, int menu_return, char **input,
                               G_GNUC_UNUSED unsigned int selected_line) {
  UsdMxnModeData *data = mode_get_private_data(switcher);
  if ((menu_return & MENU_CUSTOM_COMMAND) &&
      (menu_return & MENU_LOWER_MASK) == 0) {
    const char *current_input = data->input;
    if (input != NULL && *input != NULL && **input != '\0') {
      current_input = *input;
    }
    char *preserved_input = g_strdup(current_input);
    data->mxn_to_usd = !data->mxn_to_usd;
    update_conversion(data, preserved_input);
    g_free(preserved_input);
    return RELOAD_DIALOG;
  }

  if ((menu_return & MENU_OK) || (menu_return & MENU_CUSTOM_INPUT)) {
    if (input == NULL || *input == NULL || **input == '\0') {
      update_conversion(data, "1");
    }
    if (!data->valid || !copy_result(data)) {
      return RELOAD_DIALOG;
    }
  }
  return MODE_EXIT;
}

static void usd_mxn_destroy(Mode *switcher) {
  UsdMxnModeData *data = mode_get_private_data(switcher);
  if (data == NULL) {
    return;
  }
  g_free(data->rate_text);
  g_free(data->rate_date);
  g_free(data->input);
  g_free(data->display);
  g_free(data);
  mode_set_private_data(switcher, NULL);
}

Mode mode = {
    .abi_version = ABI_VERSION,
    .name = "usd-mxn",
    .cfg_name_key = "display-usd-mxn",
    .display_name = NULL,
    ._init = usd_mxn_mode_init,
    ._destroy = usd_mxn_destroy,
    ._get_num_entries = usd_mxn_num_entries,
    ._result = usd_mxn_result,
    ._token_match = usd_mxn_token_match,
    ._get_display_value = usd_mxn_display,
    ._preprocess_input = usd_mxn_preprocess,
    ._get_message = usd_mxn_message,
    .private_data = NULL,
    .free = NULL,
    .type = MODE_TYPE_SWITCHER,
};
