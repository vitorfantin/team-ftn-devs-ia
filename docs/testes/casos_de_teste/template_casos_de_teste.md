# 📑 Casos de Teste - [Nome da Funcionalidade / Feature]

* **Feature:** [Nome da Feature / Código na Spec]
* **Especificação de Referência:** `.spec/features/[feature].md`
* **Responsável:** `@QATester`
* **Data de Criação:** [Data]
* **Status:** `Planejado` | `Em Automação` | `Aprovado`

---

## 🎯 1. Matriz de Rastreabilidade (Spec ↔ qa-id)

| ID do Caso | Tipo | qa-ids Mapeados | Cobertura |
| :--- | :--- | :--- | :--- |
| `CT-001` | Caminho Feliz | `qa-id="input-email"`, `qa-id="btn-submit"` | Autenticação com sucesso |
| `CT-002` | Caminho Triste | `qa-id="input-email"`, `qa-id="alert-error"` | E-mail inválido |
| `CT-003` | Fallback Anti-Crash | `qa-id="btn-error-retry"` | Recuperação de falha crítica |

---

## 📋 2. Casos de Teste Estruturados

### 🟢 CT-001: [Título do Caso - Caminho Feliz]
* **Severidade:** `Crítica`
* **Tipo:** Funcional / Positivo
* **Pré-condições:** Usuário com conta ativa e sem bloqueios no sistema.
* **Cenário (BDD / Gherkin):**
  ```gherkin
  Dado que o usuário está na tela de login
  Quando preenche o campo "qa-id=input-email" com um e-mail válido
  E preenche o campo "qa-id=input-password" com a senha correta
  E clica no botão "qa-id=btn-submit"
  Então deve ser redirecionado para a tela inicial
  E deve visualizar a mensagem de boas-vindas com "qa-id=welcome-user"
  ```
* **Resultado Esperado:** Autenticação realizada com sucesso e token persistido em Secure Storage / Local.

---

### 🔴 CT-002: [Título do Caso - Caminho Triste / Validações]
* **Severidade:** `Alta`
* **Tipo:** Funcional / Negativo
* **Pré-condições:** Usuário na tela de login.
* **Cenário (BDD / Gherkin):**
  ```gherkin
  Dado que o usuário preenche o campo "qa-id=input-email" com formato inválido
  Quando clica no botão "qa-id=btn-submit"
  Então o sistema não deve disparar a requisição de autenticação
  E deve exibir a mensagem de erro no elemento "qa-id=alert-validation-email"
  ```
* **Resultado Esperado:** Bloqueio imediato na interface com feedback visual amigável.

---

### 🚨 CT-003: [Título do Caso - Erro Crítico & Fallback]
* **Severidade:** `Crítica`
* **Tipo:** Resiliência / Anti-Crash
* **Pré-condições:** Servidor fora do ar (HTTP 500) ou falha na renderização do componente.
* **Cenário (BDD / Gherkin):**
  ```gherkin
  Dado que ocorre uma falha catastrófica na obtenção de dados
  Quando o Error Boundary captura a exceção
  Então a tela de fallback elegante deve ser apresentada
  E deve conter o botão "qa-id=btn-error-retry"
  Quando o usuário clica em "qa-id=btn-error-retry"
  Então o sistema deve tentar recarregar os dados sem quebrar a aplicação
  ```
* **Resultado Esperado:** Interface não exibe tela branca e permite tentativa de recuperação via `btn-error-retry`.
