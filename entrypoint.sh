#/bin/bash
bash -c  "nohup mega-cmd" &
sleep 1
if [[ "$USERNAME" != "NOBODY" ]] && [[ "$PASSWORD" != "CHANGEME" ]]; then
    mega-login $USERNAME $PASSWORD
else
    echo "Please specify a valid username and password with -e USERNAME and -e PASSWORD. Aborting."
    exit 1
fi
if [ -d $TARGET ]; then
    ARCHIVENAME=$PREFIX$(echo _$(date --iso-8601)_$(date +%s))
    if [[ -f "/gpg/public.key" ]] && [[ "$GPG_ID" != "NONE" ]]; then
        gpg --import --armor /gpg/public.key
        ARCHIVENAME=$ARCHIVENAME.gpg.zip
        gpg-zip -r $GPG_ID --gpg-args "--batch --trust-model always" -e -o $ARCHIVENAME $TARGET/*
        TARGET=$ARCHIVENAME
    else
        ARCHIVENAME=$ARCHIVENAME.tar.gz
        tar -czvf $ARCHIVENAME $TARGET/*
    fi
else
    echo "Please mount the dir that you want to upload to $TARGET or set \$TARGET to an existing dir. Aborting."
    exit 1
fi
mega-put $ARCHIVENAME
exec $@

