# Command: /der
# Mentions: @back der
# Aliases: /banco, /er, /schema
# Team: FTN DevsIA
# Governança: Living DER & Banco de Dados Postgres 18.6

Ao acionar `/der` (ou `@back der`), o `@BackendDev` lê o arquivo de modelo relacional vivo em `docs/banco_de_dados/diagrama_er.md` e renderiza o **Diagrama Entidade-Relacionamento Completo** formatado em Mermaid diretamente no chat.

---

## 🧭 O que o `/der` exibe:

1. **Diagrama Visual em Mermaid:**
   * Todas as tabelas, chaves primárias (`PK`), chaves estrangeiras (`FK`), tipos de dados e relacionamentos de cardinalidade (`1:N`, `N:N`, `1:1`).
2. **Status das Migrations:**
   * Versão atual da migration do banco `postgres:18.6`.
3. **Histórico de Alterações Recentes:**
   * Resumo das tabelas ou colunas adicionadas pela feature ativa.
4. **Regras de Integridade:**
   * Índices criados, constraints de unicidade e regras de deleção em cascata (*CASCADE/RESTRICT*).
