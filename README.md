# pambase

[PAM](https://wiki.gentoo.org/wiki/PAM) base configuration files.

This repository contains a small [Python](https://wiki.gentoo.org/wiki/Python) script that renders `PAM` configuration templates for [Gentoo Linux](https://www.gentoo.org).

## Dependencies

`pambase` depends on [jinja](https://packages.gentoo.org/packages/dev-python/jinja).

## Testing

In order to perform tests, run [tox](https://packages.gentoo.org/packages/dev-python/tox).

Alternatively, you can run tests with [Docker](https://wiki.gentoo.org/wiki/Docker):
```sh
docker run --rm -it $(docker build -q .)
```
