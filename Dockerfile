FROM alpine:3.24

LABEL maintainer="phamcs"

RUN addgroup -S app \
    && adduser -S -G app app \
    && apk --no-cache add \
    bash ca-certificates curl netcat-openbsd

RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

WORKDIR /home/app

COPY * .

RUN chown -R app:app ./

USER app

CMD ["/bin/sh"]