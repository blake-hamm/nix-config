# shell.nix

{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.colmena
    pkgs.sops
  ];
}
