#!/usr/bin/env bash

# Make the virtual environment to be relocatable
virtualenv --relocatable awscliv2

# Re-create the links that are not updated by the 'virtualenv --relocatable' command
find awscliv2/ -type l -ls | grep $PWD | while read a b c d e f g h i j dest l orig; do
  rm -f ${dest}
  ln -srf ${orig//${PWD}/.} ${dest}
done

# Update the virtualenv activation script (only take care of the bash version)
sed -i 's,^VIRTUAL_ENV.*$,VIRTUAL_ENV="${BASH_SOURCE%%/bin/activate}",' awscliv2/bin/activate

# Compress the virtual environment so it can be installed into a container in next steps
tar cvf - awscliv2 | gzip -v9 > awscliv2.venv.tar.gz
