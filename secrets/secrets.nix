let
  richard_thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnj2UVHohOtL22P3FSjp5JHohTUUX233/N7qKO3Fejj";
  richard_nixos_desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOp2NZL/Xzb3hz4WeEELPkMCHSItShEHvc+V/DJ5NLA8";
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPU0uKVY5RmfhE3QV63WNU13Sq2IAZ5zp1pbeCRjMxQ+";
  nixos_desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKG5nvOW3BVTjzwgsMTRkyEEu3QRHlH+P5xai5CjlpIY";
  users = [
    richard_thinkpad
    richard_nixos_desktop
  ];
  hosts = [
    thinkpad
    nixos_desktop
  ];
in
{
  "github-pat.age".publicKeys = [
    richard_thinkpad
    richard_nixos_desktop
    thinkpad
    nixos_desktop
  ];

  "api-keys.age".publicKeys = users ++ hosts;
}
