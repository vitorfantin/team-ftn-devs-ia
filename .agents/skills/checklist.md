# Command: /checklist
# Mentions: @time checklist, @qa checklist
# Aliases: /auditoria, /audit, /check
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Ao acionar `/checklist` (ou `@time checklist`), o time FTN DevsIA executa a **Auditoria Completa de Qualidade, Padrões e Segurança**, executando mecanicamente o `onp-spec audit --ci` e checando todos os itens do Checklist Mestre de Conformidade FTN.

---

## 🧭 O que o comando `/checklist` faz:

1. **Auditoria Mecânica do Spec-Driven:**
   * Executa `onp-spec audit --ci` na raiz da aplicação.
   * Se o retorno for código diferente de 0, exibe os problemas apontados (`AC_SEM_TESTE`, `AC_SEM_PROVA`, `TESTE_ORFAO`, `ASM_ABERTA`, etc.) e interrompe o gate.
2. **Checagem de Qualidade & Padrões FTN:**
   * Verifica se a cobertura de testes é ≥ 90%.
   * Valida se não existem seletores XPath nas automações de QA.
   * Checa se o DER vivo em `docs/banco_de_dados/diagrama_er.md` foi atualizado.
   * Valida se 100% dos botões e campos possuem atributos `qa-id` da spec.
   * Valida a regra de comentários ≤ 2 linhas.
   * Confirma a aprovação visual do protótipo no Doop pelo cliente.
   * Roda varredura SAST / git hygiene (zero segredos expostos).
3. **Emite o Relatório no Chat:**

```text
📋 [FTN DevsIA - Checklist Mestre de Conformidade]:

- [x] @ProductManager: Spec ONP (.spec/features/[feature]/spec.md) com US, AC e Tabela qa-ids.
- [x] @TechLead: Arquitetura em .spec/arquitetura.md, postgres:18.6 e comentários ≤ 2 linhas.
- [x] @UIUXDesigner: Telas no Doop Canvas com 5 estados e APROVADO visualmente pelo cliente.
- [x] @BackendDev: TDD aplicado (cobertura ≥ 90%) e DER vivo atualizado em docs/banco_de_dados/.
- [x] @FrontendDev / @MobileDev: 100% dos qa-ids da spec injetados sem seletores ad-hoc.
- [x] @QATester: Casos de Teste documentados antes da automação, pirâmide coberta e zero XPath.
- [x] @SecOps: Higiene do Git (zero secrets), SAST sem falhas críticas e conformidade LGPD.
- [x] Motor Mecânico ONP: onp-spec audit --ci [EXIT CODE 0 - APROVADO ✅]

🚦 Veredito: 100% Homologado! Pronto para abertura de Pull Request para develop/staging.
```
