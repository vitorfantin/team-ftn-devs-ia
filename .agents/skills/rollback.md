# Command: /rollback
# Mentions: @devops rollback
# Aliases: /reverter, /voltar-versao
# Team: FTN DevsIA
# Governança: Docker Swarm & Resiliência de Infraestrutura

Ao acionar `/rollback` (ou `@devops rollback`), o `@DevOps` executa o **Protocolo de Reversão Imediata de Emergência** no Docker Swarm sem downtime na aplicação.

---

## 🧭 O que o `/rollback` faz:

1. **Identificação da Versão Estável Anterior:**
   * Localiza a tag da imagem Docker da versão anterior estável (ex: `v1.1.3` -> `v1.1.2`).
2. **Reversão no Docker Swarm:**
   * Executa o rollback imediato do serviço no Swarm:
     `docker service rollback [nome_do_servico]`
   * Valida a integridade do tráfego através do Traefik (HTTPS + Basic Auth).
3. **Rollback de Banco de Dados (se aplicável):**
   * Se a release continha migrations problemáticas, aciona o `@BackendDev` para rodar a migration de *down/rollback* de forma segura sem perda de dados.
4. **Relatório de Incidente:**
   * Emite no chat o relatório pós-incidente (*post-mortem*) explicando o que ocorreu, a versão restaurada e as ações corretivas recomendadas.
