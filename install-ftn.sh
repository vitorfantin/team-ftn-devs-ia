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
PARAM_DOOP_MODE=""
PARAM_DOOP_URL=""
PARAM_DOOP_USER=""
PARAM_DOOP_PASS=""

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
        --doop-mode)
            PARAM_DOOP_MODE="$2"
            shift 2
            ;;
        --doop-url)
            PARAM_DOOP_URL="$2"
            shift 2
            ;;
        --doop-user)
            PARAM_DOOP_USER="$2"
            shift 2
            ;;
        --doop-pass)
            PARAM_DOOP_PASS="$2"
            shift 2
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
            echo "  --with-doop               Habilita o Doop UI/UX Canvas"
            echo "  --no-doop                 Desabilita o Doop (design specs em Markdown)"
            echo "  --doop-mode <local|remote> Modo do Doop (local via Docker ou remote via IP/externo)"
            echo "  --doop-url <url>          URL ou IP do servidor Doop (ex: http://192.168.1.50:3000)"
            echo "  --doop-user <usuario>     Usuário/e-mail para login no Doop"
            echo "  --doop-pass <senha>       Senha para login no Doop"
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
    echo -e "Deseja utilizar o ${BLUE}Doop UI/UX Canvas${NC} para desenho visual de telas e Design System?"
    echo "1) Sim (Recomendado - prototipagem visual de telas e tokens antes do código)"
    echo "2) Não (Utilizar especificações de telas em Markdown puro)"
    read_input "Escolha uma opção (1 ou 2) [Padrão: 1]: " OPCAO_DOOP
    OPCAO_DOOP="${OPCAO_DOOP:-1}"
    if [[ "$OPCAO_DOOP" =~ ^(1|[Ss]|[Ss][Ii][Mm]|[Yy]|[Yy][Ee][Ss])$ ]]; then
        PARAM_DOOP=true
        echo -e "✅ Doop UI/UX: ${GREEN}Habilitado${NC}\n"
    else
        PARAM_DOOP=false
        echo -e "ℹ️  Doop UI/UX: ${YELLOW}Desabilitado (Design em Markdown)${NC}\n"
    fi
else
    echo -e "✅ Doop UI/UX: $([ "$PARAM_DOOP" = "true" ] && echo -e "${GREEN}Habilitado${NC}" || echo -e "${YELLOW}Desabilitado${NC}")\n"
fi

# Se o Doop estiver habilitado, pergunta sobre modo de instalação e credenciais
if [ "$PARAM_DOOP" = "true" ]; then
    # 3.1 Modo de Hospedagem / Acesso do Doop
    if [ -z "$PARAM_DOOP_MODE" ]; then
        echo -e "Como você deseja utilizar e hospedar o Doop?"
        echo "1) Instalar localmente neste computador via Docker (http://localhost:3000) [Padrão]"
        echo "2) Acessar servidor existente por IP da rede local ou externo (ex: http://192.168.1.50:3000)"
        read_input "Escolha uma opção (1 ou 2) [Padrão: 1]: " OPCAO_DOOP_MODE
        OPCAO_DOOP_MODE="${OPCAO_DOOP_MODE:-1}"

        if [[ "$OPCAO_DOOP_MODE" =~ ^(2|[Rr][Ee][Mm][Oo][Tt][Ee]|[Ss][Ee][Rr][Vv][Ii][Dd][Oo][Rr])$ ]]; then
            PARAM_DOOP_MODE="remote"
            read_input "Digite a URL completa ou IP com porta do Doop (ex: http://192.168.1.50:3000) [Padrão: http://localhost:3000]: " PARAM_DOOP_URL
            PARAM_DOOP_URL="${PARAM_DOOP_URL:-http://localhost:3000}"
            echo -e "✅ Servidor Doop configurado para: ${GREEN}$PARAM_DOOP_URL${NC}\n"
        else
            PARAM_DOOP_MODE="local"
            PARAM_DOOP_URL="http://localhost:3000"
            echo -e "✅ Instalação local do Doop via Docker selecionada (${GREEN}$PARAM_DOOP_URL${NC})\n"
        fi
    else
        PARAM_DOOP_URL="${PARAM_DOOP_URL:-http://localhost:3000}"
    fi

    # 3.2 Credenciais de Acesso ao Doop (Usuário e Senha)
    if [ -z "$PARAM_DOOP_USER" ] && [ -z "$PARAM_DOOP_PASS" ]; then
        echo -e "Deseja configurar o usuário e senha de acesso ao Doop agora ou deixar para depois?"
        echo "1) Inserir usuário e senha agora"
        echo "2) Deixar para depois (configurar no arquivo posteriormente) [Padrão]"
        read_input "Escolha uma opção (1 ou 2) [Padrão: 2]: " OPCAO_CREDS
        OPCAO_CREDS="${OPCAO_CREDS:-2}"

        if [[ "$OPCAO_CREDS" =~ ^(1|[Ss]|[Ss][Ii][Mm]|[Yy]|[Yy][Ee][Ss])$ ]]; then
            read_input "Usuário / E-mail de acesso ao Doop: " PARAM_DOOP_USER
            read_input "Senha de acesso ao Doop: " PARAM_DOOP_PASS
            echo -e "✅ Credenciais do Doop registradas!\n"
        else
            PARAM_DOOP_USER=""
            PARAM_DOOP_PASS=""
            echo -e "ℹ️  Configuração de credenciais postergada."
            echo -e "📝 Para configurar o usuário e senha mais tarde, edite o arquivo:"
            echo -e "   👉 ${YELLOW}ftn.config.json${NC} nas chaves ${BLUE}\"doop.username\"${NC} e ${BLUE}\"doop.password\"${NC}"
            if [ "$PARAM_DOOP_MODE" = "local" ]; then
                echo -e "   (ou no arquivo ${YELLOW}docker/doop/.env${NC} para inicialização do container).\n"
            else
                echo -e "\n"
            fi
        fi
    fi
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
    "mode": "${PARAM_DOOP_MODE:-local}",
    "url": "${PARAM_DOOP_URL:-http://localhost:3000}",
    "username": "${PARAM_DOOP_USER:-}",
    "password": "${PARAM_DOOP_PASS:-}"
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
cp -rf "$SOURCE_FILES/.agents/skills/"* "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true
cp -f "$SOURCE_FILES"/[0-9]*.md "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true
cp -f "$SOURCE_FILES/.agents/skills/iniciar_time_ftn.md" "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || \
cp -f "$SOURCE_FILES/.agent/skills/iniciar_time_ftn.md" "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true

