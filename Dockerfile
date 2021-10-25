FROM python:3.6-alpine

RUN adduser --disabled-password sashok
COPY . /

RUN pip install -r requirements.txt


RUN ["python3", "setup.py", "install"]
USER sashok
CMD ["python", "-m", "demo"]
