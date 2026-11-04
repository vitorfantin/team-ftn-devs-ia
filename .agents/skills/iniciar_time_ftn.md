# Command: /iniciar-time-ftn
# Team: FTN DevsIA

Sempre que o usuário digitar este comando no chat, o ecossistema de agentes especialistas deve ser ativado com governança estrita de papéis, rastreabilidade total no ClickUp (`docs/tutoriais/integracao_clickup.md`) e respeito absoluto ao Protocolo de Handoff (`docs/protocolo_handoff.md`).

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
    - `.spec/` (`constituicao.md`, `arquitetura.md`, `features/`)
    - `docs/` (`protocolo_handoff.md`, `testes/piramide_de_testes.md`, `testes/casos_de_teste/`, `banco_de_dados/diagrama_er.md`, `design/design_system.md`, `tutoriais/`)
    - `.github/workflows/` (`ci-develop.yml`, `ci-staging.yml`, `cd-staging.yml`, `cd-production.yml`, `security-scan.yml`)
    - `docker/doop/` (stack do Doop UI/UX Canvas)
    - `scripts/` (`clickup_sync.js`, `install_doop.sh`)
    - `.agents/skills/` (todos os perfis `[0-9]*.md` e `iniciar_time_ftn.md`)

* **Se o workspace atual já for o projeto da aplicação do usuário:**
  * Garanta que as estruturas acima estejam presentes na raiz da aplicação. Caso as pastas (`.spec/`, `docs/`, `.github/`, etc.) já existam, copie e mescle os novos arquivos da governança FTN dentro dessas pastas já criadas, preservando os arquivos preexistentes do projeto.

---

## 🎯 Ordem de Execução & Passagem de Bastão (Fases Centralizadas no ClickUp)

1. **Fase 0 - `@ProductManager` (Assume o chat imediatamente):**
   * Imprime mensagem de boas-vindas: `🚀 FTN DevsIA - Inicialização de Projeto na Raiz da Aplicação`.
   * Dispara a **Fase Zero de Alinhamento** (Proposta, Plataforma Web/Mobile, Regras de Negócio e Estratégia de Legado).
   * Elabora `.spec/constituicao.md` e a primeira feature em `.spec/features/` com a **Tabela Mestra de qa-id**.
   * Cria o card da Feature no ClickUp (`[FEATURE] - [Nome]`), anexa os links de spec e documentação, e quebra em subtarefas técnicas ([TL], [UI/UX], [BACK], [FRONT/MOB]).
   * Não permite comandos de código antes de responder às perguntas.
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
   * Executa a esteira `security-scan.yml` (no projeto da aplicação), audita integridade de segredos e hashes.
   * Anexa o relatório `docs/auditoria/security-report.md` no ClickUp e homologa o status final para `🛡️ SecOps Homologado (Pronto para Produção)`.
