# check_if_submodule_specified <env_dir>
check_if_submodule_specified() {
  local env_dir=$1
  if [ -d "$env_dir" ] &&
    [ -f "$env_dir/SUBMODULE_BRANCH" ] &&
    [ -f "$env_dir/SUBMODULE_URL" ] &&
    [ -f "$env_dir/SUBMODULE_DIR" ]; then
    return 0
  else
    return 1
  fi
}

# export_private_key_env_var <env_dir>
export_private_key_env_var() {
  local env_dir=$1
  if [ -d "$env_dir" ]; then
    if [ -f "$env_dir/PRIVATE_KEY" ]; then
      export "PRIVATE_KEY=$(cat $env_dir/PRIVATE_KEY)"
    fi
  fi
}

# export_repo_env_var <env_dir>
export_repo_env_var() {
  local env_dir=$1
  if [ -d "$env_dir" ]; then
    if [ -f "$env_dir/SUBMODULE_BRANCH" ]; then
      export "SUBMODULE_BRANCH=$(cat $env_dir/SUBMODULE_BRANCH)"
    fi
    if [ -f "$env_dir/SUBMODULE_URL" ]; then
      export "SUBMODULE_URL=$(cat $env_dir/SUBMODULE_URL)"
    fi
    if [ -f "$env_dir/SUBMODULE_DIR" ]; then
      export "SUBMODULE_DIR=$(cat $env_dir/SUBMODULE_DIR)"
    fi
  fi
}

create_ssh_key_file() {
if [[ -z $PRIVATE_KEY ]]; then
  echo "PRIVATE_KEY is unset"
  exit 0
fi

mkdir ~/.ssh
chmod 700 ~/.ssh/
cat > ~/.ssh/id_rsa << KEY
-----BEGIN RSA PRIVATE KEY-----
$PRIVATE_KEY
-----END RSA PRIVATE KEY-----
KEY
chmod 400 ~/.ssh/id_rsa
}

# clone_repo <git_url> <branch> <local_directory>
clone_repo() {
  local url=$1
  local branch=$2
  local directory=$3
  ssh-keyscan github.com >> ~/.ssh/known_hosts
  git clone -b "$branch" "$url" "$directory"
}

# build_entries <build_dir>
build_entries() {
  local build_dir=$1
  ENTRIES_OUTPUT_PATH="$build_dir/$ENTRIES_OUTPUT_RELATIVE_PATH" npm run buildEntries -- --release
}
