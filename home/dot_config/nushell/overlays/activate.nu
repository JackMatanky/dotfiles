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

module activate {
    export-env {
        def is-env-true [name: string] {
            if ($name in $env) {
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

        let virtual_env = $env.__VIRTUAL_ENV__
        let bin = $env.__BIN_NAME__
        let virtual_env_prompt = $env.__VIRTUAL_PROMPT__

        let path_name = (if 'Path' in $env {
            'Path'
        } else {
            'PATH'
        })

        let venv_path = ([$virtual_env $bin] | path join)
        let new_path = ($env | get $path_name | prepend $venv_path)

        mut new_env = {
            $path_name         : $new_path
            VIRTUAL_ENV        : $virtual_env
            VIRTUAL_ENV_PROMPT : $virtual_env_prompt
        }

        if not (is-env-true 'VIRTUAL_ENV_DISABLE_PROMPT') {
            let virtual_prefix = $'(char lparen)($virtual_env_prompt)(char rparen) '
            let old_prompt_command = (if 'PROMPT_COMMAND' in $env {
                $env.PROMPT_COMMAND
            } else {
                ''
            })
            let new_prompt = {|| $'($virtual_prefix)(do $old_prompt_command)' }
            $new_env = ($new_env | merge {
                PROMPT_COMMAND      : $new_prompt
                VIRTUAL_PREFIX      : $virtual_prefix
            })
        }
        load-env $new_env
    }
}
