#!/bin/ksh 




#########################################################


# file:autosvn.ksh
# Automatic checkout from SVN to deploy scripts dir
# created by: Zvika Gutkin


#########################################################








DT=$(date '+%Y%m%d')




echo -n "Would you like to create date_type directory [Y]: "
read DATE_TYPE

echo -n "Enter DBAR Output Directory [/home/oracle/11g/vertica_scripts_deployment]: "
read OUTPUTDIR
#OUTPUTDIR=${DIR:-"/home/oracle/11g/vertica_scripts_deployment"}



echo -n "Enter SVN Username : "
read SVNUSER

echo -n "Enter SVN Path (full path)[http://tlvsvn1:18080/svn/le-data/trunk/le-campaign/dal/src/main/resources/sql] : "
read SVNPATH

 if [[ $DATE_TYPE = "N" ]]
    then

    echo "${OUTPUTDIR}/"
    echo "Cheking out ${SVNPATH} ....."
    svn checkout --username ${SVNUSER} ${SVNPATH}  ${OUTPUTDIR}/
 else
    echo -n "Enter Deploy Type [site_data b_default dbadmin general ]: "
    read DEPLOYTYPE

    echo "${OUTPUTDIR}/${DT}_${DEPLOYTYPE}"
    mkdir -p ${OUTPUTDIR}/${DT}_${DEPLOYTYPE}
    echo "Cheking out ${SVNPATH} ....."
    svn checkout --username ${SVNUSER} ${SVNPATH}  ${OUTPUTDIR}/${DT}_${DEPLOYTYPE}

 fi


