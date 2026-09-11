class Chronicle < Formula
  desc "Local-first, privacy-driven activity tracker with a correctable timeline and chat."
  homepage "https://chronicled.dev"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/james-clarke/chronicle/releases/download/v0.1.0/chronicle-aarch64-apple-darwin.tar.xz"
      sha256 "4c047dfb2122580d1bbe1205aa7506dfa634d06aa19b87a16b9889cf2fb98530"
    end
    if Hardware::CPU.intel?
      url "https://github.com/james-clarke/chronicle/releases/download/v0.1.0/chronicle-x86_64-apple-darwin.tar.xz"
      sha256 "0bd64e850c14c0edc9df78cfce031112e5e39dea62793e2b82e50d001b34fd12"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/james-clarke/chronicle/releases/download/v0.1.0/chronicle-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e34ad7c52043d7ff51a94168c53ba24ed818b4204b70942d526724e50d8cd614"
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
