# EM TESTE PROJETO PARTICULAR, LIBERADO PARA TODOS USAREM E ACEITO FEEDBACKS DE MELHORIAS.

# 🚀 FTN DevsIA - Ecossistema de Governança e Automação Sênior

## 🎯 Objetivo do Projeto
O objetivo principal deste ecossistema é padronizar e blindar o ciclo de desenvolvimento de software do time **FTN DevsIA** (tanto para plataformas Web quanto para aplicativos em Flutter), operando com o nível de maturidade de grandes empresas de tecnologia do mercado. 

Este ecossistema garante de forma intransponível:
* **Isolamento de Papéis & Protocolo de Handoff:** 8 agentes de IA especialistas que atuam estritamente em suas funções de alçada, com passagem formal de bastão sem interferência mútua.
* **Gestão e Rastreabilidade Centralizada no ClickUp:** 100% das demandas passam pelo ClickUp (Features, quebra de subtarefas de engenharia, registro de Casos de Teste planejados e automatizados, e documentações sincronizadas).
* **Pirâmide de Testes Completa (Cobertura Total):** Implementação obrigatória de todos os níveis da pirâmide de testes (Unitários, Componentes/Widgets, Integração com Postgres 18.6, Contratos de API e E2E via `qa-id`), com TDD e cobertura mínima de 90%.
* **Automação de QA Inquebrável:** Proibição absoluta de caminhos XPath, forçando o planejamento prévio de Casos de Teste e a seleção puramente por atributos `qa-id` / `data-qa` em cenários bons, ruins e anti-crash (`btn-error-retry`).
* **Ambiente de Testes Isolado & CI/CD Modular:** Infraestrutura modular com esteiras de CI/CD prontas para serem instaladas nos projetos de destino via GitHub Actions (com trava inteligente que impede execução indevida no repositório matriz), além de deploy no Docker Swarm gerenciado via Portainer e Traefik no Ubuntu Server.
* **Segurança Ativa (DevSecOps):** Blindagem de borda contra ataques de hackers via Basic Auth no Traefik, esteira dedicada de auditoria SAST (`security-scan.yml`), caça a vazamentos de segredos (Zero-Secret Leak) e `.gitignore` higienizado.

> [!IMPORTANT]
> **Natureza deste Repositório (Matriz de Governança / Blueprint):**
> O repositório **`team-ftn-devs-ia`** é a matriz de criação, salvamento e atualização contínua de toda a estrutura do time. Os arquivos de workflow em `.github/workflows/` possuem uma trava nativa (`if: github.repository != 'vitorfantin/team-ftn-devs-ia'`) para que **não rodem ações aqui**. Ao executar o assistente `install-ftn.sh` nos seus projetos finais, todas as esteiras de CI/CD são copiadas e passam a rodar automaticamente!

---

## 🔄 Protocolo de Handoff & Rastreabilidade no ClickUp

Para eliminar ambiguidades e sobreposições, a execução segue uma esteira sequencial orientada a artefatos e cards do ClickUp:

```text
[Fase 0: @ProductManager]  ──► Reunião (/reuniao), Spec ONP + Tabela de qa-ids
         │
[Fase 1: @TechLead]        ──► Arquitetura, Contratos e Postgres 18.6 em .spec/arquitetura.md
         │
[Fase 2: @UIUXDesigner]    ──► Projeta no Doop Canvas (Local/Rede) e APROVAÇÃO VISUAL DO CLIENTE
         │
[Fase 3: @Devs (Front/Mob/Back)] ──► Back atualiza DER vivo, Front/Mob pós-Doop, TDD ≥90% e PR
         │
[Fase 4: @QATester]        ──► 1º Casos de Teste ➔ 2º E2E sem XPath ➔ 3º Checklist Mestre FTN
         │
[Fase 5: @DevOps]          ──► Valida CI ➔ PORTÃO HUMANO (Avisa Usuário) ➔ Merge & Deploy Swarm
         │
[Fase 6: @SecOps]          ──► Roda security-scan.yml, anexa relatório e homologa no ClickUp
```

