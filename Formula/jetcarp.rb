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
  version "0.4.1"
  license any_of: ["Unlicense", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.1/jetcarp-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "73e0a4cccd125bca2dca8c3da6f351aadb5ef214d77461d9fea207d6830f9686"
    end
    on_intel do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.1/jetcarp-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "7e059a3118c59cda15cd235b88ed9a83aa5f52ffa32f9cc9a5c0e4c2b5ce2b2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.1/jetcarp-0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fb621740c7932dd55163250734272bd0ddaed34389a9e4a6150b7552300e0d59"
    end
    on_intel do
      url "https://github.com/jprodgers/jetcarp/releases/download/v0.4.1/jetcarp-0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3455eac047c030059236a5e0077ff733ec3e2f2943753974b8b48580492c02c8"
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
