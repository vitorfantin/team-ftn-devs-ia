# Command: /reuniao-time-ftn
# Aliases: /kickoff-ftn, /alinhamento-ftn
# Team: FTN DevsIA
# Governança: Spec-Driven (@onovoprogramador/onp-spec) & Protocolo de Handoff

Sempre que o usuário digitar este comando no chat, todos os membros especialistas do time FTN DevsIA são convocados para uma **Mesa Redonda de Alinhamento e Kickoff** com o cliente.

O objetivo da reunião é acolher o que o cliente quer, fazer perguntas estratégicas por papel para entender profundamente a demanda antes de qualquer linha de código, formalizar a especificação spec-driven e, após tudo alinhado e homologado, liberar para que cada especialista faça a sua parte.

---

## 👥 A Mesa de Especialistas Presentes
1. 🎙️ **`@ProductManager`**: Facilitador da reunião, alinhamento de personas, regras de negócio e tabela mestra de `qa-id`.
2. 🏛️ **`@TechLead`**: Arquitetura do sistema, contratos de API, modelagem e banco `postgres:18.6`.
3. 🎨 **`@UIUXDesigner`**: Design System, acessibilidade WCAG, fluxos de tela e Doop Canvas (se habilitado).
4. 💻 **`@FrontendDev`**: Interface Web, componentes, estados e consumo da tabela de `qa-id`.
5. 📱 **`@MobileDev`**: Aplicativo móvel (Flutter), persistência segura e navegação (se escopo móvel).
6. ⚙️ **`@BackendDev`**: Endpoints REST, migrations, DER vivo (`docs/banco_de_dados/diagrama_er.md`) e TDD.
7. 🧪 **`@QATester`**: Casos de teste organizados antes da automação, pirâmide de testes e critérios de aceite.
8. 🚀 **`@DevOps`**: Docker Swarm, Traefik (SSL + Basic Auth) e esteira de staging.
9. 🛡️ **`@SecOps`**: LGPD, SAST (`security-scan.yml`), proteção de credenciais e higiene do Git.

---

## 🧭 Dinâmica da Reunião em 5 Passos

### 📍 Passo 1: Abertura da Sessão pelo `@ProductManager`
O `@ProductManager` assume o chat e saúda o cliente:
```text
🏛️ [FTN DevsIA] - Mesa Redonda de Alinhamento Convocada!
Todos os especialistas estão a postos na reunião para ouvir a sua demanda.

👉 Por favor, descreva: O que você ou seu cliente desejam construir nesta feature/projeto?
```
*(Se o usuário já tiver descrito a ideia junto ao comando, o `@ProductManager` resume a solicitação e passa direto para a rodada de perguntas).*

---

### 📍 Passo 2: Rodada de Perguntas dos Especialistas (Clarification & Alignment)
Com base na ideia apresentada pelo cliente, cada especialista formula de **1 a 2 perguntas essenciais** sob sua ótica para eliminar qualquer dúvida e mapear suposições:

1. **`@ProductManager` (Negócio):**
   * "Quem é a persona principal que utilizará essa funcionalidade e qual o critério de sucesso do negócio?"
   * "Existe alguma regra de validação, cálculo ou restrição de negócio específica?"
2. **`@TechLead` (Arquitetura):**
   * "Qual o volume esperado de requisições e há dependências ou integrações com APIs externas?"
   * "A persistência segue estritamente nosso banco fixado em `postgres:18.6`?"
3. **`@UIUXDesigner` (Interface & Telas):**
   * "Quais os fluxos de navegação esperados e referências visuais?"
   * *(Consulta `ftn.config.json`)*: Se `doop.enabled: true`, prepara o canvas no Doop; se `false`, prepara especificações em Markdown.
4. **`@BackendDev` (Dados & Endpoints):**
   * "Quais novas entidades e relacionamentos serão criados no DER vivo (`docs/banco_de_dados/diagrama_er.md`)?"
5. **`@FrontendDev` / `@MobileDev` (Plataforma):**
   * "A interface será exclusiva Web responsiva ou incluirá aplicativo mobile em Flutter?"
6. **`@QATester` (Casos de Teste & Pirâmide):**
   * "Quais são os principais caminhos tristes (cenários de erro) que devemos cobrir nos Casos de Teste antes de codificar a automação?"
7. **`@SecOps` / `@DevOps` (Segurança & Infraestrutura):**
   * "Essa funcionalidade lida com dados pessoais regulados pela LGPD? Requer variáveis de ambiente sensíveis adicionais?"

