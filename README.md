# EM TESTE PROJETO PARTICULAR, LIBERADO PARA TODOS USAREM E ACEITO FEEDBACKS DE MELHORIAS.

# 🚀 FTN DevsIA - Ecossistema de Governança e Automação Sênior

## 🎯 Objetivo do Projeto
O objetivo principal deste ecossistema é padronizar e blindar o ciclo de desenvolvimento de software do time **FTN DevsIA** (tanto para plataformas Web quanto para aplicativos em Flutter), operando com o nível de maturidade de grandes empresas de tecnologia do mercado. 

Este ecossistema garante de forma intransponível:
* **Isolamento de Papéis & Protocolo de Handoff:** 8 agentes de IA especialistas que atuam estritamente em suas funções de alçada, com passagem formal de bastão sem interferência mútua.
* **Gestão e Rastreabilidade Centralizada no ClickUp:** 100% das demandas passam pelo ClickUp (Features, quebra de subtarefas de engenharia, registro de Casos de Teste planejados e automatizados, e documentações sincronizadas).
* **Pirâmide de Testes Completa (Cobertura Total):** Implementação obrigatória de todos os níveis da pirâmide de testes (Unitários, Componentes/Widgets, Integração com Postgres 18.6, Contratos de API e E2E via `qa-id`), com TDD e cobertura mínima de 90%.
* **Automação de QA Inquebrável:** Proibição absoluta de caminhos XPath, forçando o planejamento prévio de Casos de Teste e a seleção puramente por atributos `qa-id` / `data-qa` em cenários bons, ruins e anti-crash (`btn-error-retry`).
* **Ambiente de Testes Isolado:** Infraestrutura modular em micro-serviços (GitHub Actions) com deploy automático em subdomínio dedicado (`://dominio.com.br`) gerenciado via Docker Swarm, Portainer e Traefik no Ubuntu Server.
* **Segurança Ativa (DevSecOps):** Blindagem de borda contra ataques de hackers via Basic Auth no Traefik, esteira dedicada de auditoria SAST (`security-scan.yml`), caça a vazamentos de segredos (Zero-Secret Leak) e `.gitignore` higienizado.

---

## 🔄 Protocolo de Handoff & Rastreabilidade no ClickUp

Para eliminar ambiguidades e sobreposições, a execução segue uma esteira sequencial orientada a artefatos e cards do ClickUp:

```text
[Fase 0: @ProductManager]  ──► Cria Feature & Subtarefas no ClickUp + .spec/constituicao.md
         │
[Fase 1: @TechLead]        ──► Assume card [TL], anexa .spec/arquitetura.md e refina subtarefas
         │
[Fase 2: @UIUXDesigner]    ──► Projeta no Doop Canvas (Local/Rede), gera docs/design/ e homologa no ClickUp
         │
[Fase 3: @Devs (Front/Mob/Back)] ──► Back atualiza DER vivo, Front/Mob iniciam pós-Doop, TDD ≥90% e PR
         │
[Fase 4: @QATester]        ──► 1º Registra Casos no ClickUp ➔ 2º Automatiza E2E e Aprova
         │
[Fase 5: @DevOps]          ──► Publica em Staging Swarm e comenta URL segura no ClickUp
         │
[Fase 6: @SecOps]          ──► Roda security-scan.yml, anexa relatório e homologa no ClickUp
```

