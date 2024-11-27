#!/bin/bash
# ./ background
#this script does the original clean-up of the files and outputs the files used by the pos.sh and calculator.sh scripts
#this script also records a conversation ID for each transcript and situation information.


#initialize the results table file
echo Conversation No. > convo.col
echo Situation > situations.col

count=1

for file in ~/text_tools_project/Miami/eng/*.cha
do
while read -r line; do
	if [[ "$line" =~ 'spa]' ]]; then
		filename=$(basename "$file")
		cp "$file" ~/text_tools_project/project_data_files/"$filename"
	fi
done < "$file"
done


for file in ~/text_tools_project/project_data_files/*.cha
do
	echo $count >> convo.col	

	sit=$(cat $file | grep -w "@Situation" | cut -f2 -d ':')
	echo $sit >> situations.col

	count=$(( $count + 1 ))
done
