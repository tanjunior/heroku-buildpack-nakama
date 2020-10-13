function download_nakama_binary() {
  NAKAMA_BINARY_URL="https://github.com/heroiclabs/nakama/releases/download/v2.14.0/nakama-2.14.0-linux-amd64.tar.gz"

  if [ ! -f $CACHE_DIR/nakama ]; then
    output_section "Downloading Nakama Binary..."
    mkdir -p $CACHE_DIR/nakama
    curl -L $NAKAMA_BINARY_URL | tar -xvz -C $CACHE_DIR/nakama
    touch "$CACHE_DIR/._sc_"
  else
    output_section "Using cached Nakama Binary"
  fi
}

function download_cockroachdb() {
  
  COCKROACHDB_URL=https://binaries.cockroachdb.com/cockroach-v20.1.0.linux-amd64.tgz
  COCKROACHDB="$CACHE_DIR/cockroachdb"

  if [ ! -f $COCKROACHDB/cockroach-v20.1.0.linux-amd64 ]; then
    output_section "Downloading CockroachDB..."
    mkdir -p $COCKROACHDB
    curl -s $COCKROACHDB_URL -o cockroachdb.tgz || tar -xvz -C $COCKROACHDB
  else
    output_section "Using cached CockroachDB"
  fi
}

function migrate_database_schema() {
  output_section "Starting the database server..."
  ls -d $CACHE_DIR/*
  ls $CACHE_DIR/cockroachdb
  ls $CACHE_DIR/cockroachdb
  $CACHE_DIR/cockroachdb/cockroach-v20.1.0.linux-amd64/cockroach start --background --insecure --store=path="./cdb-store1/"
  output_section "Migrating the database schema..."
  $CACHE_DIR/nakama/nakama migrate up
}

function start_nakama_server() {
  $CACHE_DIR/nakama/nakama
}
