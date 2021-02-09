FROM registry.access.redhat.com/ubi8/go-toolset AS build-env
USER root
RUN mkdir -p /go/src/github.com/salanisor/go-app
ADD main.go /go/src/github.com/salanisor/go-app/
WORKDIR /go/src/github.com/salanisor/go-app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o app .

FROM registry.access.redhat.com/ubi8/ubi-minimal
COPY --from=build-env /go/src/github.com/salanisor/go-app/app /usr/bin/
EXPOSE 8080/tcp
USER 1001
ENTRYPOINT [ "/usr/bin/app" ]
