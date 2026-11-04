# Command: /bloqueio
# Mentions: @time bloqueio
# Aliases: /impedimento, /block
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Ao acionar `/bloqueio` (ou `/impedimento`), você ou qualquer especialista do time sinaliza um **impedimento crítico** que trava a continuidade do desenvolvimento da feature.

---

## 🧭 O que o comando `/bloqueio` faz:

1. **Identifica a Causa Raiz do Travamento:**
   * Falta de credenciais de terceiros;
   * Dúvida de regra de negócio que requer alinhamento do cliente;
   * Dependência técnica não atendida;
   * Falha de infraestrutura externa.
2. **Registro no Spec-Driven (`@onovoprogramador/onp-spec`):**
   * Registra o ponto de dúvida formalmente na seção de **Perguntas em Aberto (`Q-xxx`)** ou **Suposições (`ASM-xxx`)** em `.spec/features/[feature]/spec.md`.
3. **Atualização de Status:**
   * Atualiza o card da tarefa no ClickUp (ou `task.md`) com a etiqueta/status: **`⛔ Bloqueado`**.
4. **Alerta no Chat:**

```text
🚨 [FTN DevsIA - Sinalização de Impedimento]:
Fase Travada: [Fase / Especialista]
Motivo: [Descrição clara do bloqueio]
Pergunta em Aberto: Q-[xxx] (registrada na spec)

👉 O que é necessário para destravar:
[Ação que o cliente ou usuário precisa executar ou responder]
```
*(Após a resolução do problema pelo usuário, utilize `/status` ou chame o especialista para retomar a execução).*
