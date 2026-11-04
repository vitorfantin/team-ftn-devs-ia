#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

echo -e "${GREEN}🚀 [FTN DevsIA] Assistente Inteligente de Instalação na Aplicação${NC}\n"

# Função para leitura interativa resiliente (suporta terminal, pipe e /dev/tty)
read_input() {
    local prompt="$1"
    local var_name="$2"
    if [ -t 0 ]; then
        read -r -p "$prompt" "$var_name"
    else
        if ! read -r "$var_name"; then
            if [ -c /dev/tty ]; then
                read -r -p "$prompt" "$var_name" < /dev/tty
            fi
        fi
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# PARSE DE ARGUMENTOS DE LINHA DE COMANDO
# ─────────────────────────────────────────────────────────────────────────────
TARGET_APP_DIR=""
PARAM_AGENTE=""
PARAM_CLICKUP=""
PARAM_DOOP=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force|-y|--yes)
            # Mantido para retrocompatibilidade
            shift
            ;;
        -a|--agent)
            PARAM_AGENTE="$2"
            shift 2
            ;;
        --with-clickup)
            PARAM_CLICKUP=true
            shift
            ;;
        --no-clickup)
            PARAM_CLICKUP=false
            shift
            ;;
        --with-doop)
            PARAM_DOOP=true
            shift
            ;;
        --no-doop)
            PARAM_DOOP=false
            shift
            ;;
        -d|--dir)
            TARGET_APP_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Uso: ./install-ftn.sh [DIRETORIO_DA_APLICACAO] [OPCOES]"
            echo ""
            echo "Opções:"
            echo "  -a, --agent <nome>        Seleciona o agente (antigravity, cursor, codex, claude)"
            echo "  --with-clickup            Habilita o ClickUp para gestão visual de tarefas"
            echo "  --no-clickup              Desabilita o ClickUp (rastreamento local via Markdown)"
            echo "  --with-doop               Habilita o Doop UI/UX Canvas (Docker local/rede)"
            echo "  --no-doop                 Desabilita o Doop (design specs em Markdown)"
            echo "  -d, --dir <caminho>       Caminho da raiz da aplicação destino"
            echo "  -f, --force, -y, --yes    Execução direta sem confirmações"
            echo "  -h, --help                Exibe esta ajuda"
            exit 0
            ;;
        *)
            if [ -z "$TARGET_APP_DIR" ]; then
                TARGET_APP_DIR="$1"
            fi
            shift
            ;;
    esac
done

# ─────────────────────────────────────────────────────────────────────────────
# FASE 0: RESOLUÇÃO DA RAIZ DO PROJETO DA APLICAÇÃO (DESTINO)
# ─────────────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
REPO_NAME="team-ftn-devs-ia"

if [ -z "$TARGET_APP_DIR" ]; then
    if [ -f "$PWD/8_SecOps.md" ] && [ -f "$PWD/1_ProductManager.md" ]; then
        echo -e "${YELLOW}⚠️  ATENÇÃO: Você executou o instalador dentro do repositório matriz ($REPO_NAME).${NC}"
        echo -e "As estruturas ${RED}NÃO devem ser instaladas aqui${NC}, mas sim na ${GREEN}raiz do seu projeto de aplicação${NC}.\n"
        read_input "Digite o caminho absoluto da pasta da sua aplicação (ex: /Users/seu-usuario/meu-app): " USER_INPUT_DIR
        TARGET_APP_DIR="$USER_INPUT_DIR"
    else
        TARGET_APP_DIR="$PWD"
    fi
fi

if [ -z "$TARGET_APP_DIR" ] || [ ! -d "$TARGET_APP_DIR" ]; then
    echo -e "${RED}❌ Diretório da aplicação inválido ou não encontrado: '$TARGET_APP_DIR'.${NC}"
    exit 1
fi

TARGET_APP_DIR="$(cd "$TARGET_APP_DIR" && pwd)"
echo -e "📁 ${BLUE}Diretório Alvo da Aplicação:${NC} ${YELLOW}$TARGET_APP_DIR${NC}\n"

