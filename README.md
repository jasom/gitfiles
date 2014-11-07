#List all files in a git repository sorted by pack size

##Really quick start (if quicklisp & sbcl are  installed):

    mkdir -p $HOME/.local/share/common-lisp/source
    cd $HOME/.local/share/common-lisp/source
    git clone https://github.com/jasom/gitfiles.git
    sbcl --dynamic-space-size $((8*1024)) --eval '(ql:quickload :gitfiles)' --eval '(gitfiles::make)'
    cd /path/to/a/git/repository
    git repack
    $HOME/.local/share/common-lisp/source/gitfiles/gitfiles .


##Slightly slower start:

* Load the system "gitfiles" via asdf
* invoke ```(gitfiles::make)``` to save an image and quit;  This will output an
  executable named "gitfiles" in the same directory as the ```gitfiles.asd```
* you can run that executable giving it exactly one argument as the path to a
  git repository with no loose objects
* Alternatively (gitfiles:show-files) list the objects, running on the
  current working directory.

##Output format
```<size-in-pack> <size-uncompressed> <filename>```

Note that each filename may appear multiple times (once for each revision
of it in the repository)
