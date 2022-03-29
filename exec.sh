#/bin/bash

if [[ $(whoami) != "root" ]]; then
  echo 'please run this script as root'
  exit
fi

gpg --quiet --batch --yes --decrypt --passphrase='$passphrase' --output ./ENV ENV.gpg 2> /dev/null

alias composePullUp="docker-compose pull && docker-compose up -d"

if [ ! -f ./ENV ]; then
    echo "File does not exist"
    exit
else 
    source ./ENV

    if [[ -z "${APP_USER}" ]]; then
        exit
    fi

    if [ id -u "${APP_USER}" >/dev/null 2>&1 ]; then
        echo "user exists"
    else
        echo "add user ${APP_USER}"
        useradd --home-dir /${APP_DIR} --shell /bin/bash -G sudo -M -U ${APP_USER}
    fi

    if [[ ! -d /${APP_DIR} ]]; then
        (su root -c "mkdir /${APP_DIR}; touch /${APP_DIR}/ENV; chown -R ${APP_USER}:${APP_USER} /${APP_DIR}; ls -lasR /${APP_DIR}")
    fi

    cd /${APP_DIR}

    # Pull latest docker
    git clone git@github.com:Duke-MatSci/deployer.git .

    composePullUp
fi