# ─────────────────────────────────────────────────────────────────────────────
# FASE 1: VARREDURA E CONFIRMAÇÃO DE CÓPIA NAS PASTAS JÁ CRIADAS
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[1/3] Verificando pastas na raiz da aplicação...${NC}"

PASTAS_EXISTENTES=""
[ -d "$TARGET_APP_DIR/.spec" ] && PASTAS_EXISTENTES="${PASTAS_EXISTENTES} .spec"
[ -d "$TARGET_APP_DIR/.github/workflows" ] && PASTAS_EXISTENTES="${PASTAS_EXISTENTES} .github/workflows"
[ -d "$TARGET_APP_DIR/docs" ] && PASTAS_EXISTENTES="${PASTAS_EXISTENTES} docs"
[ -d "$TARGET_APP_DIR/.agents" ] && PASTAS_EXISTENTES="${PASTAS_EXISTENTES} .agents"

if [ -n "$PASTAS_EXISTENTES" ]; then
    echo -e "ℹ️  Pastas já criadas detectadas na aplicação:${YELLOW}${PASTAS_EXISTENTES}${NC}"
    echo -e "📂 ${GREEN}Mesclagem automática: os arquivos do FTN DevsIA serão copiados diretamente para dentro dessas pastas, mantendo todos os arquivos existentes do seu projeto intactos.${NC}\n"
else
    echo -e "✅ Diretório limpo. Pastas serão criadas normalmente.\n"
fi

# ─────────────────────────────────────────────────────────────────────────────
# FASE 2: SELEÇÃO DO AGENTE DE IA & CONFIGURAÇÃO DE CLICKUP E DOOP
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[2/3] Configurações de Stack & Ferramentas Opcionais:${NC}"

# 1. Seleção do Agente
if [ -n "$PARAM_AGENTE" ]; then
    case "$PARAM_AGENTE" in
        1|antigravity) PARAM_AGENTE="antigravity" ;;
        2|cursor) PARAM_AGENTE="cursor" ;;
        3|codex) PARAM_AGENTE="codex" ;;
        4|claude) PARAM_AGENTE="claude" ;;
        *) PARAM_AGENTE="antigravity" ;;
    esac
    echo -e "✅ Agente de IA: ${YELLOW}$PARAM_AGENTE${NC}"
else
    echo "Qual editor/agente de IA você utilizará neste projeto?"
    echo "1) Antigravity (Padrão)"
    echo "2) Cursor"
    echo "3) Codex"
    echo "4) Claude Code"
    read_input "Escolha uma opção (1-4) [Padrão: 1]: " OPCAO_AGENTE
    OPCAO_AGENTE="${OPCAO_AGENTE:-1}"

    case $OPCAO_AGENTE in
        1|antigravity) PARAM_AGENTE="antigravity" ;;
        2|cursor) PARAM_AGENTE="cursor" ;;
        3|codex) PARAM_AGENTE="codex" ;;
        4|claude) PARAM_AGENTE="claude" ;;
        *) 
            echo -e "${YELLOW}Opção não reconhecida ('$OPCAO_AGENTE'). Utilizando padrão: antigravity.${NC}"
            PARAM_AGENTE="antigravity"
            ;;
    esac
    echo -e "✅ Agente selecionado: ${GREEN}$PARAM_AGENTE${NC}\n"
fi

# 2. Configuração do ClickUp (Opcional)
if [ -z "$PARAM_CLICKUP" ]; then
    echo -e "Deseja utilizar o ${BLUE}ClickUp${NC} para visualização, rastreabilidade e gestão de tarefas das features?"
    echo "1) Sim (Recomendado - integra cards, status e subtarefas automáticas)"
    echo "2) Não (Utilizar apenas arquivos locais em Markdown / Spec)"
    read_input "Escolha uma opção (1 ou 2) [Padrão: 1]: " OPCAO_CLICKUP
    OPCAO_CLICKUP="${OPCAO_CLICKUP:-1}"
    if [[ "$OPCAO_CLICKUP" =~ ^(1|[Ss]|[Ss][Ii][Mm]|[Yy]|[Yy][Ee][Ss])$ ]]; then
        PARAM_CLICKUP=true
        echo -e "✅ ClickUp: ${GREEN}Habilitado (Padrão para todas as features)${NC}\n"
    else
        PARAM_CLICKUP=false
        echo -e "ℹ️  ClickUp: ${YELLOW}Desabilitado (Rastreamento via Markdown local)${NC}\n"
    fi
