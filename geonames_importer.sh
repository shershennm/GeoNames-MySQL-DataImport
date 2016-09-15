#!/bin/bash

# Default values for database variables.
dbhost="localhost"
dbport=3306
dbname="geonames"
dir=$( cd "$( dirname "$0" )" && pwd )

download_folder="`pwd`/download"

logo() {
	echo "================================================================================================"
	echo "                           GEONAMES US POSTAL CODE IMPORTER                                     "
	echo "================================================================================================"
}

usage() {
	logo
	echo "Usage: " $0 "-u <user> -p <password> -h <host> -r <port> -n <dbname>"
	echo " This is to operate with the geographic database"
    echo " Actions go in order: "
	echo "    download-data Downloads the last packages of data available in GeoNames."
    echo "    drop-table If table with predefined name exists."
    echo "    create-table Creates the table in the current database. Useful if we want to import them in an exsiting db."
    echo "    import-dumps Imports geonames data into db. A database is previously needed for this to work."
    echo
    echo " The rest of parameters indicates the following information:"
	echo "    -u <user>     User name to access database server."
	echo "    -p <password> User password to access database server."
	echo "    -h <host>     Data Base Server address (default: localhost)."
	echo "    -r <port>     Data Base Server Port (default: 3306)"
	echo "    -n <dbname>  Data Base Name for the geonames.org data (default: geonames)"
	echo "================================================================================================"
    exit -1
}

download_geonames_data() {
	echo "Downloading GeoNames.org data..." 
    download_folder="$1"
    wget -c -P "$download_folder" -O "US.zip" http://download.geonames.org/export/zip/US.zip
    unzip "*.zip" -d ./download
    rm *.zip
}

if [ $# -lt 1 ]; then
	usage
	exit 1
fi

logo

# Deals with operation mode 2 (Database issues...)
# Parses command line parameters.
while getopts "a:u:p:h:r:n:" opt; 
do
    case $opt in
        a) action=$OPTARG ;;
        u) dbusername=$OPTARG ;;
        p) dbpassword=$OPTARG ;;
        h) dbhost=$OPTARG ;;
        r) dbport=$OPTARG ;;
        n) dbname=$OPTARG ;;
    esac
done


case $action in
    download-data)
        download_geonames_data
        exit 0
    ;;
esac

if [ -z $dbusername ]; then
    echo "No user name provided for accessing the database. Please write some value in parameter -u..."
    exit 1
fi

if [ -z $dbpassword ]; then
    echo "No user password provided for accessing the database. Please write some value in parameter -p..."
    exit 1
fi

echo "download_folder=$download_folder"
download_geonames_data "$download_folder"

echo "Database parameters being used..."
echo "Orden: " $action
echo "UserName: " $dbusername
echo "Password: " $dbpassword
echo "DB Host: " $dbhost
echo "DB Port: " $dbport
echo "DB Name: " $dbname

echo "Creating tables for database $dbname..."
mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword -Bse "USE $dbname;" 
mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword $dbname < $dir/geonames_db_struct.sql

echo "Importing postal code dumps into database $dbname"
mysql -h $dbhost -P $dbport -u $dbusername -p$dbpassword --local-infile=1 $dbname < $dir/geonames_import_data.sql

echo "Clearing download folder"
rm -rf $download_folder

if [ $? == 0 ]; then 
	echo "[OK]"
else
	echo "[FAILED]"
fi

exit 0
