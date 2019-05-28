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
                                                                                             
      buildInputs = [ unzip pythonPackages.boost boost.dev eigen ];                       
                                                                                             
      patchPhase = ''                                                                        
        sed -i "s/^.*libraries=libraries.//g" setup.py                                       
      '';

      preConfigure = ''
        export LDFLAGS="-L${eigen.out}/lib -lboost_python27"
        export CFLAGS="-I${eigen.out}/include/eigen3"
      '';

    };

  in 

  {


yade-env = stdenv.mkDerivation rec {

      name = "yade-env";

      buildInputs = [ 
        boost167.dev
        cgal
        loki
        python27Full
        python27Packages.numpy
        eigen
        bzip2.dev
        zlib.dev 
        pkgconfig
        cmake
        makeWrapper
        python2Packages.wrapPython
        python27Packages.matplotlib
        python27Packages.pillow
        python27Packages.mpi4py
        openmpi
        gdb
        openblas
        vtk
        gmp
        gmp.dev
        gts
        metis
        mpfr
        mpfr.dev
        suitesparse
        glib.dev
        pcre.dev
        minieigen
     ] ++ (with pythonPackages; [
                        pygments mpi4py pexpect decorator numpy
                        ipython ipython_genutils traitlets
                        enum six boost minieigen
                      ]) ;

    };
  }

