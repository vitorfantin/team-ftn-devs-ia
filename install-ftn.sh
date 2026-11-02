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
mkdir -p docs/design
mkdir -p docs/auditoria
mkdir -p docs/testes/casos_de_teste
mkdir -p docs/banco_de_dados
mkdir -p docker/doop
mkdir -p .spec/features
mkdir -p .agent/skills

# Copia arquivos dos especialistas se executado localmente no repositório
if ls [0-9]*.md 1> /dev/null 2>&1; then
    echo "📋 Copiando perfis especialistas para .agent/skills/..."
    cp -f [0-9]*.md .agent/skills/ 2>/dev/null || true
fi

# Cria o gatilho de comando para o ecossistema de IAs saber como agir
cat << 'EOF' > .agent/skills/iniciar_time_ftn.md
# Command: /iniciar-time-ftn
# Team: FTN DevsIA

Sempre que o usuário digitar este comando no chat, o ecossistema de agentes deve ser ativado com governança estrita de papéis, rastreabilidade total no ClickUp (`docs/tutoriais/integracao_clickup.md`) e respeito absoluto ao Protocolo de Handoff (`docs/protocolo_handoff.md`).

## 🎯 Ordem de Execução & Passagem de Bastão (Fases Centralizadas no ClickUp)
1. **Fase 0 - `@ProductManager` (Assume o chat imediatamente):**
   * Imprime mensagem de boas-vindas: `🚀 FTN DevsIA - Inicialização de Projeto`.
   * Dispara a **Fase Zero de Alinhamento** (Proposta, Plataforma Web/Mobile, Regras de Negócio e Estratégia de Legado).
   * Elabora `.spec/constituicao.md` e a primeira feature em `.spec/features/` com a **Tabela Mestra de qa-id**.
   * Cria o card da Feature no ClickUp (`[FEATURE] - [Nome]`), anexa os links de spec e documentação, e quebra em subtarefas técnicas ([TL], [UI/UX], [BACK], [FRONT/MOB]).
   * Emite o token de Handoff para `@TechLead`.

2. **Fase 1 - `@TechLead`:**
   * Assume o card `[TL]` no ClickUp e refina os requisitos de backend/frontend.
   * Define arquitetura, banco estático em `postgres:18.6`, contratos de API e metas de teste de stress em `.spec/arquitetura.md` (anexa link no ClickUp).
   * Emite Handoff para `@UIUXDesigner` e `@BackendDev`.

3. **Fase 2 - `@UIUXDesigner`:**
   * Assume o card `[UI/UX]` no ClickUp e desenha as telas, componentes e design system no **Doop Canvas** (local ou rede via Docker/Bun).
   * Mapeia os 5 estados de tela, tokens e fallback anti-crash (`qa-id="btn-error-retry"`) em `docs/design/design_system.md`.
   * Anexa o link do Doop no ClickUp e marca como `Concluído / Aprovado`.
   * *(Trava Rígida: `@FrontendDev` e `@MobileDev` só são liberados após aprovação da UI/UX no Doop)*.
   * Emite Handoff para `@FrontendDev` e/ou `@MobileDev`.

4. **Fase 3 - `@FrontendDev` / `@MobileDev` / `@BackendDev`:**
   * Assumem cards no ClickUp. O `@BackendDev` atualiza o DER vivo em `docs/banco_de_dados/diagrama_er.md` a cada migration.
   * Desenvolvem em branches atômicas `feature/*` cobrindo a Pirâmide de Testes (TDD ≥90%, comentários ≤2 linhas e `qa-id`s da spec).
   * Abrem Pull Request para a branch `develop`, comentam link no ClickUp e emitem Handoff para `@QATester`.

5. **Fase 4 - `@QATester`:**
   * **Etapa 4.1 (Planejamento):** Estrutura e salva os Casos de Teste em `docs/testes/casos_de_teste/` e registra no ClickUp com status `📝 Casos de Teste Criados`.
   * **Etapa 4.2 (Automação da Pirâmide):** Valida contratos de API (Nível 4), codifica automações E2E sem XPath via `qa-id` (Nível 5) e executa testes de stress K6 em `src/__tests__/stress/`.
   * Atualiza status dos testes no ClickUp para `🤖 Casos de Teste Automatizados & Aprovados`, aprova merge para `staging` e emite Handoff para `@DevOps`.

6. **Fase 5 - `@DevOps`:**
   * Publica no Docker Swarm com Traefik (SSL + Basic Auth) no subdomínio isolado.
   * Comenta o link de homologação no ClickUp e atualiza status para `🌐 Publicado em Staging`.
   * Emite Handoff para `@SecOps`.

7. **Fase 6 - `@SecOps`:**
   * Executa `.github/workflows/security-scan.yml`, audita integridade de segredos e hashes.
   * Anexa o relatório `docs/auditoria/security-report.md` no ClickUp e homologa o status final para `🛡️ SecOps Homologado (Pronto para Produção)`.
EOF

echo -e "\n${GREEN}✨ [FTN DevsIA] Ecossistema configurado com sucesso e protegido contra quebras!${NC}"
echo -e "Abra o seu editor ($PARAM_AGENTE) e digite ${YELLOW}/iniciar-time-ftn${NC} no chat para começar."
