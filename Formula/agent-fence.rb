class AgentFence < Formula
  desc "Shared permission policy for coding agent tool calls"
  homepage "https://github.com/Abelo9996/agent-fence"
  url "https://registry.npmjs.org/@abelo9996/agent-fence/-/agent-fence-0.3.0.tgz"
  sha256 "c8d3eae160a892e32837db3dcae515e843e5383fef52b8141940c8bcf8b6d59f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-fence --version")

    denied = shell_output("#{bin}/agent-fence check --tool bash --input 'rm -rf /'", 3)
    assert_match "DENY", denied
    assert_match "rm-root-or-home", denied

    assert_match "ALLOW", shell_output("#{bin}/agent-fence check --tool bash --input 'ls -la'")

    assert_equal "fenced\n", shell_output("#{bin}/agent-fence-shell -c 'echo fenced'")
  end
end
