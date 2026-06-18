# homebrew-opencode

Homebrew tap for the [cwirz/opencode](https://github.com/cwirz/opencode) fork of
[OpenCode](https://github.com/anomalyco/opencode).

Tracks the upstream version and appends `-cwirz` (e.g. `1.17.8-cwirz`).

## Install

```sh
brew install cwirz/opencode/opencode-cwirz
```

Installs as `opencode-cwirz`, coexists side-by-side with the official `opencode`.
Optionally alias it:

```sh
alias opencode=opencode-cwirz
```

### Updating

```sh
brew upgrade cwirz/opencode/opencode-cwirz
```

If a release rebuilds the **same** version string (same upstream version, new
fork patch), use `reinstall` instead — brew won't see a version bump:

```sh
brew reinstall cwirz/opencode/opencode-cwirz
```

## What this fork adds

Two opt-in features that cut the tool-schema tokens sent to the model (~50k+
tokens reclaimed on a heavy MCP setup), plus a distribution fix so it shares the
official app's session history.

### 1. Compact tool schemas — `experimental.tool_schema: "compact"`

Strips prose (descriptions, examples, titles) from tool JSON schemas and caps
tool descriptions at 800 chars before sending them to the provider. A synthetic
`tool_schema` tool is injected so the agent can pull the full description/schema
for any tool on demand when it actually needs the detail.

```jsonc
// ~/.config/opencode/opencode.json
{
  "experimental": { "tool_schema": "compact" }
}
```

Default is `"full"` (unchanged upstream behavior).

### 2. Lazy MCP tool loading — `experimental.mcp_lazy` + `mcp.<server>.lazy`

Connects MCP servers as usual but **withholds their tools** from the model until
needed. A tiny hint lists the deferred servers and tool counts; the agent calls
the injected `mcp_load` tool to activate a server's tools for the session.

Use it for heavy MCP servers you only touch occasionally (e.g. chrome-devtools
~35 tools) while keeping always-used ones (e.g. gitlab) eager.

```jsonc
// ~/.config/opencode/opencode.json
{
  "experimental": { "mcp_lazy": true },
  "mcp": {
    "chrome-devtools": { "lazy": true },
    "bright-data":     { "lazy": true },
    "gitlab":          { /* eager — no lazy flag */ }
  }
}
```

Both flags require nothing upstream-breaking; with them unset the fork behaves
like stock OpenCode.

### 3. Shared session database (fork-only)

Stock OpenCode gives source/local builds their own `opencode-<channel>.db`, so a
non-official binary would start with an empty session list. This fork makes the
`local` channel read the **same `opencode.db`** as the official app, so your
existing sessions carry over.

**Caveat:** both binaries then share one SQLite file. Safe as long as the fork
stays on the **same upstream version** as your installed official app (identical
DB schema; WAL + busy_timeout handle concurrent access). If a future upstream
merge changes DB migrations, whichever app opens the file first migrates it —
keep the versions aligned.

## Maintainer notes (releasing a new version)

1. In the fork checkout: merge upstream `dev`, resolve, commit.
2. Build darwin-arm64 only (single-target patch to `build.ts`), version
   `<upstream>-cwirz`, `OPENCODE_CHANNEL=local`.
3. `tar -czf opencode-cwirz-darwin-arm64.tar.gz -C dist/opencode-darwin-arm64/bin opencode`
   and `shasum -a 256` it.
4. Tag `v<upstream>-cwirz` on the fork, create the GitHub release, upload the tarball.
5. Update `Formula/opencode-cwirz.rb` (`url`, `sha256`, `version`, test assert) and push.
6. Team: `brew upgrade` (new version) or `brew reinstall` (rebuilt same version).

Currently darwin-arm64 only (whole team is on Apple Silicon). Add `on_intel` /
`on_linux` blocks + matching release assets when another platform is needed.
