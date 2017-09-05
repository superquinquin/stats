#!/bin/bash


mkdir -p ./output/html/
mkdir -p ./output/data/

python statistiques.py 

echo "Les doublons"
echo "------------------"
more output/data/membres.csv | sort |cut -d "," -f1  | uniq -c | sed -e "s/\  //g" | grep -v "^1"

echo

echo "Sans date effective"
echo "------------------"
more output/data/membres.csv |cut -d "," -f3 | grep False 


echo "Recopie des chart.js "
echo "------------------"
cp html/Chart.bundle.js ./output/html
cp html/utils.js ./output/html
cp -p -r html/assets ./output/html 

date=`date  +"%d/%m/%Y"
`
FOOTER="<li>Superquinquin. Stats générée le $date</li> <a href='csv/csv.zip'> </a> " 

MENU="<nav id=\"nav\"><ul><li><a href=\"\">Coop</a><ul><li><a href=\"coop_genre.html\">Genre</a></li><li><a href=\"coop_code_postal.html\">Code postal</a></li><li><a href=\"coop_semaine.html\">Semaine</a></li><li><a href=\"coop_age.html\">Age</a></li></ul></li><li><a href=\"\">Bientôt</a></li></ul></nav>"

echo "Par code postal"
echo "------------------"
LABELS=""
DATA=""
LABEL_DATASET_1="code postal"
PAGE_TITLE="Situation geographique"
CHART_TITLE="Les coopérateurs par code postal ( + de 5 personnes sinon autre)"  
FILE_TEMPLATE=./html/modele_doughnut.html
FILE_OUTPUT=./output/html/coop_code_postal.html
for i in ` cat output/data/zipsMacro.csv `
do 
	code=`echo $i|cut -d "," -f1`
	nb=`echo $i|cut -d "," -f2`	
	ville=`grep "$code," output/data/membres.csv  | cut -d "," -f6-7 | sort -n | uniq -c |sort -n | tail -1 | cut -d "," -f2` 
 
	LABELS=`echo $LABELS \"$code-$ville\" ,` 
	DATA=`echo $DATA $nb,` 
	 
done
COUNT_DATA=`echo $DATA |sed -e "s/,/\n/g" |wc -l`

cat  $FILE_TEMPLATE>$FILE_OUTPUT  
sed -i  "s#{MENU}#${MENU}#" $FILE_OUTPUT
sed -i  "s#{PAGE_TITLE}#${PAGE_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABEL_DATASET_1}#${LABEL_DATASET_1}#" $FILE_OUTPUT
sed -i  "s#{CHART_TITLE}#${CHART_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABELS}#${LABELS}#" $FILE_OUTPUT
sed -i  "s#{DATA}#${DATA}#" $FILE_OUTPUT
sed -i  "s#{COUNT_DATA}#${COUNT_DATA}#" $FILE_OUTPUT
sed -i  "s#{FOOTER}#${FOOTER}#" $FILE_OUTPUT





echo "Par Age "
echo "------------------"
LABELS=""
DATA=""
LABEL_DATASET_1="Age"
PAGE_TITLE="Par tranche d âge"
CHART_TITLE="Les coopérateurs par tranche d âge"  
FILE_TEMPLATE=./html/modele_doughnut.html
FILE_OUTPUT=./output/html/coop_age.html
for i in ` cat output/data/age.csv `
do 
	tranche=`echo $i|cut -d "," -f1`
	nb=`echo $i|cut -d "," -f2`	
	
	LABELS=`echo $LABELS \"$tranche\" ,` 
	DATA=`echo $DATA $nb,` 
	 
done
COUNT_DATA=`echo $DATA |sed -e "s/,/\n/g" |wc -l`

cat  $FILE_TEMPLATE>$FILE_OUTPUT  
sed -i  "s#{MENU}#${MENU}#" $FILE_OUTPUT
sed -i  "s#{PAGE_TITLE}#${PAGE_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABEL_DATASET_1}#${LABEL_DATASET_1}#" $FILE_OUTPUT
sed -i  "s#{CHART_TITLE}#${CHART_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABELS}#${LABELS}#" $FILE_OUTPUT
sed -i  "s#{DATA}#${DATA}#" $FILE_OUTPUT
sed -i  "s#{COUNT_DATA}#${COUNT_DATA}#" $FILE_OUTPUT
sed -i  "s#{FOOTER}#${FOOTER}#" $FILE_OUTPUT
















