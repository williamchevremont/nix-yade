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

      name = "yadedaily";

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
        url = "https://gitlab.com/yade-dev/trunk.git";
        rev = "aa4802e5a60e99a9220381f27c47fbb0e670e26f";
        sha256 = "13whapqn85k4dlx60pj9gc8fypci8lqk2y57r3ls5y0qkraydz1j";
      };


      patches = [ ./cmake.2.patch ];
	
      postInstall = ''
        wrapPythonPrograms
      '';


      enableParallelBuilding = true;

      system = builtins.currentSystem;

      preConfigure = ''
        cmakeFlags="--check-system-vars -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_PREFIX=$out -DENABLE_GUI=OFF -DSUFFIX=daily -DENABLE_OAR=ON -DENABLE_LINSOLV=OFF -DENABLE_PFVFLOW=OFF -DENABLE_TWOPHASEFLOW=OFF -DCMAKE_CXX_FLAGS=-Wno-int-in-bool-context"
      '';

    };

 }

