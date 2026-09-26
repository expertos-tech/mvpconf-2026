#!/usr/bin/env bash
# Limpeza dos recursos das demos do MVPConf 2026.
#
# Lista os resource groups com a tag evento=mvpconf2026 (opcionalmente filtrando
# por palestra) e só apaga depois de confirmação explícita.
#
# Uso:
#   ./cleanup.sh            # todos os RGs do evento
#   ./cleanup.sh afd        # só a palestra 1 (palestra=afd)
#   ./cleanup.sh free       # só a palestra 2 (palestra=free)
#
# Idempotente: se não houver RG com a tag, termina sem erro.

set -euo pipefail

TAG_EVENTO="evento=mvpconf2026"
PALESTRA="${1:-}"

# Por que: apagar recursos na assinatura errada é irreversível.
echo "Assinatura ativa:"
az account show --query "{nome:name, id:id}" -o table
echo

QUERY="[?tags.evento=='mvpconf2026'"
if [[ -n "$PALESTRA" ]]; then
  QUERY+=" && tags.palestra=='${PALESTRA}'"
fi
QUERY+="].name"

# Por que: o bash 3.2 do macOS não tem mapfile.
GRUPOS=()
while IFS= read -r RG; do
  [[ -n "$RG" ]] && GRUPOS+=("$RG")
done < <(az group list --query "$QUERY" -o tsv)

if [[ ${#GRUPOS[@]} -eq 0 ]]; then
  echo "Nenhum resource group com a tag ${TAG_EVENTO}${PALESTRA:+ e palestra=${PALESTRA}}. Nada a fazer."
  exit 0
fi

echo "Resource groups que serão APAGADOS (com tudo o que há dentro):"
printf '  - %s\n' "${GRUPOS[@]}"
echo
read -r -p "Digite 'apagar' para confirmar: " CONFIRMA
if [[ "$CONFIRMA" != "apagar" ]]; then
  echo "Cancelado."
  exit 0
fi

# Por que --no-wait: a exclusão de Front Door e VMs demora; disparamos todas em paralelo.
for RG in "${GRUPOS[@]}"; do
  echo "Apagando ${RG}..."
  az group delete --name "$RG" --yes --no-wait
done

echo
echo "Exclusão iniciada. Acompanhe com: az group list --query \"${QUERY}\" -o table"
