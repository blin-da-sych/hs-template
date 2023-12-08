FROM debian:latest

# ARG DEBIAN_FRONTEND=noninteractive
# ENV TZ=Europe/Berlin

COPY . /app

WORKDIR /app

# Specify Cabal file
ARG CABAL_FILE=hs-template.cabal

# install dependencies
RUN \
  apt-get update -y && \
  apt-get install -y --no-install-recommends \
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
  automake \
  build-essential

# install gpg keys
# ARG GPG_KEY=7784930957807690A66EBDBE3786C5262ECB4A3F
# RUN gpg --batch --keyserver keys.openpgp.org --recv-keys $GPG_KEY

# install ghcup
RUN \
  curl https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup > /usr/bin/ghcup && \
  chmod +x /usr/bin/ghcup
  # ghcup config set gpg-setting GPGStrict

# install ghcup
# RUN \
#   curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
#   BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
#   BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 sh

# ENV PATH="/root/.ghcup/bin:${PATH}"

ARG GHC=9.2.8
ARG CABAL=latest

# install GHC and cabal
RUN \
  ghcup -v install ghc --isolate /usr/local --force ${GHC} && \
  ghcup -v install cabal --isolate /usr/local/bin --force ${CABAL}
  # cp ${CABAL_FILE} .

RUN cabal update && cabal install && cabal build

EXPOSE 8080

CMD cabal run
