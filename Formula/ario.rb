class Ario < Formula
  desc "A batteries-included terminal download manager powered by aria2"
  homepage "https://github.com/peymanAzad/ario"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/peymanAzad/ario/releases/download/v0.1.2/ario-aarch64-apple-darwin.tar.gz"
      sha256 "7156287530ec450f6a84a1dc02615cb61113865df13cdf1c31aa9c5c96aa4333"
    end
    if Hardware::CPU.intel?
      url "https://github.com/peymanAzad/ario/releases/download/v0.1.2/ario-x86_64-apple-darwin.tar.gz"
      sha256 "b07777ee4b93151659dde94df3c37ce8abd11e8aeee7bd190f80fcd3b352da6a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/peymanAzad/ario/releases/download/v0.1.2/ario-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "f4ca54962e00ff7df416bf9f228208e862624e3d8466cb182f236f0d69a259d7"
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
