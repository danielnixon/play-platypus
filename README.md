play-platypus [![Build Status](https://travis-ci.org/danielnixon/play-platypus.svg?branch=master)](https://travis-ci.org/danielnixon/play-platypus)
=============

Package a [Play Framework](http://www.playframework.com/) app for OS X using [Platypus](http://sveinbjorn.org/platypus).

Usage
-----

1. Install Platypus with [Homebrew](http://brew.sh/):

    ```bash
    $ brew install platypus
    ```

2. Copy `platypus.sh` (and optionally your `icon.icns`) to the same directory as your `build.sbt`.

3. Add a `platypus` task to your `build.sbt`:

    ```scala
    lazy val platypus = taskKey[Unit]("Creates an OS X app bundle using Platypus.")
    
    platypus <<= (packageZipTarball in Universal, name, version) map { (result, name, version) =>
      val result = Seq("./platypus.sh", name, version).!
      if (result != 0) {
        throw new Exception("Platypus failed.")
      }
    }
```

4. Invoke the `platypus` task with activator (or sbt):

    ```bash
    $ activator platypus
    $ sbt platypus
    ```

5. You can now find a `<name>-<version>.dmg` disk image containing `<name>.app` in `./target/universal/`.
