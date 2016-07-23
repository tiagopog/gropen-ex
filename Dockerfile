FROM elixir:1.3.0

RUN mkdir -p /gropen
WORKDIR /gropen

COPY . /gropen
RUN mix deps.get
RUN mix escript.build
