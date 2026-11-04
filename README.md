# EM TESTE PROJETO PARTICULAR, LIBERADO PARA TODOS USAREM E ACEITO FEEDBACKS DE MELHORIAS.

# 🚀 FTN DevsIA - Ecossistema de Governança e Automação Sênior

## 🎯 Objetivo do Projeto
O objetivo principal deste ecossistema é padronizar e blindar o ciclo de desenvolvimento de software do time **FTN DevsIA** (tanto para plataformas Web quanto para aplicativos em Flutter), operando com o nível de maturidade de grandes empresas de tecnologia do mercado. 

Este ecossistema garante de forma intransponível:
* **Isolamento de Papéis & Protocolo de Handoff:** 9 agentes de IA especialistas que atuam estritamente em suas funções de alçada, com passagem formal de bastão sem interferência mútua.
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

## 🛠️ Guia de Instalação & Atualização na sua Aplicação

As estruturas do ecossistema FTN DevsIA são instaladas e atualizadas **estritamente na raiz do projeto da sua aplicação**, mantendo o repositório matriz clonado (`team-ftn-devs-ia`) limpo e intacto.

### 🌟 1. Comando Padrão de Instalação (Sempre puxa o LATEST do GitHub)
Abra o terminal na pasta da sua aplicação e execute o comando oficial:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vitorfantin/team-ftn-devs-ia/main/install-ftn.sh)"
```
*(O instalador baixa a versão mais recente diretamente do GitHub, detecta pastas existentes e copia os arquivos diretamente para dentro delas sem sobrescrever nada do seu projeto).*

---

### 🔄 2. Comando Padrão de Atualização (Para Projetos Antigos / Em Produção)
Se você já possui um projeto com o FTN DevsIA instalado e quer atualizar para a versão mais recente com novos comandos, skills e esteiras, **sem perder nenhuma configuração**, token ou código da sua aplicação:

#### Opção A: Direto via cURL (Mais Rápida de Qualquer Lugar):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vitorfantin/team-ftn-devs-ia/main/update-ftn.sh)"
```

#### Opção B: Terminal Local da Aplicação:
```bash
./update-ftn.sh
```
*(ou `./install-ftn.sh --update`)*

> **🔒 Garantia de Preservação em Produção:**
> A atualização renova todas as 25 skills (`.agents/skills/`), protocolo de handoff, tutoriais e constituição, mas **PRESERVA INTACTOS**:
> - **Suas esteiras de CI/CD:** O atualizador pergunta interativamente se você deseja atualizar os workflows (opção padrão: **Não sobrescrever**, preservando suas esteiras existentes). Você também pode usar `--no-cicd` ou `--with-cicd`;
> - **Configurações e Segredos:** Seus tokens, chaves de API e credenciais do ClickUp e Doop em `ftn.config.json`;
> - **Código-fonte:** Todo o código da aplicação (`src/`, `lib/`, `tests/`);
> - **Histórico e Features:** Todas as especificações, histórias e casos de teste existentes (`.spec/features/` e `docs/testes/casos_de_teste/`).

---

### Opção Manual: A partir do Repositório Clonado (Local)
Se você clonou o `team-ftn-devs-ia` na sua máquina, informe o caminho da sua aplicação:
```bash
./install-ftn.sh /caminho/absoluto/da/sua-aplicacao
```
*(Para atualizar uma aplicação existente localmente: `./install-ftn.sh /caminho/da/aplicacao --update`).*

> **Flags Opcionais de Automação / Não-Interativo:**
> - `--with-cicd`: Importa/atualiza as esteiras modulares de CI/CD (`.github/workflows/`).
> - `--no-cicd`: Não importa nem altera as esteiras de CI/CD (mantém intactas as do seu projeto).
> - `--with-clickup` / `--no-clickup`: Habilita ou desabilita integração com ClickUp.
> - `--with-doop` / `--no-doop`: Habilita ou desabilita o Doop UI/UX Canvas.
> - `-a <antigravity|cursor|codex|claude>`: Pré-seleciona a IA alvo.

---

