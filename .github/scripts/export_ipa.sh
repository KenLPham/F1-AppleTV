# clear old files
rm -rf F1TV.ipa
# create temp dir
mkdir Payload
# copy app file
cp -r build/F1TV.xcarchive/Products/Applications/F1TV.app Payload
# compress archive to IPA
zip -r F1TV.ipa Payload
# delete temp file
rm -rf Payload
