FROM python:3.10

# Prevent Python from buffering logs
ENV PYTHONUNBUFFERED=1

# Working directory
WORKDIR /app

# Install system dependencies (ffmpeg included)
RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean

# Copy dependencies
COPY requirements.txt .

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files
COPY . .

# Expose port for HuggingFace
EXPOSE 7860

# Run FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
