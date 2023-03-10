{
  description = "Flake for video-downloader";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  };

  
  outputs = { self, nixpkgs }:

  let
    pname = "video-downloader";
    version = "v0.11.1";
    rev = "60cedc3b7481eb966b69ac902a7246cdcc5be1e4";
    sha256 = "BNopifjZnrFJwK8FiTRO6fRylQVg0Mm17ToSYNmukqk=";


  in {  

    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation rec {

        name = "${pname}-${version}";
        inherit pname;

        src = fetchFromGitHub {
          owner = "Unrud";
          repo = "${pname}";
          inherit rev;
          inherit sha256;
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
