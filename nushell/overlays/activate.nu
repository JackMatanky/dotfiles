# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/overlays/pyenv_activate.nu
# Source: adapted from https://github.com/pypa/virtualenv/blob/main/src/virtualenv/activation/nushell/activate.nu
# -----------------------------------------------------------------------------
# virtualenv activation module
# Activate with `overlay use pyenv_activate.nu`
# Deactivate with `deactivate`, as usual
#
# To customize the overlay name, you can call `overlay use pyenv_activate.nu as foo`,
# but then simply `deactivate` won't work because it is just an alias to hide
# the "activate" overlay. You'd need to call `overlay hide foo` manually.

export-env {
    def is-string [x] {
        ($x | describe) == 'string'
    }

    def has-env [...names] {
        $names | each {|n|
            $n in $env
        } | all {|i| $i == true}
    }

    # Emulates a `test -z`, but better as it handles e.g. 'false'
    def is-env-true [name: string] {
      if (has-env $name) {
        # Try to parse 'true', '0', '1', and fail if not convertible
        let parsed = (do -o { $env.$name | into bool })
        if ($parsed | describe) == 'bool' {
          $parsed
        } else {
          not ($env.$name | is-empty)
        }
      } else {
        false
      }
    }

    # Primary virtual environment value: placeholder wins, then standard
    let virtual_env = if (has-env '__VIRTUAL_ENV__') {
        $env.__VIRTUAL_ENV__
    } elif (has-env 'VIRTUAL_ENV') {
        $env.VIRTUAL_ENV
    } else {
        ''
    }

    # Bin directory name: placeholder wins, else platform-specific default
    let bin_name = if (has-env '__BIN_NAME__') {
        $env.__BIN_NAME__
    } else {
        let is_windows = ($nu.os-info.family) == 'windows'
        if $is_windows { 'Scripts' } else { 'bin' }
    }

    # Compose venv path to prepend to PATH if we have a virtual_env
    let venv_path = if (not ($virtual_env | is-empty)) {
        ([$virtual_env $bin_name] | path join)
    } else {
        ''
    }

    # Determine correct PATH key (Path vs PATH)
    let path_name = (if (has-env 'Path') {
            'Path'
        } else {
            'PATH'
        }
    )

    let new_path = if (not ($venv_path | is-empty)) {
        ($env | get $path_name | prepend $venv_path)
    } else {
        ($env | get $path_name)
    }

    # Virtual prompt: placeholder, then VIRTUAL_PROMPT, then basename of virtual_env
    let raw_prompt_override = if (has-env '__VIRTUAL_PROMPT__') {
        $env.__VIRTUAL_PROMPT__
    } elif (has-env 'VIRTUAL_PROMPT') {
        $env.VIRTUAL_PROMPT
    } else {
        ''
    }

    let virtual_env_prompt = if (not ($raw_prompt_override | is-empty)) {
        $raw_prompt_override
    } else if (not ($virtual_env | is-empty)) {
        ($virtual_env | path basename)
    } else {
        ''
    }

    # Base new environment
    let new_env = {
        $path_name         : $new_path
        VIRTUAL_ENV        : $virtual_env
        VIRTUAL_ENV_PROMPT : $virtual_env_prompt
    }

    let new_env = (if (is-env-true 'VIRTUAL_ENV_DISABLE_PROMPT') {
      $new_env
    } else {
      # Creating the new prompt prefix
      let virtual_prefix = $'(char lparen)($virtual_env_prompt)(char rparen) '

      # Back up existing PROMPT_COMMAND if any
      let old_prompt_command = (if (has-env 'PROMPT_COMMAND') {
              $env.PROMPT_COMMAND
          } else {
              ''
        })

      let new_prompt = (if (has-env 'PROMPT_COMMAND') {
          if 'closure' in ($old_prompt_command | describe) {
              {|| $'($virtual_prefix)(do $old_prompt_command)' }
          } else {
              {|| $'($virtual_prefix)($old_prompt_command)' }
          }
      } else {
          {|| $'($virtual_prefix)' }
      })

      $new_env | merge {
        PROMPT_COMMAND      : $new_prompt
        VIRTUAL_PREFIX      : $virtual_prefix
      }
    })

    # Apply the environment overlay
    load-env $new_env
}

export alias pydoc = python -m pydoc
export alias deactivate = overlay hide activate
