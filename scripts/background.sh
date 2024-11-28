#!/bin/bash
# ./ background
#this script does the original clean-up of the files and outputs the files used by the pos.sh script to its appropriate directory
#records a conversation number for each transcript and situation information.
#identifies the 3 main relationship dynamic categories or other

#initialize files
echo Conversation No. > convo.col
echo Situation > situations.col


for file in ~/text_tools_project/Miami/eng/*.cha
do
while read -r line; do
	if [[ "$line" =~ 'spa]' ]]; then
		filename=$(basename "$file")
		cp "$file" ~/text_tools_project/project_data_files/"$filename"
	fi
done < "$file"
done

count=1
for file in ~/text_tools_project/project_data_files/*.cha
do
	echo $count >> convo.col	

	sit=$(cat $file | grep -w "@Situation" | cut -f2 -d ':')
	echo $sit >> situations.col

	count=$(( $count + 1 ))
done

while read -r line; do
        if [[ "$line" =~ 'Situation' ]]; then
                echo Relationship Category > relat.col
        elif [[ "$line" =~ 'cousin'|'sister'|'couple'|'grand' ]]; then
                echo Family >> relat.col
        elif [[ "$line" =~ 'colleague'|'worker' ]]; then
                echo Work >> relat.col
        elif [[ "$line" =~ 'friend' ]]; then
                echo Friend >> relat.col
        elif [[ "$line" =~ 'informal' ]]; then
                echo Other informal >> relat.col
        else
                echo Other >> relat.col
        fi
done < situations.col

