#!/bin/bash
# This script advises on jars with different version in a  directory. Provides a command to remove those jars.
# The script can be change to delete the files as well
# For example: if a directory contains jersey-client-1.18.1.jar jersey-client-1.17.1.jar
# it will advise to remove jersey-client-1.17.1.jar

# pass the --remove option to remove the files

###
### A Few Functions
###

#
# Pad version numbers for comparision i.e. te-2.7.2.jar to te-2.07.02.jar
#
pad_numbers() {
	#       ?           ; Add 0 to any ending single digit
    #                   ; |                   ; Any single digit number and prepend with 0
    #                   ; |                   ; |                     ; prepends 0 to any number before a hyphen
    #                   ; |                   ; |                     ; |                      ; prepends 0 to any number before a '.'
    #                   ; |                   ; |                     ; |                      ; |
    #                   ; |                   ; |                     ; |                      ; |
    #sed 's/^[0-9]\./0&/; s/\.\([0-9]\)$/.0\1/; s/\.\([0-9]\)\./.0\1./; s/\.\([0-9]\+-\)/.0\1/g; s/\.\([0-9]\)\./.0\1./g;'
    sed 's/^[0-9]\./0&/; s/\.\([0-9]\)$/.0\1/; s/\.\([0-9]\)\./.0\1./; s/\.\([0-9]\+-\)/.0\1/g; s/\.\([0-9]\)\./.0\1./g;' \
    | sed 's/\([0-9]\)\.jar/\1.000.jar/'
	# lastly add '.000' to number to handle miss matching version lenghts is 2.3 and 2.3.1
}
remove_pad() {
		# remove .000
		# remove leading 0
		# remove prepended 0
    sed 's/\([0-9]\).000.jar/\1.jar/; s/^0// ; s/\.0/./g'
}

wrapper() {
		#sed 's/ /\n   /g'
        #sed 's/^/   /g'
        awk '/^</{s=$0;next}{print $0,s}' | sed 's/^/   /g' | fmt --width=90 -t
}

### Requires pending file name
check_if_pending_and_official_exist() {
    local pending_filename="$@"
    local test_file=$(echo ${pending_filename} | sed 's/-pending//g' )

    # If this is a pending file
    if [[ $pending_filename == *"pending"* ]] ; then
        # if this file without pending exists in the listing then discard
        if [[ $(ls -r *.jar) =~ ${test_file} ]]; then
            #echo "It's there! SO NEED TO discard $pending_filename"
            return 0 # true
        fi
    fi
    return 1 # false
}

usage() {
		echo "This script advises which old jar files to remove."
		echo "It only looks in the directory in which it is run."
		echo "By default, the script will only instruct."
		echo
		echo "Usage: $(basename $0) [Options]"
		echo
		echo "  --remove : Remove the jars"
		echo
}

###
### Main
###

# TODO better option handling
if [ "$#" -gt 0 ] ; then
		if [ "$1" == '--remove' ] ; then
			RemoveFiles=yes
		else
			echo "Error: Bad Option"
			usage
			exit 254

		fi
fi

# find . | sed -e 's/^.\///' | grep "^json-[0-9]\+[\.0-9\.\-]*[a-z]*[A-Z]*[0-9]*.jar"
patternVersion='-[0-9]\+[\.0-9\.\-]*[a-z]*[A-Z]*[0-9]*.jar'

# Compare/Get lists of basenames
# sdiff -bB <(ls *.jar|sort -r) <(ls *.jar|sort|sed  's/-[0-9]\+[\.0-9\.\-]*[a-z]*[A-Z]*[0-9]*.jar//g' | uniq | sort -r)

list_of_files_to_remove=""
list_of_files_to_skip=""
list_of_files_to_keep=""

PREFIXES=$(ls -1 -I "*-*-*-*" |sed  "s/$patternVersion//g" | uniq )

