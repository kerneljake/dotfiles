# my .zprofile is a hack around macOS M1 path_helper which is most unhelpful with its /etc/paths nonsense

# brew
if [[ "$(uname -s)" == "Darwin" ]]; then
    brew_dirs=("/opt/homebrew/bin" "/usr/local/bin")
    for dir in "${brew_dirs[@]}"; do
        if [ -x "$dir/brew" ]; then
            eval "$($dir/brew shellenv)"
            break
        fi
    done
fi
