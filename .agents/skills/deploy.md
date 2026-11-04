# Command: /deploy
# Mentions: @devops deploy
# Aliases: /staging, /publicar
# Team: FTN DevsIA
# Governança: Docker Swarm, Traefik & Portão Humano

Ao acionar `/deploy` (ou `@devops deploy`), o `@DevOps` assume o chat para gerenciar, validar pré-condições ou executar a publicação do projeto nos ambientes de homologação (Staging) ou Produção.

---

## 🧭 O que o `/deploy` faz:

1. **Validação das Pré-condições:**
   * Verifica se o Pull Request foi aprovado no Portão Humano pelo usuário;
   * Valida se todas as esteiras de CI (`ci-staging.yml`) passaram com 100% de sucesso;
   * Confirma que a esteira de auditoria de segurança do `@SecOps` (`security-scan.yml`) está limpa.
2. **Ambiente Staging (Docker Swarm + Traefik):**
   * Configura o Traefik com SSL automático (Let's Encrypt) e Basic Auth ativo no subdomínio de homologação;
   * Implanta a stack do Docker Swarm gerenciada via Portainer;
   * Atualiza o card da feature com a URL segura de homologação.
3. **Ambiente Produção (Tags de Versão):**
   * Para deploy em produção, gera a tag de versão semântica (`vX.Y.Z`), prepara o plano de rollback imediato e publica com zero downtime.
