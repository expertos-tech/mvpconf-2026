# Perguntas prováveis — Azure Front Door

Respostas de até 3 frases, como seriam faladas no palco.
Números citados estão em `../fontes.md`.

## Front Door, Application Gateway ou Traffic Manager: qual eu uso?
Depende do escopo. Front Door é global e vê o tráfego HTTP na borda; Application Gateway é regional, dentro da sua rede; Traffic Manager é só DNS, não vê o tráfego e o failover depende do cache de DNS. Eles se combinam: Front Door na frente, Application Gateway dentro da região.

## Preciso do Premium?
Só se precisar de rule set gerenciado do WAF, proteção contra bots ou Private Link até a origem. Para cache, certificado, roteamento e regras customizadas de WAF, o Standard resolve. Dá para fazer upgrade depois; o caminho de volta exige recriar o perfil.

## Quanto custa para um site pequeno?
A taxa fixa é US$ 35 por mês no Standard e US$ 330 no Premium, cobrada por hora (verificado em set/2026). Depois disso, paga-se por requisição e por GB entregue, e o preço varia por região do usuário. O tráfego da origem no Azure até o Front Door é grátis.

## Minha origem está fora do Azure. Funciona?
Funciona: a origem pode estar em outra nuvem ou on-premises, desde que acessível por HTTP. Nesse caso, o trecho final entre o PoP e a origem passa pela internet pública. Private Link só existe para origens no Azure.

## O Front Door substitui a CDN?
Sim. O Front Door é a CDN atual da Microsoft, para conteúdo estático e dinâmico. O Azure CDN Standard from Microsoft (classic) será desligado em 30/09/2027, e o caminho de migração é o Front Door.

## Ainda uso o Front Door (classic). O que faço?
Migre para Standard ou Premium: o classic não aceita novos perfis, domínios nem certificados gerenciados e será desligado em 31/03/2027. Existe uma ferramenta de migração no portal. Antes, compare o custo, porque o modelo de cobrança mudou.

## Como impeço que acessem minha origem direto, pulando o WAF?
No Premium, com Private Link a origem fica sem endereço público. No Standard, use as duas medidas juntas: libere só os IPs da service tag `AzureFrontDoor.Backend` e confira o header `X-Azure-FDID`, que traz o ID do seu perfil. No App Service e no Functions, as restrições de acesso fazem os dois filtros sem mexer no código.

## Como sei que uma requisição passou pelo Front Door?
Ele envia o header `X-Azure-Ref` para a origem e para o cliente, com um código único da requisição. Esse código aparece nos logs de acesso e do WAF, então dá para seguir a mesma requisição da borda até a aplicação.

## O cache entrega conteúdo velho depois do deploy?
Até o TTL vencer, sim. Para forçar, use o purge por caminho ou por raiz; ele propaga em até 10 minutos por todos os PoPs. Alternativa mais segura: versionar os arquivos na URL a cada deploy.

## O Front Door faz balanceamento dentro da região também?
Ele escolhe entre as origens do origin group, que podem estar na mesma região ou em várias. Para balancear entre VMs dentro de uma VNet, o papel é do Application Gateway ou do Load Balancer.

## Mudei o DNS e o site caiu. O que aconteceu?
O domínio personalizado precisa estar validado no Front Door (registro TXT) e associado ao endpoint antes de trocar o CNAME. Se o CNAME apontar antes da validação, o Front Door não reconhece o host e recusa a requisição.
