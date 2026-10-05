# Abelo9996 Homebrew tap

Homebrew formulae and casks for tools by [Abelo9996](https://github.com/Abelo9996). The formulae work on macOS and Linux; the cask is macOS only.

| Name | What it is | Install |
| --- | --- | --- |
| [nerf-watch](https://github.com/Abelo9996/nerf-watch) | CLI that flags coding agent regressions and cost changes from local session logs | `brew install abelo9996/tap/nerf-watch` |
| [snap-back](https://github.com/Abelo9996/snap-back) | CLI that snapshots a project into a shadow git repo so you can roll back coding agent edits | `brew install abelo9996/tap/snap-back` |
| [agent-fence](https://github.com/Abelo9996/agent-fence) | One permission policy for every coding agent (commands `agent-fence` and `agent-fence-shell`) | `brew install abelo9996/tap/agent-fence` |
| [rerun-bench](https://github.com/Abelo9996/rerun-bench) | Runs one coding task many times per agent to measure consistency and cost | `brew install abelo9996/tap/rerun-bench` |
| [nerf-watch-app](https://github.com/Abelo9996/nerf-watch) (cask) | Nerf Watch menu bar app for macOS 13 or later; installs the nerf-watch CLI too | `brew install --cask abelo9996/tap/nerf-watch-app` |

## Installing

Use the full `abelo9996/tap/<name>` form shown above. Homebrew taps the repository on first use, and since Homebrew 6.0 that form also trusts only the item you install, not the whole tap ([Tap Trust](https://docs.brew.sh/Tap-Trust)).

To use short names instead, tap once and trust the specific items:

```sh
brew tap abelo9996/tap
brew trust --formula abelo9996/tap/nerf-watch
brew install nerf-watch
```

Upgrades arrive with the usual `brew update && brew upgrade`. Remove a tool with `brew uninstall <name>` (or `brew uninstall --cask nerf-watch-app`), and the tap with `brew untap abelo9996/tap`.

The npm based formulae depend on Homebrew's `node`; `rerun-bench` depends on `python@3.13`. Everything is installed inside Homebrew's prefix and does not touch your global npm or Python packages.

## nerf-watch-app first launch

The Nerf Watch app is ad-hoc signed and **not notarized by Apple**. Homebrew keeps macOS quarantine on cask downloads, so Gatekeeper still checks the app and blocks the first launch. That is expected. To allow this one app, and nothing else:

1. Open **Nerf Watch** from `/Applications`. macOS says it could not verify the app; click **Done** (not Move to Trash).
2. Open **System Settings > Privacy & Security**, scroll to the Security section, find the message about "Nerf Watch" and click **Open Anyway**. Confirm with your password or Touch ID.
3. Later launches open normally. After an upgrade to a new version you may need to repeat step 2 once.

On macOS 14 and earlier you can instead Control-click the app in Finder, choose **Open**, then **Open** again.

Do not turn off Gatekeeper system-wide for this; the steps above approve only this app. If you want to check what you are approving first, the cask pins the SHA-256 of the release zip, and the app's source is in [Abelo9996/nerf-watch](https://github.com/Abelo9996/nerf-watch/tree/main/apps/macos).

The app runs the `nerf-watch` CLI in the background, so the cask depends on the `nerf-watch` formula. To also remove the app's settings and saved state: `brew uninstall --zap --cask nerf-watch-app`.

## Updating a formula or cask after a release

Run these from a machine with the tap installed (`brew tap abelo9996/tap`) and `gh` logged in as the tap owner.

**npm formulae** (nerf-watch, snap-back, agent-fence), after the new version is on npm:

```sh
brew bump-formula-pr --no-fork --version 0.2.2 abelo9996/tap/nerf-watch
```

Homebrew rewrites the registry tarball URL for the new version, downloads it, fills in the SHA-256 and opens a pull request on this repo. CI on the pull request installs and tests the new version on macOS and Linux. Merge it when green. For scoped packages the command is the same: `brew bump-formula-pr --no-fork --version 0.1.2 abelo9996/tap/snap-back`.

**rerun-bench**, after the new version is on PyPI:

```sh
brew bump-formula-pr --no-fork --version 0.1.2 abelo9996/tap/rerun-bench
```

If the release adds runtime dependencies to `pyproject.toml`, regenerate the resource blocks before merging: `brew update-python-resources abelo9996/tap/rerun-bench`.

**nerf-watch-app**, after `NerfWatch-macOS.zip` is attached to the new GitHub release:

```sh
brew bump-cask-pr --no-fork --version 0.2.2 abelo9996/tap/nerf-watch-app
```

**Manual bump** (works for every formula and the cask):

```sh
# 1. Hash the new artifact (pick the line that matches the formula)
curl -sL https://registry.npmjs.org/nerf-watch/-/nerf-watch-0.2.2.tgz | shasum -a 256
curl -sL https://registry.npmjs.org/@abelo9996/snap-back/-/snap-back-0.1.2.tgz | shasum -a 256
curl -sL https://registry.npmjs.org/@abelo9996/agent-fence/-/agent-fence-0.1.2.tgz | shasum -a 256
curl -sL https://github.com/Abelo9996/nerf-watch/releases/download/v0.2.2/NerfWatch-macOS.zip | shasum -a 256
# rerun-bench: copy the sdist URL and SHA-256 from https://pypi.org/project/rerun-bench/#files
#   (the "Download files" table lists the sha256 of rerun_bench-<version>.tar.gz)

# 2. Edit Formula/<name>.rb (url and sha256) or Casks/nerf-watch-app.rb (version and sha256)

# 3. Check it locally, then commit and push
brew install --build-from-source abelo9996/tap/nerf-watch
brew test abelo9996/tap/nerf-watch
brew audit --strict --online abelo9996/tap/nerf-watch
brew style abelo9996/tap
```

A formula's `version` comes from its URL, so only `url` and `sha256` change. A cask's `url` is built from `version`, so only `version` and `sha256` change.

## CI

Every push and pull request runs, on `macos-latest` and on `ubuntu-latest` in Homebrew's Linux container: `brew style`, `brew audit --strict --online` on every formula and the cask, then `brew install --build-from-source` and `brew test` for each formula. On macOS it also installs and uninstalls the cask. The standard `brew tap-new` workflow also runs `brew test-bot`: its tap syntax check on every push, and its full formula build and test on pull requests.

`brew audit --new` is not part of CI. It checks eligibility for Homebrew's official repositories, and for the cask it reports two expected problems: the app is not notarized, and the repository is below homebrew/cask's notability threshold. Neither applies to a personal tap.

## License

[MIT](LICENSE)
