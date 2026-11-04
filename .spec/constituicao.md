# 📜 Constituição de Engenharia - FTN DevsIA

Este documento estabelece as regras de ouro, padrões técnicos inegociáveis e limites de governança aplicados a todos os agentes e desenvolvedores do projeto, auditados mecanicamente pelo motor do Spec-Driven (@onovoprogramador/onp-spec).

---

## P-001 [DEVE] Todo requisito tem prova executável e teste anotado (@spec:AC-xxx)
- verificação(gate): intrínseca ao audit
Cada critério de aceite (`AC-xxx`) deve possuir um teste automatizado anotado no título com `@spec:AC-xxx` e passar no verify. Teste pulado (skip/todo) não é prova.

## P-002 [DEVE] Proibido uso de seletores XPath em automações de testes (Zero XPath)
- verificação(proibido): `(xpath|//[a-zA-Z]|xpath=)` em `tests/**/*`
Automações de testes (E2E e Integração) devem mapear elementos exclusivamente através de `qa-id` ou `data-qa`. O uso de XPath ou classes CSS voláteis é terminantemente proibido.

## P-003 [DEVE] Banco de dados fixado estritamente em postgres:18.6
- verificação(proibido): `postgres:latest` em `docker/**/*.yml`
O banco de dados do projeto é fixado estritamente na versão `postgres:18.6`. É proibido o uso da tag `latest`. Modificações de schema devem ocorrer 100% via migrations com atualização do DER vivo.

## P-004 [DEVE] Zero-Secret Leak - Nenhuma credencial ou token exposto em código
- verificação(proibido): `(password\s*=\s*['\"][^'\"]{4,}|api_key\s*=\s*['\"][^'\"]{4,})` em `src/**/*.{js,ts,dart}`
Credenciais, tokens e senhas reais nunca devem ser commitados no repositório. Use variáveis de ambiente (`.env`) ou GitHub Actions Secrets.

## P-005 [DEVE] Fallback anti-crash obrigatório na interface
- verificação(teste): @principle:P-005
Toda interface de usuário deve possuir uma tela ou estado de erro crítico com o botão de recuperação contendo o atributo `qa-id="btn-error-retry"`.

## P-006 [RECOMENDADO] Cobertura geral de testes TDD mínima de 90%
Todo código de produção deve ser precedido ou acompanhado por testes unitários e de integração com cobertura mínima de 90%.

## P-007 [RECOMENDADO] Comentários no topo de funções limitados a no máximo 2 linhas
Cada função, método ou componente-chave deve ter no topo um comentário de no máximo duas linhas explicando o que faz e onde está interligado.

## P-008 [DEVE] Portão Humano obrigatório antes de qualquer merge em develop ou staging
- verificação(gate): intrínseca ao audit
É terminantemente proibido realizar merge automático. Quando a esteira de CI estiver 100% verde, o time de IA deve emitir notificação formal no chat com o link do PR para autorização expressa do usuário humano ("Aprovo o Merge").
