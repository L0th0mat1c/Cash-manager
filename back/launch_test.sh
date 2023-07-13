sed -i 's/cashmanager-mysql/localhost:3306/g' src/main/resources/application.properties

mysql -h 127.0.0.1 -P 3306 -ucashmanagerUser -pabcd cashmanager -e "DELETE FROM Locality;"
mysql -h 127.0.0.1 -P 3306 -ucashmanagerUser -pabcd cashmanager -e "DELETE FROM BankAccount;"

mvn clean install test

mysql -h 127.0.0.1 -P 3306 -ucashmanagerUser -pabcd cashmanager -e "DELETE FROM Locality;"
mysql -h 127.0.0.1 -P 3306 -ucashmanagerUser -pabcd cashmanager -e "DELETE FROM BankAccount;"

sed -i 's/localhost:3306/cashmanager-mysql/g' src/main/resources/application.properties