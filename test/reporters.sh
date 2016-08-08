#!/bin/bash

reporter[0]="stylint-stylish"
reporter[1]="stylint-teamcity-reporter"
reporter[2]="stylint-json-reporter"
reporter[3]="None"

reporters=$(expr ${#reporter[@]} - 1)

clear;

stylint="node_modules/.bin/stylint test/test.styl"

echo -e "Reporters: $reporters reported.\n\n"

for i in $(seq 0 $reporters);
do
	reporter=${reporter[$i]}
	formatted="$stylint --reporter $reporter"
	echo "-----------------------------------------------------------------"
	echo -e -n "\nReporter: "
	if	[ $i -eq $reporters ]; then
		echo "$reporter"
		echo -e "\n-----------------------------------------------------------------\n"
		## echo -e "\nStage_1 : Index $i\n"
		$stylint
	else
		echo "$reporter"
		echo -e "\n-----------------------------------------------------------------\n"
		## echo -e "\nStage_2 : Index $i\n"
		$formatted
	fi
	if		[ $? -ne 0 ]; then
		$status=$?
		clear
		echo -e "\n-----------------------------------------------------------------\n"
		echo "Status: Somethings Fucky with $reporter."
		echo ""
		echo "Check for typo's with the reporters name in this"
		echo "scripts reporters array at the top of the file (tmp/cmd)."
		echo "Make sure the reporters are correctly installed."
		echo ""
		echo -e "\n-----------------------------------------------------------------\n"
		exit $status
	else
		echo -e "\n-----------------------------------------------------------------\n"
		echo -e "Status: Looks Good.\n"
	fi
done
