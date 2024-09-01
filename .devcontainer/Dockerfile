ARG SWIFT_VERSION=5.10

FROM swift:${SWIFT_VERSION}

ARG USERNAME=vscode
ARG GROUPNAME=vscode
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $GROUPNAME
RUN useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

USER vscode
WORKDIR /home/vscode/app