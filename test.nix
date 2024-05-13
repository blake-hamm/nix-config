let
  pkg = import <nixpkgs> { };
  oneAttribute = (name: "x_" + name.arg);
in
pkg.lib.genAttrs [{ arg = "foo"; } { arg = "bar"; }] oneAttribute
