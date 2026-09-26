---
marp: true
theme: mvpconf
paginate: true
size: 16:9
footer: "MVPConf 2026 · Azure Front Door"
---

<!-- _class: lead -->

# Azure Front Door

## Sua aplicação conquistando o mundo

---

<style scoped>
section {
  font-size: 24px;
}
h1 {
  margin-bottom: 0;
}
h1, p, ul {
  max-width: 540px;
}
img[alt="Microsoft MVP"] {
  position: absolute;
  top: 25px;
  right: 85px;
  width: 200px;
}
img[alt="Certificações"] {
  position: absolute;
  top: 151px;
  right: 75px;
  width: 220px;
}
img[alt="QR code"] {
  position: absolute;
  top: 343px;
  right: 115px;
  width: 140px;
}
h6 {
  position: absolute;
  top: 487px;
  right: 70px;
  width: 230px;
  margin: 0;
  font-size: 20px;
  text-align: center;
  color: inherit;
}
img[alt="Expertos Tech"] {
  position: absolute;
  top: 557px;
  right: 65px;
  width: 240px;
}
section[data-marpit-advanced-background="background"] figure {
  margin-left: 20px;
}
</style>

![bg left:25% fit](assets/rodrigo-tavares.png)

# Rodrigo Tavares

Head de Soluções e Transformação na Develcode
MVP Microsoft · 25 anos de carreira

**Algumas habilidades**

- Java, Angular, React, Node.js, .NET, Go, Python
- IA, SRE, Cloud, DevOps
- Linux SysAdmin, Kubernetes
- Data Science
- Computer Telephony Integration
- Arquitetura TI E2E

###### linktr.ee/expertostech

![Microsoft MVP](assets/apresentacao-mvp.png)
![Certificações](assets/apresentacao-certificacoes.png)
![QR code](assets/apresentacao-qrcode.png)
![Expertos Tech](assets/apresentacao-youtube.png)

---

<style scoped>
ul {
  columns: 2;
  column-gap: 50px;
  font-size: 21px;
}
li {
  break-inside: avoid;
  margin-bottom: 8px;
}
</style>

# Antes de começar, um breve dicionário

- **AFD:** Azure Front Door
- **CDN:** Content Delivery Network, entrega conteúdo a partir de cache perto do usuário
- **DNS:** Domain Name System, traduz nomes como `www.site.com` em endereços IP
- **TLD:** Top-Level Domain, o final do domínio (`.com`, `.br`)
- **PoP:** Point of Presence, ponto da rede de borda onde o usuário se conecta
- **WAF:** Web Application Firewall, bloqueia ataques contra a aplicação web
- **HTTP/HTTPS:** protocolo da web; o HTTPS é a versão criptografada
- **TCP:** protocolo que abre a conexão entre cliente e servidor
- **TLS:** criptografia usada pelo HTTPS
- **XSS:** Cross-Site Scripting, injeção de script malicioso na página
- **SQL injection:** comandos SQL maliciosos enviados pelos campos da aplicação
- **Origem / origin group:** sua aplicação e o grupo de instâncias dela atrás do Front Door
- **Health probe:** verificação periódica que diz se uma origem está saudável
- **Rules engine:** regras que alteram a requisição ou a resposta na borda

---

# Seu usuário está longe demais

- **Sua aplicação ficou global**
  - Usuários em vários países e continentes
  - Toda requisição atravessa o mundo até uma única região
  - Quem está longe sofre com latência alta
- **A CDN resolve só uma parte**
  - Acelera o conteúdo estático: imagens, CSS e JS
  - O conteúdo dinâmico (APIs, login, carrinho) continua indo até a origem

---

# Mais regiões, mais problemas

- **Várias instâncias em várias regiões**
  - A latência cai e a aplicação ganha redundância
  - Mas como levar cada usuário para a região certa?
  - E o que acontece quando uma região cai?
  - Certificados, WAF e regras de cache ficam duplicados em cada região

---

# Não é só a distância

- **Resolução DNS**
  - Resolver → raiz → TLD → servidor autoritativo (quando não está em cache)
- **Saltos de rede na internet pública**
  - Provedores, roteadores e pontos de troca até chegar na sua instância
  - Cada salto soma latência e pode congestionar ou perder pacotes
- **Handshake TCP + TLS**
  - Só abrir a conexão já custa de 3 a 5 idas e voltas; o TLS soma mais

---

# Mudar sem derrubar

- **Deploy de sexta-feira**
  - A versão nova vai para 100% dos usuários de uma vez
  - Bug em produção e rollback demorado
- **Migração para a nuvem**
  - Parte da aplicação ainda roda on-premises
  - Virar a chave de uma vez é arriscado
- **Sessão perdida**
  - A requisição cai em outra instância e o carrinho some

