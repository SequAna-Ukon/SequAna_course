FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://micro.mamba.pm/install.sh | bash \
    && echo 'export PATH="$HOME/micromamba/bin:$PATH"' >> /root/.bashrc
