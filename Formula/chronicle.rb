class Chronicle < Formula
  desc "Local-first, privacy-driven activity tracker with a correctable timeline and chat."
  homepage "https://chronicled.dev"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/james-clarke/chronicle/releases/download/v0.1.2/chronicle-aarch64-apple-darwin.tar.xz"
      sha256 "991e9cc3289cbe778e5f6ecaadcf4b2738dadb5cd4d760eff62a7419d3a6859f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/james-clarke/chronicle/releases/download/v0.1.2/chronicle-x86_64-apple-darwin.tar.xz"
      sha256 "0c7ee92d61905a8e01bd232e2afe5d22d7039a5654939a1ffd88fb53e74e0a24"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/james-clarke/chronicle/releases/download/v0.1.2/chronicle-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2c2c92dcbd5b676ef63c79a6934603af362695b6af562ad1ca7f5c44d250d9bc"
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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
      bin.install "chronicle"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "chronicle"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "chronicle"
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
