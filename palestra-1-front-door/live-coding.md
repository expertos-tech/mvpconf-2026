# Live coding — latência Brasil × longe do Brasil

Plano do live coding da palestra Azure Front Door. Foco em ser **funcional e mensurável**;
layout não importa.

Status: **planejamento**. Nada foi criado no Azure. Código, scripts e recursos vêm depois,
com confirmação antes de criar qualquer recurso pago.

## 1. Objetivo

Mostrar com números que o Front Door reduz a latência para um usuário longe da aplicação.
A aplicação fica publicada **só em Brazil South** e é medida de longe, **direto na origem**
e **via Front Door**.

## 2. Arquitetura

| Peça | O quê | Onde |
|---|---|---|
| **API** | Azure Functions, C# .NET 10 isolated, Flex Consumption. `GET /api/ping` devolve JSON curto (horário UTC e região), com `Cache-Control: no-store` | Brazil South |
| **Página** | HTML com Vue 3 via CDN, sem build, servido pela própria Function em `GET /` | Mesma Function App |
| **Front Door** | Standard, com a Function como origem, rota `/*` e **cache desligado** (medir o caminho dinâmico) | Global |
| **VM de teste** | Windows Server 2025 Datacenter, acessada por Azure Bastion (ou RDP restrito ao seu IP). Roda o navegador (página) e o `curl.exe` (sonda) | Australia East |

**Por que a página fica dentro da Function:** um só deploy e nenhum CORS. A página chama
`/api/ping` com caminho relativo:

- aberta pela URL da **origem** (`<app>.azurewebsites.net`) → mede o acesso direto;
- aberta pela URL do **Front Door** (`<endpoint>.azurefd.net`) → mede o acesso via Front Door.

Duas abas lado a lado, no navegador **da VM na Austrália**.

**Por que uma VM:** a medição acontece dentro da VM (VM → origem e VM → Front Door). A latência
do Remote Desktop só afeta a tela que chega até você, não os números medidos.

**Código e scripts (próximos passos):**
- `apps/latencia-ping/` → Function (API + página)
- `palestra-1-front-door/demos/01-latencia/` → scripts `az`, `README.md` com plano B e reset

## 3. Medições

### 3.1 Página (Vue), aberta no navegador da VM na Austrália
- Botão **Medir**: 20 pings em sequência com `performance.now()`.
- Mostra: primeiro ping (conexão nova) separado; depois mínimo, mediana, p95 e máximo.
- É a demo visual, para a plateia.
- **Comparação opcional:** abrir a mesma página no notebook do apresentador. Do Brasil, a
  origem já está perto e a diferença quase não aparece. Isso reforça que o ganho é para quem
  está longe.

### 3.2 Sonda (curl) na VM em Australia East
- Roda no PowerShell da VM com `curl.exe` (já vem no Windows).
- Para cada URL (origem e Front Door): 20 requisições com **conexão nova**.
- Registra de cada requisição:

| Campo do curl | Significado |
|---|---|
| `time_namelookup` | DNS |
| `time_connect` | TCP |
| `time_appconnect` | TLS |
| `time_starttransfer` | TTFB (primeiro byte) |
| `time_total` | total |

- Saída: tabela lado a lado, origem × Front Door (mediana e p95 de cada campo).
- É a demo que mostra o efeito da distância: do Brasil a origem já está perto, então quem
  evidencia o ganho do Front Door é a medição a partir da Austrália.

### 3.3 Expectativa (a confirmar no ensaio)
- **Conexão nova:** o Front Door deve ganhar, porque o handshake TCP + TLS termina no PoP
  perto do usuário (slide "Não é só a distância").
- **Conexão reaproveitada (keep-alive):** a diferença deve ser menor e pode até favorecer
  a origem.
- **Nenhum número é prometido.** Os valores medidos no ensaio vão para a tabela da seção 9.

## 4. Roteiro ao vivo (básico)

### Antes da palestra (nada que demore mais de ~1 min roda ao vivo)
1. Criar RG, Function App publicada, Front Door e VM em Australia East.
2. Aquecer a Function (várias chamadas) para tirar o cold start da medição.
3. Iniciar a VM (se estiver desalocada), abrir a sessão pelo Bastion ou RDP **antes de subir ao
   palco** e deixar prontas as duas abas da página e o PowerShell com o comando da sonda.

