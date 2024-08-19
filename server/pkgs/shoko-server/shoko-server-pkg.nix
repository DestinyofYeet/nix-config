{
  fetchFromGitHub,
  buildDotnetModule,
  lib,
  ...
}:

buildDotnetModule rec {
  pname = "ShokoServer";
  version = "4.2.2";
  
  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = pname;
    rev = "v${version}";
    sha256 = "Tm2VRYoZxPTBxkhVuMiQ9n7Wled4fArVmL2lCwe1iMk=";
  };

  projectFile = "Shoko.CLI/Shoko.CLI.csproj";

  nugetDeps = ./deps.nix;

  dotnetBuildFlags = [
    "-c=Release"
    "-r Linux-x64"
    "-f net8.0"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  meta = with lib; {
    description = "Shokoserver";
    license = licenses.gpl3;
    maintainers = [ maintainers.DestinyofYeet ];
    platforms = platforms.all;
  };
}
