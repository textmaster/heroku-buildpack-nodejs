# Custom Heroku Buildpack for Node.js submodule

This buildpack forks the default Heroku buildpack for Node.js apps.
Its main purpose is to clone a third party Node.js app (the submodule) that provides assets to the main application.

How it works:
- clone the remote repository (it uses a deployment private key if the repository is private)
- install the dependencies
- run the NPM command (buildEntries) to create the bundled assets

### Private repository

Add a PRIVATE_KEY environment variable that contains the private key.

### Main app configuration

If the submodule is stored on a private repository, you need to add the *PRIVATE_KEY* environment variable.

This variable should contain the private key itself.  Make sure you defined a deployment private key with read only access on that specific repository.

Regarding the submodule, add the following environment variables (in the main app):

- SUBMODULE_BRANCH: the branch to use for the submodule
- SUBMODULE_URL: the url of the repository
- SUBMODULE_DIR: the local directory to clone the submodule into

If one of these env variables is missing, the buildpack exits.

- ENTRIES_OUTPUT_RELATIVE_PATH: the output path of the entries, relatively to the root path of the main app

### Add this buildpack to a Heroku app

```
heroku buildpacks:add <buildpack_name || buildpack_url> --index 1
```

### Remove a buildpack from a Heroku app

```
heroku buildpacks:remove <buildpack_name || buildpack_url>
```
