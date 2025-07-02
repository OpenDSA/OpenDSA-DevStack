#### Connect to Docker Container Database:

During development, it is convenient to connect to the `opendsa` database from your host machine using [DataGrip]((https://www.jetbrains.com/datagrip/). You should have access to this via the GitHub student developer pack (and this database viewer is included in all their IDEs). Once you installed and IDE with the database viewer, you can create a new connection to Docker Database using the following setup:

- Connection Name: OpenDSA-Devstack
- Connection Method: Standard TCP/IP
- MySQL Hostname: 127.0.0.1
- MySQL Server Port: 3307
- Username: root
- Password: opendsa
