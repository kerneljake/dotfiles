# my .zprofile is a hack around macOS M1 path_helper which is most unhelpful with its /etc/paths nonsense

# brew
if [[ "$(uname -s)" == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
