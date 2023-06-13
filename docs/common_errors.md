#### Common Errors

Make sure that you have started Docker before running of the Makefile commands.

When running commands in the container, there is not sudo password, (in case you need to execute any commands that require sudo).

### Troubleshooting 

#### Docker Issues 
If you are having trouble building or running the OpenDSA Docker Images, first make sure that Docker itself is properly functioning. Before running any commands, ensure that the Docker Daemon is up and running and then run the command below in your terminal to pull a sample docker image. 

1. Pull the Docker Image: 
`docker pull shreyamallamula/dockernginx`
2. Run the Docker Image:
`docker run -d -p 5000:80 shreyamallamula/dockernginx`
3. In a browser, navigate to:
http://localhost:5000/ 

If you are not able to pull this image, reinstall Docker, or double check that you followed all the steps correctly. 