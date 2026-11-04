# Command: /doop
# Mentions: @uiux doop
# Aliases: /canvas, /telas
# Team: FTN DevsIA
# Governança: Doop UI/UX Canvas & Design System

Ao acionar `/doop` (ou `@uiux doop`), o `@UIUXDesigner` exibe as informações completas do **Doop UI/UX Canvas** do projeto:

---

## 🧭 O que o `/doop` exibe:

1. **Status e Modo de Execução:**
   * Modo ativo em `ftn.config.json` (Local Docker `http://localhost:3000` ou Servidor Remoto via IP/domínio).
2. **URL do Canvas da Feature:**
   * Link direto para visualização e prototipagem interativa das telas (`[doop.url]/canvas/[feature]`).
3. **Status de Autenticação:**
   * Usuário configurado ou instruções de preenchimento em `ftn.config.json` (`doop.username` e `doop.password`) caso tenha sido deixado para configurar depois.
4. **Mapeamento dos 5 Estados de Interface:**
   * Inicial, Loading/Skeleton, Sucesso, Vazio (*Empty State*) e Erro Crítico (*Anti-Crash*) com `qa-id="btn-error-retry"`.
5. **Status da Aprovação Visual do Cliente:**
   * Se o design está `Pendente de Validação` ou `Aprovado pelo Cliente` (autorizando Frontend e Mobile a codificarem).
