# -----------------------------------------------------------------------------
# Filename: ~/.config/nushell/overlays/activate.nu
# Source: https://github.com/pypa/virtualenv/blob/main/src/virtualenv/activation/nushell/activate.nu
# -----------------------------------------------------------------------------
# virtualenv activation module
# Activate with `overlay use activate.nu`
# Deactivate with `deactivate`, as usual
#
# To customize the overlay name, you can call `overlay use activate.nu as foo`,
# but then simply `deactivate` won't work because it is just an alias to hide
# the "activate" overlay. You'd need to call `overlay hide foo` manually.

export-env {
    # Emulates a `test -z`, but better as it handles e.g 'false'
    def is-env-true [name: string] {
      if (is-string $name) and ($name in $env) {
        # Try to parse 'true', '0', '1', and fail if not convertible
        let parsed = (do -i { $env | get $name | into bool })
        if ($parsed | describe) == 'bool' {
          $parsed
        } else {
          not ($env | get -o $name | is-empty)
        }
      } else {
        false
      }
    }

    # We now get these from the parent scope, where they are defined before calling `overlay use`.
    let virtual_env = $env.__VIRTUAL_ENV__
    let bin = $env.__BIN_NAME__

    let path_name = (if 'Path' in $env {
            'Path'
        } else {
            'PATH'
        }
    )

    let venv_path = ([$virtual_env $bin] | path join)
    let new_path = ($env | get $path_name | prepend $venv_path)

    # If there is no default prompt, then use the env name instead
    let virtual_env_prompt = (if ($env.__VIRTUAL_PROMPT__ | is-empty) {
        ($virtual_env | path basename)
    } else {
        $env.__VIRTUAL_PROMPT__
    })

    let new_env = {
        $path_name         : $new_path
        VIRTUAL_ENV        : $virtual_env
        VIRTUAL_ENV_PROMPT : $virtual_env_prompt
    }

    let new_env = (if (is-env-true 'VIRTUAL_ENV_DISABLE_PROMPT') {
      $new_env
    } else {
      # Creating the new prompt for the session
      let virtual_prefix = $'(char lparen)($virtual_env_prompt)(char rparen) '

      # Back up the old prompt builder
      let old_prompt_command = (if ('PROMPT_COMMAND' in $env) {
              $env.PROMPT_COMMAND
          } else {
              ''
        })

      let new_prompt = (if ('PROMPT_COMMAND' in $env) {
          {|| $'($virtual_prefix)(do $old_prompt_command)' }
      } else {
          {|| $'($virtual_prefix)' }
      })

      $new_env | merge {
        PROMPT_COMMAND      : $new_prompt
        VIRTUAL_PREFIX      : $virtual_prefix
      }
    })

    # Environment variables that will be loaded as the virtual env
    load-env $new_env
}

export alias pydoc = python -m pydoc
export alias deactivate = overlay hide activate
