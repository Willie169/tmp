## OpenSSL
### Introduction about OpenSSL
**OpenSSL** is a widely used open-source software library that implements the Secure Sockets Layer (SSL) and Transport Layer Security (TLS) protocols. It provides a robust set of cryptographic functions and tools for secure communication over networks.
### Installation of OpenSSL in Termux
```
pkg install openssl openssl-tool
```
### Installation of OpenSSL in Debian
```
sudo apt install openssl libssl-dev
```
### RSA
#### Generate New Private Key
```
openssl genrsa -out /path/privatekeyfilename.pem 2048
```
`2048` means 2048 iterations, change the number as needed.
#### Generate Public Key from Private Key
```
openssl rsa -pubout -in /path/privatekeyfilename.pem -out /path/publickeyfilename.pem
```
#### Encrypt with Public Key
```
openssl pkeyutl -in /path/filename.txt -out /path/publickeyencryptedfilename.txt -inkey /path/publickeyfilename.pem -pubin -encrypt
```
#### Decrypt with Public Key
```
openssl pkeyutl -in /path/publickeyencryptedfilename.txt -out /path/filename.txt -inkey /path/privatekeyfilename.pem -decrypt
```
#### Encrypt with Private Key
```
openssl pkeyutl -in /path/filename.txt -out /path/privatekeyencryptedfilename.txt -inkey /path/privatekeyfilename.pem -encrypt
```
#### Decrypt with Private Key
```
openssl pkeyutl -in /path/privatekeyencryptedfilename.txt -out /path/filename.txt -inkey /path/publickeyfilename.pem -pubin -decrypt
```
#### Sign a Raw File
```
openssl pkeyutl -in filename.txt -rawin -out signed_filename.txt -inkey keyfile/privatekeyfile.pem -sign
```
#### Sign a Hex File
```
openssl pkeyutl -in hexfilename.txt -out signed_filename.txt -inkey keyfile/privatekeyfile.pem -sign
```
#### Verify a Signature Against a Raw File
```
openssl pkeyutl -in filename.txt -rawin -out verification.txt -sigfile signed_filename.txt -inkey keyfile/publickeyfile.pem -pubin -verify
```
#### Verify a Signature Against a Hex File
```
openssl pkeyutl -in hexfilename.txt -rawin -out verification.txt -sigfile signed_filename.txt -inkey keyfile/publickeyfile.pem -pubin -verify
```
#### All Command Options
```
openssl pkeyutl [-help] [-in file] [-rawin] [-digest algorithm] [-out file] [-sigfile file] [-inkey filename|uri] [-keyform DER|PEM|P12|ENGINE] [-passin arg] [-peerkey file] [-peerform DER|PEM|P12|ENGINE] [-pubin] [-certin] [-rev] [-sign] [-verify] [-verifyrecover] [-encrypt] [-decrypt] [-derive] [-kdf algorithm] [-kdflen length] [-pkeyopt opt:value] [-pkeyopt_passin opt[:passarg]] [-hexdump] [-asn1parse] [-engine id] [-engine_impl] [-rand files] [-writerand file] [-provider name] [-provider-path path] [-propquery propq] [-config configfile]
```
**DESCRIPTION**: This command can be used to perform low-level public key operations using any supported algorithm.\
**OPTIONS**:
- -help: Print out a usage message.
- -in filename: This specifies the input filename to read data from or standard input if this option is not specified.
- -rawin: This indicates that the input data is raw data, which is not hashed by any message digest algorithm. The user can specify a digest algorithm by using the -digest option. This option can only be used with -sign and -verify and must be used with the Ed25519 and Ed448 algorithms.
- -digest algorithm: This specifies the digest algorithm which is used to hash the input data before signing or verifying it with the input key. This option could be omitted if the signature algorithm does not require one (for instance, EdDSA). If this option is omitted but the signature algorithm requires one, a default value will be used. For signature algorithms like RSA, DSA and ECDSA, SHA-256 will be the default digest algorithm. For SM2, it will be SM3. If this option is present, then the -rawin option must be also specified.
- -out filename: Specifies the output filename to write to or standard output by default.
- -sigfile file: Signature file, required for -verify operations only
- -inkey filename|uri: The input key, by default it should be a private key.
- -keyform DER|PEM|P12|ENGINE: The key format; unspecified by default. See openssl-format-options(1) for details.
- -passin arg: The input key password source. For more information about the format of arg see openssl-passphrase-options(1).
- -peerkey file: The peer key file, used by key derivation (agreement) operations.
- -peerform DER|PEM|P12|ENGINE: The peer key format; unspecified by default. See openssl-format-options(1) for details.
- -pubin: By default a private key is read from the key input. With this option a public key is read instead. If the input contains no public key but a private key, its public part is used.
- -certin: The input is a certificate containing a public key.
- -rev: Reverse the order of the input buffer. This is useful for some libraries (such as CryptoAPI) which represent the buffer in little endian format.
- -sigfile file: Signature file, required for -verify operations only
- -inkey filename|uri: The input key, by default it should be a private key.
- -keyform DER|PEM|P12|ENGINE: The key format; unspecified by default. See openssl-format-options(1) for details.
- -passin arg: The input key password source. For more information about the format of arg see openssl-passphrase-options(1).
- -peerkey file: The peer key file, used by key derivation (agreement) operations.
- -peerform DER|PEM|P12|ENGINE: The peer key format; unspecified by default. See openssl-format-options(1) for details.
- -pubin: By default a private key is read from the key input. With this option a public key is read instead. If the input contains no public key but a private key, its public part is used.
- -certin: The input is a certificate containing a public key.
- -rev: Reverse the order of the input buffer. This is useful for some libraries (such as CryptoAPI) which represent the buffer in little endian format.
- -sign: Sign the input data (which must be a hash) and output the signed result. This requires a private key.
- -verify: Verify the input data (which must be a hash) against the signature file and indicate if the verification succeeded or failed.
- -verifyrecover: Verify the input data (which must be a hash) and output the recovered data.
- -encrypt: Encrypt the input data using a public key.
- -decrypt: Decrypt the input data using a private key.
- -derive: Derive a shared secret using the peer key.
- -kdf algorithm: Use key derivation function algorithm. The supported algorithms are at present TLS1-PRF and HKDF. Note: additional parameters and the KDF output length will normally have to be set for this to work. See EVP_PKEY_CTX_set_hkdf_md(3) and EVP_PKEY_CTX_set_tls1_prf_md(3) for the supported string parameters of each algorithm.
- -kdflen length: Set the output length for KDF.
- -pkeyopt opt:value: Public key options specified as opt:value. See NOTES below for more details.
- -pkeyopt_passin opt[:passarg]: Allows reading a public key option opt from stdin or a password source. If only opt is specified, the user will be prompted to enter a password on stdin. Alternatively, passarg can be specified which can be any value supported by openssl-passphrase-options(1).
- -hexdump: hex dump the output data.
- -asn1parse: Parse the ASN.1 output data, this is useful when combined with the -verifyrecover option when an ASN1 structure is signed.
- -engine id: See "Engine Options" in openssl(1). This option is deprecated.
- -engine_impl: When used with the -engine option, it specifies to also use engine id for crypto operations.
- -rand files, -writerand file: See "Random State Options" in openssl(1) for details.
- -provider name: -provider-path path: -propquery propq: See "Provider Options" in openssl(1), provider(7), and property(7).
- -config configfile: See "Configuration Option" in openssl(1).
### Symmetric Encryption and Decryption
#### AES-256-CBC Encryption
```
openssl enc -aes-256-cbc -in file.rar -out encfile.rar -pass pass:1234567890123456789012345678901234567890123456789012345678901234 -base64 -iv 12345678901234567890123456789012 -S 1234567890123456 -md sha-256 -iter 2048 -pbkdf2 -p
```
#### AES-256-CBC Decryption
```
openssl enc -aes-256-cbc -in encfile.rar -out file.rar -pass pass:1234567890123456789012345678901234567890123456789012345678901234 -d -base64 -iv 12345678901234567890123456789012 -S 1234567890123456 -md sha-256 -iter 2048 -pbkdf2
```
#### All Command Options 
```
openssl enc|cipher [-cipher] [-help] [-list] [-ciphers] [-in filename] [-out filename] [-pass arg] [-e] [-d] [-a] [-base64] [-A] [-k password] [-kfile filename] [-K key] [-iv IV] [-S salt] [-salt] [-nosalt] [-z] [-md digest] [-iter count] [-pbkdf2] [-saltlen size] [-p] [-P] [-bufsize number] [-nopad] [-v] [-debug] [-none] [-engine id] [-rand files] [-writerand file] [-provider name] [-provider-path path] [-propquery propq]
```
**DESCRIPTION**: The symmetric cipher commands allow data to be encrypted or decrypted using various block and stream ciphers using keys based on passwords or explicitly provided. Base64 encoding or decoding can also be performed either by itself or in addition to the encryption or decryption.
**OPTIONS**:
-help: Print out a usage message.
- -list: List all supported ciphers.
- -ciphers: Alias of -list to display all supported ciphers.
- -in filename: The input filename, standard input by default.
- -out filename: The output filename, standard output by default.
- -pass arg: The password source. For more information about the format of arg see "Pass Phrase Options" in openssl(1).
- -e: Encrypt the input data: this is the default.
- -d: Decrypt the input data.
- -a: Base64 process the data. This means that if encryption is taking place the data is base64 encoded after encryption. If decryption is set then the input data is base64 decoded before being decrypted.
- -base64: Same as -a
- -A: If the -a option is set then base64 process the data on one line.
- -k password: The password to derive the key from. This is for compatibility with previous versions of OpenSSL. Superseded by the -pass argument.
- -kfile filename: Read the password to derive the key from the first line of filename. This is for compatibility with previous versions of OpenSSL. Superseded by the -pass argument.
- -md digest: Use the specified digest to create the key from the passphrase. The default algorithm is sha-256.
- -iter count: Use a given number of iterations on the password in deriving the encryption key. High values increase the time required to brute-force the resulting file. This option enables the use of PBKDF2 algorithm to derive the key.
- -pbkdf2: Use PBKDF2 algorithm with a default iteration count of 10000 unless otherwise specified by the -iter command line option.
- -saltlen: Set the salt length to use when using the -pbkdf2 option. For compatibility reasons, the default is 8 bytes. The maximum value is currently 16 bytes. If the -pbkdf2 option is not used, then this option is ignored and a fixed salt length of 8 is used. The salt length used when encrypting must also be used when decrypting.
- -nosalt: Don't use a salt in the key derivation routines. This option SHOULD NOT be used except for test purposes or compatibility with ancient versions of OpenSSL.
- -z: Compress or decompress encrypted data using zlib after encryption or before decryption. This option exists only if OpenSSL was compiled with the zlib or zlib-dynamic option.
- -none: Use NULL cipher (no encryption or decryption of input).
- -rand files, -writerand file: See "Random State Options" in openssl(1) for details.
- -provider name: -provider-path path: -propquery propq: See "Provider Options" in openssl(1), provider(7), and property(7).
- -engine id: See "Engine Options" in openssl(1). This option is deprecated.
- Supported ciphers:
  - aes-128-cbc
  - aes-128-cfb
  - aes-128-cfb1
  - aes-128-cfb8
  - aes-128-ctr
  - aes-128-ecb
  - aes-128-ofb
  - aes-192-cbc
  - aes-192-cfb
  - aes-192-cfb1
  - aes-192-cfb8
  - aes-192-ctr
  - aes-192-ecb
  - aes-192-ofb
  - aes-256-cbc
  - aes-256-cfb
  - aes-256-cfb1
  - aes-256-cfb8
  - aes-256-ctr
  - aes-256-ecb
  - aes-256-ofb
  - aes128
  - aes128-wrap
  - aes128-wrap-pad
  - aes192
  - aes192-wrap
  - aes192-wrap-pad
  - aes256
  - aes256-wrap
  - aes256-wrap-pad
  - aria-128-cbc
  - aria-128-cfb
  - aria-128-cfb1
  - aria-128-cfb8
  - aria-128-ctr
  - aria-128-ecb
  - aria-128-ofb
  - aria-192-cbc
  - aria-192-cfb
  - aria-192-cfb1
  - aria-192-cfb8
  - aria-192-ctr
  - aria-192-ecb
  - aria-192-ofb
  - aria-256-cbc
  - aria-256-cfb
  - aria-256-cfb1
  - aria-256-cfb8
  - aria-256-ctr
  - aria-256-ecb
  - aria-256-ofb
  - aria128
  - aria192
  - aria256
  - bf
  - bf-cbc
  - bf-cfb
  - bf-ecb
  - bf-ofb
  - blowfish
  - camellia-128-cbc
  - camellia-128-cfb
  - camellia-128-cfb1
  - camellia-128-cfb8
  - camellia-128-ctr
  - camellia-128-ecb
  - camellia-128-ofb
  - camellia-192-cbc
  - camellia-192-cfb
  - camellia-192-cfb1
  - camellia-192-cfb8
  - camellia-192-ctr
  - camellia-192-ecb
  - camellia-192-ofb
  - camellia-256-cbc
  - camellia-256-cfb
  - camellia-256-cfb1
  - camellia-256-cfb8
  - camellia-256-ctr
  - camellia-256-ecb
  - camellia-256-ofb
  - camellia128
  - camellia192
  - camellia256
  - cast
  - cast-cbc
  - cast5-cbc
  - cast5-cfb
  - cast5-ecb
  - cast5-ofb
  - chacha20
  - des
  - des-cbc
  - des-cfb
  - des-cfb1
  - des-cfb8
  - des-ecb
  - des-ede
  - des-ede-cbc
  - des-ede-cfb
  - des-ede-ecb
  - des-ede-ofb
  - des-ede3
  - des-ede3-cbc
  - des-ede3-cfb
  - des-ede3-cfb1
  - des-ede3-cfb8
  - des-ede3-ecb
  - des-ede3-ofb
  - des-ofb
  - des3
  - des3-wrap
  - desx
  - desx-cbc
  - id-aes128-wrap
  - id-aes128-wrap-pad
  - id-aes192-wrap
  - id-aes192-wrap-pad
  - id-aes256-wrap
  - id-aes256-wrap-pad
  - id-smime-alg-CMS3DESwrap
  - idea
  - idea-cbc
  - idea-cfb
  - idea-ecb
  - idea-ofb
  - rc2
  - rc2-128
  - rc2-40
  - rc2-40-cbc
  - rc2-64
  - rc2-64-cbc
  - rc2-cbc
  - rc2-cfb
  - rc2-ecb
  - rc2-ofb
  - rc4
  - rc4-40
  - seed
  - seed-cbc
  - seed-cfb
  - seed-ecb
  - seed-ofb
  - sm4
  - sm4-cbc
  - sm4-cfb
  - sm4-ctr
  - sm4-ecb
  - sm4-ofb