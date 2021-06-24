# syntax=docker/dockerfile:1
FROM inoeg/eps:v0.1.13
RUN apk add gettext
RUN apk add curl

ENV APP_NAME="Recover"
ENV SETTINGS_PATH="/app/settings"
ENV LOCAL_PATH="/settings/staging"
ENV EPS_SETTINGS="${SETTINGS_PATH}/staging/roles/Recover"
ENV APP_ENDPOINT="http://api.rcvr.app:443"



RUN mkdir -p "${SETTINGS_PATH}/staging/roles/Recover"
RUN mkdir -p "${SETTINGS_PATH}/staging/certs"

RUN echo ${EPS_KEY} > ${LOCAL_PATH}/certs/Recover.key
RUN echo ${EPS_CRT} > ${LOCAL_PATH}/certs/Recover.crt
RUN echo ${EPS_STAGING_CRT} > ${LOCAL_PATH}/certs/staging-root.crt

ARG DIR=${SETTINGS_PATH}/staging/roles/Recover
RUN wget https://raw.githubusercontent.com/iris-connect/iris-documentation/main/connect_your_app_to_IRIS/technical_details/eps-config/settings/staging/roles/yourapp/001_default.yml
RUN envsubst < 001_default.yml > "${SETTINGS_PATH}/staging/roles/Recover/001_default.yml"

EXPOSE 5556
EXPOSE 4444

CMD ["--level", "trace", "server", "run"]
