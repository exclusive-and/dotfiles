{ config, lib, pkgs, ... }:

let
  
  cfg = config.origami.niri;

  forEachUser = lib.genAttrs cfg.users;

  niri-spicy = pkgs.callPackage (
    {
      lib,
      cmake,
      dbus,
      eudev,
      fetchFromGitHub,
      git,
      installShellFiles,
      libdisplay-info,
      libglvnd,
      libinput,
      libxkbcommon,
      libgbm,
      versionCheckHook,
      nix-update-script,
      pango,
      pipewire,
      pkg-config,
      python3,
      rustPlatform,
      seatd,
      shaderc,
      stdenv,
      systemd,
      wayland,
      withDbus ? true,
      withDinit ? false,
      withScreencastSupport ? true,
      withSystemd ? true,
    }:

    rustPlatform.buildRustPackage (finalAttrs: rec {
      pname = "niri";
      
      version = "26.4.0";

      src = pkgs.fetchFromGitHub {
        owner = "losnoco";
        repo = "niri";
        rev = "15c93f62b4a2963b0b3fe8f1732c3ea73f9396f5";
        hash = "sha256-0k0olAUEVfFMS7QhBTfOqEODjM1ab34VVnqPfo7uzQA=";
      };

      smithay-src = pkgs.fetchFromGitHub {
        owner = "losnoco";
        repo = "smithay";
        rev = "ce13557df3f29525f195816c112bbfebd4e5a822";
        hash = "sha256-yzYJ6ELVLZ+EkzuXQzSF1xZYylcP0e763lFV/nkNu+k=";
      };

      outputs = [
        "out"
        "doc"
      ];

      postUnpack = ''
        ln -s ${smithay-src} $TMPDIR/smithay
      '';

      postPatch = ''
        patchShebangs resources/niri-session
        substituteInPlace resources/niri.service \
          --replace-fail 'niri' "$out/bin/niri"
      '';

      cargoLock = {
        allowBuiltinFetchGit = true;
        lockFile = "${src}/Cargo.lock";
      };

      strictDeps = true;

      nativeBuildInputs = [
        cmake
        git
        installShellFiles
        pkg-config
        python3
        rustPlatform.bindgenHook
      ];

      buildInputs = [
        cmake
        git
        libdisplay-info
        libglvnd # For libEGL
        libinput
        libxkbcommon
        libgbm
        pango
        python3
        seatd
        shaderc
        wayland # For libwayland-client
      ]
      ++ lib.optional (withDbus || withScreencastSupport || withSystemd) dbus
      ++ lib.optional withScreencastSupport pipewire
      ++ lib.optional withSystemd systemd # Includes libudev
      ++ lib.optional (!withSystemd) eudev; # Use an alternative libudev implementation when building w/o systemd

      buildFeatures =
        lib.optional withDbus "dbus"
        ++ lib.optional withDinit "dinit"
        ++ lib.optional withScreencastSupport "xdp-gnome-screencast"
        ++ lib.optional withSystemd "systemd";
      buildNoDefaultFeatures = true;

      postInstall = ''
        install -Dm0644 README.md resources/default-config.kdl -t $doc/share/doc/niri
        mv docs/wiki $doc/share/doc/niri/wiki

        install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
      ''
      + lib.optionalString withDbus ''
        install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
      ''
      + lib.optionalString (withSystemd || withDinit) ''
        install -Dm0755 resources/niri-session -t $out/bin
      ''
      + lib.optionalString withSystemd ''
        install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/lib/systemd/user
      ''
      + lib.optionalString withDinit ''
        install -Dm0644 resources/dinit/niri{-shutdown,} -t $out/lib/dinit.d/user
      ''
      + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        installShellCompletion --cmd $pname \
          --bash <($out/bin/niri completions bash) \
          --fish <($out/bin/niri completions fish) \
          --nushell <($out/bin/niri completions nushell) \
          --zsh <($out/bin/niri completions zsh)
      '';

      env = {
        # Force linking with libEGL and libwayland-client
        # so they can be discovered by `dlopen()`
        RUSTFLAGS = toString (
          map (arg: "-C link-arg=" + arg) [
            "-Wl,--push-state,--no-as-needed"
            "-lEGL"
            "-lwayland-client"
            "-Wl,--pop-state"
          ]
        );

        # Upstream recommends setting the commit hash manually when in a
        # build environment where the Git repository is unavailable.
        # See https://github.com/niri-wm/niri/wiki/Packaging-niri#version-string
        NIRI_BUILD_COMMIT = "Nixpkgs";
      };

      checkFlags = [ "--skip=::egl" ];
      nativeInstallCheckInputs = [ ];
      doInstallCheck = true;

      passthru = {
        providedSessions = [ "niri" ];
        updateScript = nix-update-script { };
      };

      meta = {
        description = "Scrollable-tiling Wayland compositor";
        homepage = "https://github.com/niri-wm/niri";
        changelog = "https://github.com/niri-wm/niri/releases/tag/v${finalAttrs.version}";
        license = lib.licenses.gpl3Only;
        maintainers = with lib.maintainers; [
          sodiboo
          getchoo
          zimward
        ];
        mainProgram = "niri";
        platforms = lib.platforms.linux;
      };
    })
  ) {};

in
{
  options.origami = {
    niri = {
      enable = lib.mkOption {
        description = "Whether to enable Niri window manager.";
        type = lib.types.bool;
        default = false;
        example = true;
      };

      users = lib.mkOption {
        description = ''

        '';
        type = with lib.types; listOf str;
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.xwayland-satellite
    ];

    programs.xwayland.enable = true;

    services.displayManager.enable = true;
    services.displayManager.sessionPackages = [
      niri-spicy
    ];

    systemd.packages = [
      niri-spicy
    ];

    users.users = forEachUser (
      username: usercfg:
      {
        packages = [ niri-spicy ];
      }
    );

  };
}
