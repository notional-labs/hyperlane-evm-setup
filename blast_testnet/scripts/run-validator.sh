HOME_DIR=$(pwd)
CONFIG_FILES="${1:-$HOME_DIR/blast_testnet/artifacts/agent-config-2024-03-09-20-55-46.json}"
echo "Using config files: $CONFIG_FILES"

# Pick an informative name specific to the chain you're validating
mkdir -p $HOME_DIR/tmp
VALIDATOR_SIGNATURES_DIR=$HOME_DIR/tmp/hyperlane-validator-signatures-blasttestnet

BINARY_DIR=$HOME_DIR/hyperlane-monorepo/rust
cd $BINARY_DIR

BINARY_FILE=$BINARY_DIR/target/release/validator

VALIDATOR_KEY=${2:-$(cat $HOME_DIR/blast_testnet/.keys/valkey)}
if [ -z $VALIDATOR_KEY ]; then
    echo "No validator key provided"
    exit 1
fi

# Create the directory
mkdir -p $VALIDATOR_SIGNATURES_DIR

CONFIG_FILES=$CONFIG_FILES $BINARY_FILE \
    --db ./hyperlane_db_validator_sepolia \
    --originChainName sepolia \
    --checkpointSyncer.type localStorage \
    --checkpointSyncer.path $VALIDATOR_SIGNATURES_DIR \
    --validator.key $VALIDATOR_KEY