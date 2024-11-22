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
        "C.UTF-8"
        # systemSettings.localeDefault
        # systemSettings.localeSecondary
      ];
      allLocales = false; # Explicitly disable building all locales
    };
    defaultLocale = "C.UTF-8"; #systemSettings.localeDefault;
    supportedLocales = [
      "C.UTF-8"
      # systemSettings.localeDefault
      # systemSettings.localeSecondary
    ];
    extraLocaleSettings = {
      LC_ADDRESS = "C.UTF-8"; # systemSettings.localeDefault;
      LC_IDENTIFICATION = "C.UTF-8"; # systemSettings.localeDefault;
      LC_MEASUREMENT = "C.UTF-8"; # systemSettings.localeDefault;
      LC_MONETARY = "C.UTF-8"; # systemSettings.localeDefault;
      LC_NAME = "C.UTF-8"; # systemSettings.localeDefault;
      LC_NUMERIC = "C.UTF-8"; # systemSettings.localeDefault;
      LC_PAPER = "C.UTF-8"; # systemSettings.localeDefault;
      LC_TELEPHONE = "C.UTF-8"; # systemSettings.localeDefault;
      LC_TIME = "C.UTF-8"; # systemSettings.localeDefault;
    };
  };
}
