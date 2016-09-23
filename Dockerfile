FROM trenpixster/elixir:1.3.2

RUN mkdir -p /gropen
WORKDIR /gropen

COPY . /gropen

RUN mix deps.get
RUN mix escript.build

ENTRYPOINT []
