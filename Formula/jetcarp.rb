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
  version "0.4.2"
  license any_of: ["Unlicense", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.2/jetcarp-0.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "46eb5a57251dbe155dd3148e052be4e035a9c3dcd6ae61a9a01495b0e90e47f7"
    end
    on_intel do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.2/jetcarp-0.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "d9631c0caf810b8f08e92dea7b9cdb09bfd3491841dca703ee48a17adcf20040"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.2/jetcarp-0.4.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1258204f9e5ab472d7b866d8c0caec983fe6be2233d5198cd00d8db2c0d111e2"
    end
    on_intel do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.2/jetcarp-0.4.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d1517c0b431e0023041631b242faf113aedaf6a5530e9485b554cbeadf8524db"
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

  # No post_install step registers the login item with launchd: Homebrew may run it in a sandbox.
  # The program does it itself when the app or the host starts.
  def caveats
    <<~EOS
      Before `brew uninstall jetcarp`, run `jetcarp uninstall` to undo what JETCARP set up
      outside its folders (the background host, login item and screen saver).

      On macOS, after `brew upgrade jetcarp`: if the desktop background starts at login, open
      the JETCARP app or run `jetcarp host start` once, so that macOS accepts the new version
      at login.
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
