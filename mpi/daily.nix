with (import <nixpkgs> {});

let 

  pythonPackages = python27Packages;

    minieigen = pythonPackages.buildPythonPackage rec {
      name = "minieigen";

      src = pkgs.fetchFromGitHub {
        owner = "eudoxos";
        repo = "minieigen";
        rev = "7bd0a2e823333477a2172b428a3801d9cae0800f";
        sha256 = "1jksrbbcxshxx8iqpxkc1y0v091hwji9xvz9w963gjpan4jf61wj";
      };

      buildInputs = [ unzip pythonPackages.boost boost.dev eigen3_3 ];

      patchPhase = ''
        sed -i "s/^.*libraries=libraries.//g" setup.py 
      '';

      preConfigure = ''
        export LDFLAGS="-L${eigen3_3.out}/lib -lboost_python27"
        export CFLAGS="-I${eigen3_3.out}/include/eigen3"
      '';

    };

in 

 {

    minieigen = minieigen;
    boost = boost167;

    yadedaily = stdenv.mkDerivation rec {

      name = "yadedaily-mpi";

      nativeBuildInputs = [
        pkgconfig
        cmake
        makeWrapper
        python2Packages.wrapPython
        gmp.dev
        mpfr.dev
        bzip2.dev
        zlib.dev 
        glib.dev
        pcre.dev
        boost167.dev
      ];

      buildInputs = [ 
        boost
        cgal
        loki
        openmpi
        python27Full
        python27Packages.numpy
        python27Packages.matplotlib
        python27Packages.pillow
        eigen3_3
        bzip2
        zlib
        openblas
        vtk
        gmp
        gts
        metis
        mpfr
        suitesparse
        glib
        pcre
        minieigen
      ];

      pythonPath = with pythonPackages; [
        pygments
        pexpect
        decorator
        numpy
        ipython
        ipython_genutils
        traitlets
        enum
        six
        boost
        minieigen
        pillow
        matplotlib
      ];

      src = fetchgit
      {
        url = "https://github.com/bchareyre/yade-mpi.git";
        rev = "65806456f1280e695c777775131b8bc3720f0081";
        sha256 = "0jpjdyq5y7yr2sjg65sd9s4k0am7ax2hdq3g0sdmf48wi6brvbiq";
      };


      patches = [ ./cmake.2.patch ];

      postInstall = ''
        wrapPythonPrograms
      '';


      enableParallelBuilding = true;

      system = builtins.currentSystem;

      preConfigure = ''
        cmakeFlags="--check-system-vars -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_PREFIX=$out -DENABLE_GUI=OFF -DSUFFIX=mpi-daily -DENABLE_OAR=ON -DENABLE_LINSOLV=OFF -DENABLE_PFVFLOW=OFF -DENABLE_TWOPHASEFLOW=OFF -DCMAKE_CXX_FLAGS=-Wno-int-in-bool-context"
      '';

    };

 }
