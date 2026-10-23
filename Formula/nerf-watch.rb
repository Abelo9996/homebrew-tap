class NerfWatch < Formula
  desc "See and cut what loads into every coding agent session, and flag regressions"
  homepage "https://github.com/Abelo9996/nerf-watch"
  url "https://registry.npmjs.org/nerf-watch/-/nerf-watch-0.5.0.tgz"
  sha256 "7427b9a1b5405c38dd7ce787f272c15def50f93810e76c7edffb532d8e9d037b"
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
