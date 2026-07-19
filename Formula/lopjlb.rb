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
  url "https://files.pythonhosted.org/packages/d4/16/c6fbb0d84bb2dcde49f6ef805a5997382cf5623ff463d4b5766dce73f374/lopjlb-0.1.1.tar.gz"
  # sha256 filled by release workflow after PyPI publish; placeholder fails brew until then
  sha256 "c69514be471c88221cba08fd81143af733c89832e733d511da0db86eefb66d4b"
  license "LicenseRef-LOPJLB-Proprietary"
  version "0.1.1"

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
      Enterprise REST: export LOPJLB_API_KEY=… && lopjlb export signals
    EOS
  end
end
