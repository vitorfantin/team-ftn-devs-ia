#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# 🔄 FTN DevsIA - Assistente de Atualização da Governança na Aplicação
# Atualiza as mentes especialistas, esteiras de CI/CD, docs e constituição
# preservando intactos o ftn.config.json (tokens/credenciais) e o código do projeto.
# ─────────────────────────────────────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}🔄 [FTN DevsIA] Assistente de Atualização da Governança na Aplicação${NC}\n"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

TARGET_APP_DIR=""
EXTRA_ARGS=()

for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
        EXTRA_ARGS+=("$arg")
    elif [ -z "$TARGET_APP_DIR" ]; then
        TARGET_APP_DIR="$arg"
    else
        EXTRA_ARGS+=("$arg")
    fi
done

TARGET_APP_DIR="${TARGET_APP_DIR:-$PWD}"

# Se executado dentro do repositório matriz, orienta o usuário
if [ -f "$TARGET_APP_DIR/8_SecOps.md" ] && [ -f "$TARGET_APP_DIR/1_ProductManager.md" ]; then
    if [ -f "$TARGET_APP_DIR/.git/config" ] && grep -q "team-ftn-devs-ia" "$TARGET_APP_DIR/.git/config" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  ATENÇÃO: Você executou o atualizador dentro do repositório matriz (team-ftn-devs-ia).${NC}"
        echo -e "Para atualizar sua aplicação, informe o caminho: ${GREEN}./update-ftn.sh /caminho/da/aplicacao${NC}\n"
        exit 1
    fi
fi

TARGET_APP_DIR="$(cd "$TARGET_APP_DIR" && pwd)"
echo -e "📁 ${BLUE}Diretório da Aplicação a Atualizar:${NC} ${YELLOW}$TARGET_APP_DIR${NC}\n"

# Baixa ou usa o install-ftn.sh mais recente com a flag --update
TEMP_INSTALLER=""
if [ -f "$SCRIPT_DIR/install-ftn.sh" ] && [ "$SCRIPT_DIR" != "$TARGET_APP_DIR" ]; then
    INSTALLER_SCRIPT="$SCRIPT_DIR/install-ftn.sh"
else
    echo "🌐 Baixando instalador mais recente do repositório oficial..."
    TEMP_INSTALLER=$(mktemp)
    curl -fsSL https://raw.githubusercontent.com/vitorfantin/team-ftn-devs-ia/main/install-ftn.sh -o "$TEMP_INSTALLER" 2>/dev/null || {
        echo -e "${RED}❌ Erro ao baixar install-ftn.sh do GitHub. Verifique sua conexão com a internet.${NC}"
        exit 1
    }
    INSTALLER_SCRIPT="$TEMP_INSTALLER"
fi

bash "$INSTALLER_SCRIPT" "$TARGET_APP_DIR" --update "${EXTRA_ARGS[@]}"

if [ -n "$TEMP_INSTALLER" ] && [ -f "$TEMP_INSTALLER" ]; then
    rm -f "$TEMP_INSTALLER"
fi