### 3. Comandos & Atalhos de Ativação no Chat da IA
Abra o seu editor na pasta da **sua aplicação** e utilize os comandos mestres conforme a necessidade (o time aceita chamadas via **`/`** ou menções via **`@`**):

#### 👥 Rituais de Início & Reunião Geral:
* **`/reuniao`** *(ou `@time reuniao`)*: Convoca **todos os especialistas do time** para a mesa redonda de alinhamento. O `@ProductManager` ouve a demanda, cada membro faz perguntas pontuais, a spec ONP é gerada, o protótipo no Doop é submetido à sua aprovação visual, e a esteira de desenvolvimento é disparada com Checklist Mestre e Portão Humano pré-merge.
* **`/iniciar-time-ftn`**: Inicialização da governança na raiz da aplicação, configuração do [ftn.config.json](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/ftn.config.json) e validação de estruturas.

#### 🎯 Chamar Especialistas Diretamente (via `@` ou `/`):
| Menção | Comando | Especialista | Papel e Alçada |
| :---: | :---: | :--- | :--- |
| **`@pm`** | **`/pm`** | `@ProductManager` | Regras de negócio, escopo de features, histórias (`US`), critérios de aceite (`AC`) e congelamento da Tabela de `qa-id` |
| **`@tl`** | **`/tl`** | `@TechLead` | Arquitetura técnica, modelagem `postgres:18.6`, contratos de API e metas de stress |
| **`@uiux`** | **`/uiux`** | `@UIUXDesigner` | Protótipos visuais no Doop Canvas (Local/Rede), tokens, 5 estados e acessibilidade WCAG |
| **`@back`** | **`/back`** | `@BackendDev` | DER vivo (`docs/banco_de_dados/diagrama_er.md`), migrations, APIs seguras OWASP e TDD ≥ 90% |
| **`@front`** | **`/front`** | `@FrontendDev` | Interface Web responsiva, componentes atômicos, injeção dos `qa-id`s e TDD ≥ 90% |
| **`@mobile`** | **`/mobile`** | `@MobileDev` | Aplicativo Flutter, secure storage, consumo de APIs e TDD ≥ 90% |
| **`@qa`** | **`/qa`** | `@QATester` | Planejamento de Casos de Teste, automação E2E sem XPath (`qa-id`), pirâmide de testes e stress K6 |
| **`@devops`** | **`/devops`** | `@DevOps` | Esteiras de CI/CD, Swarm, Traefik (SSL + Basic Auth) e trava do Portão Humano pré-merge |
| **`@secops`** | **`/secops`** | `@SecOps` | Auditoria SAST, varredura de segredos (Zero-Secret Leak), higiene do Git e compliance LGPD |

#### 🚦 Controle da Esteira & Governança:
* **`/status`**: Exibe o painel visual da esteira e o status mecânico via `onp-spec resumo --tabela`.
* **`/checklist`**: Audita o Checklist Mestre de Qualidade FTN e valida o exit code 0 de `onp-spec audit --ci`.
* **`/aprovar`**: Destrava a validação visual do Doop e autoriza o merge pré-deploy no Portão Humano.
* **`/handoff`**: Força a emissão formal do bloco de passagem de bastão para a próxima fase.
* **`/bloqueio`**: Sinaliza impedimento crítico e registra pergunta em aberto (`Q-xxx`) na spec.

#### ⚙️ Engenharia, Qualidade & Operações:
* **`/bug`**: Ciclo de resolução rápida de defeitos baseado em TDD (cria teste que falha primeiro e corrige).
* **`/review`**: Code review conjunto de arquitetura e segurança (`@TechLead` + `@SecOps`) pré-PR.
* **`/testes`**: Raio-X da pirâmide de testes completa e taxa de cobertura + `onp-spec verify`.
* **`/der`**: Renderiza o Diagrama ER vivo do banco de dados relacional em formato Mermaid.
* **`/doop`**: Exibe o link, credenciais e telas ativas no Doop Canvas.
* **`/deploy`**: Publicação assistida nos ambientes de Staging (Swarm + Traefik) ou Produção.
* **`/rollback`**: Reversão emergencial de versão no Docker Swarm sem downtime.
* **`/resumo`**: Release notes formatadas em linguagem de negócio para envio ao cliente final.
* **`/ajuda`**: Cola rápida de todos os comandos e atalhos disponíveis.

