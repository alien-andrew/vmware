FROM python:3.8.0
COPY requirements.txt /
RUN pip install --upgrade pip && pip install -r /requirements.txt
COPY . /build
WORKDIR /build

EXPOSE 8000
CMD ["mkdocs", "serve"]

