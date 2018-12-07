with import <nixpkgs> {};

pkgs.python27Packages.buildPythonPackage rec{
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

}
