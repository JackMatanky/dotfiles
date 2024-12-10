let
  myAliases = {
    dot = "cd ~/.dotfiles";
    dot_nix = "cd ~/.dotfiles/nixos";
    obsidian = "cd ~/obsidian_vault";
    obsidian_gpl = "cd ~/obsidian_vault; git pull";

    # Nix - Flakes
    flake_rebuild = "sudo nixos-rebuild switch --flake .";
    flake_rebuild_trace = "sudo nixos-rebuild switch --flake . --show-trace";
    flake_up = "sudo nix flake update";
    flake_up_trace = "sudo nix flake update --show-trace";

    # Nix - Home Manager
    hm_switch = "home-manager switch --flake .";
    hm_switch_trace = "home-manager switch --flake . --show-trace";

    # Nix - Garbage Collector
    cg_empty = "sudo nix-collect-garbage";
    cg_empty_all = "sudo nix-collect-garbage -d";

    # Git
    gad = "git add";
    gad_d = "git add .";
    gad_p = "git add -p";
    gc = "git commit -m";
    gca = "git commit -a -m";
    gps = "git push";
    gps_o = "git push origin";
    # gps_oh = "git push origin HEAD";
    gpl = "git pull";
    gpl_o = "git pull origin";
    gst = "git status";
    glog = "git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit";
    gdiff = "git diff";
    gbr = "git branch";
    gbra = "git branch -a";
    gco = "git checkout";
    gcoall = "git checkout -- .";
    grm = "git remote";
    grs = "git reset";

    # Dirs
    # .. = "cd ..";
    # ... = "cd ../..";
    # .... = "cd ../../..";
    # ..... = "cd ../../../..";
    # ...... = "cd ../../../../..";
  };
in
  myAliases
