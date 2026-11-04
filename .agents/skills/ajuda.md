# Command: /ajuda
# Mentions: @time ajuda
# Aliases: /comandos, /help
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Ao acionar `/ajuda` (ou `/comandos`, ou `@time ajuda`), o ecossistema exibe a **Cola Rápida Oficial do Time FTN DevsIA** contendo todos os comandos e atalhos disponíveis no chat:

---

## 👥 1. Rituais de Reunião & Inicialização
* **`/reuniao`** *(ou `@time reuniao`)*: Convoca a mesa redonda com todo o time para acolher a demanda, sabatinar o cliente, gerar spec ONP e prototipar no Doop.
* **`/iniciar-time-ftn`**: Inicializa a governança, copia arquivos para a raiz da aplicação e configura `ftn.config.json`.

---

## 🎯 2. Chamar Especialistas Diretamente (Use `@` ou `/`)
* **`@pm`** ou **`/pm`**: Product Manager (regras de negócio, escopo, histórias `US` e critérios `AC`).
* **`@tl`** ou **`/tl`**: Tech Lead (arquitetura, contratos de API, Postgres 18.6).
* **`@uiux`** ou **`/uiux`**: UI/UX Designer (protótipos no Doop Canvas e WCAG).
* **`@back`** ou **`/back`**: Backend Dev (DER vivo, APIs seguras, TDD ≥ 90%).
* **`@front`** ou **`/front`**: Frontend Dev (telas web responsivas, componentes, TDD ≥ 90%).
* **`@mobile`** ou **`/mobile`**: Mobile Dev (Flutter, telas móveis, TDD ≥ 90%).
* **`@qa`** ou **`/qa`**: QA Tester (casos de teste, E2E sem XPath via `qa-id`, carga K6).
* **`@devops`** ou **`/devops`**: DevOps (esteiras CI/CD, Swarm, Traefik, Portão Humano).
* **`@secops`** ou **`/secops`**: SecOps (auditoria SAST, vazamento de segredos, LGPD).

---

## 🚦 3. Controle da Esteira & Governança
* **`/status`**: Painel visual de andamento da esteira + `onp-spec resumo --tabela`.
* **`/checklist`**: Auditoria do Checklist Mestre FTN + `onp-spec audit --ci`.
* **`/handoff`**: Emite passagem formal de bastão para a próxima fase.
* **`/aprovar`**: Destrava o protótipo no Doop e autoriza o merge pré-deploy no Portão Humano.
* **`/bloqueio`**: Sinaliza impedimento que precisa de decisão externa (registra `Q-xxx`).

---

## ⚙️ 4. Engenharia, Qualidade & Operações
* **`/bug`**: Resolução rápida de defeitos com TDD (teste que falha primeiro).
* **`/review`**: Code review de arquitetura e segurança pré-PR.
* **`/testes`**: Raio-X da pirâmide de testes e cobertura + `onp-spec verify`.
* **`/der`**: Exibe o Diagrama ER vivo do banco no chat em Mermaid.
* **`/doop`**: Exibe o link, credenciais e telas do Doop Canvas.
* **`/deploy`**: Publicação assistida em Staging (Swarm + Traefik).
* **`/rollback`**: Reversão emergencial de versão sem downtime.
* **`/resumo`**: Release notes prontas para o cliente final.
