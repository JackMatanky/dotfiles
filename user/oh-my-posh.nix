{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: {
  programs.oh-my-posh = {
    enable = true;
    package = pkgs.oh-my-posh;
    enableZshIntegration = true;
    useTheme = "dracula";
    settings = {
      # Example: builtins.fromJSON (builtins.unsafeDiscardStringContext
      # (builtins.readFile "${pkgs.oh-my-posh}/share/oh-my-posh/themes/space.omp.json"))
      #   blocks = {
      #       alignment = "left";
      #       segments = [
      #       {
      #           background = "#6272a4";
      #           foreground = "#ffffff";
      #           leading_diamond = "\ue0b6";
      #           properties = {
      #             template = "{{ .UserName }} ";
      #           };
      #           style = "diamond";
      #           type = "session";
      #         },
      #         {
      #           background = "#bd93f9";
      #           foreground = "#ffffff";
      #           powerline_symbol = "\ue0b0";
      #           properties = {
      #             style = "folder";
      #             template = " {{ .Path }} ";
      #           };
      #           style = "powerline";
      #           type = "path";
      #         },
      #         {
      #           background = "#ffb86c";
      #           foreground = "#ffffff";
      #           powerline_symbol = "\ue0b0";
      #           properties = {
      #             branch_icon = "";
      #             fetch_stash_count = true;
      #             fetch_status = false;
      #             fetch_upstream_icon = true;
      #             template = " \u279c ({{ .UpstreamIcon }}{{ .HEAD }}{{ if gt .StashCount 0 }} \uf692 {{ .StashCount }}{{ end }}) ";
      #           };
      #           style = "powerline";
      #           type = "git";
      #         },
      #         {
      #           background = "#8be9fd";
      #           foreground = "#ffffff";
      #           powerline_symbol = "\ue0b0";
      #           properties = {
      #             template = " \ue718 {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }} ";
      #           };
      #           style = "powerline";
      #           type = "node";
      #         },
      #         {
      #           background = "#ff79c6";
      #           foreground = "#ffffff";
      #           properties = {
      #             template = " \u2665 {{ .CurrentDate | date .Format }} ";
      #             time_format = "15:04";
      #           };
      #           style = "diamond";
      #           trailing_diamond = "\ue0b0";
      #           type = "time";
      #         };
      #         ]
      #       type = "prompt";
      #     };
      #   final_space = true;
      #   version = 1;
      # };
    };
  };
}
