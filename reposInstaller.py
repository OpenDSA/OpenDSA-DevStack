import subprocess

cmdMap = {
    '--dry-run': "(--dry-run) Print instead of execute the make commands? ", 
    'opendsa' : "(Repo: OpenDSA/OpenDSA) Are you building eBooks? ", 
    'opendsa-lti' : "(Repo: OpenDSA/OpenDSA-LTI) Working with LTI connections? ", 
    'code-workout' : "(Repo: Webcat/code-workout) Developing code-workout exercises? ", 
    'openPOP' : "(Repo: OpenDSA/OpenPOP) Working with OpenPOP? "
}

def main():
    print("Beginning the OpenDSA Developer Stack setup...")
    commands = ['make']
    for cmd, question in cmdMap.items():
        if prompt(question):
            commands.append(cmd)
    print("Running:", ' '.join(commands))
    subprocess.run(commands)


def prompt(question):
    while True:
        resp = input(question).strip().lower()
        if resp in ['y', 'yes']:
            return True
        elif resp in ['n', 'no']:
            return False
        print("Valid responses: 'yes' or 'no'")


if __name__ == '__main__':
    main()
