### Generate Key
```
keytool -genkeypair -v -keystore willie-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias willie-key
```
```
Enter keystore password:
Re-enter new password:
What is your first and last name?
  [Unknown]:  Willie
What is the name of your organizational unit?
  [Unknown]:  Willie
What is the name of your organization?
  [Unknown]:  PIS
What is the name of your City or Locality?
  [Unknown]:  Taiwan
What is the name of your State or Province?
  [Unknown]:  Taiwan
What is the two-letter country code for this unit?
  [Unknown]:  TW
Is CN=Willie, OU=Willie, O=PIS, L=Taiwan, ST=Taiwan, C=TW correct?
  [no]:  yes

Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
        for: CN=Willie, OU=Willie, O=PIS, L=Taiwan, ST=Taiwan, C=TW
[Storing willie-release-key.jks]
```
### Sign APK
#### Install
```
pkg install apksigner
```
#### Sign APK
```
apksigner sign --ks willie-release-key.jks --ks-key-alias willie-key --ks-pass pass:ck1110169 --key-pass pass:ck1110169 --out com.willie.mancala_10.apk ~/app-release-unsigned.apk
```