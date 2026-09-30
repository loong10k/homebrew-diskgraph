# DiskGraph — a Rust file-relationship engine for AI agents and PruneX.
#
# Installs the `diskgraph` CLI and the `diskgraph-mcp` MCP server from the
# project's signed-by-digest GitHub releases. The two binaries are expected
# in the release archive; `test do` runs the CLI, so a broken archive fails
# the install instead of landing on a user's PATH.
class Diskgraph < Formula
  desc "File-relationship engine for AI agents: disk usage, ownership, evidence, history"
  homepage "https://github.com/loong10k/diskgraph"
  url "https://github.com/loong10k/diskgraph/releases/download/v0.2.0/diskgraph-aarch64-apple-darwin.tar.gz"
  version "0.2.0"
  license "MIT"

  on_arm do
    url "https://github.com/loong10k/diskgraph/releases/download/v0.2.0/diskgraph-aarch64-apple-darwin.tar.gz"
    sha256 "cc670d358be92431f40a1b6fa98012a8e6d23b61dc5303590d4894064bd42cc5"
  end

  on_intel do
    url "https://github.com/loong10k/diskgraph/releases/download/v0.2.0/diskgraph-x86_64-apple-darwin.tar.gz"
    sha256 "c41617d1b238adfe14dde30d52028d18040834b49c99934526c4b1e405e5c34a"
  end

  def install
    # Homebrew strips the archive's single top-level directory when staging,
    # so the binaries land at bin/ inside the keg.
    bin.install "bin/diskgraph"
    bin.install "bin/diskgraph-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diskgraph --version")

    # A full scan/query round trip on a throwaway tree, so the formula only
    # passes when the installed CLI can actually index and answer. (Scope id
    # is pulled from the JSON text by pattern: the formula sandbox has no
    # json library and must not depend on one.)
    (testpath/"tree").mkpath
    (testpath/"tree/data.bin").write("x" * 1024)
    system bin/"diskgraph", "scope", "add",
           "--root", testpath/"tree", "--data-dir", testpath/"db", "--json"
    listing = shell_output("#{bin}/diskgraph scope list --data-dir #{testpath}/db --json")
    scope = listing[/scope-[0-9a-f-]{36}/]
    refute_nil scope, "scope add produced no scope id: #{listing}"
    system bin/"diskgraph", "index", "--scope", scope,
           "--data-dir", testpath/"db", "--wait", "--json"
    answer = shell_output("#{bin}/diskgraph node --scope #{scope} --data-dir #{testpath}/db --json")
    assert_match "\"ok\":true", answer
    assert_match "\"complete\":true", answer
  end
end
