# 🔄 Protocolo de Handoff & Governança de Agentes - FTN DevsIA

Este documento define o contrato inegociável de transição de tarefas entre os agentes especialistas do time **FTN DevsIA**, garantindo que cada membro atue estritamente dentro da sua alçada e sem interferir no trabalho dos demais.

---

## 🎯 Princípios Fundamentais de Isolamento

1. **Fonte Única da Verdade (SSOT):** Nenhuma decisão de escopo, arquitetura ou identificador de teste (`qa-id`) é tomada em memória volátil de chat. Toda decisão deve ser registrada em seu respectivo arquivo na pasta `.spec/` ou `docs/`.
2. **Execução Estritamente Sequencial por Fases:** Um agente só inicia sua atuação quando o artefato de saída da fase anterior estiver formalmente gerado e homologado pelo usuário humano.
3. **Proibição de Invasão de Alçada:** Cada agente possui limites explícitos do que **NÃO PODE FAZER**. Tentativas de alterar artefatos de outro agente invalidam o ciclo.
4. **Token de Handoff Obrigatório:** Ao finalizar sua missão, o agente deve emitir o bloco padronizado de Handoff no chat, indicando o próximo especialista responsável.
5. **Cobertura Integral da Pirâmide de Testes:** Todo o ciclo deve cobrir rigorosamente todos os níveis da pirâmide de testes de software ([`docs/testes/piramide_de_testes.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/testes/piramide_de_testes.md)): Unitários (Nível 1), Componentes (Nível 2), Integração (Nível 3), Contratos de API (Nível 4) e E2E sem XPath (Nível 5).
6. **Rastreabilidade e Centralização no ClickUp:** Toda feature, quebra em subtarefas técnicas de engenharia, ciclo de Casos de Teste (planejamento prévio e automação) e documentações aprovadas devem ser obrigatoriamente sincronizadas no ClickUp ([`docs/tutoriais/integracao_clickup.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/tutoriais/integracao_clickup.md)).

---

## 📋 Matriz de Contrato de Handoff & Rastreabilidade no ClickUp

| Fase | Agente Responsável | Artefato de Entrada | Ação no ClickUp | Artefato de Saída | Próximo Agente |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **0** | `@ProductManager` | Solicitação do usuário (`/iniciar-time-ftn`) | Cria o card `[FEATURE] - [Nome]`, anexa links da spec e quebra as subtarefas técnicas ([TL], [UI/UX], [BACK], [FRONT/MOB]). | `.spec/constituicao.md`<br>`.spec/features/[nome].md` | `@TechLead` |
| **1** | `@TechLead` | `.spec/features/[nome].md` | Assume card `[TL]`, anexa a arquitetura e refina as subtarefas técnicas de desenvolvimento. | `.spec/arquitetura.md` | `@UIUXDesigner` & `@BackendDev` |
| **2** | `@UIUXDesigner` | `.spec/features/[nome].md`<br>`.spec/arquitetura.md` | Assume card `[UI/UX]`, desenha telas no Doop Canvas (local ou rede), anexa tokens e fallbacks anti-crash no ClickUp. | `docs/design/design_system.md`<br>Doop Canvas URL | `@FrontendDev` ou `@MobileDev`<br>*(Trava Rígida: Front/Mobile bloqueados até UI/UX estar pronta)* |
| **3** | `@BackendDev`<br>`@FrontendDev`<br>`@MobileDev` | Specs de Produto, Arquitetura, Design no Doop e DER | Assumem cards no ClickUp. Backend atualiza DER vivo (`docs/banco_de_dados/diagrama_er.md`), devs codificam TDD ≥90%, abrem PR e movem para `Pronto para QA`. | Pull Request aberto para `develop`<br>`docs/banco_de_dados/diagrama_er.md` atualizado | `@QATester` |
| **4** | `@QATester` | PR aberto + Tabela de `qa-id` da spec | 1. Registra Casos de Teste no ClickUp (`📝 Casos de Teste Criados`).<br>2. Automatiza E2E sem XPath e atualiza para `🤖 Automatizado & Aprovado`. | `docs/testes/casos_de_teste/[nome].md`<br>Suíte E2E automatizada e PR aprovado | `@DevOps` (se aprovado) |
| **5** | `@DevOps` | Merge aprovado em `develop` ou `staging` | Publica em Staging, comenta a URL segura (`://dominio.com.br`) no ClickUp e move status para `🌐 Publicado em Staging`. | Deploy ativo em staging | `@SecOps` |
| **6** | `@SecOps` | Deploy ativo e código mesclado | Executa `security-scan.yml`, anexa relatório de auditoria e marca no ClickUp como `🛡️ SecOps Homologado (Pronto para Produção)`. | `docs/auditoria/security-report.md` | Ciclo concluído |

---

## 🏷️ Padrão Obrigatório de Emissão do Bloco de Handoff

Ao concluir sua alçada, o agente **DEVE** emitir exatamente este bloco no final de sua resposta:

```markdown
---
### 🔄 [FTN DevsIA] - Protocolo de Handoff
- **De:** @[PapelAtual]
- **Para:** @[ProximoPapel]
- **ClickUp Task / Card:** `[ID_OU_URL_DA_TAREFA_NO_CLICKUP]` (Status atualizado)
- **Artefato Gerado/Atualizado:** `caminho/do/arquivo.md`
- **Status:** Concluído e em conformidade com as regras do time
- **Ação Requerida do Próximo Agente:** [Ação objetiva de 1 a 2 linhas]
---
```

---

## 🛡️ Tabela Mestra de `qa-id` (Fonte Única da Verdade)

Para erradicar o conflito entre o código dos desenvolvedores e as automações de QA:
1. O `@ProductManager` e o `@UIUXDesigner` definem na spec da feature a tabela com todos os elementos interativos:
   ```markdown
   | Elemento | Tipo | qa-id Obrigatório | Comportamento Esperado |
   | :--- | :--- | :--- | :--- |
   | Botão Entrar | Button | `qa-id="btn-login-submit"` | Dispara autenticação |
   | Campo E-mail | Input | `qa-id="input-login-email"` | Recebe e-mail do usuário |
   | Mensagem Erro | Alert | `qa-id="alert-login-error"` | Exibe mensagem de credenciais inválidas |
   ```
2. O `@FrontendDev` e o `@MobileDev` são **proibidos** de alterar esses identificadores.
3. O `@QATester` é **proibido** de buscar elementos por XPath ou classes CSS, programando seus testes consumindo estritamente os `qa-id` desta tabela.

---

## 📝 Regra Obrigatória para QA: Casos de Teste Antes da Automação

O `@QATester` deve seguir rigorosamente a sequência de 2 etapas na Fase 4:
1. **Etapa 4.1 (Planejamento & Estruturação):** Criar e salvar `docs/testes/casos_de_teste/[feature].md` cobrindo cenários positivos (caminho feliz), negativos (caminho triste/validações) e anti-crash (`qa-id="btn-error-retry"`), rastreados pelos `qa-id`s da spec.
2. **Etapa 4.2 (Codificação da Automação):** Apenas após documentar os casos de teste, codificar os scripts de automação E2E (Playwright, Cypress, Flutter Integration), implementando fielmente cada caso planejado.

