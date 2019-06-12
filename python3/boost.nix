with (import <nixpkgs> {});

{

 boost = stdenv.mkDerivation rec {
  name = "boost-1.71";

  buildInputs = [
   python37Full
   bzip2
   zlib
   xz
   icu
   zstd
   ];


  src = fetchgit {
    url = "https://github.com/boostorg/boost.git";
    rev = "e28c89c8b9d68fe0d87349e8326a4784ada29be9";
#    sha256 = "12sljnp3327xvwj3x9hwnw3bisr3xcl65izjlv071danfhc7n3g6";
    sha256 = "1vdxgpqy1p0gfv9rdp80xngh8cban3w90rzfl5dhbaqs9jm3c8ai";
  };

  hardeningDisable = [ "format" ];

  patchPhase = ''
    grep -r '/usr/share/boost-build' \
      | awk '{split($0,a,":"); print a[1];}' \
      | xargs sed -i "s,/usr/share/boost-build,$out/share/boost-build,"
  '';

  buildPhase = ''
    ./bootstrap.sh --with-python=~/.nix-profile/bin/python3 --includedir=~/.nix-profile/include --libdir=~/.nix-profile/lib
  '';

  installPhase = ''
    ./b2 install --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.boost.org/boost-build2/;
    license = stdenv.lib.licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
};
}
