#bin/sh
#
# usage :
# ./jonction.sh -p <folder path>
#

clear
PREVIOUS_DIR=$(pwd)
REPORTS_FOLDER_PATH=$PREVIOUS_DIR"/reports"
mkdir $REPORTS_FOLDER_PATH

REPORT_PATH=$REPORTS_FOLDER_PATH"/report.txt"
INSPECTOR_HTML_PATH=$REPORTS_FOLDER_PATH"/report.html"
GIT_SHORT_LOGS_PATH=$REPORTS_FOLDER_PATH"/shortlogs.txt"
LONG_LOGS_PATH=$REPORTS_FOLDER_PATH"/longlogs.txt"

cd "$(dirname "$0")"

echo "Very dirty basic report + $INSPECTOR_HTML_PATH\n\n"  > $REPORT_PATH
echo "" > $INSPECTOR_HTML_PATH

# Arguments parsing
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
      -p|--folder-path)
      GIT_FOLDER_PATH="$2"
      ;;
      *)
      #
      ;;
  esac
  shift
done

# Import the options file?
if [ -z ${GIT_FOLDER_PATH+x} ];
    then
    echo "Folder path is missing use ./jonction.sh -p <folder path>"
    exit 1
    else
    echo "Moving to $GIT_FOLDER_PATH"
    cd $GIT_FOLDER_PATH
fi;

# Analytics REPORT GIT & CLOC

echo "\nnumber of users :" >> $REPORT_PATH
git shortlog -s -n | wc -l >> $REPORT_PATH

echo "\nnumber of commits:\n" >> $REPORT_PATH
git log --pretty=oneline | wc -l >> $REPORT_PATH

echo "\nMain users:\n" >> $REPORT_PATH
git shortlog -s -n >> $REPORT_PATH

echo "\n\n" >>  $REPORT_PATH
cloc $GIT_FOLDER_PATH >> $REPORT_PATH
echo "\n\n" >> $REPORT_PATH

git log --pretty=format:"%h - %an, %ar : %s" > $GIT_SHORT_LOGS_PATH

git log > $LONG_LOGS_PATH
# Git inspector

gitinspector --format=htmlembedded >> $INSPECTOR_HTML_PATH

# Open the file
if [[ "$OSTYPE" =~ ^darwin ]];
   then
      open $REPORTS_FOLDER_PATH
fi;

cd "$PREVIOUS_DIR"
exit 0
