FROM elixir:1.3.4

ENV APP_PATH=/gropen

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY . $APP_PATH

RUN mix local.hex --force
RUN mix deps.get

# ENTRYPOINT ["iex"]
# CMD ["-S", "mix"]
ENTRYPOINT []
