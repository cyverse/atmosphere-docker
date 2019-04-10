FROM ubuntu:18.04
RUN apt-get update && apt-get install -y curl jq
COPY ./test.sh /test.sh
RUN chmod +x /test.sh
