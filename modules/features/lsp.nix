{ self, inputs, ... }:
{
  flake.nixosModules.lsp =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # nix
        nixd
        nil
        nixfmt
        # typescript
        astro-language-server
        svelte-language-server
        typescript-language-server
        # ruby
        ruby-lsp
        rubocop
      ];
    };
}
