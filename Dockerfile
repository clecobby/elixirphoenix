FROM elixir:1.16-alpine

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
RUN MIX_ENV=prod mix deps.get --only prod

COPY lib ./lib
RUN MIX_ENV=prod mix compile

EXPOSE 4000

ENV MIX_ENV=prod

CMD ["mix", "run", "--no-halt"]
