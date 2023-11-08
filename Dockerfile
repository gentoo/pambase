# based on https://github.com/gentoo/gentoo-docker-images

FROM gentoo/portage:latest as portage
FROM gentoo/stage3:latest

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

ENV ACCEPT_KEYWORDS="~amd64"
RUN emerge -qvu python:3.{10..12} dev-python/tox

COPY . /usr/src/pambase
WORKDIR /usr/src/pambase

CMD tox --colored yes
