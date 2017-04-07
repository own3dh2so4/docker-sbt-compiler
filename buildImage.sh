#!/bin/ksh

readonly RUN_PATH=${.sh.file} ;
readonly RUN_BASE=$(dirname  ${RUN_PATH});

function writeConsole {
  TIMESTAMP=$( date +%Y-%m-%d][%T.%3N )
  echo "[${TIMESTAMP}]${*}"
}

function buildImage {
    PATH_DOCKER_FILE=$1
    IMAGE_NAME=$2
    IMAGE_VERSION=$3
    writeConsole "[info] Procedemos a construir la imagen $PATH_DOCKER_FILE con el nombre $IMAGE_NAME version $IMAGE_VERSION"
    docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} ${PATH_DOCKER_FILE}
    if [ ${?} != 0 ] ; then
        writeConsole "[error] No se pudo construir el contenedor"
        exit -1
    fi
}

function pushImage {
    PATH_DOCKER_FILE=$1
    IMAGE_NAME=$2
    writeConsole "[info] Procedemos a pushear la imagen $PATH_DOCKER_FILE con el nombre $IMAGE_NAME version $IMAGE_VERSION"
    docker push ${IMAGE_NAME}:${IMAGE_VERSION}
    if [ ${?} != 0 ] ; then
        writeConsole "[error] No se pudo pushear el contenedor"
        exit -1
    fi
}

function buildAndPushImage {
    buildImage $1 $2 $3
    pushImage $1 $2
}

function main {
    writeConsole "[info] Iniciamos la construcción de la imagen"
    DEFAULT_USER="own3dh2so4"

    writeConsole "[info] Construimos la imagen base, el usuario que se usará: ${DEFAULT_USER}"
    buildAndPushImage "${RUN_BASE}/." "$DEFAULT_USER/sbt-compiler" "sbt-0.13.8"
    buildAndPushImage "${RUN_BASE}/." "$DEFAULT_USER/sbt-compiler" "latest"

    writeConsole "[info] Imagen creada correctamente"


}

main