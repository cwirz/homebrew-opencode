class OpencodeCwirz < Formula
  desc "OpenCode fork: compact tool schemas + lazy MCP tool loading"
  homepage "https://github.com/cwirz/opencode"
  url "https://github.com/cwirz/opencode/releases/download/v0.1.0-cwirz/opencode-cwirz-darwin-arm64.tar.gz"
  sha256 "32b9d7e830aa460e5359a2e95081b77b9573ad52596a2eaa48bfa2cb165aeb96"
  version "0.1.0-cwirz"

  # ponytail: darwin-arm64 only; add on_intel/on_linux blocks when a teammate needs them
  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "opencode" => "opencode-cwirz"
  end

  test do
    assert_match "0.1.0-cwirz", shell_output("#{bin}/opencode-cwirz --version")
  end
end
