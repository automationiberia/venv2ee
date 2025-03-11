#!/usr/bin/env bash

# Make the virtual environment to be relocatable
# virtualenv --relocatable ${1}

# Remove all the 'pyc' files in the venv
find ${1} -name "*.pyc" -exec rm -f {} \;

# Remove the links so they become the final files
#find ${1}/ -type l -ls | grep "/usr/" | while read a b c d e f g h i j dest l orig; do
find ${1}/ -type l -ls | grep $PWD | while read a b c d e f g h i j dest l orig; do
  rm -f ${dest}
  cp -a ${orig} ${dest}
done

# Update the virtualenv activation script (only take care of the bash version)
sed -i 's,^VIRTUAL_ENV.*$,VIRTUAL_ENV="${BASH_SOURCE%%/bin/activate}",' ${1}/bin/activate
grep -lRE '^#\\!/.*/bin/.*' ${1} 2>/dev/null | while read file; do
  sed -ri 's,(^#\\!).*/(.*),\1/usr/bin/env \2,g' "${file}" 2>/dev/null
done

# Compress the virtual environment so it can be installed into a container in next steps
tar cf - ${1} | gzip -9 > ${1}.venv.tar.gz
