#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🎨 [FTN DevsIA] Instalador & Gerenciador do Doop (UI/UX Canvas)${NC}"
echo -e "Repositório Oficial: https://github.com/kgoedecke/doop\n"

# Obtém o IP da rede local para acesso compartilhado
LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

echo "Como você deseja executar o Doop para o time de UI/UX?"
echo "1) Via Docker / Docker Compose (Recomendado para servidores locais e isolamento)"
echo "2) Via Bun Nativo (Local na máquina de desenvolvimento)"
read -p "Escolha uma opção (1-2): " OPCAO_DOOP

case $OPCAO_DOOP in
    1)
        echo -e "\n${GREEN}🐳 Inicializando Doop via Docker...${NC}"
        if ! command -v docker &> /dev/null; then
            echo -e "${RED}❌ Docker não está instalado. Instale o Docker Desktop primeiro: https://www.docker.com/${NC}"
            exit 1
        fi

        cd "$(dirname "$0")/../docker/doop" || exit 1
        docker compose up -d --build

        echo -e "\n${GREEN}✨ Doop UI/UX Canvas está ativo no Docker!${NC}"
        echo -e "👉 Acesso Local:        ${YELLOW}http://localhost:3000${NC}"
        echo -e "👉 Acesso Rede Local:   ${YELLOW}http://${LOCAL_IP}:3000${NC}"
        ;;

    2)
        echo -e "\n${GREEN}⚡ Inicializando Doop nativamente via Bun...${NC}"
        if ! command -v bun &> /dev/null; then
            echo -e "${YELLOW}⚠️  Bun não detectado. Instalando Bun automaticamente...${NC}"
            curl -fsSL https://bun.sh/install | bash
            export PATH="$HOME/.bun/bin:$PATH"
        fi

        TARGET_DIR="$(dirname "$0")/../.doop-local"
        if [ ! -d "$TARGET_DIR" ]; then
            echo "📥 Clonando https://github.com/kgoedecke/doop..."
            git clone https://github.com/kgoedecke/doop.git "$TARGET_DIR"
        fi

        cd "$TARGET_DIR" || exit 1
        bun install
        echo -e "\n${GREEN}✨ Doop pronto! Iniciando servidor de desenvolvimento...${NC}"
        echo -e "👉 Acesso Local:        ${YELLOW}http://localhost:3000${NC}"
        echo -e "👉 Acesso Rede Local:   ${YELLOW}http://${LOCAL_IP}:3000${NC}"
        bun run dev
        ;;

    *)
        echo -e "${RED}❌ Opção inválida.${NC}"
        exit 1
        ;;
esac
