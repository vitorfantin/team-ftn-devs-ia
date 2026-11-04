# Command: /review
# Mentions: @tl review, @secops review
# Aliases: /revisar, /pr-review
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Ao acionar `/review` (ou `/revisar`), o `@TechLead` e o `@SecOps` realizam uma **Revisão Técnica e de Segurança Integrada** sobre o diff de código do branch atual antes da abertura ou homologação de Pull Request:

---

## 🧭 O que o `/review` audita:

1. **Auditoria de Arquitetura & Código (`@TechLead`):**
   * Cobertura de testes unitários e de integração (mínimo inegociável de 90%);
   * Regra estrita de comentários ≤ 2 linhas no topo de métodos/funções;
   * Conformidade com os contratos de API e schemas em `.spec/arquitetura.md`;
   * Banco fixado em `postgres:18.6` e migrations válidas;
   * Injeção de atributos `qa-id` em todos os elementos interativos.
2. **Auditoria de Segurança & Higiene (`@SecOps`):**
   * Varredura Zero-Secret Leak: nenhum token, chave privada ou senha commitada;
   * Conformidade com a LGPD nos modelos de dados;
   * Auditoria de dependências (`npm audit` / `flutter pub audit`) sem vulnerabilidades críticas;
   * Higiene do Git (zero arquivos temporários, logs ou pastas de agentes commitadas).
3. **Parecer Formal:**
   * Emite no chat a tabela com os itens aprovados e recomendações de refatoração, se houver.
