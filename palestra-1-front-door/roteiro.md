# Roteiro — Azure Front Door: Sua aplicação conquistando o mundo

MVPConf 2026 · 10h · 50 min

**Objetivo:** mostrar como distribuir uma aplicação globalmente com baixa latência, segurança
e alta disponibilidade.

## Blocos

| Bloco | Tempo | Slides | Conteúdo |
|---|---|---|---|
| Abertura | 00:00–02:45 | 1–3 | Capa, apresentação pessoal, dicionário |
| O problema | 02:45–10:15 | 4–9 | Latência, várias regiões, rede, deploy, segurança, operação |
| O Front Door | 10:15–14:00 | 10–13 | O que é, como funciona, rede da Microsoft, comparação com Application Gateway e Traffic Manager |
| Planos | 14:00–16:45 | 14–16 | Standard × Premium: recursos e custos |
| Recursos | 16:45–27:15 | 17–27 | Um slide por recurso, ligando cada um ao problema que resolve |
| Demos ao vivo | 27:15–44:30 | 28 | "Talk is cheap. Show me the code." + demos |
| Fechamento | 44:30–45:00 | 29 | Obrigado + convite para as 14h |
| Perguntas e folga | 45:00–50:00 | — | — |
| Apêndice | não apresentado | 30–34 | Conta gratuita, referências, treinamentos |

**Total planejado:** 45 min + 5 min de folga = 50 min

> ⚠️ Os slides somam ~27 min e as demos ~17 min. O `CLAUDE.md` pede "pouco PPT + live coding"
> (a demo é a estrela). Ver "Se estourar o tempo" para ganhar tempo de demo.

---

## Slide a slide

### Abertura (00:00–02:45)

**1. Capa** · 00:00–00:30 (0:30)
- Cumprimentar e dizer o título. Não se apresentar aqui; isso é o próximo slide.
- Dizer a promessa da palestra.

**2. Rodrigo Tavares** · 00:30–02:00 (1:30)
- Apresentação rápida: cargo, MVP, 25 anos de carreira.
- Apontar o QR code: "o material e meus canais estão aqui". Deixar alguns segundos para fotos.

**3. Antes de começar, um breve dicionário** · 02:00–02:45 (0:45)
- Não ler termo por termo. Dizer que as siglas vão aparecer e que o slide fica no material.
- Destacar só PoP, WAF, CDN e origem, que aparecem o tempo todo.

### O problema (02:45–10:15)

Contar como uma história: a aplicação cresce e os problemas aparecem. **Não citar o Front Door
neste bloco**; a solução vem no slide 10.

**4. Seu usuário está longe demais** · 02:45–04:15 (1:30)
- Cenário: a app funciona numa região e passa a ter usuários do outro lado do mundo.
- Perguntar: "quem aqui já colocou uma CDN e achou que resolveu?". Mostrar que ela resolve só o estático.

**5. Mais regiões, mais problemas** · 04:15–05:45 (1:30)
- A reação natural é publicar em várias regiões. A latência melhora, mas surgem as perguntas do slide.
- Terminar com: "agora você tem várias apps para operar".

**6. Não é só a distância** · 05:45–07:15 (1:30)
- Explicar que, antes do primeiro byte, há resolução DNS, saltos na internet pública e o handshake TCP + TLS.
- Frase de efeito: "só abrir a conexão já custa de 3 a 5 idas e voltas".

**7. Mudar sem derrubar** · 07:15–08:15 (1:00)
- Histórias rápidas: o deploy de sexta, a migração que precisa ser gradual, o carrinho que some.

**8. Sua aplicação é um alvo** · 08:15–09:15 (1:00)
- Passar pelos quatro riscos. "Porta dos fundos" costuma surpreender: quem acessa a origem direto pula toda a proteção.

**9. O dia a dia da operação** · 09:15–10:15 (1:00)
- Tom de bom humor: certificado vencido, link quebrado, cache velho, ninguém sabe de onde vem o erro.
- Transição: "e se tudo isso pudesse ser resolvido num lugar só?"

### O Front Door (10:15–14:00)

**10. Te apresento o Azure Front Door** · 10:15–10:30 (0:15)
- Pausa dramática. Só dizer o título.

**11. O que é o Azure Front Door?** · 10:30–12:00 (1:30)
- O que é: porta de entrada global, CDN para conteúdo estático e dinâmico.
- Pra que serve: acelerar, proteger e manter disponível.
- Como funciona: ler a sequência WAF → rota → rules engine → cache → origem. Ela é o mapa dos próximos slides.

**12. Do PoP até a sua aplicação** · 12:00–13:00 (1:00)
- Ligar com o slide 6: do PoP em diante, o tráfego segue pela rede da Microsoft.
- Reforçar a ressalva do slide: vale por completo quando a origem está no Azure. Fora do Azure, o trecho final passa pela internet.

**13. Front Door, Application Gateway ou Traffic Manager?** · 13:00–14:00 (1:00)
- É a pergunta que sempre aparece; responder antes que perguntem.
- Front Door é global e vê o tráfego (L7). Application Gateway é regional. Traffic Manager é só DNS: não vê o tráfego e o failover depende do cache de DNS.
- Não são excludentes: Front Door na frente, Application Gateway dentro da região.

### Planos (14:00–16:45)

**14. Standard × Premium: recursos (1/2)** · 14:00–14:45 (0:45)
- "O que os dois planos têm": a base é igual.

