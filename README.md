# tufts-lean-seminar

Lean 4 / Mathlib project for the Tufts Lean seminar.

## Setup

1. **Install `elan` (the Lean version manager) and the
   [VS Code Lean 4 extension](https://marketplace.visualstudio.com/items?itemName=leanprover.lean4).**
   You might have done this already. `elan` will fetch the correct Lean
   toolchain for this project automatically.

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

4. **Open the project in VS Code.** Open the `tufts-lean-seminar` folder
   directly (not just a single file) so the Lean 4 extension can find the
   project's `lakefile.toml`.

## Where to work

Do your own work under
[`TuftsLeanSeminar/Work`](TuftsLeanSeminar/Work/README.md). That directory
is excluded from git (aside from its `README.md`), so you can freely add,
edit, and delete `.lean` files there without ever causing a merge conflict
with the seminar repo or with other participants.

If you want to edit a file from `Lecture/` or `Homework/` (e.g. to work
through the exercises in place), **copy it into `Work/` first** and edit
the copy there, rather than editing it where it sits. That way `git pull`
never has to reconcile your edits with mine.

## Staying up to date

To pull in updates from the seminar repo:

```sh
git pull
lake exe cache get
lake build
```

## If something goes wrong

If you *did* edit a tracked file directly (outside `Work/`) and `git pull`
now refuses because it would overwrite your local changes, you have two
options:

* **You don't care about your edits — discard them:**

  ```sh
  git restore <path/to/file.lean>
  ```

  Then `git pull` again.

* **You want to keep your edits for later:** stash them out of the way,
  pull, and (optionally) bring them back:

  ```sh
  git stash        # sets your local changes aside
  git pull
  git stash pop    # re-applies them, on top of the update
  ```

  `git stash pop` can itself report a conflict if the file changed
  upstream in the same place you edited it. If that happens, it's usually
  easiest to just copy the piece of your work you want to keep into a new
  file under `Work/`, then `git checkout <path/to/file.lean>` to drop the
  stashed change entirely.

When in doubt, `git status` will tell you what's going on.
