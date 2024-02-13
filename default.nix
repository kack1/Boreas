{ mkDerivation, base, curl, lib, optparse-applicative, parsec
, process
}:
mkDerivation {
  pname = "boreas";
  version = "0.1.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base curl optparse-applicative parsec process
  ];
  description = "Boreas is access control utility";
  license = lib.licenses.bsd2;
  mainProgram = "boreas";
}
