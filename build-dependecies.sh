git clone https://github.com/cloudflare/quiche.git

cd quiche
git submodule update --init

xcode-select --install || true
rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim
cargo install cargo-lipo
cargo lipo --features ffi --release

xcodebuild -create-xcframework \
	-library target/aarch64-apple-ios/release/libquiche.a \
	-headers quiche/include \
	-library target/x86_64-apple-ios/release/libquiche.a \
	-headers quiche/include \
	-output ../Quiche.xcframework

cd ..

curl -O http://dist.schmorp.de/libev/libev-4.33.tar.gz
tar -xvf libev-4.33.tar.gz
rm libev-4.33.tar.gz
mv libev-4.33 libev

cd libev

cp ../build-ios.sh .
chmod +x build-ios.sh
./build-ios.sh
make
make install

xcodebuild -create-xcframework \
	-library ./_build/platforms/arm/lib/libev.a \
	-headers ./_build/include \
	-library ./_build/platforms/x86_64-sim/lib/libev.a \
	-headers ./_build/include \
	-output ../Ev.xcframework

# You can now include the quiche and ev framework in your xcode project
