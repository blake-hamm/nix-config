# shell.nix

{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.colmena
    pkgs.poetry
    pkgs.sops
  ];
}
