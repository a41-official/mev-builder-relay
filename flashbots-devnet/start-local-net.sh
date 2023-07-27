if [ ! -d "consensus/prysm" ]; then
    git clone https://github.com/flashbots/prysm.git consensus/prysm
    docker build -t eth-pos-devnet_beacon-chain:latest -f consensus/Dockerfile consensus/prysm
fi

if [ ! -d "execution/builder" ]; then
    git clone https://github.com/flashbots/builder.git execution/builder
    docker build -t eth-pos-devnet_geth:latest execution/builder
fi

running="$(docker compose ps --services --filter "status=running")"
if [ -n "$running" ]; then
    docker compose down
    sudo rm -rf execution/geth
    sudo rm -rf consensus/beacondata
    sudo rm -rf consensus/validatordata
    sudo rm consensus/genesis.ssz
    sleep 5
fi

docker compose up -d