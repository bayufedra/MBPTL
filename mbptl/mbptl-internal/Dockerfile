FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY app.py .
COPY flag.txt /

# Install the required packages
RUN pip install flask
USER nobody

# Command to run the Flask app
CMD ["python", "app.py"]