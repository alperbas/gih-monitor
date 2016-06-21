#!/bin/bash

function check_domain() {
    # $1 = profil
    # $2 = domain
    case "$1" in
        aile)
            dns="193.192.98.20"
            yip="193.192.98.49"
        ;;
        aile-oyun)
            dns="193.192.98.55"
            yip="193.192.98.46"
        ;;
        aile-sohbet)
            dns="193.192.98.57"
            yip="193.192.98.47"
        ;;
        aile-sosyal)
            dns="193.192.98.52"
            yip="193.192.98.48"
        ;;
        aile+oyun+sohbet)
            dns="193.192.98.56"
            yip="193.192.98.42"
        ;;
        aile+sosyal+oyun)
            dns="193.192.98.54"
            yip="193.192.98.43"
        ;;
        aile+sohbet+sosyal)
            dns="193.192.98.51"
            yip="193.192.98.45"
        ;;
        aile+oyun+sohbet+sosyal)
            dns="193.192.98.59"
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

    #dig $2 @$dns +short | while read ip eq; do
    #    echo $ip
    #done

    for ip in $(dig $2 @$dns +short); do
        break
    done

    if [ "$ip" == "$yip" ]; then
        echo "yasakli bu"
    else
        echo "yasakli degil bu"
    fi

    return 0
}

while read profil y ydomain i idomain; do
        #echo "====== $profil ======"
        ycheck=$(check_domain $profil $ydomain)
        #echo $y $ydomain $ycheck
        icheck=$(check_domain $profil $idomain)
        #echo $i $idomain $icheck
        #echo ""
        #echo "$profile $ydomain $ychech $idomain $icheck"
        output="$output $profil     $ydomain $ycheck $idomain $icheck\n"
done < ./domains.txt

printf "$output"
