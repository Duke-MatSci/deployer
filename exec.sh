#/bin/bash

gpg --quiet --batch --yes --decrypt --passphrase='$passphrase' --output ./ENV ENV.gpg 2> /dev/null

if [ ! -f ./ENV ]; then
    echo "File does not exist"
else 
    source ./ENV

    echo add user ${APP_USER}
    useradd --home-dir /${APP_DIR} --shell /bin/bash -G sudo -M -U ${APP_USER}

    if [[ ! -d /apps ]]; then
        (su root -c 'mkdir /${APP_DIR}; touch /${APP_DIR}/ENV; chown -R ${APP_USER}:${APP_USER} /${APP_DIR}; ls -lasR /${APP_DIR}')
    fi

    cd /${APP_DIR}

    # Pull latest docker
    git clone git@github.com:Duke-MatSci/deployer.git .
fi
