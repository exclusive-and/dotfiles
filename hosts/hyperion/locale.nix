{
  time.timeZone = "America/Montreal";
 
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANG    = "en_CA.UTF-8";
    LC_TIME = "C";
  }; 
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_CA.UTF-8/UTF-8"
  ];

  services.xserver.xkb.layout = "us";
}
