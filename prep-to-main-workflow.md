# Publishing files from `prep` to `main`

Workflow for copying finished seminar files from the private `prep` branch
into the participant-facing `main` branch, without merging `prep`'s full
history (which may contain drafts of future material).

## Command line

```bash
git checkout main
git checkout prep -- path/to/file1.lean path/to/file2.lean
git commit -m "Add week N materials"
git push origin main
```

`git checkout prep -- <paths>` pulls just those specific files from `prep`
into whatever branch you're currently on (`main`), without bringing along
the rest of `prep`'s tree or history.

Then switch back to `prep` to keep working on future material:

```bash
git checkout prep
```

## In Magit (Emacs)

1. Make sure you're on `main` (`b b` to switch branches if needed).
2. `M-x magit-file-checkout`
3. Prompts for a revision — type `prep`.
4. Prompts for a file — pick it (repeat the command for each file you're
   publishing).
5. `c c` to open the commit buffer, write a message, `C-c C-c` to commit.
6. `P p` (or `P u`) to push.
7. `b b` back to `prep` to resume drafting.

## Notes

- Only commit files you've deliberately chosen to publish — `prep` can
  contain drafts, notes, or future-week material that should never land
  on `main`.
- If `prep` and `main` diverge awkwardly over time (same file edited on
  both), periodically sync `main`'s state back into `prep` (e.g.
  `git merge -s ours main` on `prep`) to avoid conflicts down the line.
