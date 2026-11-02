# 📜 Constituição de Engenharia - FTN DevsIA

Este documento estabelece as regras de ouro, padrões técnicos inegociáveis e limites de governança aplicados a todos os agentes e desenvolvedores do projeto.

---

## 🏛️ 1. Princípios Inegociáveis

1. **Isolamento Estrito de Papéis:** Cada especialista atua estritamente em sua fase e respeita o [Protocolo de Handoff](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/protocolo_handoff.md).
2. **Desenvolvimento Guiado por Testes (TDD):** Todo código de produção deve ser precedido por testes unitários e de integração, com meta mandatória de cobertura geral de no mínimo **90%**.
3. **Regra de Comentários de 2 Linhas:** Cada função, método ou componente-chave deve ter no topo um comentário de no máximo duas linhas explicando objetivamente:
   - O que a função faz e o que ela é;
   - Onde ela está interligada.
4. **Governança de Automação de QA (Zero XPath):**
   - É terminantemente proibido o uso de seletores XPath em automações de testes.
   - Todo elemento interativo deve possuir atributo `qa-id` ou `data-qa` previamente mapeado na especificação da feature.
5. **Estabilidade de Banco de Dados:**
   - O banco de dados padrão é fixado estritamente em `postgres:18.6`.
   - É proibido o uso da tag `latest` para banco de dados.
   - Modificações de schema devem ocorrer 100% via migrations.
6. **Segurança Ativa e Higiene (Zero-Secret Leak):**
   - Nenhuma credencial real de produção pode ser informada no chat ou commitada no Git.
   - Ambientes de staging são protegidos por Traefik com SSL e Basic Auth.
   - Branches de trabalho são sempre atômicas (`feature/nome-da-tarefa`) com PR direcionado exclusivamente para a branch `develop`.
