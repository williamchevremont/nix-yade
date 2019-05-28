with (import <nixpkgs> {});

( let
minieigen = pkgs.python37Packages.buildPythonPackage rec{
      name = "minieigen";

      src = pkgs.fetchFromGitHub {
        owner = "eudoxos";
        repo = "minieigen";
        rev = "7bd0a2e823333477a2172b428a3801d9cae0800f";
        sha256 = "1jksrbbcxshxx8iqpxkc1y0v091hwji9xvz9w963gjpan4jf61wj";
      };

      buildInputs = [ unzip myboost eigen ];

      patchPhase = ''
        sed -i "s/^.*libraries=libraries.//g" setup.py 
      '';

      preConfigure = ''
        export LDFLAGS="-L${eigen.out}/lib -lboost_python37"
        export CFLAGS="-I${eigen.out}/include/eigen3"
      '';

};

 myboost = stdenv.mkDerivation rec {
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


in 

{ yade-env = pkgs.python37.buildEnv.override rec{

        extraLibs = with pkgs.python37Packages;[
                        pygments mpi4py pexpect decorator numpy
                        ipython ipython_genutils traitlets
                        six minieigen ipython future
                      ] ;
        ignoreCollisions = true;

    };
}
)
