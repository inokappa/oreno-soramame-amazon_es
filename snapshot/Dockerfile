FROM ruby
MAINTAINER inokappa
RUN apt-get update
ADD snapshot.rb /app/snapshot.rb
ADD run /app/run
RUN chmod 755 /app/*.rb
RUN chmod 755 /app/run

ENTRYPOINT ["/app/run"]
