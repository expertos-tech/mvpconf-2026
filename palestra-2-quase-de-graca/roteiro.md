# Roteiro — Azure quase de graça: como publicar sem gastar uma fortuna

MVPConf 2026 · 14h · 50 min

> Primeira palestra do dia. Fechar convidando para a do Azure Front Door às 16h.

**Objetivo:** mostrar caminhos reais para publicar aplicações no Azure gastando pouco ou nada.

**Sem live coding.** No lugar do live coding, a demo é **a fatura real de uma aplicação sua**
que roda com Azure Front Door e gira em torno de **US$ 1/dia**. Prepare com antecedência:
login no portal já feito, Cost Management aberto na assinatura certa, e um recorte de
período (ex.: últimos 30 dias) pronto para mostrar sem digitar nada ao vivo.

> ⚠️ O slide "Talk is cheap. Show me the code." ainda está no deck como transição para a
> demo. A frase é sobre código; como não há live coding, a nota do apresentador redireciona
> para "mostrar a fatura real". Considerar trocar o texto do slide depois.

## Blocos

| Bloco | Tempo | Conteúdo |
|---|---|---|
| Abertura | 00:00–02:45 | Capa, apresentação pessoal, dicionário |
| O problema | 02:45–12:15 | A arquitetura dos sonhos, a fatura, a virada |
| A virada | 12:15–14:15 | Azure super econômico, capacidades não tecnologia |
| O que é grátis e barato | 14:15–19:45 | 65 serviços grátis, tabelas, Canivete Suíço |
| Nossa arquitetura | 19:45–25:00 | Tabela, diagrama, custo, "fatura que dá pra pagar", SLA |
| Além do básico | 25:00–26:45 | App global, escala |
| Demo: a fatura real | 27:00–44:00 | Cost Management de uma aplicação real, ~US$ 1/dia |
| Fechamento | 44:00–44:45 | Obrigado + convite para as 16h |
| Perguntas e folga | 44:45–50:00 | — |
| Apêndice | não apresentado | Conta gratuita, referências, treinamentos |

**Total planejado:** 44:45 + 5:15 de folga ≈ 50 min

---

## Slide a slide

### Abertura (00:00–02:45)

**1. Capa** · 00:00–00:30 (0:30)
- Cumprimentar, dizer o título, prometer: sair daqui sabendo publicar sem gastar uma fortuna.

**2. Rodrigo Tavares** · 00:30–02:00 (1:30)
- Apresentação rápida: cargo, MVP, 25 anos de carreira.
- Apontar o QR code: material e canais estão ali. Deixar alguns segundos para fotos.

**3. Antes de começar, um breve dicionário** · 02:00–02:45 (0:45)
- Não ler termo por termo. Avisar que ele fica no material.
- Destacar só DLQ/poison queue e RU/s, que vão aparecer bastante mais à frente.

### O problema (02:45–12:15)

**4. Esqueci que existe um negócio chamado CUSTO** · 02:45–04:00 (1:15)
- Gancho pessoal: quem trabalha em empresa grande esquece que existe orçamento.
- Frase de efeito: "aquela arquitetura que o arquiteto nunca deixou você criar".

**5. De cor, sem escrever uma linha** · 04:00–05:00 (1:00)
- Ninguém freia: sem arquiteto, sem FinOps, só você e o cartão de crédito.

**6. Minha infra dos sonhos — borda e computação** · 05:00–06:00 (1:00)
- Passar rápido pelos 5 itens; não precisa explicar cada serviço, é para impressionar pelo volume.

**7. Minha infra dos sonhos — dados e mensageria** · 06:00–07:00 (1:00)
- Destacar o detalhe do Kafka não ter DLQ nativo — é uma pegadinha boa para citar.

**8. Minha infra dos sonhos — observabilidade, segurança e ambientes** · 07:00–08:00 (1:00)
- Fechar com "dev, qa e prod, cada um com seu resource group" — prepara a piada dos "3 ambientes idênticos" da fatura.

**9. Como tudo isso conversa** · 08:00–09:00 (1:00)
- Mostrar o diagrama só como confirmação visual do exagero. Não narrar cada seta.

**10. E quando chega a fatura** · 09:00–10:15 (1:15)
- Pausa antes de revelar o número. Deixar a plateia reagir ao "R$ 23.250/mês por ambiente".
- Bater o "× 3 ambientes ≈ R$ 70 mil/mês" com força.

**11. O sonho quase perdido** · 10:15–11:15 (1:00)
- Vira o tom: não é "nunca", é "ainda não". O cliente não liga pra arquitetura.

**12. Você quer produto e valor, ou só tecnologia?** · 11:15–12:15 (1:00)
- As 3 necessidades reais (escalar, backup, logs). Termina com a promessa: dá pra ter tudo isso sem gastar uma fortuna.

### A virada (12:15–14:15)

**13. Vou te apresentar o Azure super econômico** · 12:15–12:30 (0:15)
- Pausa dramática, só o título.

**14. Finalmente uma boa notícia** · 12:30–13:15 (0:45)
- Antecipa a objeção ("vou ter que fazer monolito?") e já nega: mesmas peças da arquitetura dos sonhos, escolhidas certo.

