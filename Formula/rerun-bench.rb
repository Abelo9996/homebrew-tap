class RerunBench < Formula
  include Language::Python::Virtualenv

  desc "Run one coding task many times per agent to measure consistency and cost"
  homepage "https://github.com/Abelo9996/rerun-bench"
  url "https://files.pythonhosted.org/packages/58/7c/9daacc4c1842727ca76ed509d26331760198c524b745857295b8757ab7d5/rerun_bench-0.3.0.tar.gz"
  sha256 "b9541a9a6050bf2c9b151c962807d9fdea3225aa802af1e3fbf78c96470b67fa"
  license "MIT"

  depends_on "python@3.13"

  # rerun-bench has no runtime Python dependencies, so there are no resource blocks.
  # Regenerate with `brew update-python-resources rerun-bench` if that changes.

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rerun-bench --version")

    tasks = shell_output("#{bin}/rerun-bench list")
    assert_match "add-cli-flag", tasks
    assert_match "fix-failing-test", tasks
  end
end
