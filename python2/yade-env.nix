with (import <nixpkgs> {});

( let
minieigen = pkgs.python27Packages.buildPythonPackage rec{
      name = "minieigen";

      src = pkgs.fetchFromGitHub {
        owner = "eudoxos";
        repo = "minieigen";
        rev = "7bd0a2e823333477a2172b428a3801d9cae0800f";
        sha256 = "1jksrbbcxshxx8iqpxkc1y0v091hwji9xvz9w963gjpan4jf61wj";
      };

      buildInputs = [ unzip pythonPackages.boost boost.dev eigen-3.3.7 ];

      patchPhase = ''
        sed -i "s/^.*libraries=libraries.//g" setup.py 
      '';

      preConfigure = ''
        export LDFLAGS="-L${eigen3_3.out}/lib -lboost_python27"
        export CFLAGS="-I${eigen3_3.out}/include/eigen3"
      '';

};

in 

{ yade-env = pkgs.python27.buildEnv.override rec{

        extraLibs = with pkgs.python27Packages;[
                        pygments mpi4py pexpect decorator numpy
                        ipython ipython_genutils traitlets
                        enum six boost minieigen ipython
                      ] ;
        ignoreCollisions = true;

    };
}
)
