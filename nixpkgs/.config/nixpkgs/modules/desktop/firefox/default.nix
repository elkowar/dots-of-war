{ config, lib, pkgs, ... }:
let
  cfg = config.elkowar.programs.firefox;
in
{
  options.elkowar.programs.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.leon = {
        isDefault = true;
        name = "Main profile";
        extraConfig = builtins.readFile /home/leon/desktop-dotfiles/files/firefoxChrome/chrome/userChrome.js;
        userChrome = builtins.readFile /home/leon/desktop-dotfiles/files/firefoxChrome/chrome/userChrome.css;
        userContent = builtins.readFile /home/leon/desktop-dotfiles/files/firefoxChrome/chrome/userContent.css;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.startup.homepage" = "file:///home/leon/.config/my_startpage/index.html";
          "browser.search.region" = "DE";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "de-DE";
          "general.useragent.locale" = "de-DE";
          "browser.bookmarks.showMobileBookmarks" = true;
          "general.smoothScroll" = true;
        };
      };
    };

  };
}
