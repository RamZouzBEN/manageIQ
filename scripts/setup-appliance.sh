#!/usr/bin/env bash
# Prépare l'appliance ManageIQ pour lancer OpenTofu depuis les playbooks du POC.
# À exécuter une seule fois en root sur l'appliance.
set -euo pipefail

TOFU_VERSION="1.13.9"
POC_ROOT="/var/lib/manageiq-poc"
CONFIG_DIR="/etc/manageiq-poc"
BASE_URL="https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}"
ARCHIVE="tofu_${TOFU_VERSION}_linux_amd64.tar.gz"

[ "$(id -u)" -eq 0 ] || { echo "Ce script doit être lancé en root." >&2; exit 1; }
id manageiq >/dev/null 2>&1 || { echo "Utilisateur manageiq introuvable." >&2; exit 1; }

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT
cd "$WORK_DIR"

echo "Téléchargement d'OpenTofu ${TOFU_VERSION}..."
curl -fsSL -o "$ARCHIVE" "${BASE_URL}/${ARCHIVE}"
curl -fsSL -o SHA256SUMS "${BASE_URL}/tofu_${TOFU_VERSION}_SHA256SUMS"
grep " ${ARCHIVE}\$" SHA256SUMS | sha256sum -c -

tar -xzf "$ARCHIVE" tofu
install -m 0755 -o root -g root tofu /usr/local/bin/tofu

install -d -m 0750 -o manageiq -g manageiq "$POC_ROOT" "$POC_ROOT/stacks" "$POC_ROOT/plugin-cache"
install -d -m 0750 -o root -g manageiq "$CONFIG_DIR"
if [ ! -f "$CONFIG_DIR/prism.json" ]; then
  install -m 0640 -o root -g manageiq /dev/null "$CONFIG_DIR/prism.json"
  cat > "$CONFIG_DIR/prism.json" <<'JSON'
{
  "endpoint": "A_REMPLACER",
  "username": "A_REMPLACER",
  "password": "A_REMPLACER"
}
JSON
fi

/usr/local/bin/tofu version
echo "Terminé. Renseigne maintenant ${CONFIG_DIR}/prism.json."
