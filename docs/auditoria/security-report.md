# 🛡️ Relatório de Auditoria SecOps - FTN DevsIA

Este documento é preenchido e mantido pelo **`@SecOps`** a cada ciclo de homologação e release.

---

## 📋 Resumo da Última Auditoria

* **Data:** A definir na primeira release
* **Versão / Tag:** `v0.1.0-staging`
* **Auditor Responsável:** `@SecOps`
* **Status Geral:** `PENDENTE`

---

## 🔍 Checklist de Auditoria

| Item de Verificação | Alvo | Status | Observações |
| :--- | :--- | :---: | :--- |
| **Higiene do Git** | `.gitignore` e árvore de arquivos | ⏳ | Caches de IA e `.env` bloqueados |
| **Proteção de Borda** | Traefik Basic Auth & SSL | ⏳ | Hashes fortes e SSL automático |
| **Varredura SAST** | Dependências Node / Flutter | ⏳ | Executado via `security-scan.yml` |
| **Vazamento de Segredos** | Histórico de commits | ⏳ | Validado via Gitleaks |
| **Privacidade & LGPD** | Fluxo de dados sensíveis | ⏳ | Criptografia em repouso e trânsito |

---

## 🚨 Vulnerabilidades & Itens de Ação
*Nenhuma vulnerabilidade crítica registrada até o momento.*
