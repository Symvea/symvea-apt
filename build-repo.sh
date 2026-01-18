#!/bin/bash
set -e

echo "Building Symvea APT Repository..."

# Build the Rust binary first
cd ../symvead
cargo build --release

# Create APT repository structure
cd ../symvea-apt
mkdir -p pool/main/s/symvea
mkdir -p dists/stable/main/binary-amd64

# Build Debian package
mkdir -p pkg/usr/bin
mkdir -p pkg/etc/symvea
mkdir -p pkg/lib/systemd/system
mkdir -p pkg/DEBIAN

# Copy files
cp ../symvead/target/release/symvead pkg/usr/bin/
cp example-config.toml pkg/etc/symvea/
cp debian/symvea.service pkg/lib/systemd/system/
cp debian/control pkg/DEBIAN/
cp debian/postinst pkg/DEBIAN/

# Build package
dpkg-deb --build pkg symvea_0.1.0_amd64.deb

# Move package to APT repo
mv symvea_0.1.0_amd64.deb pool/main/s/symvea/

# Generate Packages files
dpkg-scanpackages pool/ /dev/null | gzip -9c > dists/stable/main/binary-amd64/Packages.gz
dpkg-scanpackages pool/ /dev/null > dists/stable/main/binary-amd64/Packages

# Generate Release file
cat > dists/stable/Release << EOF
Origin: Symvea
Label: Symvea Repository
Suite: stable
Codename: stable
Version: 1.0
Architectures: amd64
Components: main
Description: Symvea APT Repository
Date: $(date -Ru)
EOF

# Cleanup
rm -rf pkg

echo "✅ APT repository built in symvea-apt/"
echo "📦 Package: symvea_0.1.0_amd64.deb"
echo "🚀 Ready to upload to GitHub Pages"