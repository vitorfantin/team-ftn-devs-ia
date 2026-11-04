# Command: /status
# Mentions: @time status
# Aliases: /andamento, /onde-estamos
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Ao acionar `/status` (ou `@time status`), o time compila e exibe instantaneamente o **Painel Visual de Andamento da Feature** no chat, combinando o status da esteira de Handoff com o motor mecânico do Spec-Driven (`onp-spec status` e `onp-spec resumo <feature> --tabela`).

---

## 🧭 O que o comando `/status` faz:

1. **Localiza a Feature Ativa:**
   * Identifica a feature em desenvolvimento em `.spec/features/` ou no `task.md`.
2. **Consulta Mecânica do Spec-Driven:**
   * Executa `onp-spec status` para verificar requisitos (`US`, `AC`), tarefas pendentes/concluídas (`T-xxx`) e provas gravadas.
   * Executa `onp-spec resumo <feature> --tabela` para obter o ledger de tarefas em tempo real.
3. **Imprime o Painel no Chat:**

```text
📍 [FTN DevsIA - Status da Esteira]:
Feature: [Nome da Feature]
Spec ONP: .spec/features/[feature]/spec.md
Doop Canvas: [URL do Canvas ou 'Não utilizado']
ClickUp: [Link do Card ou 'Rastreamento Nativo em Markdown']

🚦 Fases da Esteira:
- [x] Fase 0: @ProductManager (/pm)   - Spec ONP, Histórias e Tabela qa-ids
- [x] Fase 1: @TechLead (/tl)         - Arquitetura, Contratos e Postgres 18.6
- [x] Fase 2: @UIUXDesigner (/uiux)   - Telas no Doop e APROVAÇÃO DO CLIENTE
- [/] Fase 3: @BackendDev (/back)     - Endpoints REST & DER vivo ◄ [EM ANDAMENTO]
- [ ] Fase 4: @QATester (/qa)         - Casos de Teste & E2E sem XPath
- [ ] Fase 5: @DevOps (/devops)       - CI & Trava do Portão Humano
- [ ] Fase 6: @SecOps (/secops)       - Auditoria SAST/LGPD

📊 Tabela de Tarefas Spec-Driven (onp-spec):
| Tarefa | Título | Responsável | Status | Prova (@spec:AC-xxx) |
|---|---|---|---|---|
| T-001 | Migrations Postgres | @BackendDev | Concluída | @spec:AC-001 [PASS] |
| T-002 | Endpoints REST | @BackendDev | Executando | Pendente |
| T-003 | Interface Web | @FrontendDev | Pendente | Bloqueado por T-002 |

👉 Próxima Ação: @BackendDev concluir T-002 para liberar handoff do @FrontendDev.
```
