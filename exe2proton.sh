#!/bin/bash
APPID=""
EXE=""
STEAMPATH=""
COMPATDATA=""
PROTONPATH=""
usage() {
  echo "Usage: $0 [ -a APPID ] [ -e EXE ] [ -s STEAMPATH ] [ -c COMPATDATA ] [ -p PROTONPATH ] [ -h HELP ]" 1>&2
  echo ""  1>&2
  echo "APPID (-a): App ID of the steamgame. Can be found in 'Properties->Updates' or on protondb.com"  1>&2
  echo "EXE (-e): Executeable that should be run in the prefix"  1>&2
  echo "STEAMPATH (-s): [optional] Path to steam. Default: '$HOME/.steam'"  1>&2
  echo "COMPATDATA (-c): [optional] Path to all the prefixes. Default: '$HOME/.local/share/Steam/steamapps/compatdata'"  1>&2
  echo "PROTONPATH (-p): [optional] Path the folder with the proton executeabel. Default: config_info will be searched for it"  1>&2
  echo "HELP (-h): This dialog"  1>&2
}

exit_abnormal() {
  usage
  exit 1
}
while getopts ":g:e:s:c:p:h" options; do
  case "${options}" in
    g)
      APPID=${OPTARG}
      ;;
    e)
      EXE=${OPTARG}
      ;;
    s)
      STEAMPATH=${OPTARG}
      ;;
    c)
      COMPATDATA=${OPTARG}
      ;;
    p)
      PROTONPATH=${OPTARG}
      ;;
    h)
      usage
      exit 0
      ;;
    :)
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal
      ;;
    *)
      exit_abnormal
      ;;
  esac
done

if [ "APPID" == "" ]; then
    echo "APPID (-a) not set. Exiting."
    exit 1
fi
if ! [ -f "$EXE" ]; then
    echo "Can't find the executeabel '$EXE'. Exiting."
    exit 1
fi
if [ "$STEAMPATH" == "" ]; then
    STEAMPATH="$HOME/.steam"

fi
if ! [ -d "$STEAMPATH" ]; then
    echo "Can't find the steam folder '$STEAMPATH'. Exiting."
    exit 1
fi
if [ "$COMPATDATA" == "" ]; then
    COMPATDATA="$HOME/.local/share/Steam/steamapps/compatdata"
fi
if ! [ -d "$COMPATDATA/$APPID" ]; then
    echo "Can't find the compatdata folder '$COMPATDATA/$APPID'. Exiting."
    exit 1
fi
if [ "$PROTONPATH" == "" ]; then
    search='/share/default_pfx/'
    while read -r line
    do
        if [[ $line = *$search* ]]
        then
            PROTONPATH=$(dirname $line)
            PROTONPATH=$(dirname $PROTONPATH)
            PROTONPATH=$(dirname $PROTONPATH)
        fi
    done < "$COMPATDATA/$APPID/config_info"
fi
if ! [ -f "$PROTONPATH/proton" ]; then
    echo "Can't find the proton binary '$PROTONPATH/proton'. Exiting."
    exit 1
fi

echo $APPID
echo $EXE
echo $STEAMPATH
echo $COMPATDATA
echo $PROTONPATH


compatdataDir="$COMPATDATA/$APPID"
mkdir "$compatdataDir" 2> /dev/null
winePrefixDir=${compatdataDir}/pfx
echo $winePrefixDir
#cd "$winePrefixDir"
export STEAM_COMPAT_DATA_PATH=${compatdataDir}
export STEAM_COMPAT_CLIENT_INSTALL_PATH=${STEAMPATH}
export WINEPREFIX="${winePrefixDir}"
echo "$PROTONPATH/proton run $EXE"
"$PROTONPATH/proton" run "$EXE"
exit 0
