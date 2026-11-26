class Contextaudit < Formula
  desc "Measures the real value of your AI coding-assistant context files (AGENTS.md, CLAUDE.md) by running the assistants in isolated containers."
  homepage "https://github.com/280Zo/contextaudit"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/280Zo/contextaudit/releases/download/v0.1.2/contextaudit-aarch64-apple-darwin.tar.xz"
    sha256 "8822c14fdbc932b09fcc3a821eaffaed1f03fb918cb0c0f6571a74339e04fac9"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/280Zo/contextaudit/releases/download/v0.1.2/contextaudit-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "599f2bb2e97e4cc2d9c5873eec3d6e6124058c2e1f8a3fc8af1a780c320d210f"
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
