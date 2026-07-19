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
  url "https://files.pythonhosted.org/packages/12/73/b925ea417c6bd8a4bb24af27ce38259bbd65de576133fc5719925bea4448/lopjlb-0.1.0.tar.gz"
  # sha256 filled by release workflow after PyPI publish; placeholder fails brew until then
  sha256 "a8eaec68d2497c5013cbdd9f855fe5560d05919b6fd79c26eaab309e77184d7a"
  license "LicenseRef-LOPJLB-Proprietary"
  version "0.1.0"

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
