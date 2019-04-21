FROM fluent/fluentd:v0.12-debian
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "1.9.7"]


# volumes: - ./fluentd/conf:/fluentd/etc

#### Set ENV
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN echo "America/New_York" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
    software-properties-common \
    unzip \
    curl \
    xvfb

#### Initialization linux (install python and python modules)
RUN apt-get update -y && \
	apt-get install -y python3 \
	                    python3-pip \
	                    curl

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN dpkg -i vufind_3.1.1.deb || true

RUN \
   curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
   echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
   apt-get -y update && \
   apt-get -y install google-chrome-stable

RUN \
    wget -N http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip -P ~/Downloads && \
    unzip ~/Downloads/chromedriver_linux64.zip -d ~/Downloads && \
    mv -f ~/Downloads/chromedriver /usr/bin/chromedriver && \
    chown root:root /usr/bin/chromedriver && \
    chmod 0755 /usr/bin/chromedriver


RUN pip3 install selenium
RUN pip3 install --upgrade selenium


ADD elasticsearch_template.sh /esconfiguration/elasticsearch_template.sh
RUN chmod +x /esconfiguration/elasticsearch_template.sh
ADD src/naver_crawler.py /Crawler/naver_crawler.py
ADD fluent.conf /fluentd/etc

ENTRYPOINT ["sh", "/esconfiguration/elasticsearch_template.sh"]

