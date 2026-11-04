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
AUTO_CONFIRM=false
PARAM_AGENTE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force|-y|--yes)
            AUTO_CONFIRM=true
            shift
            ;;
        -a|--agent)
            PARAM_AGENTE="$2"
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
            echo "  -f, --force, -y, --yes    Continua e copia arquivos dentro das pastas já existentes"
            echo "  -a, --agent <nome>        Seleciona o agente (antigravity, cursor, codex, claude)"
            echo "  -d, --dir <caminho>       Caminho da raiz da aplicação destino"
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
# FASE 1: VALIDAÇÃO DE CONFLITOS E PASTAS JÁ EXISTENTES NA APLICAÇÃO
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[1/3] Realizando varredura preventiva na raiz da aplicação...${NC}"
CONFLITOS=0
AVISOS=""

if [ -d "$TARGET_APP_DIR/.spec" ]; then
    AVISOS="${AVISOS}⚠️  A pasta '.spec' já existe na aplicação.\n"
    ((CONFLITOS++))
fi

if [ -d "$TARGET_APP_DIR/.github/workflows" ]; then
    AVISOS="${AVISOS}⚠️  A pasta '.github/workflows' já existe na aplicação.\n"
    ((CONFLITOS++))
fi

if [ -d "$TARGET_APP_DIR/docs" ]; then
    AVISOS="${AVISOS}⚠️  A pasta 'docs' já existe na aplicação.\n"
    ((CONFLITOS++))
fi

if [ $CONFLITOS -gt 0 ]; then
    echo -e "${YELLOW}\n🚨 ATENÇÃO: Detectamos pastas já existentes no projeto da sua aplicação:${NC}"
    echo -e "${YELLOW}${AVISOS}${NC}"
    echo -e "${BLUE}ℹ️  Se você continuar, o FTN DevsIA irá copiar e mesclar os arquivos dentro das pastas já criadas (.spec, docs, .github, etc.), preservando os arquivos que você já tem no seu projeto.${NC}\n"

    if [ "$AUTO_CONFIRM" = "true" ]; then
        echo -e "${GREEN}⚡ Modo de continuação automática ativado (--force / -y). Prosseguindo com a cópia dos arquivos para dentro das pastas existentes...${NC}\n"
    else
        echo "Como você deseja prosseguir?"
        echo -e "  ${GREEN}1) Continuar mesmo assim e copiar os arquivos dentro das pastas já criadas (Recomendado)${NC}"
        echo -e "  ${RED}2) Cancelar a instalação para proteger o projeto atual${NC}"
        echo ""
        read_input "Escolha uma opção (1 ou 2) [Padrão: 1 - Continuar]: " RESPOSTA_CONFLITO
        RESPOSTA_CONFLITO="${RESPOSTA_CONFLITO:-1}"

        if [[ "$RESPOSTA_CONFLITO" =~ ^([1SsYy]|[Ss][Ii][Mm]|[Yy][Ee][Ss])$ ]]; then
            echo -e "${GREEN}✅ Opção 1 selecionada. Prosseguindo com a cópia dos arquivos para dentro das pastas existentes...${NC}\n"
        else
            echo -e "${RED}❌ Instalação cancelada pelo usuário.${NC}"
            exit 1
        fi
    fi
else
    echo -e "✅ Nenhuma pasta conflitante detectada. Diretório seguro para instalação limpa.\n"
fi

# ─────────────────────────────────────────────────────────────────────────────
# FASE 2: SELEÇÃO DO AGENTE DE IA
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[2/3] Seleção do Agente de IA para a Engine Spec-Driven:${NC}"