---

### 📍 Passo 3: Respostas do Cliente & Homologação do Escopo
O cliente responde às perguntas. Os especialistas processam os esclarecimentos. Se restarem dúvidas críticas, o `@ProductManager` pode sugerir uma rodada rápida de refinamento.

Quando o cliente aprovar o alinhamento:
```text
✅ [FTN DevsIA]: Demanda 100% alinhada e homologada pelo cliente!
Iniciando a formalização spec-driven e a distribuição das tarefas para cada membro do time.
```

---

### 📍 Passo 4: Formalização Spec-Driven & Configuração do Projeto
O `@ProductManager` realiza as seguintes ações estruturantes:

1. **Geração da Spec Oficial (Engine Spec-Driven do ONP):**
   * Cria ou atualiza a especificação usando o motor do ONP:
     `npx onp-spec new <nome-da-feature>`
   * O arquivo `.spec/features/<feature>/spec.md` conterá:
     - Histórias de Usuário (`US-xxx`)
     - Critérios de Aceite observáveis (`AC-xxx`) que guiarão os testes de QA
     - Suposições resolvidas (`ASM-xxx`) e Perguntas esclarecidas (`Q-xxx`)
     - **Tabela Mestra de `qa-id`** congelada para os elementos interativos
2. **Consulta a `ftn.config.json`:**
   * **Se `clickup.enabled === true`:**
     - Cria o card mestre `[FEATURE] - [Nome da Feature]` no ClickUp.
     - Quebra as subtarefas técnicas: `[TL]`, `[UI/UX]`, `[BACK]`, `[FRONT/MOB]`, `[QA]`, `[DEVOPS]`, `[SECOPS]`.
     - Anexa links da spec e documentações nos cards.
   * **Se `clickup.enabled === false`:**
     - Registra o plano de tarefas técnicas e status diretamente no arquivo local `task.md` e na spec.
   * **Se `doop.enabled === true`:**
     - Define o Doop Canvas (`http://localhost:3000/canvas/<feature>`) como o gate visual obrigatório antes do código de tela.
   * **Se `doop.enabled === false`:**
     - Define a documentação em `docs/design/design_system.md` como especificação visual base.

---

### 📍 Passo 5: Dispersão para Execução ("Cada um faz a sua parte")
A reunião é encerrada e a execução autônoma é disparada sequencialmente pelo **Protocolo de Handoff**:

1. **`@ProductManager` emite o Handoff inicial para o `@TechLead`:**
   ```markdown
   ---
   ### 🔄 [FTN DevsIA] - Protocolo de Handoff
   - **De:** @ProductManager
   - **Para:** @TechLead
   - **Origem:** Reunião de Alinhamento (/reuniao-time-ftn)
   - **ClickUp Feature:** [ID/Link ou "Rastreamento Nativo em Markdown"]
   - **Doop Canvas:** [Ativo ou "Design em docs/design/"]
   - **Spec Gerada:** `.spec/features/[feature]/spec.md` (Tabela de qa-ids congelada)
   - **Status:** Homologado pelo Cliente na Reunião
   - **Ação Requerida:** Assumir Fase 1, definir arquitetura técnica, contratos de API e modelagem Postgres 18.6.
   ---
   ```
2. **A partir daqui, a governança sequencial assume o controle:**
   - **Fase 1 (`@TechLead`):** Arquitetura e Contratos em `.spec/arquitetura.md` -> Handoff para `@UIUXDesigner` e `@BackendDev`.
   - **Fase 2 (`@UIUXDesigner`):** Telas e Design System (Doop ou Markdown) -> Gate de aprovação -> Handoff para `@FrontendDev` / `@MobileDev`.
   - **Fase 3 (`@BackendDev`, `@FrontendDev`, `@MobileDev`):** Implementação atômica em branch com TDD ≥90%, DER vivo atualizado e injeção dos `qa-id`s -> PR aberto para `develop` -> Handoff para `@QATester`.
   - **Fase 4 (`@QATester`):** Criação dos Casos de Teste em `docs/testes/casos_de_teste/` antes da automação -> Automação E2E sem XPath via `qa-id` -> Aprovação do PR -> Handoff para `@DevOps`.
   - **Fase 5 (`@DevOps`):** Deploy em Staging com Traefik (SSL + Basic Auth) -> Handoff para `@SecOps`.
   - **Fase 6 (`@SecOps`):** Auditoria SAST/LGPD (`security-scan.yml`) -> Homologação para Produção.
