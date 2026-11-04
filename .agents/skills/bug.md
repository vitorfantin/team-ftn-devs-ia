# Command: /bug
# Mentions: @qa bug, @back bug, @front bug, @mobile bug
# Aliases: /fix, /defeito
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & TDD

Ao acionar `/bug` (ou `/fix`), o time FTN DevsIA dispara o **Protocolo de Resolução Cirúrgica de Defeitos**, baseado estritamente em TDD (*Test-Driven Development*):

---

## 🧭 O Ciclo de Resolução de Bug em 4 Passos:

1. **Passo 1 - Reprodução & Teste que Falha (TDD Red):**
   * O `@QATester` isola o defeito reportado.
   * Cria um teste automatizado específico cobrindo o bug, anotado com a referência do critério ou defeito (ex: `@spec:AC-xxx [BUGFIX]`).
   * Roda o teste para provar mecanicamente que ele **FALHA** (vermelho ❌).
2. **Passo 2 - Correção do Código (TDD Green):**
   * O `@BackendDev` ou `@FrontendDev` / `@MobileDev` assume a tarefa e faz a correção pontual no código da aplicação até o teste passar (verde ✅).
3. **Passo 3 - Regressão & Cobertura:**
   * O `@QATester` roda a suíte de testes completa para garantir que a correção não quebrou nenhuma funcionalidade preexistente.
   * Verifica se a cobertura de testes permanece ≥ 90%.
4. **Passo 4 - Prova Mecânica & Auditoria:**
   * Executa `onp-spec verify` e `onp-spec audit --ci`.
   * Registra a lição aprendida no ledger (`onp-spec licoes add`).
   * Emite o relatório de bug resolvido no chat.
