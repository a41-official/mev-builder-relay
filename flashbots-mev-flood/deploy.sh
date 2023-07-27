if [ ! -f "deployments/local.json" ]; then
    docker run -v ${PWD}/deployments:/app/cli/deployments mevflood init -r http://localhost:8545 -s local.json
else
    echo "Local deployment already exists"
fi