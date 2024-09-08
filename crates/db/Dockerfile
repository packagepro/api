FROM ghcr.io/amacneil/dbmate:2.20.0@sha256:d2ac1a9758b77ce6cc687641e7b266f01c9269b72b61dee8ee793e5da1fd4e6d

WORKDIR /app/db
COPY migrations .

CMD ["--wait", "--no-dump-schema", "-d", "./migrations", "up"]