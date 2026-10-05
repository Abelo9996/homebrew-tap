class RerunBench < Formula
  include Language::Python::Virtualenv

  desc "Run one coding task many times per agent to measure consistency and cost"
  homepage "https://github.com/Abelo9996/rerun-bench"
  url "https://files.pythonhosted.org/packages/e8/a9/16c9a30f68c7e454c5f7ae7cc3c80f796a214dbba7ce57848068cd98e70d/rerun_bench-0.1.1.tar.gz"
  sha256 "19aa3eb7a8031a6b32349dbf153ba8223bf75f83b7371aff0497c08375146aeb"
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
