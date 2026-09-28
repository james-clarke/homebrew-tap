class Chronicle < Formula
  desc "Local-first, privacy-driven activity tracker with a correctable timeline and chat."
  homepage "https://chronicled.dev"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/james-clarke/chronicle/releases/download/v0.1.1/chronicle-aarch64-apple-darwin.tar.xz"
      sha256 "56ec66aab4846118e826573c9a9cba37c420d6c1ff51cfa8eeeb0185d234a464"
    end
    if Hardware::CPU.intel?
      url "https://github.com/james-clarke/chronicle/releases/download/v0.1.1/chronicle-x86_64-apple-darwin.tar.xz"
      sha256 "616d834177143aa853ab224e038aceedf847a409c119c65025738e3142051237"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/james-clarke/chronicle/releases/download/v0.1.1/chronicle-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a9eb5d3afa3976408612e03e6a4ebcb4594ee3eca43065c3dbf725213d4523fd"
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
