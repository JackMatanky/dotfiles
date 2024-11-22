{
  config,
  pkgs,
  systemSettings,
  ...
}: {
  # Set your time zone.
  time.timeZone = systemSettings.timeZone;

  # Select internationalisation properties.
  i18n = {
    glibcLocales = pkgs.glibcLocales.override {
      locales = [
        systemSettings.localeDefault
        systemSettings.localeSecondary
      ];
      allLocales = false; # Explicitly disable building all locales
    };
    defaultLocale = systemSettings.localeDefault;
    supportedLocales = [
      systemSettings.localeDefault
      systemSettings.localeSecondary
    ];
    extraLocaleSettings = {
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
  };
}
