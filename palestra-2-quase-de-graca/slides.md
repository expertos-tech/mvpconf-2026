---
marp: true
theme: mvpconf
paginate: true
size: 16:9
footer: "MVPConf 2026 · Azure Quase de Graça"
---

<!-- _class: lead -->

# Azure Quase de Graça
## Como publicar sem gastar uma fortuna

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
</style>

![bg left:25% fit](assets/apresentacao-avatar.png)

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

---

# Esqueci que existe um negócio chamado CUSTO

- **Você trabalha em empresas grandes**
  - Orçamento de infraestrutura que parece infinito
  - Ninguém questiona o custo de mais um ambiente
- **Seu projeto pessoal chegou**
  - Hora de criar aquela arquitetura que o arquiteto nunca deixou
  - Kubernetes, observabilidade, logs centralizados, microsserviços, serviços assíncronos
  - Múltiplas instâncias de banco, ambientes dev, qa e prod

---

# De cor, sem escrever uma linha

- **Você cria o resource group e começa**
  - Não precisa nem desenhar: essa arquitetura mora na sua cabeça há anos
- **Só que agora é diferente**
  - Não tem arquiteto para dizer "isso não cabe"
  - Não tem FinOps perguntando o custo do ambiente
  - É só você, o cartão de crédito e uma arquitetura pensada para escala horizontal e vertical

---

<style scoped>
table {
  font-size: 20px;
  width: 100%;
}
</style>

# Minha infra dos sonhos — borda e computação

| Componente | Serviço do Azure |
|---|---|
| Porta de entrada global | Azure Front Door Premium *(vemos às 16h)* |
| Gateway de API | Azure API Management Premium, multi-região |
| Os dois microsserviços | Azure Kubernetes Service (AKS), multi-node pool |
| Comunicação entre serviços | Istio-based service mesh add-on |
| Imagens dos containers | Azure Container Registry Premium, geo-replicado |

---

<style scoped>
table {
  font-size: 20px;
  width: 100%;
}
</style>

# Minha infra dos sonhos — dados e mensageria

| Componente | Serviço do Azure |
|---|---|
| Banco do microsserviço de pedidos | Azure DocumentDB (compatível com MongoDB) |
| Banco do microsserviço de pagamentos | Azure Database for PostgreSQL, Flexible Server |
| Stream de eventos entre os serviços | Event Hubs com protocolo Kafka |
| Fila de reprocessamento (dead-letter) | Azure Service Bus *(Kafka não tem DLQ nativo)* |

---

<style scoped>
table {
  font-size: 20px;
  width: 100%;
}
</style>

# Minha infra dos sonhos — observabilidade, segurança e ambientes

| Componente | Serviço do Azure |
|---|---|
| Métricas, logs e traces da aplicação | Azure Monitor + Application Insights |
| Métricas do cluster Kubernetes | Azure Monitor managed service for Prometheus |
| Dashboards | Azure Managed Grafana |
| Segredos e certificados | Azure Key Vault |
| Isolamento de rede | Virtual Network + Private Endpoint |
| Ambientes separados | dev, qa e prod, cada um com seu resource group |

---

# Como tudo isso conversa

![w:1050](assets/arquitetura-sonhos.svg)

---

<!-- _class: lead -->

# Talk is cheap. Show me the code.

---

<!-- _class: lead -->

# Obrigado!

Hoje às 16h: **Azure Front Door** 

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
| Lorem ipsum | [Lorem ipsum](https://exemplo.com) |

---

# Continue aprendendo
