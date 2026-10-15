class Mtdis < Formula
  include Language::Python::Virtualenv

  desc "Run background tasks on macOS only when internet, power, CPU, RAM and GPU allow"
  homepage "https://github.com/DongkuKim/mac-task-dispatcher"
  url "https://github.com/DongkuKim/mac-task-dispatcher/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "7830bf70e767311cc09db6b6c4304c1113b6732058b2ac3aa86809c027b74a41"
  license "MIT"

  depends_on :macos
  depends_on "python@3.15"
  depends_on "tmux"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      mtdis needs Hammerspoon to react to network, power and wake events:
        brew install --cask hammerspoon
        mtdis setup
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtdis --version")
    ENV["MTDIS_CONFIG_DIR"] = testpath/"config"
    ENV["MTDIS_STATE_DIR"] = testpath/"state"
    system bin/"mtdis", "add", "hello", "--no-run", "--", "echo", "hi"
    assert_match "hello", shell_output("#{bin}/mtdis list")
  end
end
