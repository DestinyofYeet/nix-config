type="$1"

function help {
  echo "Type must be one of the following: $(ls ~/nixos/non-server/envs)"
}

function setup_rust {
  project_name="$2"

  if [ -z "$project_name" ]; then
    echo "Project name not given, skipping cargo creation!"
    exit 0
  fi

  cargo init "$project_name"

  cd "$project_name" || (echo "Failed to cd into $project_name!" && exit 1)

  flake_copy
  git add flake.nix
  flake_update
}

function flake_init {
  flake_copy
  flake_update
}

function flake_copy {
  cp "$dir/flake.nix" .
}

function flake_update {
  nix flake update
}

if [ -z "$type" ]; then
  help
  exit 1
fi

dir="$HOME/nixos/non-server/envs/$type"

if [ ! -d "$dir/" ]; then
  echo "Unavailable type: $type"
  help
  exit 1
fi

case "$type" in 
  "rust") setup_rust "$@";;
  *) create_flake;;
esac