**15. Standard × Premium: recursos (2/2)** · 14:45–15:30 (0:45)
- "O que só o Premium tem": segurança avançada e Private Link.
- Avisar que Premium → Standard exige recriar o perfil.

**16. Standard × Premium: custos** · 15:30–16:45 (1:15)
- Citar só a taxa fixa (US$ 35 × US$ 330) e dizer que o resto varia por zona.
- Ponte para as 14h: "custo em detalhe, e como gastar pouco, é na palestra Azure quase de graça". Não aprofundar aqui.
- Lembrar o classic: desligamento em 31/03/2027.

### Recursos (16:45–27:15)

Em cada slide, **dizer qual problema do bloco 2 ele resolve**. Os que são só do Premium estão
marcados no título.

**17. Cache e compressão** · 16:45–17:45 (1:00) — resolve o slide 4
- Foco no purge: "corrigiu? manda limpar o cache; em até 10 minutos todos os PoPs buscam de novo" (liga com o slide 9).

**18. Domínios e certificados** · 17:45–18:45 (1:00) — resolve o slide 9
- Certificado gerenciado grátis com renovação automática: "o certificado não vence mais na Black Friday".

**19. Roteamento e origin groups** · 18:45–20:15 (1:30) — resolve os slides 5 e 7
- Latency para as várias regiões, Priority para failover, Weighted para canary e migração, session affinity para o carrinho.

**20. Rules engine** · 20:15–21:15 (1:00) — resolve o slide 9
- Exemplos: redirect de URLs antigas e headers de segurança sem mexer na aplicação.

**21. Proteção DDoS** · 21:15–22:00 (0:45) — resolve o slide 8
- Camadas 3 e 4 inclusas; camada 7 com WAF e rate limiting.

**22. WAF: regras customizadas** · 22:00–23:00 (1:00) — resolve o slide 8
- Destacar rate limiting e geo-filtering. Dica: começar em Detection e depois passar para Prevention.

**23. WAF: rule set gerenciado [Premium-only]** · 23:00–23:45 (0:45) — resolve o slide 8
- "SQL injection e XSS sem escrever regra: a Microsoft mantém."

**24. Proteção contra bots [Premium-only]** · 23:45–24:30 (0:45) — resolve o slide 8
- Bad, Good e Unknown; Googlebot passa, robô malicioso não.

**25. Private Link até a origem [Premium-only]** · 24:30–25:30 (1:00) — resolve o slide 8 ("porta dos fundos")
- A origem fica sem acesso público. Lembrar que está disponível em Brazil South.

**26. Relatórios e logs** · 25:30–26:15 (0:45) — resolve o slide 9 ("sem visibilidade")
- Avisar: os logs não vêm ligados por padrão.

**27. Observabilidade de ponta a ponta** · 26:15–27:15 (1:00)
- Azure Monitor para os recursos, Application Insights para a aplicação, `X-Azure-Ref` ligando os dois.

### Demos ao vivo (27:15–44:30)

**28. Talk is cheap. Show me the code.** · 27:15–27:30 (0:15)
- Trocar para o terminal ou o portal.

**Demo 1: latência Brasil × Austrália** · 27:30–37:00 (~9:30)
- Plano em `live-coding.md`; roteiro detalhado e plano B em `demos/01-latencia/README.md` (a criar).
- Fecha os slides 4, 6 e 12.

**Demo 2 (a definir)** · 37:00–44:30 (~7:30)
- Candidatas, em ordem de preferência:
  1. **WAF bloqueando um ataque:** regra customizada de rate limiting ou geo-filtering, mostrar o 403 e o log. Fecha os slides 8, 22 e 26. Funciona no Standard.
  2. **Failover de origem:** derrubar a origem principal e mostrar o health probe tirando ela de circulação (Priority). Fecha os slides 5 e 19.
- Qualquer uma reaproveita o Front Door e a Function da demo 1.

### Fechamento (44:30–50:00)

**29. Obrigado!** · 44:30–45:00 (0:30)
- Agradecer, dizer onde encontrar o material (QR code do slide 2) e convidar para as 14h:
  "de manhã levamos a app para o mundo; à tarde, vamos ver como fazer isso sem gastar uma fortuna".
- Transição: abrir para perguntas.

**Perguntas e folga** · 45:00–50:00 (5:00)
- Respostas prontas em `perguntas.md`.

### Apêndice (não apresentado)

**30–34.** Apêndice, Comece de graça no Azure, Referências (2), Continue aprendendo.
- Só para quem consultar o material depois. Abrir apenas se alguém perguntar.

---

## Se estourar o tempo (cortar)
- **Slide 3 (dicionário):** mostrar por 15 s e seguir (ganha ~30 s).
- **Slides 14–15 (recursos):** passar juntos em 1 min (ganha ~30 s).
- **Slides 21–26:** agrupar DDoS, WAF, bots e Private Link numa fala só de segurança, 30 s por slide (ganha ~2 min).
- **Slide 16 (custos):** só a taxa fixa e a ponte para as 14h (ganha ~30 s).
- **Slide 13 (comparação):** responder só se perguntarem (ganha ~1 min).

## Bônus (se sobrar tempo)
- Edge Actions (preview): JavaScript rodando na borda.
- Private Link: não mistura origens públicas e privadas no mesmo origin group; limite de 7200 RPS por cluster regional.
- Contar a história do "anycast × unicast" (o classic usava anycast; Standard e Premium usam unicast + Traffic Manager).
