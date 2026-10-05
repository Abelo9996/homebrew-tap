class NerfWatch < Formula
  desc "Flag coding agent regressions and cost changes from local session logs"
  homepage "https://github.com/Abelo9996/nerf-watch"
  url "https://registry.npmjs.org/nerf-watch/-/nerf-watch-0.3.0.tgz"
  sha256 "fa19a2157a36d606bf8b8b53323bacc44aa865c19ea57e020dd6f30a3d0924c8"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerf-watch --version")

    # One recorded Claude Code response in the on-disk session log format.
    (testpath/"claude/demo-project/session-1.jsonl").write <<~JSONL
      {"type":"assistant","sessionId":"s1","version":"2.1.100","cwd":"/work","timestamp":"2026-09-01T00:00:00.000Z","requestId":"req_1","message":{"id":"msg_1","model":"test-model-1","content":[],"stop_reason":"end_turn","usage":{"input_tokens":5,"cache_creation_input_tokens":100,"cache_read_input_tokens":1000,"output_tokens":42}}}
    JSONL

    output = shell_output("#{bin}/nerf-watch scan --agent claude --root claude=#{testpath}/claude --json")
    data = JSON.parse(output)
    assert_equal 1, data["summary"]["turns"]
    segment = data["segments"].first
    assert_equal "test-model-1", segment["model"]
    assert_equal "2.1.100", segment["cliVersion"]
    assert_equal 42, segment["medianOutputTokens"]
  end
end
