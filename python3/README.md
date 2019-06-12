## Python3

This is the new support of Yade with Python3.

To install the production environment:

```bash
nix-env -if yade-env.nix
```

To build yade:

```bash
mkdir build install
git clone https://gitlab.com/yade-dev/trunk
cd build
nix-shell <path-to-default.nix>
cmake -DCMAKE_INSTALL_DIR=../install ../trunk
make -j8
make install
```
