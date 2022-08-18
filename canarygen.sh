#!/bin/bash



#Randomize file type
fileNames=(CONFIDENTIAL.docx Admininfo.docx userpasswords.docx Clientinformation.xlsx financeinfo.xlsx userandpassw.xlsx)
email="security@company.com"


getFiletype() 
{
    if [[ "$1" == *.docx ]] ;then
        echo ms_word
        return
    fi

	if [[ "$1" == *.xlsx ]] ;then
        echo ms_excel
        return
	fi
    
	echo ""
    return
}


repeat()
{
	size=${#fileNames[@]}
	index=$((RANDOM % size))
	
	outFilename="${fileNames[$index]}"
	unset "fileNames[$index]"
	fileNames=("${fileNames[@]}" )

	type=$(getFiletype "${outFilename}") 

	if [ -z "$type" ]
	then 
		echo "ERROR Empty filetype"
		return 
	fi
	 
	# Get hostname from MDM email 
	mdmUserEmail="$(sudo defaults read company user.email)"
	if [ -z "${mdmUserEmail}" ]; then
		mdmUserEmail="$(hostname)"
	fi
	echo "Retrieving ${mdmUserEmail} from MDM"

	#variables
	memo="The ${outFilename} (${type}) canary file was triggered for ${mdmUserEmail}."
    
	# curl for document and auth for file download + add email for triggered tokens 
	jsonResponse=$( curl -s -X POST -F "type=${type}" -F "email=$email" -F "memo=$memo" -F "webhook="  https://www.canarytokens.org/generate )
	echo "Curl POST request $email"

	# javascript payload 
	read -r -d '' JS <<EOF
	function run() {
		var response = JSON.parse(\`$jsonResponse\`);
		return response.Token + "," + response.Auth;
	}
EOF

	# Parse JSON to extract value's
	returnvalue=$( osascript -l 'JavaScript' <<< "${JS}" )
	Token=$(echo "$returnvalue" | cut -d "," -f 1)
	Auth=$(echo "$returnvalue" | cut -d "," -f 2)

	#post curl to dowloand file
	curl -s -o "${outFilename}" "https://www.canarytokens.org/download?fmt=${type//_/}&token=${Token}&auth=${Auth}"
	echo "Curl request download $outFilename"
}

#repeat for x amount of documents wanted
count=3
for i in $(seq $count); do
echo "Creating file ${i}/${count}"
  repeat
done

## rm script after completion 
#path=$( readlink -f "${BASH_SOURCE:-$0}" )
#rm "${path}" 