echo "Par semaine"
echo "------------------"
LABELS=""
DATA=""
LABEL_DATASET_1="Coop/semaine"
PAGE_TITLE="Cooperateurs/Coopératrices par semaine"
CHART_TITLE="Nb de coopérateurs/coopératrices actifs inscrits dans la semaine N°"  
FILE_TEMPLATE=./html/modele_barre.html
FILE_OUTPUT=./output/html/coop_semaine.html
for i in ` cat output/data/semaines.csv  | sort -n `
do 
	date=`echo $i|cut -d "," -f1`
	nb=`echo $i|cut -d "," -f2`	
	
	LABELS=`echo $LABELS \"$date\" ,` 
	DATA=`echo $DATA $nb,` 
done


cat  $FILE_TEMPLATE>$FILE_OUTPUT  
sed -i  "s#{MENU}#${MENU}#" $FILE_OUTPUT
sed -i  "s#{PAGE_TITLE}#${PAGE_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABEL_DATASET_1}#${LABEL_DATASET_1}#" $FILE_OUTPUT
sed -i  "s#{CHART_TITLE}#${CHART_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABELS}#${LABELS}#" $FILE_OUTPUT
sed -i  "s#{DATA}#${DATA}#" $FILE_OUTPUT
sed -i  "s#{FOOTER}#${FOOTER}#" $FILE_OUTPUT



echo "Par jour "
echo "------------------"
LABELS=""
DATA=""
LABEL_DATASET_1="Coopérateurs / Coopératrices "
PAGE_TITLE="Cooperateurs/Coopératrices"
nb=`cat output/data/membres.csv|wc -l`

CHART_TITLE="Nb de coopérateurs/coopératrices actifs ($nb)"  
FILE_TEMPLATE=./html/modele_barre.html
FILE_OUTPUT=./output/html/index.html
for i in ` cat output/data/moiscumules.csv  | sort -n `
do 
	date=`echo $i|cut -d "," -f1`
	nb=`echo $i|cut -d "," -f2`	
	
	LABELS=`echo $LABELS \"$date\" ,` 
	DATA=`echo $DATA $nb,` 
	
done


cat  $FILE_TEMPLATE>$FILE_OUTPUT  
sed -i  "s#{MENU}#${MENU}#" $FILE_OUTPUT
sed -i  "s#{PAGE_TITLE}#${PAGE_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABEL_DATASET_1}#${LABEL_DATASET_1}#" $FILE_OUTPUT
sed -i  "s#{CHART_TITLE}#${CHART_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABELS}#${LABELS}#" $FILE_OUTPUT
sed -i  "s#{DATA}#${DATA}#" $FILE_OUTPUT
sed -i  "s#{FOOTER}#${FOOTER}#" $FILE_OUTPUT



echo "Par Genre"
echo "------------------"
LABELS=""
DATA=""
LABEL_DATASET_1="Genre"
PAGE_TITLE="Les coopérateurs / coopératrices par genre "
CHART_TITLE="Les coopérateurs / coopératrices par genre "  
FILE_TEMPLATE=./html/modele_doughnut.html
FILE_OUTPUT=./output/html/coop_genre.html
for i in ` cat output/data/gender.csv`
do 
	genre=`echo $i|cut -d "," -f1`
	nb=`echo $i|cut -d "," -f2`	
 
	LABELS=`echo $LABELS \"$genre\" ,` 
	DATA=`echo $DATA $nb,` 
	 
done
COUNT_DATA=`echo $DATA |sed -e "s/,/\n/g" |wc -l`

cat  $FILE_TEMPLATE>$FILE_OUTPUT  
sed -i  "s#{MENU}#${MENU}#" $FILE_OUTPUT
sed -i  "s#{PAGE_TITLE}#${PAGE_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABEL_DATASET_1}#${LABEL_DATASET_1}#" $FILE_OUTPUT
sed -i  "s#{CHART_TITLE}#${CHART_TITLE}#" $FILE_OUTPUT
sed -i  "s#{LABELS}#${LABELS}#" $FILE_OUTPUT
sed -i  "s#{DATA}#${DATA}#" $FILE_OUTPUT
sed -i  "s#{COUNT_DATA}#${COUNT_DATA}#" $FILE_OUTPUT
sed -i  "s#{FOOTER}#${FOOTER}#" $FILE_OUTPUT




mkdir -p output/html/csv 
rm output/html/csv.zip 
zip output/html/csv/csv.zip output/data/*.csv




