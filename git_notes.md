#### Pick changes in some certain files selected from a commit
* Do a `cherry-pick` with `--no-commit` or `-n` from the target commit ([ref](https://stackoverflow.com/questions/5717026/how-to-git-cherry-pick-only-changes-to-certain-files))
```bash
git cherry-pick -n <commit>
```

* Decide whether to reject unwanted changes by `reset`
```bash
git reset <file>

# or in oder version of git : git reset HEAD <file>
```

* Commit the final changes