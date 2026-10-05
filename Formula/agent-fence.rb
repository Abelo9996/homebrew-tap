class AgentFence < Formula
  desc "Shared permission policy for coding agent tool calls"
  homepage "https://github.com/Abelo9996/agent-fence"
  url "https://registry.npmjs.org/@abelo9996/agent-fence/-/agent-fence-0.1.1.tgz"
  sha256 "cf6da454d4d8debc7a12408fd6c4b6848ae22509cbcbf20c158f7d428b3eddc4"
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