---

# Sua aplicação é um alvo

- **Enxurrada de requisições**
  - Ataque e tráfego legítimo chegam misturados até a origem
- **Ataques na aplicação**
  - SQL injection e XSS no login e nas APIs
- **Bots**
  - Raspagem de preços e teste de senhas vazadas
- **Porta dos fundos**
  - Acessam a origem direto e pulam a proteção

---

# O dia a dia da operação

- **O certificado venceu**
  - A renovação manual foi esquecida e o navegador alerta "não seguro"
- **Rotas e URLs**
  - Site, /api e /blog rodam em serviços diferentes
  - Os links antigos quebram depois de uma migração
- **Cache desatualizado**
  - A correção foi publicada, mas o usuário ainda vê a versão antiga
- **Sem visibilidade**
  - Erros, latência e bloqueios ficam espalhados em logs por região

---

<!-- _class: lead -->

# Te apresento o Azure Front Door

---

# O que é o Azure Front Door?

- **O que é**
  - Porta de entrada global para aplicações HTTP/HTTPS
  - CDN moderna da Microsoft, para conteúdo estático e dinâmico
- **Pra que serve**
  - Acelerar, proteger e manter a aplicação disponível no mundo todo
- **Como funciona**
  - O usuário conecta no PoP mais adequado da rede de borda da Microsoft
  - WAF → rota → rules engine → cache → origem saudável

---

# Do PoP até a sua aplicação

- Do PoP em diante, o tráfego segue pela rede global da Microsoft, sem passar pela internet pública (origem no Azure)
- Menos saltos e menos intermediários, em rotas otimizadas
- O DNS continua existindo, mas já aponta para o PoP ideal

---

<style scoped>
table {
  font-size: 22px;
  width: 100%;
}
</style>

# Front Door, Application Gateway ou Traffic Manager?

| Serviço | Escopo | Como atua | Use quando |
|---|---|---|---|
| **Front Door** | Global | Proxy L7 na borda: cache, WAF, TLS, roteamento | App web pública com usuários em várias regiões |
| **Application Gateway** | Regional | Proxy L7 dentro da região (e L4 TCP/TLS), com WAF | Balancear e proteger dentro de uma região ou VNet |
| **Traffic Manager** | Global | Só DNS: responde qual endpoint usar, não vê o tráfego | Qualquer protocolo; failover mais lento (cache de DNS) |

Podem ser combinados: Front Door na frente, Application Gateway dentro da região.

---

<style scoped>
table {
  font-size: 22px;
  width: 100%;
}
</style>

# Standard × Premium: recursos (1/2)

| Recurso | Standard | Premium |
|---|---|---|
| Conteúdo estático e dinâmico, cache e compressão | ✓ | ✓ |
| Domínios personalizados e certificado gerenciado | ✓ | ✓ |
| Rules engine e roteamento (latency, priority, weighted) | ✓ | ✓ |
| Proteção DDoS L3-4 | ✓ | ✓ |
| WAF: regras customizadas (IP, país, rate limiting) | ✓ | ✓ |

---

<style scoped>
table {
  font-size: 22px;
  width: 100%;
}
</style>

# Standard × Premium: recursos (2/2)

| Recurso | Standard | Premium |
|---|---|---|
| WAF: rule set gerenciado (SQL injection, XSS...) | ✗ | ✓ |
| Proteção contra bots | ✗ | ✓ |
| Private Link até a origem | ✗ | ✓ |
| Relatórios prontos | ✓ | ✓ + relatório do WAF |
| Mudar de plano | Upgrade para Premium | Voltar ao Standard só recriando o perfil |

---

<style scoped>
table {
  font-size: 22px;
  width: 100%;
}
p {
  font-size: 18px;
}
</style>

# Standard × Premium: custos

| Item | Standard | Premium |
|---|---|---|
| Taxa fixa mensal | US$ 35 | US$ 330 |
| Requisições (por 10 mil) | Varia por zona | Varia por zona, mais caro que o Standard |
| Tráfego da borda para o usuário (por GB) | Varia por zona | Igual ao Standard |
| Tráfego de origem no Azure para a borda | Grátis | Grátis |
| Regras do WAF | Customizadas grátis | Customizadas e gerenciadas grátis |
| Private Link | Não disponível | Incluso |
| Até 100 domínios personalizados | Grátis | Grátis |

*Preços em USD, referência Central US, verificados em set/2026*
*Front Door (classic): sem perfis novos desde 31/03/2025; será desligado em 31/03/2027*

---

# Cache e compressão

- Cache na borda: o conteúdo fica no PoP, perto do usuário
- Chave de cache configurável: ignorar, usar ou filtrar query strings
- TTL definido pela origem ou sobrescrito por regra (até 366 dias)
- Compressão gzip e Brotli na borda
- Purge sob demanda: força buscar de novo na origem (propaga em até 10 min)

