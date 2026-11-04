# Command: /aprovar
# Mentions: @time aprovar, @devops aprovar, @uiux aprovar
# Aliases: /liberar, /aprovo-merge, /aceitar
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Ao acionar `/aprovar` (ou `@time aprovar`), você autoriza formalmente a continuidade da esteira nos dois gates de decisão humana do ecossistema FTN DevsIA:

---

## 🚦 Os 2 Momentos de Atuação do `/aprovar`:

### 🎨 1. Aprovação do Protótipo Visual no Doop (Fase 2 -> Fase 3):
* **Contexto:** O `@UIUXDesigner` desenhou as telas no Doop Canvas e enviou a URL no chat aguardando sua validação.
* **Ao digitar `/aprovar`:**
  - O `@UIUXDesigner` registra o status como **`Aprovado pelo Cliente`**.
  - Destrava imediatamente o `@FrontendDev` e o `@MobileDev` para iniciarem a codificação das telas.
  - Emite o Handoff formal para desenvolvimento.

### 🔔 2. Autorização do Portão Humano Pré-Merge (Fase 5 -> Deploy):
* **Contexto:** O Pull Request foi aberto, as esteiras de CI (`ci-staging.yml`) passaram com 100% de sucesso (verde ✅), e o agente notificou você com o link do PR.
* **Ao digitar `/aprovar` (ou `/aprovo-merge`):**
  - O `@DevOps` realiza o merge do Pull Request em `develop` ou `staging`.
  - Dispara a esteira de CD para publicação no **Docker Swarm com Traefik (SSL + Basic Auth)**.
  - O `@SecOps` assume para a homologação final de segurança.
