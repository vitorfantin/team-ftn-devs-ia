# 🏗️ Arquitetura de Software & Dados - FTN DevsIA

Este arquivo é gerado e mantido pelo **`@TechLead`** para consolidar os contratos de arquitetura, banco de dados e metas de carga antes da liberação do desenvolvimento.

---

## 🏛️ 1. Padrão Arquitetural
* **Padrão Selecionado:** Clean Architecture / Modular
* **Linguagem / Runtime:** Node.js LTS (Web / Back-End) / Dart Flutter (Mobile)
* **Rotas e Internacionalização (i18n):** Centralizadas em dicionário (sem strings hardcoded)
* **Tratamento Global de Exceções:** Error Boundary global e captura de logs internos

---

## 💾 2. Banco de Dados & Persistência
* **SGBD Padrão:** PostgreSQL
* **Versão Fixada (Inegociável):** `postgres:18.6`
* **Controle Estrutural:** Migrations versionadas (`npm run db:migrate`)
* **Proibição:** Uso de tags móveis como `latest`

---

## ⚡ 3. Metas de Performance e Carga (SLOs para QA)
* **RPS Mínimo Suportado:** 500 req/s em rotas públicas
* **Latência Máxima:** P95 < 200ms sob carga nominal
* **Script de Stress:** Localizado em `src/__tests__/stress/` (K6 ou Artillery)

---

## 🔌 4. Contratos de API
* **Formato Base de Resposta de Erro:**
  ```json
  {
    "statusCode": 400,
    "mensagem": "Descrição genérica e amigável para o cliente",
    "timestamp": "2026-11-01T20:00:00Z"
  }
  ```
