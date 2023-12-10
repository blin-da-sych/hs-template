# Stage 1: Build stage
FROM debian:bullseye AS builder

WORKDIR /app

RUN \
  apt-get update -y && \
  apt-get install -y build-essential \
  curl \
  libnuma-dev \
  zlib1g-dev \
  libgmp-dev \
  libgmp10 \
  git \
  wget \
  lsb-release \
  software-properties-common \
  gnupg2 \
  apt-transport-https \
  gcc \
  autoconf \
  automake

COPY . .

RUN curl https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup -o /usr/bin/ghcup && \
  chmod +x /usr/bin/ghcup

ARG GHC=9.2.8
ARG CABAL=latest

RUN \
  ghcup -v install ghc --isolate /usr/local --force ${GHC} && \
  ghcup -v install cabal --isolate /usr/local/bin --force ${CABAL}

RUN cabal update && cabal install --installdir=/app hs-template && cabal build

# Stage 2: Runtime stage
FROM debian:bullseye-slim

WORKDIR /app

COPY --from=builder /app/hs-template /app/hs-template

RUN chmod +x /app/hs-template

RUN apt-get update && \
  apt-get install -y libnuma1 libgmp10 && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 8080

CMD ["/app/hs-template"]
