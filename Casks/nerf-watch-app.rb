cask "nerf-watch-app" do
  version "0.3.0"
  sha256 "70d68fdd3d38f377bc6e4610443cd1c1905eb8c42963920b2f5dd14218abcbba"

  url "https://github.com/Abelo9996/nerf-watch/releases/download/v#{version}/NerfWatch-macOS.zip"
  name "Nerf Watch"
  desc "Menu bar monitor for coding agent regressions and cost changes"
  homepage "https://github.com/Abelo9996/nerf-watch"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "abelo9996/tap/nerf-watch"
  depends_on macos: :ventura

  app "Nerf Watch.app"

  uninstall quit: "io.github.abelo9996.nerfwatch"

  zap trash: [
    "~/Library/Application Support/NerfWatch",
    "~/Library/Preferences/io.github.abelo9996.nerfwatch.plist",
  ]

  caveats <<~EOS
    Nerf Watch is ad-hoc signed and not notarized by Apple, so macOS blocks the
    first launch. To allow this one app:
      1. Open "Nerf Watch" from /Applications and click Done on the warning.
      2. Open System Settings > Privacy & Security, find the message about
         "Nerf Watch" and click Open Anyway, then confirm.
    Details: https://github.com/Abelo9996/homebrew-tap#nerf-watch-app-first-launch
  EOS
end
