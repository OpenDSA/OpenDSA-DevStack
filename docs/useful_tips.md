#### Useful tips and options:

- Adding the `--detach` or `-d` option allows some docker commands to run in the *background*, giving you back control of the command line.
   - `docker-compose --profile <<profile>> up -d`
- Setting a `docker-compose` alias is nice to avoid typing it as much.  We recommend `docc=docker-compose`
- On Windows, you may want to do `git config --global core.filemode false`.  Repositories cloned within Docker can show many changes to the file permissions when `git diff` is used outside of the Docker container.
- There are also two specific profiles set up for common development stacks
  - `docker-compose --profile odsa-cw up` will bring up a stack including OpenDSA-LTI and CodeWorkout
  - `docker-compose --profile cw-op up` will bring up a stack including CodeWorkout and OpenPOP
- In the `docker-compose.yml` the `opendsa-lti` container has a few arguments that you can use to declare which branches of OpenDSA and OpenDSA-LTI you want to use.
- If you are on Windows, any command that enters into a container (exec or run) will most likely need to be prefaced with `winpty` see the [Windows Troubleshooting](https://github.com/OpenDSA/OpenDSA-DevStack/blob/master/docs/windows_troubleshooting.md) section for more.
- If you are editing the /embed exercises, you'll need to exec into the opendsa-lti container and run `rake update_module_versions` then `rake clear_rails_cache` in order to populate the view.
