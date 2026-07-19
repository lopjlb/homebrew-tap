# homebrew-tap (lopjlb)

Homebrew formula for the **lopjlb** CLI (REST client over `https://www.lopjlb.com/bff/api/`).

MCP is a **separate** Enterprise host surface (`POST /bff/api/mcp`). The CLI does not require MCP.

## Create the public tap (one-time)

```bash
# with gh auth
gh repo create lopjlb/homebrew-tap --public --description "Homebrew tap for lopjlb CLI"
# seed from this mirror
git clone https://github.com/lopjlb/homebrew-tap.git
cp -R packaging/homebrew-tap/* /path/to/homebrew-tap/
# after first PyPI publish, fill sha256 via:
#   bash scripts/bump_homebrew_formula.sh 0.1.0
cd /path/to/homebrew-tap && git add . && git commit -m "lopjlb 0.1.0" && git push
```

## Users

```bash
brew tap lopjlb/tap https://github.com/lopjlb/homebrew-tap
brew install lopjlb/tap/lopjlb
```

Until PyPI + tap are live:

```bash
uv tool install lopjlb
curl -fsSL https://www.lopjlb.com/install.sh | sh
```

## Maintainers

1. Publish `packages/lopjlb` to PyPI (`lopjlb==X.Y.Z`).
2. `bash scripts/bump_homebrew_formula.sh X.Y.Z` (updates `url` + `sha256`).
3. Push Formula to `github.com/lopjlb/homebrew-tap`.
4. Optional CI: `.github/workflows/homebrew-tap-bump.yml` + secret `HOMEBREW_TAP_TOKEN`.
