{ lib, stdenv, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.8.0";

  src = lib.cleanSourceWith {
    filter = name: type: !(type == "directory" && builtins.elem (baseNameOf name) [ "target" ]);
    src = lib.cleanSource ./.;
  };

  buildInputs = [ ]
   ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = with lib; {
    description = "ChatGPT/GPT-3.5/GPT-4 in the terminal";
    homepage = "https://github.com/sigoden/aichat/";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
