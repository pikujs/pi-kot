{
  description = "pi-kot — browser UI for the pi coding agent";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/b5aa0fbd538984f6e3d201be0005b4463d8b09f8";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.buildNpmPackage {
        pname = "pi-kot";
        version = "0.1.38";
        src = self;
        # Discovered via build iteration (lib.fakeHash → paste `got:` value).
        npmDepsHash = lib.fakeHash;
        # Workspace support (packument caching). Always set BEFORE computing npmDepsHash.
        npmDepsFetcherVersion = 2;
        # node-pty node-gyp fallback (prebuild-install is tried first by node-pty itself).
        nativeBuildInputs = [ pkgs.python3 ];
        # Repo's postinstall patch (branch-summarization fix) — skipped by the
        # install hook's `npm ci --ignore-scripts`, so re-apply it in-tree.
        postInstall = ''
          node $out/lib/node_modules/pi-kot-monorepo/patch-branch-summary.mjs
        '';
        meta = {
          description = "Browser UI for the pi coding agent";
          homepage = "https://github.com/keemzin/pi-kot";
          license = lib.licenses.mit;
          mainProgram = "pi-kot";
        };
      };
    };
}