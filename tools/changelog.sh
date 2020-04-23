#!/bin/sh

export Changelog=$PWD/Changelog.txt

if [ -f $Changelog ];
then
    rm -f $Changelog
fi

touch $Changelog

for i in $(seq 14);
do
export After_Date=`date --date="$i days ago" +%F`
k=$(expr $i - 1)
export Until_Date=`date --date="$k days ago" +%F`
echo "====================" >> $Changelog;
echo "     $Until_Date    " >> $Changelog;
echo "====================" >> $Changelog;
repo forall -c "GIT_LOG=\`git log --oneline --after=$After_Date --until=$Until_Date\` ; if [ ! -z \"\$GIT_LOG\" ]; then printf  '\n   * '; realpath \`pwd\` | sed 's|^$CURRENT_PATH/||' ; printf \"\$GIT_LOG\"; fi" >> $Changelog

echo "" >> $Changelog;
done

sed -i 's/project/ */g' $Changelog
sed -i 's/[/]$//' $Changelog

cp $Changelog $OUT/
