FROM ruby
MAINTAINER inokappa
RUN apt-get update
ADD . /app
RUN chmod 755 /app/run
RUN mkdir -p /app/output/html
RUN mkdir -p /app/output/png
RUN gem install aws-sdk nokogiri --no-ri --no-rdoc

CMD /app/run
