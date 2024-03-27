FROM docker.io/ruby:alpine

WORKDIR /app
COPY config.ru /app/
#COPY public/ /app/
COPY lib/ /app/lib/

RUN gem install -N nokogiri rackup sinatra

EXPOSE 9292/tcp
CMD [ "rackup", "-o", "0.0.0.0", "-E", "production" ]
