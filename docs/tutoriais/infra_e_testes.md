# 📑 Padrão de Infraestrutura e Testes - FTN DevsIA

Este documento estabelece o fluxo de publicação do ambiente de testes unificado, a arquitetura de proteção de borda contra hackers e as diretrizes para testes locais e remotos.

---

## 🌐 1. O Ambiente de Homologação em Nuvem (://dominio.com.br)

A esteira de CD (`cd-staging.yml`) publica a aplicação automaticamente no cluster **Docker Swarm** (gerenciado via **Portainer** no **Ubuntu Server**) sob o subdomínio dedicado de QA assim que a automação de CI der o sinal verde.

### 🛡️ Proteção Antihacker de Borda (Traefik Middleware)
Para evitar que o ambiente seja indexado por robôs de busca ou acessado por terceiros, o **Traefik** intercepta a conexão e aplica duas travas inegociáveis:
1. **Criptografia SSL/TLS Automática:** Tratada de forma nativa via Let's Encrypt resolver do Traefik, forçando o redirecionamento automático de HTTP para HTTPS.
2. **Basic Authentication (Porta de Vidro):** Exige um usuário e senha forte (mínimo 16 caracteres, gerado via hash `htpasswd`) antes de carregar uma única linha de código ou interface do sistema.

#### Exemplo de configuração da Stack (docker-compose.yml do Swarm):
```yaml
version: '3.8'
services:
  web-app:
    image: node:lts-alpine
    deploy:
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.ftn-qa.rule=Host(`://dominio.com.br`)"
        - "traefik.http.routers.ftn-qa.entrypoints=websecure"
        - "traefik.http.routers.ftn-qa.tls.certresolver=letsencrypt"
        - "traefik.http.routers.ftn-qa.middlewares=auth-qa"
        - "traefik.http.middlewares.auth-qa.basicauth.users=ftn_qa:\$apr1\$4fG7...criptografado"
```

### 👁️ Rotina do QA Humano no Subdomínio Isolado
Após os filtros da máquina aprovarem o código, o subdomínio de testes é atualizado. O QA deve acessar o ambiente para realizar testes que nenhuma máquina captura com precisão:
* **Bugs Visuais e de Layout:** Quebras de componentes em resoluções específicas, elementos sobrepostos ou desalinhados.
* **Experiência de Uso (UX) e Fluidez:** Comportamento de transições, desempenho do app Flutter e navegação de telas.

---

## 💻 2. Como Testar Notificações Push e PWA Localmente (Sem SSL Nativo)

Recursos como Service Workers (PWA) e Notificações Push (Firebase Cloud Messaging) exigem **HTTPS** válido e URLs públicas para receber webhooks externos.

### 🚀 Solução Padrão de Mercado: Túnel HTTP Seguro com LocalTunnel ou Ngrok
Os desenvolvedores e QAs não devem gerar certificados locais autoassinados (que geram alertas de segurança). O padrão do time é mapear a porta HTTP local para um proxy criptografado válido.

#### Passo a Passo para usar o LocalTunnel:
1. Inicialize seu projeto local em HTTP normal (ex: porta `3000`).
2. Abra o terminal paralelo e execute o comando:
   ```bash
   npx localtunnel --port 3000
   ```
3. O terminal gerará um endereço público e criptografado legítimo, como: `https://locallabs.com`.
4. **Benefícios:**
   * O link possui certificado SSL válido reconhecido pelos servidores do Firebase e navegadores.
   * Viabiliza o teste completo de notificações push e Service Workers de PWAs na máquina local ou abrindo o link diretamente no celular pelo 4G.
