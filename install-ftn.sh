#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

echo -e "${GREEN}🚀 [FTN DevsIA] Iniciando o Assistente Inteligente de Configuração...${NC}\n"

# ─────────────────────────────────────────────────────────────────────────────
# FASE 1: VALIDAÇÃO DE CONFLITOS E RISCOS (BROWNFIELD / LEGADO)
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[1/3] Realizando varredura preventiva no diretório atual...${NC}"
CONFLITOS=0
AVISOS=""

if [ -d ".spec" ]; then
    AVISOS="${AVISOS}⚠️  A pasta '.spec' já existe. Inicializar o framework pode sobrescrever regras de negócio antigas.\n"
    ((CONFLITOS++))
fi

if [ -d ".github/workflows" ]; then
    AVISOS="${AVISOS}⚠️  A pasta '.github/workflows' já existe. Nossos micro-workflows de CI/CD podem conflitar com as esteiras atuais.\n"
    ((CONFLITOS++))
fi

if [ -d "docs" ]; then
    AVISOS="${AVISOS}⚠️  A pasta 'docs' já existe. A criação das subpastas ftn pode misturar arquivos legados.\n"
    ((CONFLITOS++))
fi

if [ $CONFLITOS -gt 0 ]; then
    echo -e "${YELLOW}\n🚨 ATENÇÃO: Detectamos possíveis conflitos no projeto existente:${NC}"
    echo -e "${YELLOW}${AVISOS}${NC}"
    echo -e "Essas alterações são cruciais para o padrão FTN, mas podem modificar arquivos locais."
    read -p "Deseja continuar e aplicar as configurações mesmo assim? (s/n): " CONFIRMACAO
    if [[ ! "$CONFIRMACAO" =~ ^[Ss]$ ]]; then
        echo -e "${RED}❌ Instalação cancelada pelo usuário para proteger o código atual.${NC}"
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
# FASE 3: INSTALAÇÃO DA ENGINE E ESTRUTURA MODULAR
# ─────────────────────────────────────────────────────────────────────────────
echo -e "${GREEN}[3/3] Executando downloads e montagem de pastas...${NC}"

# Inicializa o framework oficial do ONP com o agente escolhido
echo "📦 Executando npx @onovoprogramador/onp-spec para o agente '$PARAM_AGENTE'..."
npx @onovoprogramador/onp-spec init --agents $PARAM_AGENTE

# Cria a estrutura rígida de pastas do padrão FTN
mkdir -p docs/documentacao_projeto
mkdir -p docs/tutoriais
mkdir -p .agent/skills

# Cria o gatilho de comando para o ecossistema de IAs saber como agir
cat << 'EOF' > .agent/skills/iniciar_time_ftn.md
# Command: /iniciar-time-ftn

Sempre que o usuário digitar este comando no chat, o agente `@ProductManager` deve assumir o controle absoluto do chat imediatamente.

## 🎯 Ações do Comando
1. Imprima uma mensagem de boas-vindas: `🚀 FTN DevsIA - Inicialização de Projeto`.
2. Dispare imediatamente a **Fase Zero de Alinhamento**, apresentando os 6 Blocos do Questionário Mestre (Proposta, Plataforma, Engenharia/Dados com Postgres 18.6, Estratégia de Legado, Configuração de Testes e Gestão de Tarefas).
3. Não permita que o usuário envie comandos de código antes de responder às perguntas.
EOF

echo -e "\n${GREEN}✨ [FTN DevsIA] Ecossistema configurado com sucesso e protegido contra quebras!${NC}"
echo -e "Abra o seu editor ($PARAM_AGENTE) e digite ${YELLOW}/iniciar-time-ftn${NC} no chat para começar."
