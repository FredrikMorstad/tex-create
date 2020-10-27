#!/bin/bash
dir=$(pwd)
name="report_temp.tex"
report=0
subj=""
subjName=""
file=""
num=0

declare -A subjects=(["INF-2202"]="Concurrent Data-intensive Programming" ["INF-2300"]="Computer" ["INF-2700"]="Databases")

parse_file(){
	if [ -z "$subj" ];then
		echo "failed"
	fi

	echo "$subj"
	echo "$subjName"

	if [ ! -z "$subj" ]; then
		sed -i "s/\<Subject\>/${subj}/g" $file
		sed -i "s/\<Header\>/${subj}/g" $file
	fi

	if [ ! -z "$subjName" ]; then
		sed -i "s/Name/${subjName}/g" $file
	fi
	echo "${num}"
	sed -i "s/Num/${num}/g" $file
}

set_up(){
	# val= ${!subjects["inf-2202"]}
	subj=${subj^^}
	subjName=${subjects[$subj]}
	# printf "$subj $subjName"

	cd ~/Templates
	a=$(find . -maxdepth 1 -name $name)

	if [ -z $a ]; then
		exit 1
	fi

	curdir=$(pwd)

	if [ $curdir = $dir ]; then
		cp $name $new_name".tex"
	else
		cp $curdir/$name $dir
		mv $dir/$name $dir/$new_name".tex"
		file=$dir/$new_name".tex"
	fi

	parse_file
}

if [ $# = 0 ];then
	echo "0 args"
	exit 1
fi

usage(){
	echo "Usage -r -n or --name [filename] for report"
}

while [ "$1" != "" ]; do
	case $1 in
		-r | --report) report=1;;

		-n | --name) shift; new_name=$1;;

		-h | --help) usage;;

		-s | --sub) shift; subj=$1;;

		-num | --num) shift; num=$1;;

		* ) usage;;

	esac
	shift
done

if [ $report = 1 ];then
	set_up 
fi

