# espanso text expander: https://espanso.org/docs/
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./espanso-config.nix
    ./espanso-matches.nix
  ];

  services.espanso = {
    enable = true;
    package = pkgs.espanso;

    configs = {
      default = {
        show_notifications = false;
      };
      # vscode = {
      #   filter_title = "Visual Studio Code$";
      #   backend = "Clipboard";
      # };
    };
    matches = {
      # Global Variables
      global_vars.global_vars = [
        {
          name = "my_first_name";
          type = "echo";
          params.echo = "Jack";
        }
        {
          name = "my_last_name";
          type = "echo";
          params.echo = "Matanky";
        }
        {
          name = "my_full_name";
          type = "echo";
          params.echo = "{{my_first_name}} {{my_last_name}}";
        }
        {
          name = "my_email";
          type = "echo";
          params.echo = "{{my_first_name}}{{my_last_name}}@gmail.com";
        }
      ];
      contact_vars.matches = [
        {
          trigger = ":fullname";
          replace = "{{my_full_name}}";
        }
        {
          trigger = ":phone";
          replace = "058-555-3200";
        }
        {
          trigger = ":email";
          replace = "{{my_email}}";
        }
        {
          trigger = ":atb";
          replace = "All the best,\n{{my_full_name}}";
        }
      ];
      # Datetime
      relative_datetime.matches = [
        # Date
        # Print today's date
        {
          trigger = ":today";
          replace = "{{date_var}}";
          vars = [
            {
              name = "date_var";
              type = "date";
              params.format = "%F";
            }
          ];
        }
        {
          trigger = ":tomorrow";
          replace = "{{date_var}}";
          label = "Insert tomorrow's date, such as 5-Jan-2022";
          vars = [
            {
              name = "date_var";
              type = "date";
              params = {
                format = "%d.%m.%Y";
                offset = 86400;
              };
            }
          ];
        }
        {
          trigger = ":yesterday";
          replace = "{{date_var}}";
          label = "Insert yesterday's date, such as 5-Jan-2022";
          vars = [
            {
              name = "date_var";
              type = "date";
              params = {
                format = "%d.%m.%Y";
                offset = -86400;
              };
            }
          ];
        }
        # Time
        # Print the current time
        {
          trigger = ":now";
          replace = "{{time_var}}";
          vars = [
            {
              name = "time_var";
              type = "date";
              params.format = "%H:%M";
            }
          ];
        }
      ];
    };
  };
}
