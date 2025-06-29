# exec-in-buffer.el

For files matching your choice of regular expression, runs your specified programs with arguments and reverts the buffer, on-save. Works for remote/local buffers. Can make the configuration project local.

# Usage

For example,

```
(setq exec-in-buffer-config
      '(("\\.\\(cc\\|h\\)\\'" . ("clang-format" "-i" filename))
        ("\\.py\\'" . ("black" filename))))
(add-hook 'prog-mode-hook #'exec-in-buffer-save-hook)
```
will for `.cc` and `.h` files run the `clang-format` program in-place and revert the buffer on saves, so you can `clang-format` as you go. Likewise, with `black` for `.py` files.

If you add this line

```
(setq exec-in-buffer-config-filename ".exec-in-buffer.el")
```

and in that file write

```
(setq exec-in-buffer-config
      '(("\\.cpp\\'" . ("clang-format" "-i" filename))))
```

then it will no longer do so for `.cc`/`.h`/`.py` files under that particular project, since you've turned on the local-only mode by specifying a config filename. However, under that particular project -- it will run the `clang-format` command as before on the matched regexp. The global configuration will continue to work as before, if no `exec-in-buffer-config-filename` is found in a parent directory.

If a file matches multiple regexp, it will apply the programs in the order of the regexp matches as you specified in the alist.

You can also run it interactively with `exec-in-buffer`, instead of using the save hook.