{
  self,
  inputs,
  lib,
  ...
}:
let
  userName = "richard";
in
{
  # system-level user declaration
  flake.nixosModules.user =
    { pkgs, lib, ... }:
    {
      users.users.${userName} = {
        uid = 1000;
        description = "${userName}'s profile";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "wheel"
          "plugdev"
          "gamemode"
        ];
        shell = pkgs.fish;
      };

      users.groups.plugdev = { };
    };
}
