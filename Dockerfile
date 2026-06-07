FROM erlang:29-alpine AS build
WORKDIR /app
RUN wget -q -O /usr/local/bin/rebar3 https://s3.amazonaws.com/rebar3/rebar3 \
    && chmod +x /usr/local/bin/rebar3
COPY . .
RUN rebar3 eunit && rebar3 escriptize

FROM erlang:29-alpine
WORKDIR /app
COPY --from=build /app/_build/default/bin/erlang-stakeholder /usr/local/bin/erlang-stakeholder
ENTRYPOINT ["erlang-stakeholder"]
