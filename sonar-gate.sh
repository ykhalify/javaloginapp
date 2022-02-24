if [ -e tmp.txt ];

then

rm tmp.txt

rm error.txt

rm task.json

fi





url=$(cat $WORKSPACE/sonar/report-task.txt | grep ceTaskUrl | cut -c11- )

echo ${url}

pswd=$1

curl -s -X GET -u "${pswd}" "$url" | python -m json.tool



stsCheck=1



while [ $stsCheck = 1 ]

do

sleep 10

curl -s -X GET -u "${pswd}" "$url" -o task.json

status=$(python -m json.tool < task.json | grep -i "status" | cut --delimiter=: --fields=2 | sed 's/"//g' | sed 's/,//g' )

echo ${status}



if [ $status = SUCCESS ]; then

analysisID=$(python -m json.tool < task.json | grep -i "analysisId" | cut -c24- | sed 's/"//g' | sed 's/,//g')

analysisUrl="http://10.4.0.5:9000/api/qualitygates/project_status?analysisId=${analysisID}"

echo ${analysisID}

echo ${analysisUrl}



stsCheck=0

fi

done



curl -s -X GET -u "${pswd}" -L $analysisUrl | python -m json.tool

curl -s -X GET -u "${pswd}" -L $analysisUrl | python -m json.tool | grep -i "status" | cut -c28- | sed 's/.$//' >> tmp.txt

cat tmp.txt

sed -n '/ERROR/p' tmp.txt >> error.txt

cat error.txt

if [ $(cat error.txt | wc -l) -eq 0 ]; then

echo "Quality Gate Passed ! Setting up SonarQube Job Status to Success ! "

else

echo "Quality Gate Failed ! Setting up SonarQube Job Status to Failure ! "

exit 1

fi
