
{ self, inputs, ... }: {

	flake.nixosModules.acheronHardware = { config, lib, pkgs, modulesPath, ... }:
	{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9c5e0342-6838-4b94-8080-a21ddc960477";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/9c5e0342-6838-4b94-8080-a21ddc960477";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/9c5e0342-6838-4b94-8080-a21ddc960477";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/550C-AFD0";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2db278fe-78b1-4225-a071-9f53c3761adb"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
};
}
