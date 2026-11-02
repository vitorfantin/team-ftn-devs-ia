#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

echo -e "${GREEN}🚀 [FTN DevsIA] Assistente Inteligente de Instalação na Aplicação${NC}\n"

# ─────────────────────────────────────────────────────────────────────────────
# FASE 0: RESOLUÇÃO DA RAIZ DO PROJETO DA APLICAÇÃO (DESTINO)
# ─────────────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
REPO_NAME="team-ftn-devs-ia"

if [ -n "$1" ]; then
    TARGET_APP_DIR="$1"
elif [ -f "$PWD/8_SecOps.md" ] && [ -f "$PWD/1_ProductManager.md" ]; then
    echo -e "${YELLOW}⚠️  ATENÇÃO: Você executou o instalador dentro do repositório matriz ($REPO_NAME).${NC}"
    echo -e "As estruturas ${RED}NÃO devem ser instaladas aqui${NC}, mas sim na ${GREEN}raiz do seu projeto de aplicação${NC}.\n"
    read -p "Digite o caminho absoluto da pasta da sua aplicação (ex: /Users/seu-usuario/meu-app): " USER_INPUT_DIR
    TARGET_APP_DIR="$USER_INPUT_DIR"
else
    TARGET_APP_DIR="$PWD"
fi

if [ -z "$TARGET_APP_DIR" ] || [ ! -d "$TARGET_APP_DIR" ]; then
    echo -e "${RED}❌ Diretório da aplicação inválido ou não encontrado: '$TARGET_APP_DIR'.${NC}"
    exit 1
fi

TARGET_APP_DIR="$(cd "$TARGET_APP_DIR" && pwd)"
echo -e "📁 ${BLUE}Diretório Alvo da Aplicação:${NC} ${YELLOW}$TARGET_APP_DIR${NC}\n"

# ─────────────────────────────────────────────────────────────────────────────
# FASE 1: VALIDAÇÃO DE CONFLITOS E RISCOS NA APLICAÇÃO (BROWNFIELD / LEGADO)
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[1/3] Realizando varredura preventiva na raiz da aplicação...${NC}"
CONFLITOS=0
AVISOS=""

if [ -d "$TARGET_APP_DIR/.spec" ]; then
    AVISOS="${AVISOS}⚠️  A pasta '.spec' já existe na aplicação. Sobrescrever pode alterar regras existentes.\n"
    ((CONFLITOS++))
fi

if [ -d "$TARGET_APP_DIR/.github/workflows" ]; then
    AVISOS="${AVISOS}⚠️  A pasta '.github/workflows' já existe. Nossas esteiras modulares de CI/CD podem conflitar com as atuais.\n"
    ((CONFLITOS++))
fi

if [ -d "$TARGET_APP_DIR/docs" ]; then
    AVISOS="${AVISOS}⚠️  A pasta 'docs' já existe na aplicação.\n"
    ((CONFLITOS++))
fi

if [ $CONFLITOS -gt 0 ]; then
    echo -e "${YELLOW}\n🚨 ATENÇÃO: Detectamos possíveis conflitos no seu projeto existente:${NC}"
    echo -e "${YELLOW}${AVISOS}${NC}"
    read -p "Deseja continuar e aplicar as configurações na aplicação mesmo assim? (s/n): " CONFIRMACAO
    if [[ ! "$CONFIRMACAO" =~ ^[Ss]$ ]]; then
        echo -e "${RED}❌ Instalação cancelada para proteger o projeto atual.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Confirmação recebida. Prosseguindo com cautela...${NC}\n"
else
    echo -e "✅ Nenhum conflito detectado. Diretório seguro para instalação limpa.\n"
fi

# ─────────────────────────────────────────────────────────────────────────────
# FASE 2: SELEÇÃO DO AGENTE DE IA
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[2/3] Seleção do Agente de IA para a Engine Spec-Driven:${NC}"
echo "Qual editor/agente de IA você utilizará neste projeto?"
echo "1) Antigravity"
echo "2) Cursor"
echo "3) Codex"
echo "4) Claude Code"
read -p "Escolha uma opção (1-4): " OPCAO_AGENTE

PARAM_AGENTE=""
case $OPCAO_AGENTE in
    1) PARAM_AGENTE="antigravity" ;;
    2) PARAM_AGENTE="cursor" ;;
    3) PARAM_AGENTE="codex" ;;
    4) PARAM_AGENTE="claude" ;;
    *) 
        echo -e "${RED}❌ Opção inválida. Instalação abortada.${NC}"
        exit 1 
        ;;
esac

echo -e "${GREEN}✅ Agente selecionado: $PARAM_AGENTE${NC}\n"

# ─────────────────────────────────────────────────────────────────────────────
# FASE 3: INSTALAÇÃO DA ENGINE E CÓPIA DAS ESTRUTURAS NA APLICAÇÃO
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[3/3] Instalando framework e copiando estruturas na raiz da aplicação...${NC}"

cd "$TARGET_APP_DIR" || exit 1

# Inicializa o framework oficial do ONP com o agente escolhido dentro da aplicação
echo "📦 Executando npx @onovoprogramador/onp-spec para o agente '$PARAM_AGENTE'..."
npx @onovoprogramador/onp-spec init --agents $PARAM_AGENTE

# Cria as pastas necessárias na aplicação
mkdir -p "$TARGET_APP_DIR/docs/documentacao_projeto"
mkdir -p "$TARGET_APP_DIR/docs/tutoriais"
mkdir -p "$TARGET_APP_DIR/docs/design"
mkdir -p "$TARGET_APP_DIR/docs/auditoria"
mkdir -p "$TARGET_APP_DIR/docs/testes/casos_de_teste"
mkdir -p "$TARGET_APP_DIR/docs/banco_de_dados"
mkdir -p "$TARGET_APP_DIR/docker/doop"
mkdir -p "$TARGET_APP_DIR/.spec/features"
mkdir -p "$TARGET_APP_DIR/.agent/skills"
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

# Copia estruturas essenciais diretamente para a raiz da aplicação
echo "📋 Copiando perfis especialistas e skills para .agent/skills/..."
cp -f "$SOURCE_FILES"/[0-9]*.md "$TARGET_APP_DIR/.agent/skills/" 2>/dev/null || true

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

# Limpa diretório temporário se foi criado
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

# Copia ou atualiza o gatilho de comando /iniciar-time-ftn na aplicação
cp -f "$SOURCE_FILES/.agent/skills/iniciar_time_ftn.md" "$TARGET_APP_DIR/.agent/skills/" 2>/dev/null || true

echo -e "\n${GREEN}✨ [FTN DevsIA] Todas as estruturas foram copiadas com sucesso para:${NC}"
echo -e "👉 ${YELLOW}$TARGET_APP_DIR${NC}\n"
echo -e "Abra o seu editor ($PARAM_AGENTE) na pasta da sua aplicação e digite ${YELLOW}/iniciar-time-ftn${NC} no chat para começar."
