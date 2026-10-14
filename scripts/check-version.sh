#!/usr/bin/env bash
# Version + layout consistency check for the trueseal plugin.
#
# Verifies, without building anything:
#   1. .claude-plugin/plugin.json and .claude-plugin/marketplace.json parse as JSON.
#   2. The marketplace lists exactly one plugin, named like plugin.json's name,
#      sourced from "./" (this repo is both the marketplace and the plugin).
#   3. Both version fields are identical strict semver X.Y.Z (no pre-release
#      suffixes — the lockstep tag must equal the plugin version exactly).
#   4. Every skills/<name>/ directory has a SKILL.md whose frontmatter `name:`
#      equals its directory name and carries a non-empty `description:`.
#   5. If EXPECTED_VERSION is set (release flows pass the tag version), both
#      manifests must equal it.
#
# Usage:
#   scripts/check-version.sh                 # consistency only
#   EXPECTED_VERSION=0.6.0 scripts/check-version.sh   # + tag equality
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'PYEOF'
import json, os, re, sys

SEMVER = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")

def fail(msg):
    print(f"check-version: FAIL — {msg}", file=sys.stderr)
    sys.exit(1)

plugin = json.load(open(".claude-plugin/plugin.json"))
market = json.load(open(".claude-plugin/marketplace.json"))

plugins = market.get("plugins")
if not isinstance(plugins, list) or len(plugins) != 1:
    fail("marketplace.json must list exactly one plugin")
entry = plugins[0]

if entry.get("name") != plugin.get("name"):
    fail(f"plugin name mismatch: marketplace {entry.get('name')!r} vs plugin.json {plugin.get('name')!r}")
if entry.get("source") != "./":
    fail(f"marketplace source must be './' (this repo is the plugin), got {entry.get('source')!r}")
if entry.get("version") != plugin.get("version"):
    fail(f"version mismatch: marketplace {entry.get('version')!r} vs plugin.json {plugin.get('version')!r}")

version = plugin["version"]
if not SEMVER.match(version):
    fail(f"version {version!r} is not strict semver X.Y.Z (lockstep tags need an exact match)")

expected = os.environ.get("EXPECTED_VERSION")
if expected and version != expected:
    fail(f"plugin.json version {version!r} != expected tag version {expected!r}")

# Skill layout: every skills/<dir> has a SKILL.md with matching frontmatter name.
skills_dir = "skills"
names = sorted(d for d in os.listdir(skills_dir) if os.path.isdir(os.path.join(skills_dir, d)))
if not names:
    fail("no skills found under skills/")
for name in names:
    path = os.path.join(skills_dir, name, "SKILL.md")
    if not os.path.isfile(path):
        fail(f"{path} missing")
    text = open(path).read()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    if not m:
        fail(f"{path} has no YAML frontmatter")
    fm = m.group(1)
    fm_name = re.search(r"^name:\s*(\S+)\s*$", fm, re.MULTILINE)
    fm_desc = re.search(r"^description:\s*(.+)$", fm, re.MULTILINE)
    if not fm_name or fm_name.group(1) != name:
        fail(f"{path} frontmatter name must equal its directory name {name!r}")
    if not fm_desc or not fm_desc.group(1).strip():
        fail(f"{path} frontmatter needs a non-empty description")

print(f"check-version: OK — plugin {plugin['name']!r} v{version}, {len(names)} skills ({', '.join(names)})")
PYEOF
