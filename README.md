# kcd-cheat
KCD Cheat Mod: https://www.nexusmods.com/kingdomcomedeliverance/mods/106


## Create new release

1. Edit ./Source/Scripts/Startup/main.lua and set major + minor version number

    cheat.versionMajor = 1
    cheat.versionMinor = 31

2. Run build

   ./build.sh

3. Update mod_page.txt with new content from help.txt, commands.txt

4. Commit all changes

5. Run release:

   ./release.sh

6. Upload new release zip files

   ./Release/Cheat-X.XX.zip
   ./Release/Cheat-NOKEYS-X.XX.zip
