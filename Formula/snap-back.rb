class SnapBack < Formula
  desc "Snapshot a project into a shadow git repo and roll back coding agent edits"
  homepage "https://github.com/Abelo9996/snap-back"
  url "https://registry.npmjs.org/@abelo9996/snap-back/-/snap-back-0.1.1.tgz"
  sha256 "b6248440b985e3e4e7d61619641bd0e9a8baa99bb0c61084d08883b6d586f7dc"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snap-back --version")

    ENV["SNAP_BACK_HOME"] = testpath/"snapshots"
    project = testpath/"project"
    project.mkpath
    (project/"notes.txt").write "first\n"

    cd project do
      snapshot = shell_output("#{bin}/snap-back snap")[/Snapshot (\h+)/, 1]
      refute_nil snapshot

      (project/"notes.txt").write "second\n"
      assert_match "notes.txt", shell_output("#{bin}/snap-back diff")

      system bin/"snap-back", "restore", snapshot, "--yes"
    end

    assert_equal "first\n", (project/"notes.txt").read
  end
end
