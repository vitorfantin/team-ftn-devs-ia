FROM oven/bun:latest

WORKDIR /app

# Instala git para clonar ou atualizar dependências
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Se o repositório do Doop for montado via volume ou clonado
RUN if [ ! -f package.json ]; then \
      git clone https://github.com/kgoedecke/doop.git . ; \
    fi

RUN bun install

EXPOSE 3000

ENV PORT=3000
ENV HOST=0.0.0.0

CMD ["bun", "run", "dev"]
