# Richard's nixos flake
nixos flake for my thinkpad and desktop (maybe macbook if i feel like it)

this has most of my preferred applications and settings when using Linux

`wallpapers/` is just a collection of wallpapers i found from the internet. i do not own any of these pictures

## Requirements
This flake is designed to run on a NixOS minimal install on a thinkpad e14 gen 6. WARNING: this repo isn't designed to support other devices _yet_, but you might be able to get it to work with enough Nix knowledge

## How to use

1. First, clone the repo:
`git clone git@github.com:richard-parayno/nixos-config.git`

2. Then, replace the `userName` and `hostName` variables as needed

3. This flake uses Agenix to store user secrets. Use `agenix` to generate your own `github-pat.sops` file.

4. Switch your current configuration to this one
If you have NH:
`nh os switch /home/{your-username}/nixos-config --hostname thinkpad --ask`

If you don't have NH:
`sudo nixos-rebuild switch --flake /home/{your-username}/nixos-config#thinkpad`
