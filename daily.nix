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
        export LDFLAGS="-L${eigen3_3.out}/lib -l boost_python"
        export CFLAGS="-I${eigen3_3.out}/include/eigen3"
      '';

    };

in 

 {

    minieigen = minieigen;

    yade-daily = stdenv.mkDerivation rec {

      name = "yade-daily";

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
        boost.dev
      ];

      buildInputs = [ 
        boost
        cgal
        loki
        python27Full
        python27Packages.numpy
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
        url = "https://github.com/yade/trunk.git";
        rev = "fb2deb04bcdec6334f84104b62abeeb522fdc0b6";
        sha256 = "0vwmhc1kmn80vp9l0lhdxxsl7m3pi9ldmwhnhjpa9xhq74lsijkr";
      };

      postInstall = ''
        wrapPythonPrograms
      '';


      enableParallelBuilding = true;

      system = builtins.currentSystem;

      preConfigure = ''
        cmakeFlags="-DCMAKE_INSTALL_PREFIX=$out -DENABLE_GUI=OFF -DSUFFIX=daily"
      '';

    };

 }

