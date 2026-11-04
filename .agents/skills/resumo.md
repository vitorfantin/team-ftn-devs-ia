# Command: /resumo
# Mentions: @pm resumo, @time resumo
# Aliases: /release-notes, /entrega
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Gestão de Produto

Ao acionar `/resumo` (ou `@pm resumo`), o `@ProductManager` compila a entrega da feature em linguagem de negócio amigável, pronta para ser enviada diretamente para o cliente ou stakeholders.

---

## 🧭 O que o `/resumo` compila:

1. **Visão Executiva do que foi Entregue:**
   * Resumo em português claro das Histórias de Usuário (`US-xxx`) atendidas e valor de negócio gerado.
2. **Ambiente & Credenciais de Acesso (Staging):**
   * Link da aplicação publicada no Docker Swarm via Traefik (HTTPS);
   * Instruções de acesso seguro para homologação do cliente.
3. **Garantia de Qualidade & Testes:**
   * Resumo de critérios de aceite homologados (`AC-xxx`), cobertura de testes TDD (≥90%) e pirâmide de testes sem falhas.
4. **Protótipo Doop & Design:**
   * Link do Doop Canvas para conferência do layout homologado.
5. **Texto Copiável:**
   * Um parágrafo pronto para copiar e colar no WhatsApp, e-mail ou Slack do cliente final.