else
    echo -e "✅ ClickUp: $([ "$PARAM_CLICKUP" = "true" ] && echo -e "${GREEN}Habilitado${NC}" || echo -e "${YELLOW}Desabilitado${NC}")\n"
fi

# 3. Configuração do Doop UI/UX Canvas (Opcional)
if [ -z "$PARAM_DOOP" ]; then
    echo -e "Deseja utilizar o ${BLUE}Doop UI/UX Canvas${NC} (Docker local/rede) para desenho visual de telas e Design System?"
    echo "1) Sim (Recomendado - prototipagem visual de telas e tokens antes do código)"
    echo "2) Não (Utilizar especificações de telas em Markdown puro)"
    read_input "Escolha uma opção (1 ou 2) [Padrão: 1]: " OPCAO_DOOP
    OPCAO_DOOP="${OPCAO_DOOP:-1}"
    if [[ "$OPCAO_DOOP" =~ ^(1|[Ss]|[Ss][Ii][Mm]|[Yy]|[Yy][Ee][Ss])$ ]]; then
        PARAM_DOOP=true
        echo -e "✅ Doop UI/UX: ${GREEN}Habilitado (Docker local/rede)${NC}\n"
    else
        PARAM_DOOP=false
        echo -e "ℹ️  Doop UI/UX: ${YELLOW}Desabilitado (Design em Markdown)${NC}\n"
    fi
else
    echo -e "✅ Doop UI/UX: $([ "$PARAM_DOOP" = "true" ] && echo -e "${GREEN}Habilitado${NC}" || echo -e "${YELLOW}Desabilitado${NC}")\n"
fi

# ─────────────────────────────────────────────────────────────────────────────
# FASE 3: INSTALAÇÃO DA ENGINE E CÓPIA DOS ARQUIVOS PARA DENTRO DAS PASTAS
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[3/3] Copiando arquivos e configurando ecossistema na aplicação...${NC}"

cd "$TARGET_APP_DIR" || exit 1

# Inicializa o framework oficial do ONP com o agente escolhido dentro da aplicação
echo "📦 Executando npx @onovoprogramador/onp-spec para o agente '$PARAM_AGENTE'..."
npx --yes @onovoprogramador/onp-spec init --agents "$PARAM_AGENTE" 2>/dev/null || true

# Salva a configuração de governança FTN (ftn.config.json)
echo "⚙️ Salvando configurações em ftn.config.json..."
cat << EOF > "$TARGET_APP_DIR/ftn.config.json"
{
  "version": "1.1.1",
  "agent": "$PARAM_AGENTE",
  "clickup": {
    "enabled": $PARAM_CLICKUP,
    "apiToken": "",
    "teamId": "",
    "spaceId": "",
    "listId": ""
  },
  "doop": {
    "enabled": $PARAM_DOOP,
    "url": "http://localhost:3000"
  },
  "specDriven": {
    "engine": "@onovoprogramador/onp-spec",
    "constitution": ".spec/constituicao.md",
    "featuresDir": ".spec/features",
    "verificationDir": ".spec/verification"
  }
}
EOF

# Migra .agent legado para .agents na aplicacao se existir
if [ -d "$TARGET_APP_DIR/.agent" ]; then
    echo "🔄 Migrando .agent legado para .agents..."
    mkdir -p "$TARGET_APP_DIR/.agents"
    cp -rf "$TARGET_APP_DIR/.agent/"* "$TARGET_APP_DIR/.agents/" 2>/dev/null || true
    rm -rf "$TARGET_APP_DIR/.agent"
fi

