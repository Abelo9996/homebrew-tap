class RerunBench < Formula
  include Language::Python::Virtualenv

  desc "Run one coding task many times per agent to measure consistency and cost"
  homepage "https://github.com/Abelo9996/rerun-bench"
  url "https://files.pythonhosted.org/packages/5c/0c/c70c7680385b81f4eed6ed4e225e70ef898920085968dac6b335e1dcf93e/rerun_bench-0.2.0.tar.gz"
  sha256 "7d34a76fe1a1b045755bd9bd47628af5c796447a632e1fc935463a9254b65dbe"
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
