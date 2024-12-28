FROM debian:latest

RUN apt-get update && apt-get install -y unzip zip nano

RUN apt-get install -y build-essential git curl wget

ARG PB_VERSION=0.22.14
ENV GO_VERSION=1.23.0

USER root

WORKDIR /usr/local
# Ejecuta los comandos necesarios con root
RUN wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin

# download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip

RUN unzip /tmp/pb.zip -d /pb/

COPY ./app.go /pb/app.go

WORKDIR /pb

# RUN go mod init myapp && go mod tidy

EXPOSE 8080
EXPOSE 8081                                       

# start PocketBase
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
# CMD ["go", "run", "/pb/main.go", "--http=0.0.0.0:8080"]
