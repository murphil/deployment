build:
    docker build . -t nnurphy/deployment \
        --build-arg s6url=http://172.178.1.204:2015/s6-overlay-amd64.tar.gz \
        --build-arg wstunnel_url=http://172.178.1.204:2015/tools/wstunnel_linux_x64

test:
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -v $(pwd):/srv \
        -v vscode-server:/root/.vscode-server \
        -v $(pwd)/id_ecdsa.php.pub:/root/.ssh/authorized_keys \
        nnurphy/deployment