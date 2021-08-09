# Placeholder file for a sub-project within DevStack

These files should only exist within the [OpenDSA-DevStack repo](https://github.com/OpenDSA/OpenDSA-DevStack).  

Do **NOT** commit them to any sub-projects of the Devstack, such as: [OpenDSA](https://github.com/OpenDSA/OpenDSA), [OpenDSA-LTI](https://github.com/OpenDSA/OpenDSA-LTI), [CodeWorkout](https://github.com/web-cat/code-workout), or [OpenPOP](https://github.com/OpenDSA/OpenPOP).  

This is a placeholder compose.yml file for the DevStack.  It is NOT functional as a compose file in any way.
However, the 'extends' element of the DevStack's docker-compose.yml needs to find a valid compose file here. 
Do NOT commit this file to any repository except OpendDSA-DevStack.  

During the 'setup' service of DevStack, the cloning and creation of each sub-project is designed to delete this file.
If you see this file within the sub-project folder you are trying to run, then DevStack has not run the setup yet.  
To run DevStack's setup for your sub-project use: `docker-compose run setup make <<sub-project-name>>`

Due to the new docker-compose.yml placeholder files being added, we may even remove this file in the future.  