**15. Vamos pensar em capacidades e não tecnologia** · 13:15–14:15 (1:00)
- Este é o mapa do resto da palestra. Ler as 6 capacidades com calma — cada uma vai virar conteúdo.

### O que é grátis e barato (14:15–19:45)

**16. O Azure disponibiliza mais de 65 serviços sempre gratuitos, você sabia?** · 14:15–14:30 (0:15)
- Pergunta retórica, deixar no ar 2 segundos antes de seguir.

**17. O que é sempre grátis — computação** · 14:30–15:30 (1:00)
- Destacar Functions (1 milhão de execuções) — é a peça que vai aparecer na nossa arquitetura.

**18. O que é sempre grátis — dados e mensageria** · 15:30–16:30 (1:00)
- Cosmos DB free tier é o outro pilar que volta mais à frente.

**19. O que é sempre grátis — porta de entrada, observabilidade e segredos** · 16:30–17:30 (1:00)
- Avisar que Key Vault não tem tier "sempre grátis" oficial, mas o custo é irrisório.

**20. Não é free mas é muito barato** · 17:30–18:45 (1:15)
- Passar rápido pelas 7 linhas. Storage Account fica em suspense ("aguarde, veremos a seguir").
- Front Door aqui é só a linha da tabela; o slide dedicado vem depois.

**21. Te apresento: O Canivete Suíço** · 18:45–19:45 (1:00)
- Paga o suspense do Storage Account. Ligar com o que vem a seguir: essas 4 capacidades formam a base da nossa arquitetura.

### Nossa arquitetura (19:45–25:00)

**22. Nossa arquitetura** · 19:45–21:00 (1:15)
- Ler a tabela linha por linha, ligando com as capacidades do slide 15.
- Frisar "porta de entrada: nenhuma" — é a peça que mais gera pergunta.

**23. Como tudo isso conversa** · 21:00–22:00 (1:00)
- Mostrar o diagrama e comparar visualmente com o das "sonhos" (mesmos papéis, peças diferentes).

**24. Quanto realmente custa** · 22:00–23:00 (1:00)
- As premissas de uso (200 mil execuções etc.) — deixar claro que é uma estimativa, não garantia.

**25. Uma fatura que dá pra pagar** · 23:00–24:00 (1:00)
- O contraste com o slide 10 é o clímax do bloco. Pausa antes do número.

**26. Mas a Microsoft diz: não use free em produção** · 24:00–25:00 (1:00)
- Antecipa a objeção do público antes que alguém pergunte. Fechar com "a infra cresce junto com o faturamento".

### Além do básico (25:00–26:45)

**27. E se minha aplicação for global** · 25:00–25:45 (0:45)
- Ponte direta para a palestra das 16h. Não aprofundar em Front Door aqui.

**28. Mas isso escala?** · 25:45–26:45 (1:00)
- Fecha a objeção de escala antes da demo. Cosmos sobe o RU/s, Functions escala sozinho, Container Apps é a alternativa.

### Demo: a fatura real (27:00–44:00)

**29. Talk is cheap. Show me the code.** · 27:00–27:15 (0:15)
- Trocar para o navegador/portal. Falar: "aqui não tem code, tem fatura de verdade" — usar a virada de expectativa a seu favor.

**Demo (17:00)**
- Abrir o Cost Management da assinatura real, filtrado pelos últimos 30 dias.
- Mostrar o total (~US$ 1/dia) e detalhar por serviço, destacando o Azure Front Door na lista.
- Comparar com a fatura fictícia de R$ 23.250/mês do início da palestra.
- Plano B: prints ou vídeo da tela de custos, para o caso de o portal falhar ou a rede do evento não deixar.
- Reset: nada a resetar, é só uma consulta de leitura.

### Fechamento (44:00–50:00)

**30. Obrigado!** · 44:00–44:45 (0:45)
- Agradecer, lembrar o QR code do slide 2, convidar para a palestra das 16h (Azure Front Door).

**Perguntas e folga** · 44:45–50:00 (5:15)

### Apêndice (não apresentado)

**31–35.** Apêndice, Comece de graça no Azure, Referências (2), Continue aprendendo.
- Só para quem consultar o material depois. Abrir apenas se alguém perguntar.

---

## Se estourar o tempo (cortar)
- **Slide 3 (dicionário):** 15 s e seguir (ganha ~30 s).
- **Slides 6–8 (infra dos sonhos):** passar as 3 tabelas em 2 min só, sem ler linha a linha (ganha ~1 min).
- **Slides 17–19 (sempre grátis):** juntar em 2 min (ganha ~1 min).
- **Demo:** é o coração da palestra; cortar em outro lugar antes de cortar aqui.

## Bônus (se sobrar tempo)
- Mostrar ao vivo o alerta de orçamento (budget) configurado na sua assinatura real, dentro da mesma demo do Cost Management.
- Comentar a diferença entre Cosmos DB free tier e Azure SQL Database free offer, para quem perguntar "por que não usei os dois".
