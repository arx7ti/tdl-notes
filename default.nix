with import <nixpkgs> {};
let
  unstable = import <unstable> {};
  torchaudio = python37.pkgs.buildPythonPackage rec {
    pname = "torchaudio";
    version = "0.7.2";
    src = fetchFromGitHub {
      owner  = "pytorch";
      repo   = "audio";
      rev    = "a853dff25de36cc637b1f02029343790d2dd0199";
      sha256 = "061j8v7h0g2byk979cimvm40v0av01gqwgggacs9vyh89v70fzdh";
    };
    doCheck = false;
    nativeBuildInputs = [which];
    propagatedBuildInputs = (with unstable.python37Packages; [
      pytorch-bin
    ]) ++ [sox];
  };
  torchvision_wheel = python37.pkgs.buildPythonPackage rec {
    pname = "torchvision";
    version = "0.8.2";
    src = python37.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "951239b5fcb911dbf78c1385d677f5f48c7a1b12859e3d3ec287562821b17cf2";
    };
    doCheck = false;
    propagatedBuildInputs = with python37Packages; [
      scipy
      numpy
    ];
  };
  lesscpy = python37.pkgs.buildPythonPackage rec {
    pname = "lesscpy";
    version = "0.13.0";
    src = fetchFromGitHub {
      owner  = "lesscpy";
      repo   = "lesscpy";
      rev    = "ead83625d6a83b1af440fec53a35531c1d5a415c";
      sha256 = "1jf5bp4ncvw2gahhkvjy5b0366y9x3ki9r9c5n6hkvifjk3jhmb2";
    };
    doCheck = false;
    propagatedBuildInputs = with python37Packages; [
      six
      ply
    ];
  };
  jupyterthemes = python37.pkgs.buildPythonPackage rec {
    pname = "jupyter-themes";
    version = "0.20.2";
    src = fetchFromGitHub {
      owner  = "dunovank";
      repo   = "jupyter-themes";
      rev    = "22b9358fd52cd852000a0095f491bddb49fe0f7e";
      sha256 = "0hzrwh1fj6pmjb22w7hmchagggbjfrgg45kkyf71d7v0x1zrkicq";
    };
    doCheck = false;
    propagatedBuildInputs = with python37Packages; [
      jupyter_core
      notebook
      ipython
      matplotlib
      lesscpy
    ];
  };
  jupyter_latex_envs = python37.pkgs.buildPythonPackage rec {
    pname = "jupyter_latex_envs";
    version = "1.4.6";
    src = python37.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "070a31eb2dc488bba983915879a7c2939247bf5c3b669b398bdb36a9b5343872";
    };
    doCheck = false;
    propagatedBuildInputs = with python37Packages; [
      ipython
      notebook
      nbconvert
      traitlets
      jupyter_core
    ];
  };
  jupyter_nbextensions_configurator = python37.pkgs.buildPythonPackage rec {
    pname = "jupyter_nbextensions_configurator";
    version = "0.4.1";
    src = fetchFromGitHub {
      owner  = "Jupyter-contrib";
      repo   = "jupyter_nbextensions_configurator";
      rev    = "5608b95c2b14998efc38294aae9f5d1b45cb6299";
      sha256 = "0w4kbzq16p3v5a0pnwbi6qcxg2kcqdbkpzc8am0zi5m0qjs7zxph";
    };
    doCheck = false;
    propagatedBuildInputs = with python37Packages; [
      jupyter_core
      jupyter_contrib_core
      pyyaml
      tornado
      lxml
      traitlets
    ];
  };
  jupyter_contrib_core = python37.pkgs.buildPythonPackage rec {
    pname = "jupyter_contrib_core";
    version = "0.3.3";
    src = python37.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "e65bc0e932ff31801003cef160a4665f2812efe26a53801925a634735e9a5794";
    };
    doCheck = false;
    propagatedBuildInputs = with python37Packages; [
      tornado
      notebook
      traitlets
    ];
  };
  jupyter_highlight_selected_word = python37.pkgs.buildPythonPackage rec {
    pname = "jupyter_highlight_selected_word";
    version = "0.2.0";
    src = fetchFromGitHub {
      owner  = "jcb91";
      repo   = "jupyter_highlight_selected_word";
      rev    = "156a4fe84edd70880be1f5fb6a92d69796232e54";
      sha256 = "12x0azy149hv9rpmnijffab2irv4g3ac14lwp4x2w48z4byky0ra";
    };
    doCheck = false;
  };
  nbextensions = python37.pkgs.buildPythonPackage rec {
    pname = "jupyter_contrib_nbextensions";
    version = "0.5.1";
    src = fetchFromGitHub {
      owner  = "ipython-contrib";
      repo   = "jupyter_contrib_nbextensions";
      rev    = "882fbb011308b88217a656a46ef2bcb5a6031d84";
      sha256 = "1dm3zflnm8ssrpanxixzif6is3cwyadxap967r1b9hsh5xippnjq";
    };
    doCheck = false;
    propagatedBuildInputs = with python37Packages; [
      jupyter_nbextensions_configurator
      jupyter_contrib_core
      jupyter_latex_envs
      jupyter_highlight_selected_word
      tornado
      lxml
      traitlets
    ];
  };
  libs = [
    stdenv.cc.cc.lib
    xorg.libX11
    ncurses5
    linuxPackages.nvidia_x11
    libGL
    libzip
    glib
  ];
in
  stdenv.mkDerivation rec {
    name = "deep-nilm";
    dependencies = [
      python3
      qt5.full
    ] ++ (with python37Packages; [
      torchaudio
      pandas
      black
      jupyterthemes
      nbextensions
      sklearn-deap
      matplotlib
      seaborn
      tqdm
      ipykernel
      jupyter
      jupyterlab
    ]) ++ (with unstable.python37Packages; [
      pytorch-bin
      torchvision
    ]);
    env = buildEnv {
      name = name;
      paths = dependencies;
    };
    nativeBuildInputs = [ cudatoolkit_10_1 ];
    buildInputs = dependencies;
    XDG_DATA_DIRS = "${qt5.full}:$XDG_DATA_DIRS";
    LD_LIBRARY_PATH = "${stdenv.lib.makeLibraryPath libs}";
    CUDA_PATH = "${cudatoolkit_10_1}";
}
