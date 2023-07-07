{
  description = "Quick Python starter environment";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default =
          let
            python = pkgs.python311;
          in
          pkgs.mkShell {
            packages = [
              (python.withPackages (ps: with ps; [
                virtualenv
                pip
              ]))
              pkgs.bashInteractive
            ];
            shellHook = ''
              echo "Checking for virtual environment..."

              if [ ! -d ".venv" ]; then
                echo "Creating a new virtual environment..."
                virtualenv .venv
              else
                echo "Using existing virtual environment..."
              fi

              # Activate the virtual environment
              echo "Activating virtual environment..."
              source .venv/bin/activate

            

            '';
          };
      });
    };
}
