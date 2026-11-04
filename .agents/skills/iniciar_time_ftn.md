# Command: /iniciar-time-ftn
# Team: FTN DevsIA

Sempre que o usuário digitar este comando no chat, o ecossistema de agentes especialistas é ativado na raiz da aplicação com governança estrita de papéis, orquestração pelo **Spec-Driven (@onovoprogramador/onp-spec)** e respeito às preferências de **`ftn.config.json`** (ClickUp e Doop opcionais) e ao [Protocolo de Handoff](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/protocolo_handoff.md).

> **💡 Dica de Reunião com o Cliente:** Se você deseja convocar a banca de especialistas para apresentar uma nova demanda do cliente e responder a perguntas de alinhamento antes do código, use o comando:
> 👉 **`/reuniao-time-ftn`**

---

## 🛑 PASSO 0 OBRIGATÓRIO: Instalação na Raiz da Aplicação (NÃO no Repositório Clonado)

> **REGRA FUNDAMENTAL:** O repositório `team-ftn-devs-ia` é a **matriz/blueprint** das estruturas. Ao acionar `/iniciar-time-ftn`, o agente `@ProductManager` deve garantir que os arquivos do projeto sejam criados e gerenciados **NA RAIZ DO PROJETO DA APLICAÇÃO DO USUÁRIO**, e **NUNCA** dentro da pasta do `team-ftn-devs-ia`.

### 1. Verificação de Diretório Ativo:
* Identifique o diretório de trabalho do workspace atual.
* **Se o chat estiver aberto dentro do repositório matriz clonado `team-ftn-devs-ia`:**
  * **PAUSE IMEDIATAMENTE** e emita o alerta:
    ```text
    🚨 [FTN DevsIA - Validação de Diretório]: 
    Você acionou o comando dentro do repositório matriz clonado (team-ftn-devs-ia).
    Para proteger este repositório, os arquivos da sua aplicação devem ser instalados na raiz do seu próprio projeto.
    
    👉 Por favor, informe o caminho absoluto da pasta da sua aplicação (ex: /Users/seu-usuario/Projetos/meu-app) ou abra seu editor diretamente na pasta do seu projeto.
    ```
  * Ao receber o caminho da aplicação, copie toda a estrutura do `team-ftn-devs-ia` para a raiz da aplicação do usuário:
    - `ftn.config.json` (configuração do projeto: ClickUp, Doop e Spec-Driven)
    - `.spec/` (`constituicao.md`, `arquitetura.md`, `features/`, `verification/`)
    - `docs/` (`protocolo_handoff.md`, `testes/piramide_de_testes.md`, `testes/casos_de_teste/`, `banco_de_dados/diagrama_er.md`, `design/design_system.md`, `tutoriais/`)
    - `.github/workflows/` (`ci-develop.yml`, `ci-staging.yml`, `cd-staging.yml`, `cd-production.yml`, `security-scan.yml`)
    - `docker/doop/` (stack do Doop UI/UX Canvas)
    - `scripts/` (`clickup_sync.js`, `install_doop.sh`)
    - `.agents/skills/` (todos os perfis `[0-9]*.md`, `iniciar_time_ftn.md` e `reuniao_time_ftn.md`)

* **Se o workspace atual já for o projeto da aplicação do usuário:**
  * Garanta que as estruturas acima estejam presentes na raiz da aplicação. Mesmo que as pastas (`.spec/`, `docs/`, `.github/`, `.agents/`, etc.) já existam, copie e mescle os arquivos da governança FTN diretamente para dentro dessas pastas já criadas, preservando os arquivos preexistentes do projeto.

---

## 🎯 Ordem de Execução & Passagem de Bastão (Governança FTN)

1. **Fase 0 - `@ProductManager` (Assume o chat imediatamente):**
   * Imprime mensagem de boas-vindas: `🚀 FTN DevsIA - Inicialização de Projeto na Raiz da Aplicação`.
   * Lê `ftn.config.json` para validar se ClickUp e Doop estão habilitados.
   * Dispara a **Fase Zero de Alinhamento** (Proposta, Plataforma Web/Mobile, Regras de Negócio e Estratégia de Legado).
   * Elabora `.spec/constituicao.md` e a primeira feature em `.spec/features/` via `npx onp-spec new <feature>` com a **Tabela Mestra de qa-id**.
   * Se ClickUp ativo: cria o card da Feature e quebra em subtarefas técnicas ([TL], [UI/UX], [BACK], [FRONT/MOB], [QA]). Se desativado: gerencia via `task.md`.
   * Emite o token de Handoff para `@TechLead`.

2. **Fase 1 - `@TechLead`:**
   * Assume alçada técnica e refina os requisitos de backend/frontend.
   * Define arquitetura, banco estático em `postgres:18.6`, contratos de API e metas de teste de stress em `.spec/arquitetura.md`.
   * Emite Handoff para `@UIUXDesigner` e `@BackendDev`.

3. **Fase 2 - `@UIUXDesigner`:**
   * Assume alçada visual. Se Doop ativo em `ftn.config.json`, desenha no **Doop Canvas** (`http://localhost:3000`). Se desativado, especifica em Markdown em `docs/design/design_system.md`.
   * Mapeia os 5 estados de tela, tokens e fallback anti-crash (`qa-id="btn-error-retry"`).
   * *(Trava Rígida: `@FrontendDev` e `@MobileDev` só são liberados após aprovação da UI/UX)*.
   * Emite Handoff para `@FrontendDev` e/ou `@MobileDev`.

4. **Fase 3 - `@FrontendDev` / `@MobileDev` / `@BackendDev`:**
   * Assumem o desenvolvimento. O `@BackendDev` atualiza o DER vivo em `docs/banco_de_dados/diagrama_er.md` a cada migration.
   * Desenvolvem em branches atômicas `feature/*` cobrindo a Pirâmide de Testes (TDD ≥90%, comentários ≤2 linhas e `qa-id`s da spec).
   * Abrem Pull Request para a branch `develop` e emitem Handoff para `@QATester`.

5. **Fase 4 - `@QATester`:**
   * **Etapa 4.1 (Planejamento):** Estrutura e salva os Casos de Teste em `docs/testes/casos_de_teste/`.
   * **Etapa 4.2 (Automação da Pirâmide):** Valida contratos de API (Nível 4), codifica automações E2E sem XPath via `qa-id` (Nível 5) e executa testes de stress K6 em `src/__tests__/stress/`.
   * Aprova merge para `staging` e emite Handoff para `@DevOps`.

6. **Fase 5 - `@DevOps`:**
   * Publica no Docker Swarm com Traefik (SSL + Basic Auth) no subdomínio isolado de homologação.
   * Emite Handoff para `@SecOps`.

7. **Fase 6 - `@SecOps`:**
   * Executa a esteira `security-scan.yml` (no projeto da aplicação), audita integridade de segredos e hashes.
   * Anexa o relatório `docs/auditoria/security-report.md` e homologa o status final para `🛡️ SecOps Homologado (Pronto para Produção)`.
