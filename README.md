# homebrew-diskgraph

Homebrew tap for [DiskGraph](https://github.com/loong10k/diskgraph) — a Rust
file-relationship engine for AI agents and PruneX.

```bash
brew tap loong10k/diskgraph
brew trust loong10k/diskgraph     # Homebrew 7 requires trusting third-party taps
brew install diskgraph            # or: brew install loong10k/diskgraph/diskgraph
```

Homebrew 7.0.7 refuses to load a formula from an untrusted third-party
tap, so the `brew trust` step is required, not optional.

Verified against Homebrew 7.0.7: the two-step form above resolves to
`loong10k/diskgraph/diskgraph: stable 0.1.0`. Note that `brew install
loong10k/diskgraph` alone does NOT work — Homebrew reads the second
path segment as a *formula* name, not a tap, so the tap name must be
prefixed with `homebrew-` and the formula name spelled out (or omitted
only after the tap exists locally, as in the first command).

Installs two binaries:

- `diskgraph` — the CLI (scope/index/query surfaces, JSON envelopes)
- `diskgraph-mcp` — the MCP server (stdio, streamable-http, legacy-sse)

Both come from the project's GitHub releases, verified by SHA-256 before
install. The formula's `test do` block runs a full scope→index→query round
trip, so a broken archive fails the install instead of landing on PATH.

## Channels

| Channel | Command |
| :--- | :--- |
| Homebrew (this tap) | `brew install loong10k/diskgraph/diskgraph` |
| npm (thin installer) | `npx -y diskgraph --version` |
| source | `cargo install --path crates/diskgraph-cli` (from a checkout) |
| Windows | `winget install loong10k.DiskGraph` / `scoop install diskgraph` |

All channels resolve to the same release artifacts.

## Updating

`Formula/diskgraph.rb` pins the release version and per-architecture
SHA-256 digests; bump them when a new release is published. Unsigned
binaries mean macOS Gatekeeper will warn on first run.
