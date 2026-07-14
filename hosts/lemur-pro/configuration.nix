{
  config
, pkgs
, nurpkgs
, ...
}:

{
    boot.kernelPackages = pkgs.linuxPackages;

    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;
      };
#            systemd-boot.enable = true;
    };

    imports = [
      ./hardware-configuration.nix
      ../../sw/slack
      ../../sw/vim
      ../../sw/openssh
      ../../sw/steam
    ];

    console.font = "Lat2-Terminus16";
    console.keyMap = "us";

    environment.systemPackages = with pkgs; [
      acpi
      curl
      lshw
      wget
    ];

    origami = {
        audio.enable = true;
        greet.enable = true;
        rofi.enable = true;
        xmonad.enable = true;

        xmonad.users = [
            "xand"
        ];
    };

    nixpkgs.config = {
        allowUnfree = true;
        input-fonts.acceptLicense = true;
    };

    users.users."xand" = {
        isNormalUser = true;
        extraGroups = ["audio" "wheel"];
        shell = pkgs.fish;
    };

    home-manager.users."xand" = {
        _module.args = {
            inherit nurpkgs;
        };

        imports = [
            ../../sw/direnv
            ../../sw/easyeffects
            ../../sw/firefox
            ../../sw/fish
            ../../sw/git
            ../../sw/vscodium
        ];

        nixpkgs.config = {
            allowUnfree = true;
        };

        home.homeDirectory = "/home/xand";
        home.username = "xand";
        home.stateVersion = "24.11";

        home.packages = with pkgs; [
            bitwarden-desktop
            coppwr
            pwvucontrol
            recordbox
            unzip
            zip
        ];

        news.display = "silent";

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        gtk = {
            enable = true;
            iconTheme = {
                name = "Kanagawa";
                package = pkgs.kanagawa-icon-theme;
            };
            theme = {
                name = "Kanagawa-B";
                package = pkgs.kanagawa-gtk-theme;
            };
        };
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    hardware.graphics.enable = true;
    hardware.system76.enableAll = true;

    fonts.packages = with pkgs; [
        hasklig
        input-fonts
        monaspace
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues nerd-fonts);

    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LANG    = "en_CA.UTF-8";
            LC_TIME = "C";
        };
        supportedLocales = [
            "en_US.UTF-8/UTF-8"
            "en_CA.UTF-8/UTF-8"
        ];
    };

    networking.hostName = "lemur-pro";

    networking = {
        extraHosts = ''
#            192.168.2.20    git.computeroid.org
        '';

        firewall.allowedTCPPorts = [
            22  # ssh
        ];

        networkmanager.enable = true;
    };

    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };

        package = pkgs.nix;

        settings = {
            auto-optimise-store = true;
            experimental-features = [
                "flakes"
                "nix-command"
            ];
            trusted-users = [
                "root"
                "xand"
                "@wheel"
            ];
            warn-dirty = false;
        };
    };

    programs = {
        dconf.enable = true;
        fish.enable = true;
        light = {
            enable = true;
            brightnessKeys.enable = true;
        };
        nix-ld.enable = true;
    };

    security = {
        polkit.enable = true;
        rtkit.enable = true;
    };

    services = {
        blueman.enable = true;

        dbus.enable = true;

        libinput.enable = true;

        pipewire = {
            enable = true;
            alsa.enable = true;
            audio.enable = true;
            jack.enable = true;
            pulse.enable = true;
            wireplumber.enable = true;
            extraConfig.pipewire."10-clock-rates" = {
                "context.properties" = {
                    "audio.format" = "s32le";
                    # "default.clock.rate" = 192000;
                    # "default.clock.allowed-rates" = [
                    #     192000
                    #     96000
                    #     48000
                    #     44100
                    # ];
                };
            };
        };

        seatd.enable = true;

        xserver = {
            verbose = 7;

            xkb.layout = "us";
        };
    };

    # See https://nixos.org/nixos/options.html.
    system.stateVersion = "20.09";
}
