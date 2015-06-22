# Some useful cheats for GIT

## Selective git add with untracked files

```
git ls-files --modified | xargs git add
```

## Undo a commit and Redo

```
git commit ...              (1)
git reset --soft HEAD~1     (2)
# edit files as necessary   (3)
git add ...                 (4)
git commit -c ORIG_HEAD     (5)
```

1. This is what you want to undo
2. This is most often done when you remembered what you just committed is incomplete, or you misspelled your commit message, or both. Leaves working tree as it was before commit.
3. Make corrections to working tree files.
4. Stage changes for commit
5. Commit the changes, reusing the old commit message. `reset` copied the old head to `.git/ORIG_HEAD`; commit with `-c ORIG_HEAD` will open an editor, which initially contains the log message from the old commit and allows you to edit it. If you do not need to edit the message, you could use the `-C` option instead.
