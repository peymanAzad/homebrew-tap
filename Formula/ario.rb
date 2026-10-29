class Ario < Formula
  desc "A batteries-included terminal download manager powered by aria2"
  homepage "https://github.com/peymanAzad/ario"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/peymanAzad/ario/releases/download/v0.1.0/ario-aarch64-apple-darwin.tar.gz"
      sha256 "dfe6896308f6b9fbd998c09cbd1606ca9147e3b24b742615f10ab754819fb30e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/peymanAzad/ario/releases/download/v0.1.0/ario-x86_64-apple-darwin.tar.gz"
      sha256 "5a43c064e16e20eb67ddcf097b3662b69d98d17c5331f6a732ded07a5c3f9915"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/peymanAzad/ario/releases/download/v0.1.0/ario-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "88d6a4fc250b5cc0aedfb8ec40bf439f2b31ac1c7bc92f21a6860f4c94e81e99"
  end
  license "MIT"
  depends_on "aria2"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ario", "ario_daemon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ario", "ario_daemon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ario", "ario_daemon"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
