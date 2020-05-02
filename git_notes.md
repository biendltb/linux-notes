#### Pick changes in some certain files selected from a commit
* Do a `cherry-pick` with `--no-commit` or `-n` from the target commit ([ref](https://stackoverflow.com/questions/5717026/how-to-git-cherry-pick-only-changes-to-certain-files))
```bash
git cherry-pick -n <commit>
```
* Inspect the changes in each file
```bash
# for files not yet added
git diff <file>

# for files added before commit
git diff --cached  src/vio/StateAugmentation.h
```

* Decide whether to reject unwanted changes by `reset`
```bash
git reset <file>

# or in oder version of git : git reset HEAD <file>
```

* Commit the final changes

#### Delete branch locally and remotely
```bash
# detele branch locally: '-d' = '--delete'
git branch -d <branch_name>

# 'D' = '--delete --force'
git branch -D <branch_name>

# delete remotely
git push <remote_name> --delete <branch_name>
```
