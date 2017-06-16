with (import <nixpkgs> {});

let 

  pythonPackages = python27Packages;

  minieigen = pythonPackages.buildPythonPackage rec {
    name = "minieigen";

    src = pkgs.fetchurl {
      url = "https://github.com/eudoxos/minieigen/archive/master.zip";
      sha256 = "71d91f716aeb85e6433696fc0754c32d8f4956f3685d12df925c2c9183a2a108";
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
        pkgconfig cmake makeWrapper python2Packages.wrapPython
        openblas vtk gmp gmp.dev gts metis mpfr mpfr.dev suitesparse glib.dev pcre.dev minieigen
     ] ++ (with pythonPackages; [
                        pygments pexpect decorator numpy
                        ipython ipython_genutils traitlets
                        enum six boost minieigen
                      ]) ;

    };
  }