Consulte a íntegra das regras no arquivo [`docs/protocolo_handoff.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/protocolo_handoff.md).

---

## 🛠️ Guia de Instalação na sua Aplicação

As estruturas do ecossistema FTN DevsIA são instaladas **estritamente na raiz do projeto da sua aplicação**, mantendo o repositório matriz clonado (`team-ftn-devs-ia`) limpo e intacto.

### Opção A: A partir do Repositório Clonado (Local)
Se você clonou o `team-ftn-devs-ia` na sua máquina, informe o caminho da sua aplicação:
```bash
./install-ftn.sh /caminho/absoluto/da/sua-aplicacao
```
*(Se você executar apenas `./install-ftn.sh`, o script identificará que você está no repositório matriz e solicitará a pasta da sua aplicação).*

> **ℹ️ Pastas já criadas no projeto (`.spec`, `docs`, `.github`, `.agents`):**
> O instalador detecta automaticamente as pastas existentes e copia todos os arquivos da governança **diretamente para dentro dessas pastas**, mantendo todos os arquivos preexistentes da sua aplicação intactos.

---

### Opção B: Diretamente na Raiz da sua Aplicação (Via cURL)
Abra o terminal na pasta da sua aplicação existente e execute o instalador oficial:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vitorfantin/team-ftn-devs-ia/main/install-ftn.sh)"
```

---

### 3. Comandos de Ativação no Chat da IA
Abra o seu editor na pasta da **sua aplicação** e utilize os comandos mestres conforme a necessidade:

#### 💬 `/reuniao` (Kickoff de Demanda com o Cliente)
Use este comando (ou o alias `/reuniao-time-ftn`) para convocar **todos os especialistas do time** para uma mesa redonda:
* O `@ProductManager` abre a reunião e ouve o que o cliente/usuário deseja construir;
* Cada especialista (@TechLead, @UIUXDesigner, @BackendDev, @FrontendDev, @MobileDev, @QATester, @DevOps, @SecOps) faz perguntas pontuais para entender profundamente as regras, telas, dados e riscos;
* Com tudo alinhado e homologado pelo cliente, o PM gera a spec no padrão ONP (`npx onp-spec new <feature>`) com histórias, critérios de aceite e tabela de `qa-id`s;
* O `@UIUXDesigner` desenha as telas no **Doop Canvas** (local ou remoto) e publica o link no chat para **aprovação visual do cliente** (trava inegociável antes de Front/Mobile);
* Cada especialista executa sua parte com TDD ≥90% e DER vivo;
* Antes do merge, é auditado o **Checklist Mestre de Conformidade FTN** (Qualidade e Segurança) e aberto o PR;
* Quando o CI passa com 100% de sucesso, a **Trava do Portão Humano** avisa o usuário no chat com o link do PR para análise antes do merge!

#### 🚀 `/iniciar-time-ftn` (Inicialização da Governança do Projeto)
Use este comando na primeira vez para validar as estruturas instaladas na aplicação, configurar a `.spec/constituicao.md` e alinhar escopo de legado.

---

## ⚙️ Configuração Modular: ClickUp e Doop Opcionais (`ftn.config.json`)

O instalador `install-ftn.sh` pergunta interativamente as preferências do seu projeto e salva em `ftn.config.json`:
* **ClickUp (Opcional):**
  - **Habilitado:** Cria cards de features, quebra subtarefas técnicas automáticas e sincroniza status (`docs/tutoriais/integracao_clickup.md`).
  - **Desabilitado:** Gerenciamento ágil 100% nativo em arquivos Markdown (`task.md` e `.spec/features/`).
* **Doop UI/UX Canvas (Opcional):**
  - **Habilitado:** O `@UIUXDesigner` utiliza o Doop Canvas (`http://localhost:3000`) para prototipar telas e tokens antes de liberar Front e Mobile.
  - **Desabilitado:** O design e componentes são documentados em Markdown puro em `docs/design/design_system.md`.
* **Engine Spec-Driven Integrada:**
  - Trabalha nativamente com o `@onovoprogramador/onp-spec` para garantir rastreabilidade mecânica: História de Usuário (`US-xxx`) → Critério de Aceite (`AC-xxx`) → Tarefa (`T-xxx`) → Casos de Teste de QA.

---

## 📂 Estrutura Modular do Repositório

```text
raiz-do-seu-projeto/
├── ftn.config.json                     # ⚙️ Configurações ativas do projeto (ClickUp, Doop e Engine Spec)
├── .agents/
│   └── skills/                         # 👥 As Mentes Especialistas do Time FTN
│       ├── reuniao.md                  # 💬 Comando /reuniao (Mesa redonda e alinhamento com cliente)
│       ├── reuniao_time_ftn.md         # 💬 Alias do comando /reuniao
│       ├── iniciar_time_ftn.md         # 🚀 Comando /iniciar-time-ftn (Inicialização do projeto)
│       ├── 1_ProductManager.md         # Fase Zero, Escopo, Negócio e Tabela Mestra de qa-id
│       ├── 2_TechLead.md               # Arquitetura, Postgres 18.6, Pirâmide de testes e SOLID
│       ├── 3_UIUXDesigner.md           # Design System (Doop ou Markdown), WCAG e Fallback Anti-Crash
│       ├── 4a_FrontendDev.md           # Desenvolvimento Web, TDD 90% e Injeção de qa-ids
│       ├── 4b_MobileDev.md             # Desenvolvimento Flutter, Secure Storage e Performance
│       ├── 5_BackendDev.md             # APIs seguras, Postgres 18.6, DER vivo e Migrations
│       ├── 6_QATester.md               # Casos de teste prévios, Automações E2E sem XPath e Gatekeeper
│       ├── 7_DevOps.md                 # Docker Swarm, Traefik, Basic Auth e CI/CD Modular
│       └── 8_SecOps.md                 # Auditoria SAST/LGPD, .gitignore e Zero-Secret Leak
│
├── .github/
│   └── workflows/                      # ⚙️ Esteiras Modulares de CI/CD (Copiadas para os projetos destino)
│       ├── ci-develop.yml              # Testes unitários e auditoria clean code pré-merge
│       ├── ci-staging.yml              # Validação da Pirâmide de Testes (cobertura ≥90%, Postgres 18.6 e E2E)
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
