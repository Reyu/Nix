builtins.listToAttrs (map
  (x: {
    name = x;
    value = import ./${x};
  })
  (builtins.filter (x: x != "default.nix")
    (builtins.attrNames (builtins.readDir ./.))))