---

# Domínios e certificados

- Domínio próprio no lugar do `*.azurefd.net`
- Validação por registro TXT (`_dnsauth`) + CNAME para o endpoint
- Certificado gerenciado grátis, com renovação automática
- Ou certificado próprio (BYOC) guardado no Key Vault
- TLS 1.2 e 1.3

---

# Roteamento e origin groups

- Origin group: as instâncias da aplicação, em qualquer região ou fora do Azure
- Health probes tiram de circulação a origem que falha
- **Latency** (padrão): a origem mais rápida a partir daquele PoP
- **Priority** (1 a 5): ativo/passivo
- **Weighted** (1 a 1000): canary e migração gradual
- **Session affinity**: o mesmo usuário vai para a mesma origem (cookie)

---

# Rules engine

- Regra = até 10 condições + até 5 ações, com regex e server variables
- Redirect (301, 302, 307, 308) e rewrite de URL
- Adicionar, alterar ou remover headers (HSTS, CSP, esconder `X-Powered-By`)
- Trocar origin group ou configuração de cache por regra
- Roda depois do WAF

---

# Proteção DDoS

- Proteção L3-4 da plataforma incluída, sem configuração
- Ataques na camada 7 (HTTP): WAF com rate limiting
- Para cargas web, a Microsoft recomenda combinar com WAF

---

# WAF: regras customizadas

- Bloquear ou liberar por IP ou faixa de IPs (IPv4 e IPv6)
- Filtrar por país (geo-filtering)
- Condições em query string, headers, corpo, método e tamanho da requisição
- Rate limiting: limite de requisições por IP por minuto
- Modo Detection (só registra) ou Prevention (bloqueia)

---

# WAF: rule set gerenciado [Premium-only]

- Regras mantidas e atualizadas pela Microsoft
- SQL injection, XSS, execução remota de comandos, inclusão de arquivos, PHP e Java
- As regras customizadas rodam antes das gerenciadas
- Anomaly score (DRS 2.0 ou superior): cada regra acionada soma pontos à requisição

---

# Proteção contra bots [Premium-only]

- Classifica os bots em Bad, Good e Unknown
- Padrão: bloqueia Bad, libera Good (Googlebot, Bingbot) e registra Unknown
- Assinaturas atualizadas com o Microsoft Threat Intelligence
- Ações: bloquear, liberar, registrar, redirecionar ou desafio JavaScript

---

# Private Link até a origem [Premium-only]

- A origem fica sem acesso público
- O Front Door cria um private endpoint, e você aprova a conexão na origem
- Origens suportadas: App Service, Functions, Storage, Container Apps, API Management, Application Gateway, load balancer interno (AKS)
- Não funciona com slots do App Service nem com Static Web Apps
- Disponível em Brazil South

---

# Relatórios e logs

- Relatórios prontos no portal
- Relatório do WAF [Premium-only]
- Métricas em tempo real no Azure Monitor, com alertas
- Logs de acesso, de WAF e de health probes

---

# Observabilidade de ponta a ponta

- **Azure Monitor:** observabilidade de todos os recursos do Azure
  - Métricas do Front Door coletadas automaticamente
  - Logs de acesso, WAF e health probe: ativar via diagnostic settings → Log Analytics
- **Application Insights:** APM da sua aplicação (recurso do Azure Monitor)
  - Instrumentação com OpenTelemetry ou automática em alguns serviços
- **Juntando os dois:** o header `X-Azure-Ref` liga a requisição no Front Door à requisição na aplicação

---

<!-- _class: lead -->

# Talk is cheap. Show me the code.

---

<!-- _class: lead -->

<style scoped>
.repo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 70px;
  margin-top: 30px;
}
.repo img {
  background: #ffffff;
  border-radius: 12px;
}
.repo-mark {
  width: 160px;
  padding: 16px;
}
.repo-qr {
  width: 260px;
  padding: 10px;
}
.repo-link {
  font-size: 30px;
  margin-top: 30px;
}
</style>

# Todo o material está no GitHub

<div class="repo">
  <img class="repo-mark" src="assets/github-mark.svg" alt="GitHub">
  <img class="repo-qr" src="assets/github-qrcode.svg" alt="QR code do repositório">
</div>

<p class="repo-link">github.com/expertos-tech/mvpconf-2026</p>

---

<!-- _class: lead -->

# Obrigado!

Vimos às 14h: **Azure quase de graça** 💸

---

<!-- _class: lead -->

# Apêndice

---

<style scoped>
ul {
  font-size: 26px;
}
</style>

# Comece de graça no Azure