---

## 🚀 Como Usar no Dia a Dia (Guia Prático Passo a Passo)

### 1️⃣ Instalação na Raiz da sua Aplicação
Abra o terminal na pasta da sua aplicação e execute:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/vitorfantin/team-ftn-devs-ia/main/install-ftn.sh)"
```
*(O instalador perguntará interativamente se deseja ativar ClickUp, Doop local ou remoto e as credenciais, preservando todas as pastas já existentes no seu projeto).*

---

### 2️⃣ Inicialização da Governança
No chat da IA dentro do seu editor, digite:
```text
/iniciar-time-ftn
```
O `@ProductManager` valida a raiz, lê o `ftn.config.json` e configura a `.spec/constituicao.md`.

---

### 3️⃣ Iniciar uma Nova Feature: Mesa Redonda (`/reuniao`)
Para começar qualquer funcionalidade ou projeto novo, digite no chat:
```text
/reuniao Quero criar um fluxo de pagamento via Pix com notificação em tempo real
```
1. **Sabatina dos Especialistas:** O time (@pm, @tl, @uiux, @back, @front, @qa, @devops, @secops) faz de 1 a 2 perguntas pontuais para tirar dúvidas de negócio, arquitetura, banco e caminhos tristes.
2. **Spec ONP Gerada:** Após suas respostas, o `@pm` gera a spec no padrão ONP (`.spec/features/[feature]/spec.md`) congelando histórias (`US`), critérios de aceite (`AC`), perguntas (`Q-xxx`), suposições (`ASM-xxx`) e a **Tabela Mestra de `qa-id`**.
3. **Tarefas no ClickUp ou Markdown:** Se o ClickUp estiver ativo, cria o card e quebra em subtarefas técnicas ([TL], [UI/UX], [BACK], etc.); se inativo, gerencia em `task.md`.

---

### 4️⃣ Validação do Protótipo no Doop Canvas (`/aprovar`)
1. O `@uiux` desenha as telas no **Doop Canvas** (`http://localhost:3000` ou IP remoto) com os 5 estados e o botão anti-crash (`qa-id="btn-error-retry"`).
2. O designer posta o link no chat para você validar visualmente.
3. **Trava Visual:** Front e Mobile ficam bloqueados até você validar. Digite no chat:
   ```text
   /aprovar
   ```
   *(Frontend e Mobile são liberados imediatamente).*

---

### 5️⃣ Desenvolvimento Especializado & Acompanhamento
Cada especialista executa sua parte respeitando o [Protocolo de Handoff](docs/protocolo_handoff.md):
* **Quer saber em que pé está a feature?** Digite `/status`.
* **Quer ver o modelo do banco de dados?** Digite `/der` (exibe o diagrama ER vivo em Mermaid).
* **Quer ver a tela ou link do Doop?** Digite `/doop`.
* **Quer conversar com um especialista específico?** Digite `@qa`, `@tl`, `@back`, `@front`, `@uiux`, etc.
* **Encontrou um defeito durante o desenvolvimento?** Digite `/bug` (cria teste que falha primeiro e corrige com TDD).
* **Teve algum impedimento externo?** Digite `/bloqueio` (registra dúvida na spec e pausa a esteira).

---

### 6️⃣ Auditoria de Qualidade & Abertura de PR (`/checklist`)
Antes do merge, o time audita a conformidade completa:
```text
/checklist
```
* Verifica TDD ≥ 90%, zero XPath, DER vivo atualizado, 100% `qa-id`s, SAST, e executa mecanicamente `onp-spec audit --ci` (exit code 0).
* O desenvolvedor abre o Pull Request para `develop`/`staging` com o Checklist Mestre no corpo do PR.
* O GitHub Actions dispara a esteira de CI (`ci-staging.yml`).

---