for PREFIX in ${PREFIXES} ; do

	PREFIX_TYPE="num"
	delete_file=""
	keep_file=""
	test_file=""

	### count the files that match prefix
	#prefix_file_count=$( 2>/dev/null ls -r ${PREFIX}${patternVersion} | wc -l )
	prefix_file_count=$( 2>/dev/null ls -1 ${PREFIX}* | wc -l )
	prefix_files=$( 2>/dev/null ls -1 ${PREFIX}* | sort -r )

	if [ "$prefix_file_count" -gt "1" ]; then

    	sorted_file=""
		#for FILE_PAD in `echo $prefix_files | grep -- ^${PREFIX}${patternVersion} | pad_numbers | sort -r `; do
		for FILE_PAD in `ls -r ${PREFIX}* | grep -- ^${PREFIX}${patternVersion} | pad_numbers | sort -r `; do

			FILE_NOPAD=$(echo $FILE_PAD | remove_pad)
   			#skip_file=""
			test_file=$(echo ${FILE_NOPAD}* | sed 's/-pending//g' )

			if [[ -z $keep_file ]] ; then
				keep_file="${FILE_NOPAD}"
				shift
			else
				delete_file="${delete_file} ${FILE_NOPAD}"
			fi

   			#file_prefix=$( echo ${FILE} | sed 's/^\(.*\)-.*$/\1/' )
   			#if [[ ${PREFIX} != ${file_prefix} ]]; then
   			#	skip_file=${FILE}
   			#	break
   			#fi
		done
	elif [ "$prefix_file_count" -eq "1" ]; then
		test_file=$(ls -r ${PREFIX}* | grep -- ^${PREFIX}${patternVersion} | sort -r | head -1 )
	    if check_if_pending_and_official_exist ${test_file} ; then
			delete_file="${delete_file} ${test_file}"
		else
			keep_file=$test_file
		fi
	fi

	list_of_files_to_remove="$list_of_files_to_remove $delete_file"
	list_of_files_to_skip="$list_of_files_to_skip $skip_file"
	list_of_files_to_keep="$list_of_files_to_keep $keep_file"

done

list_of_files_to_remove="$( echo "$list_of_files_to_remove" | tr -s ' ' )"
list_of_files_to_skip="$( echo "$list_of_files_to_skip" | tr -s ' ' )"
list_of_files_to_keep="$( echo "$list_of_files_to_keep" | tr -s ' ' )"

if [[ -z $list_of_files_to_remove ]] ; then
		echo "No old jars to be removed"
		exit
fi

if [ "$RemoveFiles" == "yes" ] ; then
		echo "Deleting ..."
		echo ""
		echo "rm -rf $list_of_files_to_remove"
		echo ""

        rm -f $list_of_files_to_remove

		echo "Done."
else
		echo ""
		echo "rm -rf $list_of_files_to_remove"
		echo ""

		# FINAL concat seen + deleted which needs to equal ls *.jar else echo error+diff
		### differences which should be none
		diff -urbBw <(ls -1 *.jar  | sort -r) <(echo $list_of_files_to_remove $list_of_files_to_keep | sed 's/ /\n/g' |  sort -r )
fi

##############
### TESTING
###
#
# jars="
# foo-bar-baz-2.6.2.jar
# foo-bar-baz-2.7.2.jar
# foo-bar-baz-2.7.9.jar
# ets-gml311-3.1.jar
# ets-gml32-1.25.jar
# ets-gml32-1.21.jar
# json-20090211.jar
# json-20080701.jar
# teamengine-spi-5.3.jar
# teamengine-spi-ctl-5.3.jar
# geotk-utility-3.21.jar
# geotk-utility-pending-3.21.jar
# geoapi-pending-3.1-M04.jar
# geomatics-geotk-1.10.jar
# geomatics-geotk-1.14.jar
# geomatics-geotk-1.9.jar
# geotk-utility-3.21.jar
# geotk-utility-pending-3.21.jar
# guava-16.0.1.jar
# guava-26.0-jre.jar
# javax.annotation-api-1.2-b03.jar
# javax.servlet.jsp.jstl-1.2.3.jar
# saxon9-9.0.0.8.jar
# groovy-json-2.4.12.jar
# json-path-3.1.0.jar
# json-simple-1.1.1.jar
# jsonoverlay-4.0.4.jar
# httpclient-4.5.3.jar
# httpclient-4.5.jar
# "
#
# DIR="${1:-test.d}"
#
# mkdir $DIR 2>/dev/null || false
#
# for x in $jars ; do
#         touch $DIR/$x
# done
#
# printf "=== %10s %20s  %30s ===\n"  "Current jars" " ===|=== "  "Jars to be Removed; Jars to be kept marked with '<'"
# find-repeated-jars.sh | grep "rm" | sed -e 's/^rm -rf//;s/ /\n/g; ' | sort | sed -e '/^\s*$/d' \
# | sdiff -Wbw 72 <(ls -1 *.jar | sort -r | sed -e '/^$/d' |  sort) -

