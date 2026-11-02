# 🎨 Guia de UI/UX com Doop - FTN DevsIA

Este documento orienta a operação da ferramenta de design **Doop** (`https://github.com/kgoedecke/doop`) e estabelece a trava inegociável de desenvolvimento entre o Designer e os Desenvolvedores.

---

## 🛑 Regra Fundamental: Por que a UI/UX PRECISA estar Pronta Antes da Codificação?

> **Regra de Ouro FTN:** O `@FrontendDev` (Web) e o `@MobileDev` (Flutter) são **terminantemente proibidos** de escrever código de interface antes que o `@UIUXDesigner` homologue as telas e tokens no Doop e no ClickUp.

### Motivos Críticos:
1. **Erradicação do Retrabalho:** Quando desenvolvedores começam a programar antes do design estar pronto, eles "adivinham" layouts, criam componentes descartáveis e inventam fluxos que são inevitavelmente refeitos quando o design chega.
2. **Congelamento da Tabela de `qa-id`:** As automações de teste dependem de identificadores estáveis (`qa-id="btn-login-submit"`). Se o desenvolvedor inventa IDs antes da tela ser desenhada com os fallbacks anti-crash (`btn-error-retry`), os testes do `@QATester` quebram.
3. **Paralelismo Inteligente:** Enquanto o `@UIUXDesigner` desenha no Doop, o **`@BackendDev` já trabalha em paralelo** (criando o banco Postgres 18.6, migrations e APIs). O Frontend/Mobile só entra quando a fundação de design estiver congelada.

---

## 🚀 1. Como Inicializar o Doop (Local ou Servidor da Rede)

O Doop é uma tela de design colaborativa multiplayer e aberta, com suporte nativo ao protocolo MCP e iframes sandboxados.

### Opção A: Via Docker / Docker Compose (Recomendado para Rede Local)
Ideal para hospedar em um servidor local da empresa ou máquina dedicada para que todo o time acesse:

```bash
# Na raiz do projeto, execute o assistente:
./scripts/install_doop.sh
# Escolha a opção 1 (Docker)
```
Ou execute diretamente com o compose:
```bash
docker compose -f docker/doop/docker-compose.yml up -d
```
* **Acesso Local:** `http://localhost:3000`
* **Acesso na Rede Local (Wi-Fi/LAN):** `http://IP_DO_SERVIDOR:3000`

### Opção B: Via Bun Nativo (Local na máquina)
Se preferir rodar de forma leve diretamente no Mac/Linux:
```bash
./scripts/install_doop.sh
# Escolha a opção 2 (Bun)
```

---

## 🔄 2. Fluxo de Trabalho do `@UIUXDesigner` no Doop

1. **Criação das Telas & Design System:**
   * Desenhe o layout das telas, paleta de cores, tipografia e espaçamentos no canvas do Doop.
   * Projete os **5 estados obrigatórios**: Inicial, Carregando (*Loading*), Sucesso, Vazio (*Empty State*) e Erro.
   * Desenhe a tela de fallback de erro crítico com o botão padronizado `qa-id="btn-error-retry"`.
2. **Exportação & Documentação:**
   * Registre a especificação consolidada em [`docs/design/design_system.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/design/design_system.md).
3. **Registro no ClickUp:**
   * Acesse o card `[UI/UX] Design System, Estados & Fallback` no ClickUp.
   * Anexe o link do canvas do Doop (ex: `http://servidor-local:3000/canvas/login`) e o link do documento `docs/design/design_system.md`.
   * Marque a subtarefa como **`Concluído / Aprovado`**.
4. **Handoff:**
   * Emita o bloco de Handoff liberando oficialmente o `@FrontendDev` e `@MobileDev` para a codificação.
