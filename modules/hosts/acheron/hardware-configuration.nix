
{ self, inputs, ... }: {

	flake.nixosModules.acheronHardware = { config, lib, pkgs, modulesPath, ... }:
	{
        # Whatever results from `nixos-generate-config` goes here, but in a way that it can be easily merged with the configuration.nix file.
	};
}
