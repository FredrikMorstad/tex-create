#!/bin/bash
dir=$(pwd)
name="report_temp.tex"
report=0
subj=""
subjName=""
file=""
num=1

declare -A subjects=(
	["INF-2202"]="Concurrent Data-intensive Programming" 
	["INF-2300"]="Computer Network" 
	["INF-2700"]="Databases Systems"
)

parse_file(){
	subj=${subj^^}
	subjName=${subjects[$subj]}

	if [ -z subjName ]; then
		printf "Could not find $subj"
		exit 1
	fi

	sed -i "s/\<Subject\>/${subj}/g" $file
	sed -i "s/\<Header\>/${subj}/g" $file
	sed -i "s/Name/${subjName}/g" $file
	sed -i "s/Num/${num}/g" $file
}

set_up(){
	cd ~/Templates
	check=$(find . -maxdepth 1 -name $name)

	if [ -z $check ]; then
		printf "Could not find report template \n"
		exit 1
	fi

	curdir=$(pwd)

	if [ $curdir = $dir ]; then
		cp $name $new_name".tex"
	else
		echo "not same dir"
		cp $curdir/$name $dir
		mv $dir/$name $dir/$new_name".tex"
		file=$dir/$new_name".tex"
	fi

	if [ ! -z "$subj" ];then
		parse_file
	fi
}


usage(){
	echo "Usage:  
		Required:
			-n or --name [filename]
		Optional:
			-r for report (default)
			-s or --sub to specify subject
			-num or --num to specify Assignment number
	"
}

if [ $# = 0 ];then
	usage
	exit 1
fi

while [ "$1" != "" ]; do
	case $1 in
		-n | --name) shift; new_name=$1;;

		-r | --report) report=1;;

		-h | --help) usage;;

		-s | --sub) shift; subj=$1;;

		-num | --num) shift; num=$1;;

		* ) usage;;

	esac
	shift
done

echo $new_name
if [ ! -z "$new_name" ];then
	set_up 
else
	usage
fi

