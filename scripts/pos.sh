#!/bin/bash
# ./pos 

#extract verbs
# file mentioned in cat file should be pre-processed to be 1 speaker with tagged data


echo ML F-Score > mlscore.col
echo ES F-Score > esscore.col
echo EN F-Score > enscore.col
####

# contains counts for EN & CS instances

for file in ~/text_tools_project/project_data_files/*.cha
do
	cat $file | grep -w "%mor" > mlmor
	
	n=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /noun/) print $i}' mlmor | wc -l)
	aj=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adj/) print $i}' mlmor | wc -l)
	p=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adp/) print $i}' mlmor | wc -l)
	ar=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /det/) print $i}' mlmor | grep -w "Art$" | wc -l)
	pn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /pron/) print $i}' mlmor | grep "|" | wc -l)
	v=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /verb/ || $i ~ /aux/) print $i}' mlmor | wc -l)
	av=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adv/) print $i}' mlmor | wc -l)
	in=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /intj/) print $i}' mlmor | wc -l)
	
	#echo noun $n adj $aj preps $p arts $ar prons $pn verbs $v adverbs $av intj $in
	vocab=$(awk -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')
	awk -v v="$vocab" -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj ) / v + 1) * 50}' >> mlscore.col

done 


for file in ~/text_tools_project/project_data_files/*.cha
do
	cat $file | grep -A1 spa] | grep -w "%mor" > spanmor
	nsn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /noun/) print $i}' spanmor | wc -l)
	nsaj=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adj/) print $i}' spanmor | wc -l)
	nsp=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adp/) print $i}' spanmor | wc -l)
	nsar=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /det/) print $i}' spanmor | grep -w "Art$" | wc -l)
	nspn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /pron/) print $i}' spanmor | grep "|" | wc -l)
	nsv=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /verb/ || $i ~ /aux/) print $i}' spanmor | wc -l)
	nsav=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adv/) print $i}' spanmor | wc -l)
	nsin=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /intj/) print $i}' spanmor | wc -l)
	
	#echo noun $nsn adj $nsaj preps $nsp arts $nsar prons $nspn verbs $nsv adverbs $nsav intj $nsin

	nsvocab=$(awk -v n="$nsn" -v adj="$nsaj" -v prep="$nsp" -v art="$nsar" -v pron="$nspn" -v verbs="$nsv" -v adverbs="$nsav" -v intj="$nsin" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')
	awk -v v="$nsvocab" -v n="$nsn" -v adj="$nsaj" -v prep="$nsp" -v art="$nsar" -v pron="$nspn" -v verbs="$nsv" -v adverbs="$nsav" -v intj="$nsin" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj) / v + 1) * 50}' >> esscore.col
done

for file in ~/text_tools_project/project_data_files/*.cha
do
        cat $file | grep -w "%mor" | sort > mlmor
        cat $file | grep -A1 spa] | grep -w "%mor" | sort > spanmor

        comm -23 mlmor spanmor > enmor


        n=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /noun/) print $i}' enmor | wc -l)
        aj=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adj/) print $i}' enmor | wc -l)
        p=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adp/) print $i}' enmor | wc -l)
        ar=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /det/) print $i}' enmor | grep -w "Art$" | wc -l)
        pn=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /pron/) print $i}' enmor | grep "|" | wc -l)
        v=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /verb/ || $i ~ /aux/) print $i}' enmor | wc -l)
        av=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /adv/) print $i}' enmor | wc -l)
        in=$(awk '{ for (i = 1; i<= NF; i++) if ($i ~ /intj/) print $i}' enmor | wc -l)

        #echo noun $n adj $aj preps $p arts $ar prons $pn verbs $v adverbs $av intj $in
        vocab=$(awk -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')
        awk -v v="$vocab" -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj ) / v + 1) * 50}' >> enscore.col

done


#concating all the info into 1 table

paste convo.col situations.col mlscore.col enscore.col esscore.col > formality_scores 



#### formality score calcs


#nsvocab=$(awk -v n="$nsn" -v adj="$nsaj" -v prep="$nsp" -v art="$nsar" -v pron="$nspn" -v verbs="$nsv" -v adverbs="$nsav" -v intj="$nsin" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')
#awk -v v="$nsvocab" -v n="$nsn" -v adj="$nsaj" -v prep="$nsp" -v art="$nsar" -v pron="$nspn" -v verbs="$nsv" -v adverbs="$nsav" -v intj="$nsin" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj) / v + 1) * 50}'
#vocab=$(awk -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print ( n + adj + prep + art + pron + verbs + adverbs + intj )}')
#awk -v v="$vocab" -v n="$n" -v adj="$aj" -v prep="$p" -v art="$ar" -v pron="$pn" -v verbs="$v" -v adverbs="$av" -v intj="$in" 'BEGIN {print (( n + adj + prep + art - pron - verbs - adverbs - intj ) / v + 1) * 50}'


