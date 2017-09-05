#! /usr/bin/env python
# -*- encoding: utf-8 -*-


import sys
reload(sys)
sys.setdefaultencoding('utf8')

import datetime
import time
import erppeek

from datetime import date

from cfg_secret_configuration import odoo_configuration_user


###############################################################################
# Odoo Connection
###############################################################################
def init_openerp(url, login, password, database):
    openerp = erppeek.Client(url)
    uid = openerp.login(login, password=password, database=database)
    user = openerp.ResUsers.browse(uid)
    tz = user.tz
    return openerp, uid, tz

openerp, uid, tz = init_openerp(
    odoo_configuration_user['url'],
    odoo_configuration_user['login'],
    odoo_configuration_user['password'],
    odoo_configuration_user['database'])


###############################################################################
# Configuration
###############################################################################

###############################################################################
# Script
###############################################################################


## On parcourt les partners 
partners = openerp.ResPartner.browse([])

## Nb de partner 
print "found %d partners" % len(partners)
count = 0


class Counter(dict):
    def __missing__(self, key):
        return 0
c = Counter()
semaineEntree=Counter()
moisEntree=Counter()
zips = Counter()
zipsMacro= Counter() 
gender = Counter() 
dateCumulee = Counter() 
tab_age =Counter () 


file = open("output/data/membres.csv","w") 
 
## On parcourt les partners 
for partner in partners:

	## On ne sélectionne que les Coopérateurs ( champ partner.member / effective cooperator) 
    if partner.member == True :  
	count += 1
	annee=partner.effective_date[0:4]
	mois=partner.effective_date[5:7]
	jour=partner.effective_date[8:10]
	semaine=datetime.datetime(int(annee),int(mois),int(jour)).isocalendar()[1]
	#print "%s %s %s " % (annee , mois , jour ) 
	semaineEntree[annee+"-"+ str(semaine)]+=1 
	moisEntree[annee+"-"+str(mois)]+=1

	## On fait un tableau de nb d'inscription par date effective d'entrée du coop 
	c[partner.effective_date]+= 1

	## nettoyage des codes postaux : 59.700 -> 59700 / 59 200 -> 59200 
	zips[str(partner.zip).replace('.','').replace(' ','')]+=1

	## Gender  
	gender[str(partner.gender)]+=1

	#Tranche d'âge  
	today = date.today()


	if partner.birthdate == False : 
		tab_age['N/A']+=1
	else : 
		annee_anniv = partner.birthdate[0:4]
		mois_anniv = partner.birthdate[5:7]
		jour_anniv = partner.birthdate[8:10]
		anniv=datetime.datetime(int(annee_anniv),int(mois_anniv),int(jour_anniv))
		
	    	age=today.year - anniv.year - ((today.month, today.day) < (anniv.month, anniv.day))
		if age <25	:
			tab_age['18-25']+=1

		if age >=25 and age <45	:
			tab_age['25-45']+=1

		if age >=45 and age <60	:
			tab_age['45-60']+=1

		if age >=60	:
			tab_age['>60']+=1

		


	file.write( "%s,%s,%s,%s,%s,%s,%s\n" % (
		partner.name , 
		partner.email,
		partner.effective_date,
		partner.birthdate,
		partner.gender,
		partner.zip,
		partner.city 
	) ) 



print "Nb de cooperateurs : %s" % (count )

file.close() 


file = open("output/data/dates.csv","w") 
for k, v in c.iteritems():
	file.write("%s,%s\n" %(k, v)) 
file.close() 

file = open("output/data/zips.csv","w") 
for k, v in zips.iteritems():
	file.write("%s,%s\n" %(k, v)) 
	if v>5 :
		zipsMacro[k]=v
	else : 
		zipsMacro["autre"]+=v 
file.close() 


file2 = open("output/data/zipsMacro.csv","w") 
for k, v in zipsMacro.iteritems():
	file2.write("%s,%s\n" %(k, v)) 
file2.close() 


file3= open("output/data/semaines.csv","w") 
for k, v in semaineEntree.iteritems():
	file3.write("%s,%s\n" %(k, v)) 
file3.close() 


file3bis= open("output/data/mois.csv","w") 
for k, v in sorted(moisEntree.iteritems()):
	file3bis.write("%s,%s\n" %(k, v)) 
file3bis.close() 


file4= open("output/data/gender.csv","w") 
for k, v in gender.iteritems():
	file4.write("%s,%s\n" %(k, v)) 
file4.close() 


count=0
file5 = open("output/data/datescumules.csv","w") 
for k, v in sorted(c.iteritems()):
	count+=v
	file5.write("%s,%s\n" %(k, count)) 
file5.close() 


file6= open("output/data/moiscumules.csv","w")
count=0 
for k, v in sorted(moisEntree.iteritems()):
	count+=v
	file6.write("%s,%s\n" %(k, count)) 
file6.close() 


file7= open("output/data/age.csv","w")
count=0 
for k, v in sorted(tab_age.iteritems()):
	file7.write("%s,%s\n" %(k, v)) 
file7.close() 


