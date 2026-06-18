class OpencodeCwirz < Formula
  desc "OpenCode fork: compact tool schemas + lazy MCP tool loading"
  homepage "https://github.com/cwirz/opencode"
  url "https://github.com/cwirz/opencode/releases/download/v1.17.8-cwirz/opencode-cwirz-darwin-arm64.tar.gz"
  sha256 "a48753e65f34d67eda4932af45c3478cb6ce079065f2c298e4107cedac64e422"
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
