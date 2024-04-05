# Get a base image with a slim version of Python 3.10
FROM python:3.10-slim

# run a pip install for poetry 1.5.0
RUN pip install poetry==1.5.0

# Expose the port the app runs on
EXPOSE 8501

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Run poetry install
RUN poetry install --no-root --without dev

# run the streamlit app using poetry run
CMD ["poetry", "run", "streamlit", "run", "app.py"]