echo "⚙️ Copiando esteiras modulares de CI/CD para dentro de .github/workflows/..."
cp -rf "$SOURCE_FILES/.github/workflows/"* "$TARGET_APP_DIR/.github/workflows/" 2>/dev/null || true

echo "📂 Copiando central de governança e documentação para dentro de docs/..."
cp -rf "$SOURCE_FILES/docs/"* "$TARGET_APP_DIR/docs/" 2>/dev/null || true

echo "📝 Copiando constituição e arquitetura base para dentro de .spec/..."
cp -f "$SOURCE_FILES/.spec/constituicao.md" "$TARGET_APP_DIR/.spec/" 2>/dev/null || true
cp -f "$SOURCE_FILES/.spec/arquitetura.md" "$TARGET_APP_DIR/.spec/" 2>/dev/null || true

if [ "$PARAM_DOOP" = "true" ] && [ "$PARAM_DOOP_MODE" = "local" ]; then
    echo "🐳 Copiando stack do Doop UI/UX Canvas para dentro de docker/doop/..."
    cp -rf "$SOURCE_FILES/docker/doop/"* "$TARGET_APP_DIR/docker/doop/" 2>/dev/null || true
    cat << EOF > "$TARGET_APP_DIR/docker/doop/.env"
DOOP_PORT=3000
DOOP_USER=${PARAM_DOOP_USER:-}
DOOP_PASSWORD=${PARAM_DOOP_PASS:-}
EOF
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

if [ "$PARAM_DOOP" = "true" ]; then
    if [ "$PARAM_DOOP_MODE" = "local" ]; then
        echo -e "🐳 ${BLUE}[Doop Local]:${NC} Para subir o container do Doop, execute:"
        echo -e "   ${YELLOW}docker compose -f docker/doop/docker-compose.yml up -d${NC}"
    else
        echo -e "🌐 ${BLUE}[Doop Remoto]:${NC} Apontado para ${YELLOW}$PARAM_DOOP_URL${NC}"
    fi

    if [ -z "$PARAM_DOOP_USER" ]; then
        echo -e "📝 ${YELLOW}[Credenciais do Doop]:${NC} Você optou por configurar depois. Quando desejar, edite:"
        echo -e "   👉 ${BLUE}$TARGET_APP_DIR/ftn.config.json${NC} (\"doop.username\" e \"doop.password\")"
        [ "$PARAM_DOOP_MODE" = "local" ] && echo -e "   (ou em: $TARGET_APP_DIR/docker/doop/.env)\n"
    fi
fi

echo -e "\nComandos disponíveis no chat da sua IA ($PARAM_AGENTE):"
echo -e "  👥 ${YELLOW}/reuniao${NC}          : Convoca a mesa redonda com todo o time para planejar e alinhar nova demanda"
echo -e "  🚀 ${YELLOW}/iniciar-time-ftn${NC} : Inicializa a governança e o ciclo de desenvolvimento da aplicação"
echo -e "\nAtalhos rápidos para chamar cada especialista individualmente:"
echo -e "  🎙️  ${YELLOW}/pm${NC}      : Product Manager (regras de negócio, escopo, US e AC)"
echo -e "  🏛️  ${YELLOW}/tl${NC}      : Tech Lead (arquitetura, contratos de API, Postgres 18.6)"
echo -e "  🎨 ${YELLOW}/uiux${NC}    : UI/UX Designer (protótipos no Doop Canvas e WCAG)"
echo -e "  ⚙️  ${YELLOW}/back${NC}    : Backend Dev (DER vivo, APIs seguras, TDD ≥ 90%)"
echo -e "  💻 ${YELLOW}/front${NC}   : Frontend Dev (telas web responsivas, componentes, TDD ≥ 90%)"
echo -e "  📱 ${YELLOW}/mobile${NC}  : Mobile Dev (Flutter, telas móveis, TDD ≥ 90%)"
echo -e "  🧪 ${YELLOW}/qa${NC}      : QA Tester (casos de teste, E2E via qa-id, carga K6)"
echo -e "  🚀 ${YELLOW}/devops${NC}  : DevOps (pipelines CI/CD, Swarm, Traefik, Portão Humano)"
echo -e "  🛡️  ${YELLOW}/secops${NC}  : SecOps (auditoria SAST, vazamento de segredos, LGPD)"
