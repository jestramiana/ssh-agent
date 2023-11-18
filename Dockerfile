FROM alpine:3.18.4

ENV SOCKET_DIR /ssh-agent-data
ENV SSH_AUTH_SOCK ${SOCKET_DIR}/auth/sock

RUN apk add --update openssh && \
    rm -rf /var/cache/apk/*

COPY run.sh /run.sh

RUN mkdir -p ${SOCKET_DIR} && chmod 777 ${SOCKET_DIR}

VOLUME ${SOCKET_DIR}

ENTRYPOINT ["/run.sh"]
CMD ["ssh-agent"]
