{
  src
, lockFilePath ? src + "/flake.lock"
, overrides ? {}

  # Whether to (slowly) copy the entire source tree into the Nix store.
  # Disabling this improves evaluation speed immensely at the cost of
  # deleting the alleged purity gained by flakes: no longer obeying
  # gitignores.
  #
  # It is recommended anyway to do explicit file filtering using e.g.
  # lib.filesets in nixpkgs rather than copying entire directories, since it
  # improves evaluation performance and reduces spurious rebuilds.
, copySourceTreeToStore ? true

  # Whether to use native builtins.fetchTree. In the future, this *might*
  # become `builtins ? fetchTree`, but Lix in versions prior to 2.93
  # (https://gerrit.lix.systems/c/lix/+/2399) had a fetchTree that throws in an
  # uncatchable way if flakes are disabled.
  #
  # At a broader level, we are *to some extent* documenting
  # builtins.fetchTree's oddities by implementing it in this project and it
  # would not be ideal to lose that.
, useBuiltinsFetchTree ? false
, fetchTreeFinal ? builtins.fetchTree
}:

let
  
  lockFile = builtins.fromJSON (builtins.readFile lockFilePath);

  # Compute the key corresponding to an input spec.
  resolveInput =
    inputSpec:
    if !(builtins.isList inputSpec) then
      inputSpec
    else
      getInputByPath lockFile.root inputSpec;

  # Get a locked input's key from an attrpath, starting from the root node and
  # then following dependencies transitively. For example:
  #
  # ```
  # getInputByPath lockFile.root ["dwarffs" "nixpkgs"]
  # ```
  #
  # returns the key corresponding to the node for `inputs.dwarffs.inputs.nixpkgs`.
  getInputByPath =
    key: path:
    if path == [] then
      key
    else
      getInputByPath
        (resolveInput lockFile.nodes.${key}.inputs.${builtins.head path})
        (builtins.tail path);

  isLockedNodeRelative =
    node:
    if node.locked.type or null == "path" then
      assert node.locked ? path;
      builtins.substring 0 1 node.locked.path != "/"
    else
      false;

  getParentNode =
    node:
    allNodes.${getInputByPath lockFile.root node.parent};

  rootTreeFromPathish =
    tree:
    let
      formatSecondsSinceEpoch = import ./seconds-since-epoch.nix;

      # Try to clean the source tree by using fetchGit, if this source
      # tree is a valid git repository.
      tryFetchGit =
        tree:
        if isGit && !isShallow then
          let
            res = builtins.fetchGit tree;
          in
          if res.rev == "0000000000000000000000000000000000000000" then
            removeAttrs res [
              "rev"
              "shortRev"
            ]
          else
            res
        else
          {
            outPath =
              # Massage `tree` into a store path.
              if builtins.isPath tree then
                if
                  dirOf (toString tree) == builtins.storeDir
                  # `builtins.storePath` is not available in pure-eval mode.
                  && builtins ? currentSystem
                then
                  # If it's already a store path, don't copy it again.
                  builtins.storePath tree
                else
                  builtins.path {
                    path = tree;
                    name = "source";
                  }
              else
                tree;
          };
      # NB git worktrees have a file for .git, so we don't check the type of .git
      isGit = builtins.pathExists (tree + "/.git");
      isShallow = builtins.pathExists (tree + "/.git/shallow");

    in
    {
      lastModified = 0;
      lastModifiedDate = formatSecondsSinceEpoch 0;
    }
    // (if tree ? outPath then tree else tryFetchGit tree);

  rootSrc = rootTreeFromPathish (
    if copySourceTreeToStore then
      src
    else
      # *hacker voice*: it's definitely a store path, I promise (actually a
      # nixlang path value, likely not pointing at the store).
      { outPath = src; }
  );

  # `allNodes` is the real star of the show: it maps lockfile keys to the evaluations
  # of their respective nodes.
  allNodes = builtins.mapAttrs (
    key: node:
    let
      hasOverride = overrides ? ${key};
      isRelative = isLockedNodeRelative node;

      parentNode = getParentNode node;

      # Get source info for this node. Download sources as needed.
      sourceInfo =
        if key == lockFile.root then
          rootSrc
        else if hasOverride then
          overrides.${key}.sourceInfo
        else if isRelative then
          parentNode.sourceInfo
        else
          fetchTreeFinal (node.info or {} // builtins.removeAttrs node.locked ["dir"]);

      subdir = overrides.${key}.dir or node.locked.dir or "";

      outPath =
        if !hasOverride && isRelative then
          if node.locked.path == "" then
            parentNode.outPath
          else
            parentNode.outPath + "/" + node.locked.path
        else
          if subdir == "" then
            sourceInfo.outPath
          else
            sourceInfo.outPath + "/" + subdir;

      # Import the flake.
      flake = import (outPath + "/flake.nix");

      inputs = builtins.mapAttrs
        (inputKey: inputSpec: allNodes.${resolveInput inputSpec}.result)
        (node.inputs or {});

      # Evaluate the final result of the flake `outputs` section recursively.
      outputs = flake.outputs (inputs // { self = result; });

      result = outputs
        // sourceInfo
        // {
          _type = "flake";
          inherit outPath inputs outputs sourceInfo;
        };
    in
    {
      inherit outPath sourceInfo;

      result =
        if node.flake or true then
          # The node is a flake. Assert that `flake.outputs` section is a function, and
          # evaluate it.
          assert builtins.isFunction flake.outputs;
          result
        else
          # The node is not a flake.
          # Short circuit: fetch the node and return a store path containing the fetched
          # data.
          sourceInfo // { inherit outPath sourceInfo; };
    }
  ) lockFile.nodes;

in
  allNodes.${lockFile.root}.result
