{
  description = "Flake for video-downloader";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };

  
  outputs = { self, nixpkgs }:

  let
    pname = "video-downloader";
    version = "v0.11.1";

  in {  

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation rec {

        name = "${pname}-${version}";
        inherit pname;

        src = fetchFromGitHub {
          owner = "matleborgne";
          repo = "${pname}";
        };

        nativeBuildInputs = [
          desktop-file-utils
          appstream-glib
          meson
          ninja
          pkg-config
          python3
          wrapGAppsHook4
        ];

        buildInputs = [
          gtk4
          libadwaita
          haskellPackages.gi-gdk
          haskellPackages.gi-gtk
          yt-dlp
          ffmpeg
        ];

        python = python3.withPackages (ps : with ps; [ pygobject3 yt-dlp ]);

        preFixup = ''
          wrapProgram $out/bin/$pname \
            --prefix PYTHONPATH : ${python}/${python.sitePackages} \
        '';

      };

}
