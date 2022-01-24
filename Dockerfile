# Prebuild image that contains selenium, python, chromedriver
FROM joyzoursky/python-chromedriver:3.8-selenium

RUN mkdir -p /usr/src/pytraffic
WORKDIR /usr/src/pytraffic 
COPY pytraffic.py .
COPY url.txt .
