ARG GO_VERSION=1.17
ARG VARIANT=-alpine
ARG WORKDIR=/app

ARG APP_NAME=undefined
ARG APP_VERSION=undefined
ARG GO_VERSION=undefined
ARG GIT_COMMIT=undefined
ARG BUILD_DATE=undefined

# Setup Container with Code
FROM golang:${GO_VERSION}${VARIANT} AS code
WORKDIR ${WORKDIR}
USER 1000:1000
COPY ./ ./
RUN go mod download

# Build code
FROM golang:${GO_VERSION}${VARIANT} AS builder
WORKDIR ${WORKDIR}
USER 1000:1000
COPY --from=code ${WORKDIR} ./
RUN go build \
    -installsuffix 'static' \
    -ldflags "-X main.Version=${APP_VERSION}" \
    -o ${WORKDIR} \
    ./cmd/${APP_NAME}

# Run executable
FROM scratch AS final
WORKDIR ${WORKDIR}
USER 1000:1000
COPY --from=code ${WORKDIR} ./

LABEL org.label-schema.build-date="$BUILD_DATE"
LABEL org.label-schema.vcs-url="https://github.com/jetstack/cert-manager"
LABEL org.label-schema.vcs-ref="$GIT_COMMIT"
LABEL org.label-schema.version="$APP_VERSION"
LABEL go-version="$GO_VERSION"

ENTRYPOINT ["${WORKDIR}"]