- **US$ 200 de crédito** (convertidos para a moeda da sua cobrança) para usar em 30 dias
- **Mais de 20 serviços gratuitos por 12 meses**, em quantidades mensais limitadas (só para clientes novos)
- **Mais de 65 serviços sempre gratuitos**, também dentro de limites mensais
- **Cartão de crédito ou débito:** usado para verificar sua identidade
  - Pode haver uma autorização temporária de US$ 1, estornada depois
  - Não há cobrança, a menos que você faça upgrade para pagamento conforme o uso
- **Acabou o crédito ou passaram os 30 dias?** Os serviços são desativados até você fazer o upgrade
- *Detalhes e armadilhas de custo: vimos às 14h, na palestra "Azure quase de graça"*

---

<style scoped>
table {
  font-size: 20px;
  width: 100%;
}
</style>

# Referências

| Slide | Fonte |
|---|---|
| Não é só a distância | [Traffic acceleration](https://learn.microsoft.com/azure/frontdoor/front-door-traffic-acceleration) |
| O que é o Azure Front Door? | [Overview](https://learn.microsoft.com/azure/frontdoor/front-door-overview), [Routing architecture](https://learn.microsoft.com/azure/frontdoor/front-door-routing-architecture) |
| Do PoP até a sua aplicação | [Microsoft global network](https://learn.microsoft.com/azure/networking/microsoft-global-network), [Overview](https://learn.microsoft.com/azure/frontdoor/front-door-overview) |
| Front Door, Application Gateway ou Traffic Manager? | [Load balancing options](https://learn.microsoft.com/azure/architecture/guide/technology-choices/load-balancing-overview) |
| Standard × Premium: recursos | [Tier comparison](https://learn.microsoft.com/azure/frontdoor/front-door-cdn-comparison), [WAF no Front Door](https://learn.microsoft.com/azure/web-application-firewall/afds/afds-overview) |
| Standard × Premium: custos | [Pricing](https://azure.microsoft.com/pricing/details/frontdoor/), [Compare pricing](https://learn.microsoft.com/azure/frontdoor/understanding-pricing) |
| Cache e compressão | [Rule set actions](https://learn.microsoft.com/azure/frontdoor/front-door-rules-engine-actions), [Cache purge](https://learn.microsoft.com/azure/frontdoor/cache-purge) |
| Domínios e certificados | [Add a custom domain](https://learn.microsoft.com/azure/frontdoor/standard-premium/how-to-add-custom-domain) |
| Roteamento e origin groups | [Routing methods](https://learn.microsoft.com/azure/frontdoor/routing-methods) |

---

<style scoped>
table {
  font-size: 20px;
  width: 100%;
}
</style>

# Referências

| Slide | Fonte |
|---|---|
| Rules engine | [Rule sets](https://learn.microsoft.com/azure/frontdoor/front-door-rules-engine), [Rule set actions](https://learn.microsoft.com/azure/frontdoor/front-door-rules-engine-actions) |
| Proteção DDoS | [Overview](https://learn.microsoft.com/azure/frontdoor/front-door-overview) |
| WAF: regras customizadas / rule set gerenciado / Proteção contra bots | [WAF no Front Door](https://learn.microsoft.com/azure/web-application-firewall/afds/afds-overview) |
| Private Link até a origem | [Private Link](https://learn.microsoft.com/azure/frontdoor/private-link) |
| Relatórios e logs | [Monitor Azure Front Door](https://learn.microsoft.com/azure/frontdoor/monitor-front-door) |
| Observabilidade de ponta a ponta | [Azure Monitor](https://learn.microsoft.com/azure/azure-monitor/fundamentals/overview), [Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview), [Monitor Azure Front Door](https://learn.microsoft.com/azure/frontdoor/monitor-front-door) |
| Comece de graça no Azure | [Conta gratuita](https://azure.microsoft.com/pt-br/pricing/purchase-options/azure-account), [Avoid charges](https://learn.microsoft.com/azure/cost-management-billing/manage/avoid-charges-free-account) |

---

# Continue aprendendo

- **Módulo** [Load balance HTTP(S) traffic in Azure](https://learn.microsoft.com/training/modules/load-balancing-https-traffic-azure/): intermediário, 7 unidades, com exercício de Front Door
- **Módulo** [Plan and implement security for public access to Azure resources](https://learn.microsoft.com/training/modules/security-public-access-azure-resources/): WAF, Front Door, CDN e DDoS
- **Tutorial** [Create an Azure Front Door](https://learn.microsoft.com/azure/frontdoor/create-front-door-portal) (portal)
- **Tutorial** [Scale and protect a web app using Azure Front Door and WAF](https://learn.microsoft.com/azure/frontdoor/front-door-waf)
- **Documentação** [learn.microsoft.com/azure/frontdoor](https://learn.microsoft.com/azure/frontdoor/)