Consulte a íntegra das regras no arquivo [`docs/protocolo_handoff.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/protocolo_handoff.md).

---

## 🛠️ Guia de Instalação Rápida

A instalação é controlada de forma interativa por um script assistente na raiz, projetado para prevenir conflitos em códigos existentes.

### 1. Preparação Local (Na raiz do seu projeto)
Execute o comando de instalação de uma linha (substituindo pelo seu usuário do GitHub):
```bash
curl -fsSL https://githubusercontent.com | bash
```

### 2. Fluxo do Assistente Interativo
* **Varredura Preventiva:** Se o projeto for em andamento (Brownfield / Legado), o script alertará sobre pastas existentes e pedirá sua confirmação (`s/n`) para continuar com cautela.
* **Seleção do Agente de IA:** Digite a opção correspondente ao editor de inteligência artificial que você irá trabalhar: `1 - Antigravity`, `2 - Cursor`, `3 - Codex` ou `4 - Claude Code`.

### 3. Ativação no Chat da IA
Abra o seu editor configurado, acesse o chat da IA e digite o comando mestre:
```text
/iniciar-time-ftn
```
O agente `@ProductManager` assumirá o controle imediato do chat disparando a **Fase Zero de Alinhamento** para travar o escopo e o idioma do repositório antes de liberar as tarefas técnicas.

---

## 📂 Estrutura Modular do Repositório

```text
raiz-do-seu-projeto/
├── .agent/
│   └── skills/                         # 👥 As Mentes Especialistas do Time FTN
│       ├── iniciar_time_ftn.md         # O arquivo mestre que habilita o comando /iniciar-time-ftn
│       ├── 1_ProductManager.md         # Fase Zero, Escopo, Negócio e Tabela Mestra de qa-id
│       ├── 2_TechLead.md               # Arquitetura, Postgres 18.6, Pirâmide de testes e SOLID
│       ├── 3_UIUXDesigner.md           # Design System, WCAG e Fallback Anti-Crash (btn-error-retry)
│       ├── 4a_FrontendDev.md           # Desenvolvimento Web, TDD 90% e Injeção de qa-ids
│       ├── 4b_MobileDev.md             # Desenvolvimento Flutter, Secure Storage e Performance
│       ├── 5_BackendDev.md             # APIs seguras, OWASP Top 10 e Migrations
│       ├── 6_QATester.md               # Automações E2E sem XPath, Testes de Stress e Gatekeeper de PR
│       ├── 7_DevOps.md                 # Docker Swarm, Traefik, Basic Auth e CI/CD Modular
│       └── 8_SecOps.md                 # Auditoria SAST/DAST, .gitignore e Zero-Secret Leak
│
├── .github/
│   └── workflows/                      # ⚙️ Esteiras Modulares Independentes
│       ├── ci-develop.yml              # Testes unitários e auditoria clean code pré-merge
│       ├── ci-staging.yml              # O Filtro Rígido: valida cobertura ≥90% e qa-ids
│       ├── cd-staging.yml              # Deploy automático em subdomínio de homologação
│       ├── cd-production.yml           # Deploy final com tag de versão e rollback imediato
│       └── security-scan.yml           # Auditoria SecOps isolada (Gitleaks, SAST e higiene Git)
│
├── docker/                              # 🐳 Ambientes & Stacks Isoladas
│   └── doop/                           # Servidor do Doop UI/UX Canvas (Dockerfile e docker-compose.yml)
│
├── docs/                               # 📂 Central de Conhecimento e Governança
│   ├── protocolo_handoff.md            # Contrato de transição e alçadas entre os agentes
│   ├── documentacao_projeto/           # Especificações de negócio homologadas
│   ├── tutoriais/
│   │   ├── doop_uiux.md                # Guia de instalação e design de telas no Doop Canvas
│   │   ├── integracao_clickup.md       # Guia oficial de rastreabilidade, features e tarefas no ClickUp
│   │   └── infra_e_testes.md           # Guia de túneis locais com SSL (Ngrok) e Swarm
│   ├── design/
│   │   └── design_system.md            # Tokens visuais, estados e telas de erro crítico
│   ├── banco_de_dados/
│   │   └── diagrama_er.md              # DER vivo (Mermaid) e dicionário de dados PostgreSQL 18.6
│   ├── testes/
│   │   ├── piramide_de_testes.md       # A governança dos 5 níveis da pirâmide de testes
│   │   └── casos_de_teste/             # Casos de teste estruturados (BDD/Gherkin) pré-automação
│   └── auditoria/
│       └── security-report.md          # Relatório oficial de auditoria SecOps
│
├── scripts/                            # 🛠️ Utilitários de Automação
│   ├── clickup_sync.js                 # Helper CLI de sincronização via API do ClickUp (REST v2)
│   └── install_doop.sh                 # Assistente de instalação e execução do Doop (Docker/Bun)
│
├── .spec/                              # 📝 Especificações Mecânicas do Projeto
│   ├── features/                       # Especificações atômicas de cada feature com tabela qa-id
│   ├── constituicao.md                 # As regras inegociáveis interpretadas pela IA
│   └── arquitetura.md                  # Modelagem de dados, stack e contratos técnicos
│
├── .gitignore                          # Ignore blindado contra vazamentos e caches de agentes de IA
├── install-ftn.sh                      # O script assistente de instalação
└── README.md                           # O manual geral do repositório
```

---

## 🤝 Créditos e Reconhecimento (Engine Base)

Este projeto utiliza como motor e pilar mecânico de orquestração paralela o framework **onp-spec-driven** desenvolvido pelo canal **O Novo Programador**. 

A abordagem de desenvolvimento baseado em especificações (*Spec-Driven Development*) aplicada nas automações do time FTN DevsIA é uma extensão direta das soluções inovadoras de engenharia de prompts e controle de branches por *worktrees* criadas por ele.

* **Repositório Base Original:** [onovoprogramador/onp-spec-driven](https://github.com/onovoprogramador/onp-spec-driven)
* **Canal Oficial:** [O Novo Programador](https://www.youtube.com/@ONovoProgramador)

*Agradecimentos ao criador por disponibilizar a engine open-source que possibilita a evolução de times autônomos de IA.*