### Ao vivo (~8 a 10 min)
1. Mostrar a sessão remota: "esta máquina está na Austrália; a app está no Brasil".
2. Na VM, abrir a página pela URL da **origem** e medir.
3. Na VM, abrir a página pela URL do **Front Door** e medir.
4. Comparar os números na tela.
5. No PowerShell da VM, rodar a sonda com `curl.exe` e ler DNS, TCP, TLS e TTFB com a plateia:
   origem × Front Door.
6. (Opcional) Medir no notebook, do Brasil, para mostrar que de perto quase não muda.
7. Ligar com os slides "Não é só a distância" e "Do PoP até a sua aplicação".

## 5. Comandos Azure CLI (esboço)

- **Resource group:** `rg-mvpconf26-afd-latencia`
- **Tags em tudo:** `evento=mvpconf2026`, `palestra=afd`

Ordem prevista:

1. `az group create`
2. `az storage account create` (armazenamento da Function)
3. `az functionapp create --flexconsumption-location brazilsouth --runtime dotnet-isolated --runtime-version 10`
4. Publicar: `func azure functionapp publish <app>`
5. `az afd profile create --sku Standard_AzureFrontDoor`
6. `az afd endpoint create`
7. `az afd origin-group create` (health probe em `/api/ping`)
8. `az afd origin create` (host da Function)
9. `az afd route create` (rota `/*`, sem cache)
10. `az vm create --location australiaeast` (Windows Server 2025 Datacenter, com tags; senha do
    admin por variável de ambiente ou prompt, nunca no repositório)
11. Acesso: Azure Bastion **ou** regra de NSG liberando a porta 3389 só para o seu IP público
12. `az vm auto-shutdown` (desligamento automático diário)
13. Fora dos ensaios: `az vm deallocate`; antes do uso: `az vm start`

> ⚠️ VERIFICAR: parâmetros exatos serão validados quando os scripts forem escritos.

## 6. Custo e limpeza

- **Front Door Standard:** US$ 35/mês de taxa fixa, cobrada por hora (verificado em set/2026,
  `fontes.md`). Criar perto do evento e apagar logo depois.
- **Flex Consumption:** execução sob demanda com franquia gratuita.
  > ⚠️ VERIFICAR: valor atual da franquia.
- **VM Windows:** computação cobrada por hora enquanto ligada; o disco é cobrado mesmo com a VM
  desalocada. Manter desalocada fora do uso e com auto-shutdown.
- **Azure Bastion:** depende do SKU.
  > ⚠️ VERIFICAR: preços da VM, do disco e do Bastion antes de criar.
- **Limpeza:** `shared/scripts/cleanup.sh`, apagando por tag `evento=mvpconf2026`.
- **Confirmação:** pedir confirmação antes de criar ou apagar qualquer recurso.

## 7. Plano B

- **Rede do evento bloqueia RDP (porta 3389):** usar o Azure Bastion, que funciona pela porta 443.
- **Bastion ou rede do evento falhou:** usar o hotspot do celular para abrir a sessão.
- **Nada funcionou:** prints e vídeo da medição do ensaio + tabela da seção 9.

## 8. Reset

- A sonda não guarda estado: basta rodar de novo.
- Depois do ensaio: `az vm deallocate` para parar de pagar a computação.
- A página não guarda nada: recarregar.

## 9. Resultados do ensaio

Preencher em cada ensaio (valores em ms).

| Data | De onde | Conexão | Origem: TTFB mediana | Front Door: TTFB mediana | Observação |
|---|---|---|---|---|---|
| | | | | | |

## 10. Pendências

- [ ] ⚠️ VERIFICAR: Flex Consumption disponível em Brazil South (`az functionapp list-flexconsumption-locations`).
- [ ] ⚠️ VERIFICAR: tamanho de VM Windows disponível em Australia East (com memória suficiente para o navegador).
- [ ] ⚠️ VERIFICAR: Azure Bastion Developer (gratuito) disponível em Australia East; se não, usar o SKU Basic.
- [ ] ⚠️ VERIFICAR: preços da VM, do disco e do Bastion.
- [ ] ⚠️ VERIFICAR: host header correto para a Function como origem do Front Door.
- [ ] ⚠️ VERIFICAR: valor atual da franquia do Flex Consumption.
