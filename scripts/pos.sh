#!/bin/bash
# ./pos 

#initialize files for the results table (formality_scores)

echo ML F-Score > mlscore.col
echo ES F-Score > esscore.col
echo EN F-Score > enscore.col
echo EN Nouns > ennouns.col
echo ES Nouns > esnouns.col
echo EN Adjectives > enadjs.col
echo ES Adjectives > esadjs.col
echo EN Prepositions > enpreps.col
echo ES Prepositions > espreps.col
echo EN Articles > enarts.col
echo ES Articles > esarts.col
echo EN Pronouns > enpnouns.col
echo ES Pronouns > espnouns.col
echo EN Verbs > enverbs.col
echo ES Verbs > esverbs.col
echo EN Adverbs > enadvs.col
echo ES Adverbs > esadvs.col
echo EN Interjections > enintj.col
echo ES Interjections > esintj.col
####

# contains counts for EN & CS instances
#f-score for multilingual utterances

for file in ~/text_tools_project/project_data_files/*.cha
do
	#extract morphological line

	cat $file | grep -w "%mor" > mlmor
	
	#extract parts of speech
	
	n=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /noun/) print $i}' mlmor | wc -l)
	aj=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adj/) print $i}' mlmor | wc -l)
	p=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adp/) print $i}' mlmor | wc -l)
	ar=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /det/) print $i}' mlmor | grep -w "Art$" | wc -l)
	pn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /pron/) print $i}' mlmor | grep "|" | wc -l)
	v=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /verb/ || $i ~ /aux/) print $i}' mlmor | wc -l)
	av=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adv/) print $i}' mlmor | wc -l)
	in=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /intj/) print $i}' mlmor | wc -l)

	#calculate vocab size to normalize
	
	vocab=$(awk -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')

	#calculate f-score

	awk -v v="$vocab" -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj ) / v + 1) * 50}' >> mlscore.col

done 

#f-score for ES only utterances

for file in ~/text_tools_project/project_data_files/*.cha
do
	cat $file | grep -A1 spa] | grep -w "%mor" > spanmor
	nsn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /noun/) print $i}' spanmor | wc -l)
	echo $nsn >> esnouns.col
	nsaj=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adj/) print $i}' spanmor | wc -l)
	echo $nsaj >> esadjs.col
	nsp=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adp/) print $i}' spanmor | wc -l)
	echo $nsp >> espreps.col
	nsar=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /det/) print $i}' spanmor | grep -w "Art$" | wc -l)
	echo $nsar >> esarts.col
	nspn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /pron/) print $i}' spanmor | grep "|" | wc -l)
	echo $nspn >> espnouns.col
	nsv=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /verb/ || $i ~ /aux/) print $i}' spanmor | wc -l)
	echo $nsv >> esverbs.col
	nsav=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adv/) print $i}' spanmor | wc -l)
	echo $nsav >> esadvs.col
	nsin=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /intj/) print $i}' spanmor | wc -l)
	echo $nsin >> esintj.col
	

	nsvocab=$(awk -v n="$nsn" -v adj="$nsaj" -v prep="$nsp" -v art="$nsar" -v pron="$nspn" -v verbs="$nsv" -v adverbs="$nsav" -v intj="$nsin" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')
	
	awk -v v="$nsvocab" -v n="$nsn" -v adj="$nsaj" -v prep="$nsp" -v art="$nsar" -v pron="$nspn" -v verbs="$nsv" -v adverbs="$nsav" -v intj="$nsin" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj) / v + 1) * 50}' >> esscore.col

done

#f-score for EN only utterances

for file in ~/text_tools_project/project_data_files/*.cha
do
        cat $file | grep -w "%mor" | sort > mlmor
        cat $file | grep -A1 spa] | grep -w "%mor" | sort > spanmor

        comm -23 mlmor spanmor > enmor


        en=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /noun/) print $i}' enmor | wc -l)
	echo $en >> ennouns.col
        eaj=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adj/) print $i}' enmor | wc -l)
        echo $eaj >> enadjs.col
	ep=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adp/) print $i}' enmor | wc -l)
        echo $ep >> enpreps.col
	ear=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /det/) print $i}' enmor | grep -w "Art$" | wc -l)
	echo $ear >> enarts.col
        epn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /pron/) print $i}' enmor | grep "|" | wc -l)
	echo $epn >> enpnouns.col
        ev=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /verb/ || $i ~ /aux/) print $i}' enmor | wc -l)
	echo $ev >> enverbs.col
        eav=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adv/) print $i}' enmor | wc -l)
	echo $eav >> enadvs.col
        ein=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /intj/) print $i}' enmor | wc -l)
	echo $ein >> enintj.col


        vocab=$(awk -v n="$en" -v adj="$eaj" -v prep="$ep" -v art="$ear" -v pron="$epn" -v verbs="$ev" -v adverbs="$eav" -v intj="$ein" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')

        awk -v v="$vocab" -v n="$en" -v adj="$eaj" -v prep="$ep" -v art="$ear" -v pron="$epn" -v verbs="$ev" -v adverbs="$eav" -v intj="$ein" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj ) / v + 1) * 50}' >> enscore.col

done


#concating all the info into 1 table
#this returns tsv

paste convo.col situations.col relat.col mlscore.col enscore.col esscore.col ennouns.col esnouns.col enadjs.col esadjs.col enpreps.col espreps.col enarts.col esarts.col enpnouns.col espnouns.col enverbs.col esverbs.col enadvs.col esadvs.col enintj.col esintj.col > formality_scores 

#convert to csv (optional)
#sed 's/,//g' formality_scores > fs_nocommas
#sed 's/  /,/g' fs_nocommas > formality_scores.csv



