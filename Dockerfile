FROM elixir:1.3.4

ENV APP_PATH=/gropen
ENV MIX_ENV=production

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY . $APP_PATH

RUN mix local.hex --force
RUN mix deps.get
RUN mix escript.build

ENTRYPOINT ["./gropen"]
