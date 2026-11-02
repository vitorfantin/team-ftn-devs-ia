# 🏛️ Pirâmide de Testes Completa - FTN DevsIA

Este documento estabelece a governança de qualidade de software do ecossistema FTN DevsIA. Para garantir software blindado contra bugs, regressões, quebras de contrato e lentidão, o time implementa **100% dos níveis da Pirâmide de Testes**, distribuídos estrategicamente entre os papéis de engenharia.

---

## 📊 Diagrama da Pirâmide de Testes & Responsabilidades

```text
                     ▲
                    / \
                   /   \
                  / E2E \         ◄─── Topo: Testes Ponta a Ponta (@QATester)
                 /-------\             Jornadas reais de usuário puramente via qa-id (Zero XPath)
                /         \
               /  CONTRATO \      ◄─── Meio-Alto: Testes de Contrato de API (@TechLead / @BackendDev / @QATester)
              /   DE APIS   \          Validação de Schemas OpenAPI/JSON Schema (Front ↔ Back)
             /---------------\
            /   INTEGRAÇÃO    \   ◄─── Meio: Testes de Integração (@BackendDev / @FrontendDev)
           /   BANCO DE DADOS  \       Serviços, Repositórios e Banco Real em container (Postgres 18.6)
          /---------------------\
         / COMPONENTES & WIDGETS \ ◄─── Base Visual: Testes de Componentes (@FrontendDev / @MobileDev)
        /     ACELERAÇÃO UI       \     Renderização isolada, estados e Acessibilidade WCAG (48x48px)
       /---------------------------\
      /          UNITÁRIOS          \ ◄─── Base da Pirâmide: Testes Unitários (@Devs - TDD)
     /      LÓGICA PURA / REGRAS     \     Cobertura Geral Obrigatória ≥ 90% (Jest, Vitest, Flutter Test)
    /---------------------------------\
```

### 🛡️ Níveis Transversais (Testes Não-Funcionais Especializados)
* ⚡ **Performance & Stress Tests:** Scripts em `src/__tests__/stress/` (K6 ou Artillery) calibrados pelo `@TechLead` e executados pelo `@QATester`.
* 🔒 **Segurança & SAST/DAST:** Varredura de credenciais (Gitleaks), dependências vulneráveis e testes OWASP executados pelo `@SecOps`.
* ♿ **Acessibilidade Automatizada (A11y):** Testes de conformidade WCAG e validação de áreas de clique de 48x48px integrados nos testes de componentes.

---

## 🎯 Detalhamento dos 5 Níveis da Pirâmide

### Nível 1: Testes Unitários (Base da Pirâmide)
* **Responsáveis:** `@FrontendDev`, `@MobileDev`, `@BackendDev`
* **Abordagem:** TDD estrito (teste escrito antes da implementação).
* **Escopo:** Funções puras, validações de domínio, cálculos, formatadores, reducers e regras de negócio isoladas sem dependências externas.
* **Métrica de Sucesso:** Cobertura geral de linhas, branches e funções **≥ 90%**.
* **Comando Padrão:** `npm run test:unit` ou `flutter test test/unit/`

---

### Nível 2: Testes de Componentes & Widgets (Base Visual)
* **Responsáveis:** `@FrontendDev` (Web) e `@MobileDev` (Flutter)
* **Escopo:** Renderização isolada de componentes do Design System e widgets de tela.
* **Estados Obrigatórios Testados:**
  1. Carregamento (*Loading / Skeleton*);
  2. Sucesso com exibição de dados;
  3. Estado Vazio (*Empty State*);
  4. Estado de Erro amigável;
  5. Acionamento do Fallback Crítico (`qa-id="btn-error-retry"`).
* **Acessibilidade Integrada (WCAG):** Verificação de contraste de cores e áreas mínimas de clique de **48x48px**.
* **Comando Padrão:** `npm run test:component` ou `flutter test test/widget/`

---

### Nível 3: Testes de Integração & Banco de Dados (Meio da Pirâmide)
* **Responsáveis:** `@BackendDev` e `@FrontendDev`
* **Escopo:** Comunicação real entre controllers, services, middlewares e repositórios.
* **Banco de Dados Real:** Testado contra instância real de **`postgres:18.6`** via container de teste, validando a execução correta de *Migrations* (`npm run db:migrate`) e transações seguras.
* **Comando Padrão:** `npm run test:integration`

---

### Nível 4: Testes de Contrato de API (Meio-Alto da Pirâmide)
* **Responsáveis:** `@TechLead` (define o schema), `@BackendDev` (implementa os endpoints) e `@QATester` (automatiza a validação cruzada)
* **Escopo:** Validação formal dos contratos JSON / OpenAPI / Swagger para garantir que nenhuma alteração no Backend quebre o Frontend Web ou o App Mobile.
* **Garantia:** Respostas de erro padronizadas (`statusCode`, `mensagem`, `timestamp`) e payloads com tipagem estrita.
* **Comando Padrão:** `npm run test:contract`

---

### Nível 5: Testes Ponta a Ponta / E2E (Topo da Pirâmide)
* **Responsável:** `@QATester`
* **Pré-requisito Mandatório:** Casos de Teste documentados previamente em `docs/testes/casos_de_teste/[feature].md`.
* **Escopo:** Simulação completa da jornada do usuário em browsers reais (Playwright/Cypress) ou emuladores mobile (Flutter Integration Test).
* **Regra de Ouro (Zero XPath):** Localização de elementos **estritamente por `qa-id` ou `data-qa`** mapeados na spec. Proibido o uso de seletores XPath ou classes CSS voláteis.
* **Comando Padrão:** `npm run test:e2e` ou `npm run test:qa-automation`

---

## ⚡ Níveis Transversais de Qualidade

### 1. Testes de Performance & Stress (Carga Massiva)
* **Definição de Metas (SLOs):** `@TechLead` define as metas em `.spec/arquitetura.md` (ex: 500 req/s com P95 < 200ms).
* **Automação:** `@QATester` cria e roda os scripts em `src/__tests__/stress/` usando **K6** ou **Artillery**.
* **Comando Padrão:** `npm run test:stress`

### 2. Testes de Segurança (SAST/DAST & Zero-Secret Leak)
* **Responsável:** `@SecOps` via workflow isolado `.github/workflows/security-scan.yml`.
* **Escopo:** Varredura de credenciais com Gitleaks, análise estática de código com `npm audit`, conformidade OWASP Top 10 e higienização do `.gitignore`.

---

## 🚦 Matriz de Comandos da Pirâmide no `package.json`

Para padronizar a execução local e na esteira de CI/CD, o repositório adota a seguinte convenção de scripts:

| Nível da Pirâmide | Comando npm | Executor Principal | Gate de CI |
| :--- | :--- | :--- | :---: |
| **Unitários** | `npm run test:unit` | Devs | PR Develop / Staging |
| **Componentes & A11y** | `npm run test:component` | Front / Mobile | PR Develop / Staging |
| **Integração & DB** | `npm run test:integration` | Backend | PR Develop / Staging |
| **Contrato de APIs** | `npm run test:contract` | Backend / QA | PR Staging |
| **Cobertura Geral (≥90%)** | `npm run test:coverage` | Todos os Devs | PR Staging (Bloqueante) |
| **E2E / QA Automação** | `npm run test:qa-automation` | `@QATester` | PR Staging (Bloqueante) |
| **Stress & Performance** | `npm run test:stress` | `@QATester` | Staging / On Demand |
| **Segurança & SAST** | `npm run test:security` | `@SecOps` | Workflow Security Scan |
