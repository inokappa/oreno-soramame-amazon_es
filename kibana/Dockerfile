FROM ruby
MAINTAINER inokappa
RUN apt-get update
ADD kibana_search.rb /app/kibana_search.rb
ADD kibana_visualize.rb /app/kibana_visualize.rb
ADD run /app/run
RUN chmod 755 /app/*.rb
RUN chmod 755 /app/run

ENTRYPOINT ["/app/run"]
