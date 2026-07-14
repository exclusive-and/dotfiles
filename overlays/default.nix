{ nurpkgs, ... }:

[
  (final: prev: {
    nur =
      if nurpkgs ? overlays then
        nurpkgs.overlays.default final prev
      else
        import nurpkgs {
          pkgs = prev;
          nurpkgs = prev;
        };
  })
  (final: prev: {
    firefox-addons = final.nur.repos.rycee.firefox-addons;
  })
]
