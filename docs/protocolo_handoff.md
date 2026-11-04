# 🔄 Protocolo de Handoff & Governança de Agentes - FTN DevsIA

Este documento define o contrato inegociável de transição de tarefas entre os agentes especialistas do time **FTN DevsIA**, garantindo que cada membro atue estritamente dentro da sua alçada e sem interferir no trabalho dos demais.

---

## 🎯 Princípios Fundamentais de Isolamento & Governança

1. **Reunião de Kickoff & Alinhamento (`/reuniao-time-ftn`):** Antes de iniciar qualquer feature ou demanda de cliente, todos os especialistas participam da mesa redonda de alinhamento para fazer perguntas pontuais ao cliente, esclarecer ambiguidades e formalizar a spec no padrão ONP (@onovoprogramador/onp-spec).
2. **Fonte Única da Verdade (SSOT):** Nenhuma decisão de escopo, arquitetura ou identificador de teste (`qa-id`) é tomada em memória volátil de chat. Toda decisão deve ser registrada em seu respectivo arquivo na pasta `.spec/` ou `docs/`.
3. **Execução Estritamente Sequencial por Fases:** Um agente só inicia sua atuação quando o artefato de saída da fase anterior estiver formalmente gerado e homologado pelo usuário humano.
4. **Proibição de Invasão de Alçada:** Cada agente possui limites explícitos do que **NÃO PODE FAZER**. Tentativas de alterar artefatos de outro agente invalidam o ciclo.
5. **Token de Handoff Obrigatório:** Ao finalizar sua missão, o agente deve emitir o bloco padronizado de Handoff no chat, indicando o próximo especialista responsável.
6. **Cobertura Integral da Pirâmide de Testes:** Todo o ciclo deve cobrir rigorosamente todos os níveis da pirâmide de testes de software ([`docs/testes/piramide_de_testes.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/testes/piramide_de_testes.md)): Unitários (Nível 1), Componentes (Nível 2), Integração (Nível 3), Contratos de API (Nível 4) e E2E sem XPath (Nível 5).
7. **Modularidade Opcional (`ftn.config.json`):**
   * **ClickUp:** Se `clickup.enabled === true`, features, subtarefas e status são sincronizados no ClickUp ([`docs/tutoriais/integracao_clickup.md`](file:///Users/vitorfantin/.gemini/antigravity/worktrees/team-ftn-devs-ia/analise_designacao_tarefas_especificas/docs/tutoriais/integracao_clickup.md)). Se `false`, o rastreamento é 100% nativo em Markdown (`task.md` e `.spec/features/`).
   * **Doop UI/UX Canvas:** Se `doop.enabled === true`, o Doop Canvas (`http://localhost:3000`) é a ferramenta padrão de desenho de telas e Design System. Se `false`, o design é documentado diretamente em Markdown em `docs/design/design_system.md`.

---

## 📋 Matriz de Contrato de Handoff

| Fase | Agente Responsável | Artefato de Entrada | Ação de Gestão (ClickUp / Markdown) | Artefato de Saída | Próximo Agente |
| :---: | :--- | :--- | :--- | :--- | :--- |
| **0** | `@ProductManager` | Solicitação do cliente (`/reuniao-time-ftn` ou `/iniciar-time-ftn`) | Cria Feature (ClickUp ou `task.md`), anexa links da spec e quebra subtarefas técnicas ([TL], [UI/UX], [BACK], [FRONT/MOB]). | `.spec/constituicao.md`<br>`.spec/features/[feature]/spec.md` | `@TechLead` |
| **1** | `@TechLead` | `.spec/features/[feature]/spec.md` | Assume card [TL], anexa arquitetura técnica, contratos de API e metas de stress. | `.spec/arquitetura.md` | `@UIUXDesigner` & `@BackendDev` |
| **2** | `@UIUXDesigner` | `.spec/features/[feature]/spec.md`<br>`.spec/arquitetura.md` | Assume card [UI/UX]. Desenha telas (no Doop se ativo ou em Markdown), mapeia 5 estados e fallback anti-crash. | `docs/design/design_system.md`<br>Doop Canvas URL (se ativo) | `@FrontendDev` ou `@MobileDev`<br>*(Trava Rígida: Front/Mobile bloqueados até UI/UX estar pronta)* |
| **3** | `@BackendDev`<br>`@FrontendDev`<br>`@MobileDev` | Specs de Produto, Arquitetura, Design e DER | Assumem cards. Backend atualiza DER vivo (`docs/banco_de_dados/diagrama_er.md`), devs codificam TDD ≥90%, abrem PR para `develop`. | Pull Request aberto para `develop`<br>`docs/banco_de_dados/diagrama_er.md` atualizado | `@QATester` |
| **4** | `@QATester` | PR aberto + Tabela de `qa-id` da spec | 1. Registra Casos de Teste (`docs/testes/casos_de_teste/`).<br>2. Automatiza E2E sem XPath via `qa-id` e valida pirâmide de testes. | `docs/testes/casos_de_teste/[feature].md`<br>Suíte E2E automatizada e PR aprovado | `@DevOps` (se aprovado) |
| **5** | `@DevOps` | Merge aprovado em `develop` ou `staging` | Publica em Staging no Docker Swarm com Traefik (SSL + Basic Auth). | Deploy ativo em staging | `@SecOps` |
| **6** | `@SecOps` | Deploy ativo e código mesclado | Executa esteira dedicada `security-scan.yml` (nos projetos de destino), anexa relatório de auditoria e homologa para produção. | `docs/auditoria/security-report.md` | Ciclo concluído |

---

## 🏷️ Padrão Obrigatório de Emissão do Bloco de Handoff

Ao concluir sua alçada, o agente **DEVE** emitir exatamente este bloco no final de sua resposta:

```markdown
---
### 🔄 [FTN DevsIA] - Protocolo de Handoff
- **De:** @[PapelAtual]
- **Para:** @[ProximoPapel]
- **Gestão / Tarefa:** `[ID_OU_URL_DO_CLICKUP ou "Rastreamento Nativo em Markdown"]`
- **Doop Canvas:** `[URL_DO_DOOP ou "Não utilizado (Design em docs/design/)"]`
- **Artefato Gerado/Atualizado:** `caminho/do/arquivo.md`
- **Status:** Concluído e em conformidade com as regras do time
- **Ação Requerida do Próximo Agente:** [Ação objetiva de 1 a 2 linhas]
---
```

---

## 🛡️ Tabela Mestra de `qa-id` (Fonte Única da Verdade)

Para erradicar o conflito entre o código dos desenvolvedores e as automações de QA:
1. O `@ProductManager` e o `@UIUXDesigner` definem na spec da feature a tabela com todos os elementos interativos:
   ```markdown
   | Elemento | Tipo | qa-id Obrigatório | Comportamento Esperado |
   | :--- | :--- | :--- | :--- |
   | Botão Entrar | Button | `qa-id="btn-login-submit"` | Dispara autenticação |
   | Campo E-mail | Input | `qa-id="input-login-email"` | Recebe e-mail do usuário |
   | Mensagem Erro | Alert | `qa-id="alert-login-error"` | Exibe mensagem de credenciais inválidas |
   ```
2. O `@FrontendDev` e o `@MobileDev` são **proibidos** de alterar esses identificadores.
3. O `@QATester` é **proibido** de buscar elementos por XPath ou classes CSS, programando seus testes consumindo estritamente os `qa-id` desta tabela.

---

## 📝 Regra Obrigatória para QA: Casos de Teste Antes da Automação

O `@QATester` deve seguir rigorosamente a sequência de 2 etapas na Fase 4:
1. **Etapa 4.1 (Planejamento & Estruturação):** Criar e salvar `docs/testes/casos_de_teste/[feature].md` cobrindo cenários positivos (caminho feliz), negativos (caminho triste/validações) e anti-crash (`qa-id="btn-error-retry"`), rastreados pelos `qa-id`s da spec.
2. **Etapa 4.2 (Codificação da Automação):** Apenas após documentar os casos de teste, codificar os scripts de automação E2E (Playwright, Cypress, Flutter Integration), implementando fielmente cada caso planejado.
