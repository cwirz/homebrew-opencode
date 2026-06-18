class OpencodeCwirz < Formula
  desc "OpenCode fork: compact tool schemas + lazy MCP tool loading"
  homepage "https://github.com/cwirz/opencode"
  url "https://github.com/cwirz/opencode/releases/download/v1.17.8-cwirz/opencode-cwirz-darwin-arm64.tar.gz"
  sha256 "0224c30d1ab7272ceace5bcbdd3bcb290b6d1a0dbd6b3bdc48b9099a21221ebe"
  version "1.17.8-cwirz"

  # ponytail: darwin-arm64 only; add on_intel/on_linux blocks when a teammate needs them
  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "opencode" => "opencode-cwirz"
  end

  test do
    assert_match "1.17.8-cwirz", shell_output("#{bin}/opencode-cwirz --version")
  end
end
