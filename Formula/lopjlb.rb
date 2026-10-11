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
  url "https://files.pythonhosted.org/packages/0a/b3/f4ad624a9665d6edaf11fe44c403191c72069b5a86ba345bec3e764e7e72/lopjlb-0.1.7.tar.gz"
  # sha256 filled by release workflow after PyPI publish; placeholder fails brew until then
  sha256 "24f87e1c757a25fa019874c7ac1aa67a978fddd2a4d369d033feacbc809ee797"
  license "LicenseRef-LOPJLB-Proprietary"
  version "0.1.7"

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
      lopjlb is a REST client. MCP is a separate Enterprise host surface:
        POST https://www.lopjlb.com/bff/api/mcp
      Free research needs no API key: lopjlb ticker AAPL
      Agent skill: npx skills add lopjlb/lopjlb-skill
      Agent claim (AuthKit): https://www.lopjlb.com/auth.md · lopjlb auth claim
      Enterprise REST: export LOPJLB_API_KEY=… && lopjlb export signals
    EOS
  end
end
