# streamlit-in-aws

A template for running Streamlit in aws

## Getting Started

This project uses poetry for package management. The directions assume you have poetry installed.

### Clone the project

Use the repo URL in Github and clone the repository locally.

```bash
git clone https://github.com/gibbardsteve/streamlit-in-aws.git
```

### Install the dependencies and activate the shell

Use poetry to install the required dependencies.

```bash
poetry install
```

Activate the environment

```bash
poetry shell
```

### Run the Streamlit application locally

Use the poetry run command to run streamlit

```bash
poetry run streamlit run app.py
```

#### View in the web browser

Locally the streamlit application will run on localhost on the following port:

```bash
  You can now view your Streamlit app in your browser.

  Local URL: http://localhost:8501
  Network URL: http://192.xxx.0.xx:8501  
```

### Run in docker using Colima

This assumes you have colima installed on Mac - see the following guide to get use Colima: [Use Colima to Run Docker Containers](https://smallsharpsoftwaretools.com/tutorials/use-colima-to-run-docker-containers-on-macos/)

#### Start Colima

Start Colima from the cli

```bash
colima start
```

Check it is running

```bash
docker info
```

The context should say Colima

```bash
Client: Docker Engine - Community
 Version:    26.0.0
 Context:    colima
```

#### Build the dockerfile

In the root of the repository run

```bash
docker build -t streamlit-in-aws:v0.1 .
```

#### Run the docker image

Set up the local networking so that any ip maps port 1234 to 8501 (the default port for Streamlit).  This essentially maps the address on your local mac to the address running streamlit in your docker container.

```bash
docker run -p 0.0.0.0:1234:8501 streamlit-in-aws:v0.1
```

#### Check the image is running

You can use the following docker command to check the image is running:

```bash
docker ps -a
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                    NAMES
819df79712d0   streamlit-in-aws:v0.1   "poetry run streamli…"   10 minutes ago   Up 10 minutes   0.0.0.0:1234->8501/tcp   upbeat_banach
```

#### Browse the application

Open a web browser and navigate to

```bash
localhost:1234
```

The streamlit application should be shown

#### Docker image

The docker image is published to dockerhub as [streamlit-in-aws](https://hub.docker.com/repository/docker/sgibbard/streamlit-in-aws/general)

## Additional Information

The following links have been useful in helping progress this repository:

[Transform Python Apps to Portable Containers](https://medium.com/ai-in-plain-english/docker-essentials-transforming-python-apps-into-portable-containers-cf298d3779a6)
