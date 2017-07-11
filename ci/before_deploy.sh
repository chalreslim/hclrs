# This script takes care of building your crate and packaging it for release

set -ex

main() {
    local src=$(pwd) \
          stage=

    case $TRAVIS_OS_NAME in
        linux)
            stage=$(mktemp -d)
            ;;
        osx)
            stage=$(mktemp -d -t tmp)
            ;;
    esac

    test -f Cargo.lock || cargo generate-lockfile

    rustup target add $TARGET || true
    # cargo build --target $TARGET
    cargo build --target $TARGET --release --verbose

    cargo rustc --bin hclrs --target $TARGET --release -- -C lto

    # TODO Update this to package the right artifacts
    cp target/$TARGET/release/hclrs $stage/

    cd $stage
    tar czf $src/$CRATE_NAME-$TRAVIS_TAG-$TARGET.tar.gz *
    cd $src

    rm -rf $stage
}

main
