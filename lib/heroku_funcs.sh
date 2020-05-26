function download_nakama_binary() {
  NAKAMA_BINARY_URL=https://github.com/heroiclabs/nakama/releases/download/v2.12.0/nakama-2.12.0-linux-amd64.tar.gz

  if [ ! -f $CACHE_DIR/nakama.64 ]; then
    output_section "Downloading Nakama Binary..."
    curl -s $NAKAMA_BINARY_URL -o nakama.tar.gz || exit 1
    tar xfz nakama.tar.gz
    cp nakama $CACHE_DIR/nakama.64
    # cp -i nakama /usr/local/bin
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
    curl -s $COCKROACHDB_URL -o cockroachdb.tfz || exit 1
    tar xvz cockroachdb.tgz
    mkdir -p $COCKROACHDB
    cp cockroach-v20.1.0.linux-amd64/cockroach $COCKROACHDB
    # cp -i cockroach-v20.1.0.linux-amd64/cockroach /usr/local/bin/
  else
    output_section "Using cached CockroachDB"
  fi
}

function migrate_database_schema() {
  output_section "Migrating the database schema..."
  nakama migrate up
  output_section "Starting the database server..."
  cockroach start --background --insecure --store=path="./cdb-store1/"
}

function start_nakama_server() {
  nakama
}