#!/bin/bash -xe
MOD_NAME="Cheat"
MOD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MOD_DESC="https://www.nexusmods.com/kingdomcomedeliverance/mods/106"
MOD_AUTHOR="spraguep"
MOD_CLASS=""

function packageRelease() {
  local NOKEYS="${1}"

  SRC_DIR="${MOD_DIR}/Source"
  REL_DIR="${MOD_DIR}/Release"
  PKG_DIR="${MOD_DIR}/Package"
  TMP_DIR="${MOD_DIR}/Temp"

  VERSION_MAJOR=$(grep "cheat.versionMajor =" "${SRC_DIR}/Scripts/Startup/main.lua" | sed 's/[^0-9]*//g')
  VERSION_MINOR=$(grep "cheat.versionMinor =" "${SRC_DIR}/Scripts/Startup/main.lua" | sed 's/[^0-9]*//g')
  VERSION="${VERSION_MAJOR}.${VERSION_MINOR}"

  # Delete package folder if it already exists
  if [[ -d "${PKG_DIR}" ]]; then
    rm -rf "${PKG_DIR}"
  fi

  # Setup package folder structure
  mkdir -p "${PKG_DIR}/${MOD_NAME}/Data"

  # Create manifest file
  cat <<EOF > "${PKG_DIR}/${MOD_NAME}/mod.manifest"
<?xml version="1.0" encoding="utf-8"?>
<kcd_mod>
  <info>
    <name>${MOD_NAME}</name>
    <description>${MOD_DESC}</description>
    <author>${MOD_AUTHOR}</author>
    <version>${VERSION}</version>
    <created_on>$(date)</created_on>
  </info>
</kcd_mod>
EOF

  # clone source dir
  if [[ -d "${TMP_DIR}" ]]; then
    rm -rf "${TMP_DIR}"
  fi
  mkdir -p "${TMP_DIR}"
  cp -r "${SRC_DIR}" "${TMP_DIR}"

  # delete default profile?
  if [[ "${NOKEYS}" == "TRUE" ]]; then
    # assume for now that this Config folder only contains keybinds and can be removed for the NOKEYS package
    rm -rf "${TMP_DIR}/Source/Libs/Config"
    MOD_CLASS="-NOKEYS"
  fi

  # Localization must be a sibling of the pak file
  # Localization is currently for the custom keybinds so we don't need it for NOKEYS
  if [[ -d "${PKG_DIR}/${MOD_NAME}/Localization" ]]; then
    rm -rf "${PKG_DIR}/${MOD_NAME}/Localization"
  fi
  if [[ "${NOKEYS}" != "TRUE" ]]; then
    for LOCALIZATION_FOLDER in $(ls ${TMP_DIR}/Source/Localization); do
      7za a -mx=0 -tzip "${PKG_DIR}/${MOD_NAME}/Localization/${LOCALIZATION_FOLDER}.pak" "${TMP_DIR}/Source/Localization/${LOCALIZATION_FOLDER}"/*
    done
  fi
  rm -rf "${TMP_DIR}/Source/Localization"

  # Create new data pak file
  cd "${TMP_DIR}/Source"
  7za a -mx=0 -tzip "${PKG_DIR}/${MOD_NAME}/Data/data.pak" ./*

  # Remove old release package
  if [[ -f "${REL_DIR}/${MOD_NAME}${MOD_CLASS}-${VERSION}.zip" ]]; then
    rm "${REL_DIR}/${MOD_NAME}${MOD_CLASS}-${VERSION}.zip"
  fi

  # Create new release package
  mkdir -p "${REL_DIR}"
  cd "${PKG_DIR}"
  7za a -tzip "${REL_DIR}/${MOD_NAME}${MOD_CLASS}-${VERSION}.zip" ./*

}

# normal release
packageRelease "FALSE"

# release without key bindings
packageRelease "TRUE"
