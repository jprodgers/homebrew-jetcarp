# JETCARP's Homebrew formula. This file is the source of truth: the release workflow fills in the
# version and the archives' checksums (packaging/package.py manifests) and writes the result to
# the tap, github.com/jprodgers/homebrew-jetcarp, as Formula/jetcarp.rb.
#
#   brew tap jprodgers/jetcarp
#   brew install jetcarp
#
# (or `brew install jprodgers/jetcarp/jetcarp` in one line).
#
# It installs the release archives the workflow built; nothing is compiled.
class Jetcarp < Formula
  desc "Cellular automata on almost any tiling of the plane"
  homepage "https://jprodgers.github.io/jetcarp/"
  version "0.4.0"
  license any_of: ["Unlicense", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.0/jetcarp-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "bdd9c6e433afc8f08588cf9a647025fb7dcac9e4ce990666c62e2c2956794448"
    end
    on_intel do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.0/jetcarp-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "0ccfaa7ad64be4c2e82b9f189383002adfc3b343432c463b11c0d6a6d8170c94"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.0/jetcarp-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e9615b19abc9fa0b63f284088ff763f6158fd0a27c5a286c207e0471e1cd1963"
    end
    on_intel do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.0/jetcarp-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "45ee5c92ceeeff3cfec4551cee86198e559f493ce0165c9b6ece4229aa533325"
    end
  end

  def install
    bin.install "jetcarp"
    # The macOS screen saver's code: `jetcarp host saver install` looks for it in
    # ../lib/jetcarp from the program.
    (lib/"jetcarp").install "libjetcarp_saver.dylib" if OS.mac?
    # The starter pack, when the release has one: found as ../share/jetcarp/packs.
    pkgshare.install "packs" if File.directory?("packs")
    doc.install "README.md", "THIRD_PARTY_NOTICES.md", "THIRD_PARTY_LICENSES.html"
    prefix.install "COPYING", "UNLICENSE", "LICENSE-MIT"
  end

  def caveats
    <<~EOS
      Before `brew uninstall jetcarp`, run `jetcarp uninstall` to undo what JETCARP set up
      outside its folders (the background host, login item and screen saver).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jetcarp --version")
    ENV["JETCARP_CONFIG_DIR"] = testpath/"config"
    ENV["JETCARP_DATA_DIR"] = testpath/"data"
    ENV["JETCARP_OUT"] = testpath/"out"
    assert_match "settings: #{testpath}/config", shell_output("#{bin}/jetcarp paths")
  end
end
