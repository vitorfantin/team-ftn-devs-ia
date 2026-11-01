# EM TESTE PROJETO PARTICULAR, LIBERADO PARA TODOS USAREM E ACEITO FEEDBACKS DE MELHORIAS.


# 🚀 FTN DevsIA - Ecossistema de Governança e Automação Sênior - 

## 🎯 Objetivo do Projeto
O objetivo principal deste ecossistema é padronizar e blindar o ciclo de desenvolvimento de software do time **FTN DevsIA** (tanto para plataformas Web quanto para aplicativos em Flutter), operando com o nível de maturidade de grandes empresas de tecnologia do mercado. 

Este ecossistema garante de forma intransponível:
* **Isolamento de Papéis:** 8 agentes de IA especialistas que atuam estritamente em suas funções de alçada.
* **Qualidade e Estabilidade:** Travas mecânicas no Pull Request exigindo TDD com no mínimo 90% de cobertura geral e comentários de código de até 2 linhas.
* **Automação de QA Inquebrável:** Proibição absoluta de caminhos XPath, forçando a seleção puramente por atributos `qa-id` / `data-qa` em cenários bons e ruins.
* **Ambiente de Testes Isolado:** Infraestrutura modular em micro-serviços (GitHub Actions) com deploy automático em subdomínio dedicado (`://dominio.com.br`) gerenciado via Docker Swarm, Portainer e Traefik no Ubuntu Server.
* **Segurança Ativa (DevSecOps):** Blindagem de borda contra ataques de hackers via Basic Auth no Traefik, auditoria SAST contra vazamento de segredos (Zero-Secret Leak) e `.gitignore` higienizado.

---

## 🛠️ Guia de Instalação Rápida

A instalação é controlada de forma interativa por um script assistente na raiz, projetado para prevenir conflitos em códigos existentes.

### 1. Preparação Local (Na raiz do seu projeto)
Execute o comando de instalação de uma linha (substituindo pelo seu usuário do GitHub):
```bash
curl -fsSL https://githubusercontent.com | bash
```

### 2. Fluxo do Assistente Interativo
* **Varredura Preventiva:** Se o projeto for em andamento (Brownfield / Legado), o script alertará sobre pastas existentes e pedirá sua confirmação (`s/n`) para continuar com cautela.
* **Seleção do Agente de IA:** Digite a opção correspondente ao editor de inteligência artificial que você irá trabalhar: `1 - Antigravity`, `2 - Cursor`, `3 - Codex` ou `4 - Claude Code`.

### 3. Ativação no Chat da IA
Abra o seu editor configurado, acesse o chat da IA e digite o comando mestre:
```text
/iniciar-time-ftn
```
O agente `@ProductManager` assumirá o controle imediato do chat disparando a **Fase Zero de Alinhamento** para travar o escopo e o idioma do repositório antes de liberar as tarefas técnicas.

---

## 🤝 Créditos e Reconhecimento (Engine Base)

Este projeto utiliza como motor e pilar mecânico de orquestração paralela o framework **onp-spec-driven** desenvolvido pelo canal **O Novo Programador**. 

A abordagem de desenvolvimento baseado em especificações (*Spec-Driven Development*) aplicada nas automações do time FTN DevsIA é uma extensão direta das soluções inovadoras de engenharia de prompts e controle de branches por *worktrees* criadas por ele.

* **Repositório Base Original:** [onovoprogramador/onp-spec-driven](https://github.com/onovoprogramador/onp-spec-driven)
* **Canal Oficial:** [O Novo Programador](https://www.youtube.com/@ONovoProgramador)

*Agradecimentos ao criador por disponibilizar a engine open-source que possibilita a evolução de times autônomos de IA.*



```
raiz-do-seu-projeto/
├── .agent/
│   └── skills/                         # 👥 As Mentes Especialistas do Time FTN
│       ├── iniciar_time_ftn.md         # O arquivo mestre que habilita o comando /iniciar-time-ftn
│       ├── 1_ProductManager.md         # Prompts de Concepção, Fase Zero, Idioma e Escopo
│       ├── 2_TechLead.md               # Prompts de Arquitetura, Postgres 18.6, Pirâmide de testes e SOLID
│       ├── 3_UIUXDesigner.md           # Prompts de Design System, WCAG e Fallbacks de Erro Crítico
│       ├── 4a_FrontendDev.md           # Prompts de Desenvolvimento Web, TDD 90% e qa-ids
│       ├── 4b_MobileDev.md             # Prompts de Desenvolvimento Flutter de Alta Performance e Secure Storage
│       ├── 5_BackendDev.md             # Prompts de APIs seguras, OWASP Top 10 e Migrations
│       ├── 6_QATester.md               # Prompts de Automações de testes (Bons/Ruins) sem XPath
│       ├── 7_DevOps.md                 # Prompts de Docker Swarm, Traefik, Basic Auth e CI/CD Modular
│       └── 8_SecOps.md                 # Prompts de Auditoria SAST, .gitignore e Zero-Secret Leak
│
├── .github/
│   └── workflows/                      # ⚙️ Esteiras Modulares Independentes (Estilo Micro-serviços)
│       ├── ci-staging.yml              # O Filtro Rígido: valida cobertura e qa-id antes do merge
│       ├── cd-staging.yml              # O Deploy: Atualiza o subdomínio ://dominio.com.br pós-merge
│       └── cd-production.yml           # O Deploy Final: Publica em produção com tag de rollback imediato
│
├── docs/                               # 📂 Central de Conhecimento Totalmente Despoluída
│   ├── documentacao_projeto/           # Pasta destinada a especificações de negócio homologadas
│   └── tutoriais/
│       └── infra_e_testes.md           # Bíblia técnica de túneis locais com SSL (Ngrok) e Swarm
│
├── .spec/                              # 📝 Pasta criada pelo framework do O Novo Programador
│   ├── features/                       # Pasta onde as especificações técnicas atômicas serão criadas
│   └── constituicao.md                 # As regras inegociáveis de engenharia interpretadas pela IA
│
├── .gitignore                          # Ignore padrão do time contra vazamentos e lixo de IAs
├── install-ftn.sh                      # O script auxiliar que realizou a instalação
└── README.md                           # O manual geral do repositório
```
