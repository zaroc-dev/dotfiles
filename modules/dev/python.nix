{ ... }: {
  flake.nixosModules.python =
    { pkgs, ... }:
    let
      pythonEnv = pkgs.python314.withPackages (
        ps: with ps; [
          pip
          ipython
          virtualenv
          notebook
          jupyter
        ]
      );
    in
    {
      environment.systemPackages = [
        pkgs.uv
        pkgs.poetry
        pkgs.ruff
        pythonEnv
      ];
    };
}
