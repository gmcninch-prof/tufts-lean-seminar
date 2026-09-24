# tufts-lean-seminar

Lean 4 / Mathlib project for the Tufts Lean seminar.

## Setup

1. **Install `elan`** (the Lean version manager), if you don't already have
   it. It will fetch the correct Lean toolchain for this project
   automatically.

   ```sh
   curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
   ```

   See the
   [Lean installation guide](https://leanprover-community.github.io/get_started.html)
   for platform-specific instructions (including VS Code setup) if you run
   into trouble.

2. **Clone this repository.**

   ```sh
   git clone https://github.com/gmcninch-prof/tufts-lean-seminar.git
   cd tufts-lean-seminar
   ```

3. **Fetch prebuilt Mathlib binaries and build the project.**

   ```sh
   lake exe cache get
   lake build
   ```

   `lake exe cache get` downloads prebuilt `.olean` files for Mathlib and
   its dependencies, which saves you from having to compile them locally
   (this can take a very long time otherwise).

4. **Open the project in VS Code** with the
   [Lean 4 extension](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4)
   installed, and open the `tufts-lean-seminar` folder directly (not just a
   single file) so the extension can find the project's `lakefile.toml`.

## Where to work

Do your own work under
[`TuftsLeanSeminar/Work`](TuftsLeanSeminar/Work/README.md). That directory
is excluded from git (aside from its `README.md`), so you can freely add,
edit, and delete `.lean` files there without ever causing a merge conflict
with the seminar repo or with other participants.

## Staying up to date

To pull in updates from the seminar repo:

```sh
git pull
lake exe cache get
lake build
```
