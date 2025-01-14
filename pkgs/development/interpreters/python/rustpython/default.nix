{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, SystemConfiguration
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "rustpython";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    rev = "refs/tags/${version}";
    hash = "sha256-8tDzgsmKLjsfMT5j5HqrQ93LsGHxmC2DJu5KbR3FNXc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustpython-ast-0.3.0" = "sha256-5IR/G6Y9OE0+gTvU1iTob0TxfiV3O9elA/0BUy2GA8g=";
      "rustpython-doc-0.3.0" = "sha256-34ERuLFKzUD9Xmf1zlafe42GLWZfUlw17ejf/NN6yH4=";
      "unicode_names2-0.6.0" = "sha256-eWg9+ISm/vztB0KIdjhq5il2ZnwGJQCleCYfznCI3Wg=";
    };
  };

  # freeze the stdlib into the rustpython binary
  cargoBuildFlags = [ "--features=freeze-stdlib" ];

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  nativeCheckInputs = [ python3 ];

  meta = with lib; {
    description = "Python 3 interpreter in written Rust";
    homepage = "https://rustpython.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
