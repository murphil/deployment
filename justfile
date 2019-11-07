build:
    docker build . -t nnurphy/deployment \
        --build-arg s6url=http://172.178.1.204:2015/s6-overlay-amd64.tar.gz \
        --build-arg wstunnel_url=http://172.178.1.204:2015/tools/wstunnel_linux_x64

test:
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -v $(pwd):/app \
        -v vscode-server:/root/.vscode-server \
        -e WEB_ROOT=/app \
        -e WEB_SERVERNAME=srv.1 \
        -v $(pwd)/id_ecdsa.pub:/root/.ssh/authorized_keys \
        nnurphy/deployment

tunnel token:
    docker run --rm \
        --name=wsc \
        -p 2233:8080 \
        wstunnel -L 0.0.0.0:8080:127.0.0.1:22 \
        ws://172.178.5.21:8090 \
        --upgradePathPrefix=wstunnel-{{token}}

# Host wstunnel
#     HostName localhost
#     User root
#     IdentitiesOnly yes
#     IdentityFile ~/.ssh/id_ecdsa
#     Port 2233