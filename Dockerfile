FROM ruby:alpine
LABEL maintainer="Jeffrey M. Castro <castrojeffreym@gmail.com>"
LABEL description="Friends Management Rails API Application."

ARG APP_PATH='/app'
ARG PORT=3000

RUN apk add --no-cache \
        build-base \
        tzdata \
        git \
        nodejs \
        sqlite-dev 

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

RUN bundle exec rails db:create
RUN bundle exec rails db:migrate

COPY . ./

EXPOSE $PORT

CMD ["sh","-c", "bundle exec rails server -b 0.0.0.0"]
