# 🎨 FTN DevsIA - Design System & Tokens de Interface

Este arquivo é de alçada exclusiva do **`@UIUXDesigner`**. Contém os tokens visuais, especificações de componentes reutilizáveis, acessibilidade WCAG e telas críticas de erro.

---

## 🌈 1. Tokens Globais

### Cores Principais
* **Primary:** `#1E40AF` (Azul Institucional)
* **Secondary:** `#0EA5E9` (Azul Acento)
* **Background:** `#0F172A` (Dark) / `#F8FAFC` (Light)
* **Surface:** `#1E293B` (Dark) / `#FFFFFF` (Light)
* **Text Primary:** `#F8FAFC` (Dark) / `#0F172A` (Light)
* **Error / Destructive:** `#EF4444` (Vermelho Alerta)
* **Success:** `#10B981` (Verde Sucesso)

### Tipografia & Espaçamentos
* **Fonte Primária:** Inter, Roboto ou System Default
* **Grid Base:** Múltiplos de 4px / 8px (4, 8, 16, 24, 32, 48, 64)
* **Área Mínima de Toque (WCAG):** 48x48px em qualquer botão ou elemento interativo

---

## 🔄 2. Estados Obrigatórios de Tela
Todas as telas projetadas devem contemplar:
1. **Inicial:** Interface limpa antes da interação.
2. **Carregando (Loading/Skeleton):** Feedback visual assíncrono.
3. **Sucesso:** Apresentação clara dos dados processados.
4. **Vazio (Empty State):** Mensagem ilustrativa quando não há registros cadastrados.
5. **Erro:** Tratamento amigável para falhas de validação de formulário ou rede.

---

## 🚨 3. Tela de Fallback de Erro Crítico (Anti-Crash)
Quando a aplicação captura uma falha inesperada via *Error Boundary* ou tratamento global, esta tela deve ser renderizada:

* **Título:** Mensagem amigável no idioma do projeto (ex: *"Algo inesperado aconteceu"*).
* **Descrição:** Explicação leiga sem expor detalhes técnicos ou stack traces.
* **Ação de Recuperação (Obrigatório):** Botão com o atributo **`qa-id="btn-error-retry"`** para reiniciar o estado ou voltar à tela anterior com segurança.
