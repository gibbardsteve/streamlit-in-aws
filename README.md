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

### Run the Streamlit application

Use the poetry run command to run streamlit

```bash
poetry run streamlit run app.py
```

### View in the web browser

Locally the streamlit application will run on localhost on the following port:

```bash
  You can now view your Streamlit app in your browser.

  Local URL: http://localhost:8501
  Network URL: http://192.xxx.0.xx:8501
```
