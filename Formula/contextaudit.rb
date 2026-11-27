class Contextaudit < Formula
  desc "Measures the real value of your AI coding-assistant context files (AGENTS.md, CLAUDE.md) by running the assistants in isolated containers."
  homepage "https://github.com/280Zo/contextaudit"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/280Zo/contextaudit/releases/download/v0.1.3/contextaudit-aarch64-apple-darwin.tar.xz"
    sha256 "0644b9ed00539566ad44d5eb12ae20c2965fba26d83206305a35815c432330c1"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/280Zo/contextaudit/releases/download/v0.1.3/contextaudit-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2999e90a3bda02bdd2f579552d2b61b10da1cd33163426cff275ab1ad2e3ff80"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
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
      bin.install "contextaudit"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "contextaudit"
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
