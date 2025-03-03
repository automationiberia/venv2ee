#!/usr/bin/env bash

if [ $# -ne 1 ]; then
  echo "Usage: ${0} <venv_dir>"
  exit 1
fi

INPUT_VENV="${1}"

# Make the virtual environment to be relocatable
virtualenv --relocatable "${INPUT_VENV}"

# Re-create the links that are not updated by the 'virtualenv --relocatable' command
find "${INPUT_VENV}/" -type l -ls | grep $PWD | while read a b c d e f g h i j dest l orig; do
  rm -f ${dest}
  ln -srf ${orig//${PWD}/.} ${dest}
done

# Update the virtualenv activation script (only take care of the bash version)
sed -i 's,^VIRTUAL_ENV.*$,VIRTUAL_ENV="${BASH_SOURCE%%/bin/activate}",' "${INPUT_VENV}/bin/activate"

# Compress the virtual environment so it can be installed into a container in next steps
tar cvf - "${INPUT_VENV}" | gzip -v9 > "${INPUT_VENV}.venv.tar.gz"
