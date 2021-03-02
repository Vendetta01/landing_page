ARG ALPINE_VERSION=3.13
FROM alpine:${ALPINE_VERSION}

##############################
# Install dependencies
COPY requirements.txt /tmp/requirements.txt

RUN apk -U upgrade \
    && apk add --update --no-cache \
    bash \
    curl \
    py-pip \
    python3 \
    && apk add --update --no-cache --virtual .build-deps \
    build-base \
    musl-dev \
    python3-dev \
    && pip3 install --upgrade pip wheel \
    && pip3 install --no-cache-dir -r /tmp/requirements.txt \
    && apk del .build-deps

COPY src/ /app/
COPY scripts/* /usr/bin/


WORKDIR /app

EXPOSE 8000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
