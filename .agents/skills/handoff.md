# Command: /handoff
# Mentions: @time handoff
# Aliases: /passar-bastao, /next, /avancar
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Ao acionar `/handoff` (ou `/passar-bastao`), o especialista que concluiu sua fase gera o **Bloco Formal de Passagem de Bastão** no chat e aciona o próximo responsável da esteira, conforme documentado em `docs/protocolo_handoff.md`.

---

## 🧭 O que o comando `/handoff` faz:

1. **Validação do Artefato de Saída:**
   * Verifica se a entrega da fase atual está completa e salva (Spec, Arquitetura, Doop, Código com TDD, Casos de Teste ou Deploy).
2. **Atualização no ClickUp ou `task.md`:**
   * Atualiza o status da tarefa atual para `Concluído` e move a próxima para `Em Andamento`.
3. **Emissão do Handoff Padronizado no Chat:**

```markdown
---
### 🔄 [FTN DevsIA] - Protocolo de Handoff
- **De:** @EspecialistaAtual
- **Para:** @ProximoEspecialista
- **Gestão da Feature:** [ID/Link ClickUp ou "Rastreamento em Markdown"]
- **Artefato Gerado:** [Caminho do arquivo ou link do Doop Canvas]
- **Status da Fase:** Homologado & Concluído
- **Ação Requerida:** [Descrição exata da responsabilidade do próximo especialista]
---
```
4. O próximo especialista assume o chat imediatamente para dar andamento à sua fase.
