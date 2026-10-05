class AgentFence < Formula
  desc "Shared permission policy for coding agent tool calls"
  homepage "https://github.com/Abelo9996/agent-fence"
  url "https://registry.npmjs.org/@abelo9996/agent-fence/-/agent-fence-0.2.0.tgz"
  sha256 "34cef342e73f28467e1574b06a5f6add55c7fb4ef48d2a9aa614cfb0164eb9b4"
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
