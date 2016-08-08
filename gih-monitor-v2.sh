#!/bin/bash

profilefolder="profiles"

function check_domain() {
    # $1 = profil
    # $2 = domain
    case "$1" in
        aile)
            dns="193.192.98.59"
            yip="193.192.98.49"
        ;;
        aile-oyun)
            dns="193.192.98.51"
            yip="193.192.98.46"
        ;;
        aile-sohbet)
            dns="193.192.98.54"
            yip="193.192.98.47"
        ;;
        aile-sosyal)
            dns="193.192.98.56"
            yip="193.192.98.48"
        ;;
        aile+oyun+sohbet)
            dns="193.192.98.52"
            yip="193.192.98.42"
        ;;
        aile+sosyal+oyun)
            dns="193.192.98.57"
            yip="193.192.98.43"
        ;;
        aile+sohbet+sosyal)
            dns="193.192.98.55"
            yip="193.192.98.45"
        ;;
        aile+oyun+sohbet+sosyal)
            dns="193.192.98.20"
            yip="193.192.98.41"
        ;;
        cocuk)
            dns="193.192.98.58"
            yip="193.192.98.40"
        ;;
        *)
            echo "invalid profile"
            exit 1
        ;;
    esac

    for ip in $(dig $2 @$dns +short); do
        break
    done

    tip="195.175.254.2"


    # yip = yasakli web sayfasi
    # tip = turk telekom yasakli web sayfasi
    if [ "$ip" == "$yip" ] || [ "$ip" == "$tip" ]; then
        # yasakli
        echo "$ip"
        return 2
    else
        # izinli
        echo "$ip"
        return 4
    fi

    return 1
}


for profile in $(ls $profilefolder); do
        echo "$profilefolder/$profile"
        counter=0
        result=""
        while read profil y ydomain i idomain; do
                ycheck=$(check_domain $profil $ydomain)
                if [ $? != 2 ]; then
                    yresult="$profile profilinde yasakli olmasi gereken $ydomain erisilebilir. - Cozulen adres: $ycheck"
                    #echo "$yresult"
                    result="$result$yresult\n"
                    let counter=$counter+1
                fi
                icheck=$(check_domain $profil $idomain)
                if [ $? != 4 ]; then
                    iresult="$profile profilinde izinli olmasi gereken $idomain yasakli. - Cozulen adres: $icheck"
                    #echo "$iresult"
                    result="$result$iresult\n"
                    let counter=$counter+1
                fi
                #result="$result$yresult\n$iresult\n"
                #output="$output $profil     $ydomain $ycheck $idomain $icheck\n"
        done < $profilefolder/$profile

        if [ $counter == 0 ]; then
            echo "$profile profilinde sorun yok."
        else
            printf "$result"
            echo "$counter sorguda sorun var."
        fi
done

exit 0
