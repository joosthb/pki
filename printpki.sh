for FILE in data/*cert.pem
do 
echo $FILE
# openssl x509 -in $FILE -text
openssl verify -verbose -CAfile data/ca-cert.pem  $FILE
echo
# break
done
