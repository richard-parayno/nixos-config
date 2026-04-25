let
  richard_thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnj2UVHohOtL22P3FSjp5JHohTUUX233/N7qKO3Fejj";
  richard_netrunner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID12QF5BRz67JoCp7l80/aVqX36G4fmg88VwwoejSTuv";
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPU0uKVY5RmfhE3QV63WNU13Sq2IAZ5zp1pbeCRjMxQ+";
  netrunner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKG5nvOW3BVTjzwgsMTRkyEEu3QRHlH+P5xai5CjlpIY";
  users = [
    richard_thinkpad
    richard_netrunner
  ];
  hosts = [
    thinkpad
    netrunner
  ];
in
{
  "github-pat.age".publicKeys = users ++ hosts;

  "api-keys.age".publicKeys = users ++ hosts;
}
