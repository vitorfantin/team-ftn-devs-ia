# 🎨 Guia de UI/UX com Doop - FTN DevsIA

Este documento orienta a operação da ferramenta de design **Doop** (`https://github.com/kgoedecke/doop`), os modos de hospedagem/acesso (local ou servidor por IP de rede/externo), o gerenciamento de credenciais e a trava inegociável de desenvolvimento entre o Designer e os Desenvolvedores.

---

## 🛑 Regra Fundamental: Por que a UI/UX PRECISA estar Pronta Antes da Codificação?

> **Regra de Ouro FTN:** O `@FrontendDev` (Web) e o `@MobileDev` (Flutter) são **terminantemente proibidos** de escrever código de interface antes que o `@UIUXDesigner` homologue as telas e tokens no Doop (ou no documento de design) e libere o Handoff.

### Motivos Críticos:
1. **Erradicação do Retrabalho:** Quando desenvolvedores começam a programar antes do design estar pronto, eles "adivinham" layouts, criam componentes descartáveis e inventam fluxos que são inevitavelmente refeitos quando o design chega.
2. **Congelamento da Tabela de `qa-id`:** As automações de teste dependem de identificadores estáveis (`qa-id="btn-login-submit"`). Se o desenvolvedor inventa IDs antes da tela ser desenhada com os fallbacks anti-crash (`btn-error-retry`), os testes do `@QATester` quebram.
3. **Paralelismo Inteligente:** Enquanto o `@UIUXDesigner` desenha no Doop, o **`@BackendDev` já trabalha em paralelo** (criando o banco Postgres 18.6, migrations e APIs). O Frontend/Mobile só entra quando a fundação de design estiver congelada.

---

## 🚀 1. Modos de Hospedagem & Acesso ao Doop

O Doop pode ser executado localmente ou acessado em um servidor central por toda a equipe:

### Modo 1: Instalação Local (Docker Compose)
Ideal para rodar no próprio computador do desenvolvedor ou designer:
```bash
docker compose -f docker/doop/docker-compose.yml up -d
```
* **URL Padrão:** `http://localhost:3000`

### Modo 2: Servidor Existente (IP da Rede Local ou Externo)
Ideal quando a empresa já possui uma instância central do Doop compartilhada entre os times:
* **IP na Rede Local:** `http://192.168.1.50:3000`
* **Domínio Externo:** `https://doop.sua-empresa.com`

---

## 🔐 2. Gerenciamento de Credenciais (Usuário & Senha)

Durante o assistente `./install-ftn.sh`, você pode inserir o usuário e senha ou **deixar para configurar depois**.

### Onde configurar as credenciais posteriormente:
Se você optou por deixar para depois, edite o arquivo **`ftn.config.json`** na raiz da aplicação:

```json
{
  "doop": {
    "enabled": true,
    "mode": "local",
    "url": "http://localhost:3000",
    "username": "seu-usuario-ou-email",
    "password": "sua-senha-segura"
  }
}
```

Se você estiver rodando o Doop localmente via Docker, você também pode preencher as variáveis no arquivo:
👉 **`docker/doop/.env`**:
```env
DOOP_PORT=3000
DOOP_USER=seu-usuario-ou-email
DOOP_PASSWORD=sua-senha-segura
```

---

## 🔄 3. Fluxo de Trabalho do `@UIUXDesigner` no Doop

1. **Criação das Telas & Design System:**
   * Desenhe o layout das telas, paleta de cores, tipografia e espaçamentos no canvas do Doop.
   * Projete os **5 estados obrigatórios**: Inicial, Carregando (*Loading*), Sucesso, Vazio (*Empty State*) e Erro.
   * Desenhe a tela de fallback de erro crítico com o botão padronizado `qa-id="btn-error-retry"`.
2. **Exportação & Documentação:**
   * Registre a especificação consolidada em [`docs/design/design_system.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/design/design_system.md).
3. **Registro das Tarefas:**
   * Anexe o link do canvas do Doop (ex: `http://localhost:3000/canvas/login` ou `http://192.168.1.50:3000/canvas/login`) e o link do documento `docs/design/design_system.md`.
   * Marque a subtarefa como **`Concluído / Aprovado`**.
4. **Handoff:**
   * Emita o bloco de Handoff liberando oficialmente o `@FrontendDev` e `@MobileDev` para a codificação.
