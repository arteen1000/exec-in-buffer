# exec-in-buffer.el

For files matching your choice of regular expression, runs your specified programs with arguments and reverts the Emacs buffer, on-save. Works for remote/local buffers. Can make the configuration project local.

## Getting Started

The package may be installed through [MELPA](https://www.emacswiki.org/emacs/MELPA). I recommend [use-package](https://jwiegley.github.io/use-package/installation/).

```
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package)

  (use-package exec-in-buffer
    :ensure t)
```

## Usage

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

## Why this package?

You could of course use designated packages such as [clang-format-lite](https://github.com/arteen1000/clang-format-lite/) for your formatting needs; however, this one allows you to hook up arbitrary scripts to run "on-save" and format your buffer, reverting your view.

As a general example, you might have a project `clang-format-commit.sh` script that runs on commit in a specific manner, perhaps not supported by the other code-formatting Elisp package and you could set something like that up for `*.cc` and `*.h` files.
