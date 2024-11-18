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
    # useTheme = "dracula";
    settings = builtins.fromJSON ''
      {
        "blocks": [
          {
            "alignment": "left",
            "segments": [
              {
                "type": "session",
                "style": "diamond",
                "leading_diamond": "\ue0b6",
                "background": "#6272a4",
                "foreground": "#ffffff",
                "properties": {
                  "template": "{{ .UserName }} "
                }
              },
              {
                "type": "path",
                "style": "powerline",
                "powerline_symbol": "\ue0b0",
                "background": "#bd93f9",
                "foreground": "#ffffff",
                "properties": {
                  "style": "folder",
                  "template": " {{ .Path }} "
                }
              },
              {
                "type": "git",
                "style": "powerline",
                "powerline_symbol": "\ue0b0",
                "background": "#ffb86c",
                "foreground": "#ffffff",
                "properties": {
                  "branch_icon": "",
                  "fetch_stash_count": true,
                  "fetch_status": false,
                  "fetch_upstream_icon": true,
                  "template": " \u279c ({{ .UpstreamIcon }}{{ .HEAD }}{{ if gt .StashCount 0 }} \uf692 {{ .StashCount }}{{ end }}) "
                }
              },
              {
                "type": "node",
                "style": "powerline",
                "powerline_symbol": "\ue0b0",
                "background": "#8be9fd",
                "foreground": "#ffffff",
                "properties": {
                  "template": " \ue718 {{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}{{ .Full }} "
                }
              },
              {
                "type": "time",
                "style": "diamond",
                "trailing_diamond": "\ue0b0",
                "background": "#ff79c6",
                "foreground": "#ffffff",
                "properties": {
                  "template": " \u2665 {{ .CurrentDate | date .Format }} ",
                  "time_format": "15:04"
                }
              }
            ]
          }
        ],
        "final_space": true,
        "version": 1
      }
    '';
  };
}
