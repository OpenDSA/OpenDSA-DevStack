#### General Issues 
If you are on Windows, you may run into issues with line endings.  If you do, simply open Git Bash and run `$ dos2unix filename` to fix them.  This will most likely happen on a script file.

If you are on Windows, you may run into issues with any `docker exec` or `docker run` commands (such as `make ssh`).  To solve them, you may have to start any such command with `winpty`.

#### Windows - Hyper-V 
If you are having trouble running Docker on a Windows 10 (or earlier) system, double check that Hyper-V is enabled. This setting might've been manually turned off in the past if you were running a Virtual Machine like VMWare in classes such as CS 2505/2506 . This setting should be automatically turned on by the Docker Desktop Windows Installer, but if a conflicting system (like VMWare is running) is still running, it needs to be manually checked. If you are actively running a conflicting system use the instructions found for Windows 11 instead. 

#### Windows 11
Docker on Windows was classically supported through Hyper-V, which no longer exists in Windows 11. Due to this, some manual shuffling of systems needs to be done to run Docker on these machines. The simplest approach seems to be to install a Linux Subsystem like WSL [Windows Subsystem for Linux](https://hope.edu/academics/computer-science/student-resources/using-wsl.html). After WSL is running, you should be able to download Docker, however you will still need to run Docker commands through an IDE that supports the Docker Platform. Many IDE's such as [IntelliJ](https://www.jetbrains.com/help/idea/docker.html#:~:text=IntelliJ%20IDEA%20provides%20Docker%20support,as%20described%20in%20Install%20plugins.) and [VSCode](https://code.visualstudio.com/docs/containers/overview) have plugins to support this, so use an IDE that you are comfortable with. After setting up the system, pull the sample docker image noted earlier in this section, to confirm success. 
