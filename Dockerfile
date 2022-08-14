FROM python:3.9.2-alpine3.13

# Copy files necessary for build
COPY requirements.txt / 

# Perform build and cleanup artifacts and caches
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . /docs
# Set working directory
WORKDIR /docs

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
