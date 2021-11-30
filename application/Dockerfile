FROM python:3.6-alpine

RUN apk add --no-cache g++
RUN adduser --disabled-password sashok


COPY . /
RUN ["python3", "setup.py", "install"]
USER sashok
CMD ["python3", "-m", "demo"]
