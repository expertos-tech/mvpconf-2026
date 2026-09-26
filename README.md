# MVPConf 2026 — Palestras de Azure

Material de duas palestras apresentadas no mesmo dia no **MVPConf 2026**: slides, roteiros,
demos ao vivo e fontes verificadas.

| Horário | Palestra | Pasta |
|---|---|---|
| 10h | **Azure Front Door:** Sua aplicação conquistando o mundo | [`palestra-1-front-door/`](palestra-1-front-door/) |
| 14h | **Azure quase de graça:** como publicar sem gastar uma fortuna | [`palestra-2-quase-de-graca/`](palestra-2-quase-de-graca/) |

Cada palestra tem 50 minutos, é voltada para devs e profissionais de infraestrutura de nível
intermediário e segue o formato **pouco slide + live coding**.

## Estrutura

```
palestra-1-front-door/       # Azure Front Door (código curto: afd)
  slides.md                  # deck em Marp
  roteiro.md                 # tempo e notas do apresentador, slide a slide
  live-coding.md             # plano do live coding
  perguntas.md               # perguntas prováveis da plateia
  assets/                    # imagens dos slides
  dist/                      # PDF/PPTX exportados (Git LFS)
  demos/                     # roteiro e scripts de cada demo
  infra/                     # ambiente base (Bicep)
palestra-2-quase-de-graca/   # Azure quase de graça (código curto: free), mesma estrutura
apps/                        # código das aplicações usadas nas demos
shared/                      # tema Marp e scripts comuns
fontes.md                    # preços, limites e datas verificados, com link e data
CLAUDE.md                    # regras de trabalho do repositório
```

## Pré-requisitos

- [Node.js](https://nodejs.org/) (para rodar o Marp CLI via `npx`)
- [Git LFS](https://git-lfs.com/) (exports e vídeos do plano B)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (demos)

Depois de clonar:

```bash
git lfs install
git lfs pull
```

## Slides

Os slides são escritos em [Marp](https://marp.app/). Rode os comandos a partir da pasta da palestra:

```bash
cd palestra-1-front-door

# Preview com recarga automática
npx @marp-team/marp-cli@latest slides.md --theme-set ../shared/marp/tema.css --server

# Exportar PDF
npx @marp-team/marp-cli@latest slides.md --theme-set ../shared/marp/tema.css --allow-local-files --pdf -o dist/slides.pdf

# Exportar PPTX (sem notas; as notas ficam no roteiro.md)
npx @marp-team/marp-cli@latest slides.md --theme-set ../shared/marp/tema.css --allow-local-files --pptx -o dist/slides.pptx
```

## Demos e custos

As demos criam recursos no Azure que **podem gerar cobrança**.

- Todo recurso recebe as tags `evento=mvpconf2026` e `palestra=afd|free`.
- Os resource groups seguem o padrão `rg-mvpconf26-<palestra>-<demo>`.
- Apague tudo depois de usar. Cada ambiente de demo tem um script de limpeza que remove os recursos pelas tags.

Nunca commite secrets, connection strings ou IDs de assinatura. Use o [`.env.example`](.env.example)
como modelo e mantenha o `.env` fora do git.

## Fontes

Preços, limites e datas mudam com frequência. Tudo o que aparece nos slides foi verificado
em fontes oficiais e registrado em [`fontes.md`](fontes.md), com link e data da verificação.

## Autor

**Rodrigo Tavares** · Head de Soluções e Transformação na Develcode · MVP Microsoft
[linktr.ee/expertostech](https://linktr.ee/expertostech)
