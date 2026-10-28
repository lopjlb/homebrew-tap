# frozen_string_literal: true

# Homebrew formula for the lopjlb CLI (REST client).
# Tap mirror: packaging/homebrew-tap → github.com/lopjlb/homebrew-tap
#
#   brew tap lopjlb/tap https://github.com/lopjlb/homebrew-tap
#   brew install lopjlb/tap/lopjlb
#
# After each PyPI release, update `url` + `sha256` (see homebrew-tap-bump.yml).

class Lopjlb < Formula
  desc "LOPJLB quantitative equity research CLI (REST over www.lopjlb.com/bff/api)"
  homepage "https://www.lopjlb.com/developers"
  url "https://files.pythonhosted.org/packages/9a/6d/4eda6020be33efb59c814f12bc598657d87bfa84b96c36b4d74aa04b1073/lopjlb-0.1.8.tar.gz"
  sha256 "685b8ab97b593ff77435b10a18d3085b6d1a9d43d7d5e278a5313ce85cac1e40"
  license "LicenseRef-LOPJLB-Proprietary"
  version "0.1.8"

  depends_on "python@3.12"

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
    venv = libexec/"venv"
    system python, "-m", "venv", venv
    system venv/"bin/pip", "install", "--upgrade", "pip"
    system venv/"bin/pip", "install", "lopjlb==#{version}"
    bin.install_symlink venv/"bin/lopjlb"
  end

  test do
    output = shell_output("#{bin}/lopjlb doctor")
    assert_match "surfaces", output
    assert_match "REST", output
  end

  def caveats
    <<~EOS
      lopjlb is a REST client. MCP is a separate host surface, on every plan:
        https://www.lopjlb.com/mcp (sign in with your LOPJLB account)
      Free research needs no API key: lopjlb ticker AAPL
      Agent skill: npx skills add lopjlb/lopjlb-skill
      Agent claim (AuthKit): https://www.lopjlb.com/auth.md · lopjlb auth claim
      Enterprise REST: export LOPJLB_API_KEY=… && lopjlb export signals --out signals.csv
    EOS
  end
end