# Garante que todas as pastas de destino existam na aplicação
mkdir -p "$TARGET_APP_DIR/docs/documentacao_projeto"
mkdir -p "$TARGET_APP_DIR/docs/tutoriais"
mkdir -p "$TARGET_APP_DIR/docs/design"
mkdir -p "$TARGET_APP_DIR/docs/auditoria"
mkdir -p "$TARGET_APP_DIR/docs/testes/casos_de_teste"
mkdir -p "$TARGET_APP_DIR/docs/banco_de_dados"
mkdir -p "$TARGET_APP_DIR/docker/doop"
mkdir -p "$TARGET_APP_DIR/.spec/features"
mkdir -p "$TARGET_APP_DIR/.spec/verification"
mkdir -p "$TARGET_APP_DIR/.agents/skills"
mkdir -p "$TARGET_APP_DIR/.github/workflows"
mkdir -p "$TARGET_APP_DIR/scripts"

# Determina a origem dos arquivos (local ou clone remoto temporário via curl)
TEMP_DIR=""
if [ -f "$SCRIPT_DIR/1_ProductManager.md" ]; then
    SOURCE_FILES="$SCRIPT_DIR"
else
    echo "🌐 Baixando templates do repositório oficial team-ftn-devs-ia..."
    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/vitorfantin/team-ftn-devs-ia.git "$TEMP_DIR" 2>/dev/null
    SOURCE_FILES="$TEMP_DIR"
fi

# Copia estruturas essenciais diretamente para dentro das pastas na aplicação
echo "📋 Copiando perfis especialistas e skills para dentro de .agents/skills/..."
cp -f "$SOURCE_FILES"/[0-9]*.md "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true
cp -f "$SOURCE_FILES/.agents/skills/iniciar_time_ftn.md" "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || \
cp -f "$SOURCE_FILES/.agent/skills/iniciar_time_ftn.md" "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true
cp -f "$SOURCE_FILES/.agents/skills/reuniao_time_ftn.md" "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true

echo "⚙️ Copiando esteiras modulares de CI/CD para dentro de .github/workflows/..."
cp -rf "$SOURCE_FILES/.github/workflows/"* "$TARGET_APP_DIR/.github/workflows/" 2>/dev/null || true

echo "📂 Copiando central de governança e documentação para dentro de docs/..."
cp -rf "$SOURCE_FILES/docs/"* "$TARGET_APP_DIR/docs/" 2>/dev/null || true

echo "📝 Copiando constituição e arquitetura base para dentro de .spec/..."
cp -f "$SOURCE_FILES/.spec/constituicao.md" "$TARGET_APP_DIR/.spec/" 2>/dev/null || true
cp -f "$SOURCE_FILES/.spec/arquitetura.md" "$TARGET_APP_DIR/.spec/" 2>/dev/null || true

if [ "$PARAM_DOOP" = "true" ]; then
    echo "🐳 Copiando stack do Doop UI/UX Canvas para dentro de docker/doop/..."
    cp -rf "$SOURCE_FILES/docker/doop/"* "$TARGET_APP_DIR/docker/doop/" 2>/dev/null || true
fi

echo "🛠️ Copiando utilitários para dentro de scripts/..."
cp -rf "$SOURCE_FILES/scripts/"* "$TARGET_APP_DIR/scripts/" 2>/dev/null || true
chmod +x "$TARGET_APP_DIR/scripts/"*.sh "$TARGET_APP_DIR/scripts/"*.js 2>/dev/null || true

# Limpa diretório temporário se foi criado (após todas as cópias concluídas)
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo -e "\n${GREEN}✨ [FTN DevsIA] Todas as estruturas foram configuradas com sucesso em:${NC}"
echo -e "👉 ${YELLOW}$TARGET_APP_DIR${NC}"
echo -e "⚙️  Configuração salva em: ${BLUE}$TARGET_APP_DIR/ftn.config.json${NC}\n"
echo -e "Comandos disponíveis no chat da sua IA ($PARAM_AGENTE):"
echo -e "  💬 ${YELLOW}/reuniao-time-ftn${NC} : Convoca a mesa com todos os especialistas para ouvir a demanda do cliente e alinhar dúvidas"
echo -e "  🚀 ${YELLOW}/iniciar-time-ftn${NC} : Inicializa a governança e o ciclo de desenvolvimento da aplicação"