### 7️⃣ 🚦 Portão Humano (Human Gate) & Deploy (`/aprovar`)
1. Quando a esteira de CI do GitHub Actions fica **100% verde (✅)**:
   * **É proibido fazer merge automático.**
   * O time de IA emite o alerta no chat com o link do PR:
     > *"🔔 [Portão Humano]: CI passou 100%! Analise o PR em [LINK] e responda `/aprovar` para autorizar o merge."*
2. Você clica no link do PR, analisa o código e digita no chat:
   ```text
   /aprovar
   ```
3. O `@devops` realiza o merge e o deploy automático no **Docker Swarm com Traefik (SSL + Basic Auth)**.
4. O `@secops` roda a auditoria final (`security-scan.yml`) e o `@pm` gera as Release Notes via `/resumo` para enviar ao cliente final!

---

## ⚙️ Configuração Modular: CI/CD, ClickUp e Doop Opcionais (`ftn.config.json`)

O instalador `install-ftn.sh` pergunta interativamente as preferências do seu projeto e salva em `ftn.config.json`:
* **Esteiras de CI/CD Modulares (Opcionais na Instalação e Atualização):**
  - **Instalação:** Pergunta se deseja importar os fluxos do GitHub Actions (`.github/workflows/`). Se o projeto já tiver esteiras próprias ou você preferir configurar manualmente, basta escolher **Não** (ou `--no-cicd`).
  - **Atualização:** Na atualização, a opção padrão é **Preservar intactas as esteiras existentes** da aplicação (opção 2 - Não). Se desejar sincronizar com as novidades da matriz, escolha **Sim** (ou `--with-cicd`).
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
│   └── skills/                         # 👥 Mentes Especialistas e Comandos FTN
│       ├── reuniao.md                  # 👥 /reuniao (Mesa redonda com todo o time)
│       ├── iniciar_time_ftn.md         # 🚀 /iniciar-time-ftn (Inicialização do projeto)
│       ├── pm.md (1_ProductManager)    # 🎙️ @pm ou /pm (Product Manager)
│       ├── tl.md (2_TechLead)          # 🏛️ @tl ou /tl (Tech Lead)
│       ├── uiux.md (3_UIUXDesigner)    # 🎨 @uiux ou /uiux (UI/UX Designer)
│       ├── front.md (4a_FrontendDev)   # 💻 @front ou /front (Frontend Dev)
│       ├── mobile.md (4b_MobileDev)    # 📱 @mobile ou /mobile (Mobile Dev)
│       ├── back.md (5_BackendDev)      # ⚙️ @back ou /back (Backend Dev)
│       ├── qa.md (6_QATester)          # 🧪 @qa ou /qa (QA Tester)
│       ├── devops.md (7_DevOps)        # 🚀 @devops ou /devops (DevOps)
│       ├── secops.md (8_SecOps)        # 🛡️ @secops ou /secops (SecOps)
│       ├── status.md                   # 📊 /status (Painel de andamento da esteira)
│       ├── checklist.md                # ✅ /checklist (Checklist Mestre e onp-spec audit)
│       ├── aprovar.md                  # 🚦 /aprovar (Destrava Doop e Portão Humano)
│       ├── handoff.md                  # 🔄 /handoff (Passagem formal de bastão)
│       ├── bloqueio.md                 # 🛑 /bloqueio (Sinaliza impedimento)
│       ├── bug.md                      # 🐛 /bug (Correção rápida TDD Red-Green)
│       ├── review.md                   # 🧐 /review (Code review Tech Lead + SecOps)
│       ├── testes.md                   # 🧪 /testes (Raio-X da pirâmide e cobertura)
│       ├── der.md                      # 🗄️ /der (Diagrama ER vivo em Mermaid)
│       ├── doop.md                     # 🎨 /doop (Canvas visual e telas)
│       ├── deploy.md                   # 🚀 /deploy (Publicação assistida em Staging)
│       ├── rollback.md                 # 🚨 /rollback (Reversão emergencial Swarm)
│       ├── resumo.md                   # 📝 /resumo (Release notes para o cliente)
│       └── ajuda.md                    # ❓ /ajuda (Cola rápida de todos os atalhos)
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
