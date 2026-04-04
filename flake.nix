{
  description = "A flake for openclaude";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # Explicitly defining the package
      packages.${system} = {
        openclaude = pkgs.buildNpmPackage {
          pname = "openclaude";
          version = "0.1.7";

          src = pkgs.fetchFromGitHub {
            owner = "gitlawb";
            repo = "openclaude";
            rev = "main";
            hash = "sha256-tt/XMUhu54Db1+sPoLWxYMGtISRyB5M76JnlZp02V3M=";
          };

          # Inject the lockfile you generated
          postPatch = ''
            cp ${./package-lock.json} package-lock.json
          '';

          # Use the hash you got from the previous successful-ish build
          # If you don't have it, use pkgs.lib.fakeHash and run again
          npmDepsHash = "sha256-p0zY/I+AGeqsm3u1bnnKaQYcDdmmJzDid9vxBxAQWK4=";

          nativeBuildInputs = [ pkgs.makeWrapper pkgs.bun ];

          # buildNpmPackage handles the install; we just wrap it
          postInstall = ''
            wrapProgram $out/bin/openclaude \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
          '';
        };
        
        # Set the default package explicitly
        default = self.packages.${system}.openclaude;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ self.packages.${system}.default ];
      };
    };
}
