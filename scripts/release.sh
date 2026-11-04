#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# 🚀 FTN DevsIA - Publicador Oficial de Releases & Gestão das 3 Últimas Tags
# Cria a tag no Git, publica a Release no GitHub e mantém SEMPRE apenas
# as 3 ÚLTIMAS releases e tags ativas no GitHub para clareza e governança.
# ─────────────────────────────────────────────────────────────────────────────

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

TAG_NAME="$1"
RELEASE_TITLE="$2"
RELEASE_BODY="$3"

if [ -z "$TAG_NAME" ] || [ -z "$RELEASE_TITLE" ]; then
    echo -e "${RED}Uso: ./scripts/release.sh <tag> \"<titulo>\" [\"<corpo_markdown>\"]${NC}"
    echo -e "Exemplo: ./scripts/release.sh v1.1.9 \"v1.1.9 - Nova Feature\" \"- Descrição da melhoria\""
    exit 1
fi

RELEASE_BODY="${RELEASE_BODY:-Release oficial $TAG_NAME do FTN DevsIA}"

# 1. Recupera o Token do GitHub via osxkeychain / git credential helper
TOKEN=$(printf "protocol=https\nhost=github.com\n\n" | git credential fill 2>/dev/null | grep password | cut -d= -f2 || true)
if [ -z "$TOKEN" ]; then
    TOKEN="${GITHUB_TOKEN:-}"
fi

if [ -z "$TOKEN" ]; then
    echo -e "${RED}❌ Não foi possível obter o token de acesso do GitHub. Configure GITHUB_TOKEN ou git credential helper.${NC}"
    exit 1
fi

REPO="vitorfantin/team-ftn-devs-ia"

echo -e "🚀 ${GREEN}[1/4] Criando e enviando Tag Git '$TAG_NAME'...${NC}"
if ! git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    git tag -a "$TAG_NAME" -m "$RELEASE_TITLE"
else
    echo -e "ℹ️  Tag '$TAG_NAME' já existe localmente."
fi
git push origin "$TAG_NAME"

echo -e "\n📦 ${GREEN}[2/4] Publicando Release Oficial no GitHub...${NC}"
CREATE_PAYLOAD=$(cat << EOF
{
  "tag_name": "$TAG_NAME",
  "name": "$RELEASE_TITLE",
  "body": $(echo "$RELEASE_BODY" | jq -R -s .),
  "draft": false,
  "prerelease": false
}
EOF
)

RELEASE_RESP=$(curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$REPO/releases \
  -d "$CREATE_PAYLOAD")

RELEASE_URL=$(echo "$RELEASE_RESP" | jq -r '.html_url // empty')
if [ -n "$RELEASE_URL" ] && [ "$RELEASE_URL" != "null" ]; then
    echo -e "✅ Release publicada com sucesso: ${BLUE}$RELEASE_URL${NC}"
else
    echo -e "${YELLOW}⚠️  Aviso: Release já existia ou retornou:${NC}"
    echo "$RELEASE_RESP" | jq -r '.message // empty'
fi

echo -e "\n🧹 ${GREEN}[3/4] Higienizando Releases no GitHub (Mantendo apenas as 3 últimas)...${NC}"
RELEASES_JSON=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/repos/$REPO/releases)
COUNT_RELEASES=$(echo "$RELEASES_JSON" | jq '. | length')

if [ "$COUNT_RELEASES" -gt 3 ]; then
    echo -e "ℹ️  Detectadas $COUNT_RELEASES releases. Removendo as antigas para manter exatamente 3..."
    EXCESS_RELEASES=$(echo "$RELEASES_JSON" | jq -c '.[3:][]')
    for rel in $EXCESS_RELEASES; do
        REL_ID=$(echo "$rel" | jq -r '.id')
        REL_TAG=$(echo "$rel" | jq -r '.tag_name')
        echo -e "🗑️  Removendo release antiga: $REL_TAG (id: $REL_ID)..."
        curl -s -X DELETE \
          -H "Authorization: token $TOKEN" \
          -H "Accept: application/vnd.github.v3+json" \
          https://api.github.com/repos/$REPO/releases/$REL_ID
    done
fi

echo -e "\n🏷️  ${GREEN}[4/4] Higienizando Tags Remotas (Mantendo apenas as 3 últimas no GitHub)...${NC}"
REMOTE_TAGS=$(git ls-remote --tags origin | grep -v '\^{}' | awk '{print $2}' | sed 's#refs/tags/##' | sort -V)
TAGS_COUNT=$(echo "$REMOTE_TAGS" | grep -c . || true)

if [ "$TAGS_COUNT" -gt 3 ]; then
    NUM_TO_REMOVE=$((TAGS_COUNT - 3))
    TAGS_TO_REMOVE=$(echo "$REMOTE_TAGS" | head -n "$NUM_TO_REMOVE")
    echo -e "ℹ️  Detectadas $TAGS_COUNT tags remotas. Removendo as $NUM_TO_REMOVE mais antigas do GitHub..."
    for old_tag in $TAGS_TO_REMOVE; do
        echo -e "🗑️  Excluindo tag remota: $old_tag..."
        git push origin --delete "$old_tag" 2>/dev/null || true
    done
fi

echo -e "\n✨ ${GREEN}Processo concluído com sucesso!${NC}"
echo -e "📋 As 3 últimas tags e releases ativas no GitHub são:"
curl -s -H "Authorization: token $TOKEN" https://api.github.com/repos/$REPO/releases | jq -r '.[0:3][] | " - " + .tag_name + ": " + .name + " (" + .html_url + ")"'