if [ -n "$PARAM_AGENTE" ]; then
    case "$PARAM_AGENTE" in
        1|antigravity) PARAM_AGENTE="antigravity" ;;
        2|cursor) PARAM_AGENTE="cursor" ;;
        3|codex) PARAM_AGENTE="codex" ;;
        4|claude) PARAM_AGENTE="claude" ;;
        *) PARAM_AGENTE="antigravity" ;;
    esac
    echo -e "✅ Agente pré-selecionado: ${YELLOW}$PARAM_AGENTE${NC}\n"
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
    echo -e "${GREEN}✅ Agente selecionado: $PARAM_AGENTE${NC}\n"
fi

# ─────────────────────────────────────────────────────────────────────────────
# FASE 3: INSTALAÇÃO DA ENGINE E CÓPIA DAS ESTRUTURAS NA APLICAÇÃO
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[3/3] Instalando framework e copiando estruturas na raiz da aplicação...${NC}"

cd "$TARGET_APP_DIR" || exit 1

# Inicializa o framework oficial do ONP com o agente escolhido dentro da aplicação
echo "📦 Executando npx @onovoprogramador/onp-spec para o agente '$PARAM_AGENTE'..."
npx --yes @onovoprogramador/onp-spec init --agents "$PARAM_AGENTE" 2>/dev/null || true

# Migra .agent legado para .agents na aplicacao se existir
if [ -d "$TARGET_APP_DIR/.agent" ]; then
    echo "🔄 Migrando .agent legado para .agents..."
    mkdir -p "$TARGET_APP_DIR/.agents"
    cp -rf "$TARGET_APP_DIR/.agent/"* "$TARGET_APP_DIR/.agents/" 2>/dev/null || true
    rm -rf "$TARGET_APP_DIR/.agent"
fi

# Cria ou garante as pastas necessárias na aplicação (mescla com as já existentes)
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
echo "📋 Copiando perfis especialistas e skills para .agents/skills/..."
cp -f "$SOURCE_FILES"/[0-9]*.md "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true
cp -f "$SOURCE_FILES/.agents/skills/iniciar_time_ftn.md" "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || \
cp -f "$SOURCE_FILES/.agent/skills/iniciar_time_ftn.md" "$TARGET_APP_DIR/.agents/skills/" 2>/dev/null || true

echo "⚙️ Copiando esteiras modulares de CI/CD para .github/workflows/..."
cp -rf "$SOURCE_FILES/.github/workflows/"* "$TARGET_APP_DIR/.github/workflows/" 2>/dev/null || true

echo "📂 Copiando central de governança e documentação para docs/..."
cp -rf "$SOURCE_FILES/docs/"* "$TARGET_APP_DIR/docs/" 2>/dev/null || true

echo "📝 Copiando constituição e arquitetura base para .spec/..."
cp -f "$SOURCE_FILES/.spec/constituicao.md" "$TARGET_APP_DIR/.spec/" 2>/dev/null || true
cp -f "$SOURCE_FILES/.spec/arquitetura.md" "$TARGET_APP_DIR/.spec/" 2>/dev/null || true

echo "🐳 Copiando stack do Doop UI/UX Canvas para docker/doop/..."
cp -rf "$SOURCE_FILES/docker/doop/"* "$TARGET_APP_DIR/docker/doop/" 2>/dev/null || true

echo "🛠️ Copiando utilitários para scripts/..."
cp -rf "$SOURCE_FILES/scripts/"* "$TARGET_APP_DIR/scripts/" 2>/dev/null || true
chmod +x "$TARGET_APP_DIR/scripts/"*.sh "$TARGET_APP_DIR/scripts/"*.js 2>/dev/null || true

# Limpa diretório temporário se foi criado (após todas as cópias concluídas)
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo -e "\n${GREEN}✨ [FTN DevsIA] Todas as estruturas foram copiadas com sucesso para dentro das pastas em:${NC}"
echo -e "👉 ${YELLOW}$TARGET_APP_DIR${NC}\n"
echo -e "Abra o seu editor ($PARAM_AGENTE) na pasta da sua aplicação e digite ${YELLOW}/iniciar-time-ftn${NC} no chat para começar."
