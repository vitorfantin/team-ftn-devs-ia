# Command: /testes
# Mentions: @qa testes, @qa test
# Aliases: /test, /suite
# Team: FTN DevsIA
# Governança: Pirâmide de Testes & Spec-Driven (@onovoprogramador/onp-spec)

Ao acionar `/testes` (ou `@qa testes`), o `@QATester` executa toda a suíte de testes do projeto e apresenta o **Raio-X Completo da Pirâmide de Testes** no chat, validando a integridade mecânica com o `onp-spec verify`.

---

## 🧭 O que o `/testes` reporta:

1. **Taxa de Cobertura Geral:**
   * Percentual de cobertura de linhas e branches (mínimo exigido: ≥ 90%).
2. **Níveis da Pirâmide de Testes:**
   * **Nível 1 (Unitários):** Regras de negócio isoladas;
   * **Nível 2 (Componentes / Widgets):** Renderização de telas sem chamadas reais;
   * **Nível 3 (Integração):** Comunicação real com PostgreSQL 18.6 e migrations;
   * **Nível 4 (Contratos de API):** Validação de schemas JSON de entrada e saída;
   * **Nível 5 (E2E Ponta a Ponta):** Jornadas completas em Playwright/Cypress/Flutter sem XPath (100% via `qa-id`);
   * **Carga & Stress:** Resultados de performance K6 em `src/__tests__/stress/`.
3. **Mapeamento Mecânico Spec-Driven:**
   * Executa `onp-spec verify <feature>` e lista quais critérios (`AC-xxx`) possuem prova gravada (`[PASS]`).
4. **Alerta de Falhas ou Regressões:**
   * Se houver qualquer teste quebrado, lista o arquivo, linha e causa do erro para correção imediata.
