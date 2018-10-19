with (import <nixpkgs> {});

let 

  pythonPackages = python27Packages;

  minieigen = pythonPackages.buildPythonPackage rec {
    name = "minieigen";

    src = pkgs.fetchurl {
      url = "https://github.com/eudoxos/minieigen/archive/master.zip";
      sha256 = "04l882xka9azzw1hzwza5ajx8gz6rpks0fxc5p5lm37k6f7fw8pl";
      };

      buildInputs = [ unzip pythonPackages.boost boost.dev eigen3_3 ];

      patchPhase = ''
      sed -i "s/^.*libraries=libraries.//g" setup.py 
      '';

      preConfigure = ''
      export LDFLAGS="-L${eigen3_3.out}/lib -l boost_python"
      export CFLAGS="-I${eigen3_3.out}/include/eigen3"
      '';

    };

  in 

  {


    yade-env = stdenv.mkDerivation rec {

      name = "yade-env";

      buildInputs = [ 
        boost.dev cgal loki python27Full python27Packages.numpy eigen3_3 bzip2.dev zlib.dev 
        pkgconfig cmake makeWrapper python2Packages.wrapPython python27Packages.matplotlib python27Packages.pillow
        gdb openblas vtk gmp gmp.dev gts metis mpfr mpfr.dev suitesparse glib.dev pcre.dev minieigen
     ] ++ (with pythonPackages; [
                        pygments pexpect decorator numpy
                        ipython ipython_genutils traitlets
                        enum six boost minieigen
                      ]) ;

    };
  }

