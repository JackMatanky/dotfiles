{
  config,
  systemSettings,
  ...
}: {
  # Set your time zone.
  time.timeZone = systemSettings.timeZone;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = systemSettings.localeDefault;
    supportedLocales = [
      systemSettings.localeDefault
      systemSettings.localeSecondary
    ];
  };
  # i18n.defaultLocale = systemSettings.localeDefault;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.localeDefault;
    LC_IDENTIFICATION = systemSettings.localeDefault;
    LC_MEASUREMENT = systemSettings.localeDefault;
    LC_MONETARY = systemSettings.localeDefault;
    LC_NAME = systemSettings.localeDefault;
    LC_NUMERIC = systemSettings.localeDefault;
    LC_PAPER = systemSettings.localeDefault;
    LC_TELEPHONE = systemSettings.localeDefault;
    LC_TIME = systemSettings.localeDefault;
  };
}
