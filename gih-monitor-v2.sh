#!/bin/bash

home="/usr/local/bin/gih-monitor/"
profilefolder="profiles"
eval `date "+day=%d; month=%m; year=%Y"`
logfolder="/var/log/gih-monitor"
logfile="gih-monitor-log-$year$month$day.txt"



function check_domain() {
    # $1 = profil
    # $2 = domain
    case "$1" in
        aile)
            dns="193.192.98.59"
            yip="193.192.98.41"
        ;;
        aile-oyun)
            dns="193.192.98.55"
            yip="193.192.98.45"
        ;;
        aile-sohbet)
            dns="193.192.98.57"
            yip="193.192.98.43"
        ;;
        aile-sosyal)
            dns="193.192.98.52"
            yip="193.192.98.42"
        ;;
        aile+oyun+sohbet)
            dns="193.192.98.56"
            yip="193.192.98.48"
        ;;
        aile+sosyal+oyun)
            dns="193.192.98.54"
            yip="193.192.98.47"
        ;;
        aile+sohbet+sosyal)
            dns="193.192.98.51"
            yip="193.192.98.46"
        ;;
        aile+oyun+sohbet+sosyal)
            dns="193.192.98.20"
            yip="193.192.98.49"
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

function send_result() {

    /usr/bin/perl $home/sendmail.pl "$HTML" "$STATUS"

}

BODY=""
STATUS="OK"
for profile in $(ls $home/$profilefolder); do
        count=$(cat $profilefolder/$profile | wc -l)
        let count=$count*2
        printf "$profilefolder/$profile profili icin $count sorgu yapıldı.\n" | tee -a $logfolder/$logfile
        #BODY="$BODY$profilefolder/$profile profili icin $count sorgu yapıldı.\n"
        counter=0
        result=""
        while read profil y ydomain i idomain; do
                ycheck=$(check_domain $profil $ydomain)
                if [ $? != 2 ]; then
                    yresult="   Yasakli olmasi gereken $ydomain erisilebilir. - Cozulen adres: $ycheck"
                    #echo "$yresult"
                    result="$result$yresult\n<br>"
                    let counter=$counter+1
                fi
                icheck=$(check_domain $profil $idomain)
                if [ $? != 4 ]; then
                    iresult="   İzinli olmasi gereken $idomain yasakli. - Cozulen adres: $icheck"
                    #echo "$iresult"
                    result="$result$iresult\n<br>"
                    let counter=$counter+1
                fi
                #result="$result$yresult\n$iresult\n"
                #output="$output $profil     $ydomain $ycheck $idomain $icheck\n"
        done < $profilefolder/$profile

        if [ $counter == 0 ]; then
            printf "$profile profilinde sorun yok.\n" | tee -a $logfolder/$logfile
            echo "-------------------------------------------------" | tee -a $logfolder/$logfile
            BRESULT=$(printf " <tr><td> $profile </td><td> OK </td><td> </td></tr>\n")
        else
            printf "$profile profili icin $counter sorguda sorun var.\n" | tee -a $logfolder/$logfile
            printf "$result"                                           | tee -a $logfolder/$logfile
            echo "-------------------------------------------------" | tee -a $logfolder/$logfile
            BRESULT=$(printf " <tr><td> $profile </td><td> ERR </td><td> $result </td></tr>\n")
            STATUS="ERR"

        fi
        BODY=$BODY$BRESULT
done

#echo $BODY

HTML="<style type=\"text/css\">
 table.tableizer-table {
  font-size: 12px;
  border: 1px solid #CCC;
  font-family: Arial, Helvetica, sans-serif;
 }
 .tableizer-table td {
  padding: 4px;
  margin: 3px;
  border: 1px solid #CCC;
 }
 .tableizer-table th {
  background-color: #104E8B;
  color: #FFF;
  font-weight: bold;
 }
</style>
<table class=\"tableizer-table\">
<thead><tr class=\"tableizer-firstrow\"><th>GÜVENLİ İNTERNET PROFİLLERİ</th><th>DURUM</th><th>HATA NEDENİ/LOGU</th></tr></thead><tbody>
 $BODY
</tbody></table>"

send_result

exit 0
