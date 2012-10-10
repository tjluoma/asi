#!/bin/zsh
# get the description of a Mac app
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2012-10-09

NAME="$0:t"

# NOTE: see my .tidyrc here https://github.com/tjluoma/dotfiles/blob/master/tidyrc
# You will probably need to force tidy to make output or else it gets all persnickety

export HTML_TIDY="$HOME/Dropbox/etc/tidy/basic-clean-reformat.rc"


####|####|####|####|####|####|####|####|####|####|####|####|####|####|####

if ((! $+commands[lynx] ))
then

	# note: if lynx is a function or alias, it will come back not found

	echo "$NAME: lynx is required but not found in $PATH"
	exit 1

fi


if ((! $+commands[html2text.py] ))
then

	# note: if html2text.py is a function or alias, it will come back not found

	echo "$NAME: html2text.py is required but not found in $PATH"
	echo "	Get it from https://github.com/aaronsw/html2text/downloads"
	exit 1

fi

####|####|####|####|####|####|####|####|####|####|####|####|####|####|####



	# This is where files will be stored.
	# if you are worried about security, I guess, you could use ~/.Trash instead of /tmp
	# if your directory can't be used, /tmp will be
DIR="/tmp"


ERROR=0

for ARGS in "$@"
do

	case "$ARGS" in
		-d|--des*)
							DESCRIPTION=yes
							ALL=no
							shift
		;;

		-p|--price)
							PRICE=yes
							ALL=no
							shift
		;;

		-r|--rating)
							RATING=yes
							ALL=no
							shift

		;;

		-s|--size)
							SIZE=yes
							ALL=no
							shift
		;;

		-n|--name)
							APPNAME=yes
							ALL=no
							shift
		;;

		-D|--dev*)
							DEVELOPER=yes
							ALL=no
							shift
		;;

		-R|--require*)
							REQUIREMENTS=yes
							ALL=no
							shift

		;;

		-u|--url)
							OFFICIAL_URL=yes
							ALL=no
							shift
		;;


		-i|--icon)
							ICON=yes
							ALL=no
							shift
		;;

		-*)

							echo "$NAME: I don't know what to do with $1"
							exit 1
		;;

	esac

done

####|####|####|####|####|####|####|####|####|####|####|####|####|####|####


if [[ "$ALL" != "no" ]]
then
	# if the user didn't ask for one specific piece of info, give them everything

		DESCRIPTION=yes
		PRICE=yes
		RATING=yes
		SIZE=yes
		APPNAME=yes
		DEVELOPER=yes
		REQUIREMENTS=yes
		OFFICIAL_URL=yes
		ICON=yes
fi

####|####|####|####|####|####|####|####|####|####|####|####|####|####|####

get_description () {

	DESC="$PREFIX.$ID.description.txt"

	sed '1,/Titledbox_Description/d ; /<div class="customer-reviews">/,$d ; /<h2>Screenshots<\/h2>/,$d' "$HTML" |\
		html2text.py --body-width=0 --ignore-images > "$DESC"

		# True if file exists and has a size greater than zero.
	if [[ -s "$DESC" ]]
	then
			echo '(Description Start)'
			cat "$DESC"
			echo '(Description End)'
	else
			msg "$DESC (DESC) is zero bytes"
			ERROR=1
	fi
}


get_appname () {

	APPNAME=$(egrep -i '^<title>' "$HTML" | sed 's#</title>##g ; s#<title>##g ; s#Mac App Store - ##g ; s# on the iTunes App Store##g' | lynx -dump -stdin -nolist -nomargins -nonumbers -width=1024)

	if [[ "$APPNAME" == "" ]]
	then
			die "$NAME: No app name found for $URL"
			ERROR=1
	else
			echo "AppName: $APPNAME"
	fi

}

get_developer () {

	DEVNAME=$(fgrep -i '<h2>By' "$HTML" | sed 's#<h2>By ##g ; s#</h2>##g')


	if [[ "$DEVNAME" == "" ]]
	then
			echo "$NAME: No developer name found for $URL"
			ERROR=1
	else
			echo "DevName: $DEVNAME"
	fi

}


get_icon_url () {

	ICON_URL=$(awk -F'"' '/http.*og:image/{print $2}' "$HTML")

	if [[ "$ICON_URL" == "" ]]
	then
			echo "$NAME: No icon URL found for $URL"
			ERROR=1
	else
			echo "IconURL: $ICON_URL"
	fi

}

get_rating () {

	IFS=$'\n' RATINGS=($(egrep -A1 '(Current Version|All Versions):' "$HTML" | fgrep 'aria-label=' | sed "s#'>##g ; s#.*'##g"))

	if [ "$RATINGS[2]" != "" -a "$RATINGS[1]" != "" ]
	then
		echo "RatingCurrentVersion: $RATINGS[1]"
		echo "RatingForAllVersions: $RATINGS[2]"
	elif [ "$RATINGS[2]" = "" -a "$RATINGS[1]" != "" ]
	then
		echo "Rating: $RATINGS[1]"
	else
		echo "Rating: No information available"
	fi



}

get_requirements () {

	REQ=$(fgrep app-requirements "$HTML" | lynx -dump -stdin -nolist -nomargins -nonumbers -width=1024)

	if [[ "$REQ" == "" ]]
	then
			echo "$NAME: No Requirements found for $URL"
			ERROR=1
	else
			echo "$REQ"
	fi

}

get_size () {
	APPSIZE=$(fgrep '<span class="label">Size:</span>' "$HTML" | lynx -dump -stdin -nolist -nomargins -nonumbers  -width=1024| sed 's#^ *##g')

	if [[ "$APPSIZE" == "" ]]
	then
			echo "$NAME: No App Size found for $URL"
			ERROR=1
	else
			echo "$APPSIZE"
	fi
}

get_official_url () {

	CANON_URL=$(awk -F '"' '/<link rel="canonical"/{print $4}' "$HTML")

	if [[ "$CANON_URL" == "" ]]
	then
			echo "$NAME: No canonical URL found for $URL"
			ERROR=1
	else
			echo "OfficialURL: $CANON_URL"
	fi

}

get_price () {

APP_PRICE=$(grep '<div class="price">' "$HTML" | lynx -dump -stdin -nolist -nomargins -nonumbers -width=1024)

	if [[ "$APP_PRICE" == "" ]]
	then
			echo "$NAME: No App Price found for $URL"
			ERROR=1
	else
			echo "AppPrice: $APP_PRICE"
	fi

}

####|####|####|####|####|####|####|####|####|####|####|####|####|####|####



cd "$DIR" || cd /tmp

PREFIX="$USER.$$.$EPOCHSECONDS"

for URL in $@
do

	ID=$(echo "$URL" | sed 's#?.*##; s#.*/##g')

	HTML="$PREFIX.$ID.html"

	HEADERS="$PREFIX.$ID.txt"

	curl --silent --location --dump-header "$HEADERS" "$URL" | tidy > "$HTML"

		# True if file exists and has a size greater than zero.
	if [[ ! -s "$HTML" ]]
	then
			msg "$HTML (HTML) is zero bytes"
			exit 1
	fi

	# [[ "$APPNAME" == "yes" ]] 		&& get_appname

	get_appname

	[[ "$DEVELOPER" == "yes" ]] 	&& get_developer

	[[ "$DESCRIPTION" == "yes" ]] 	&& get_description

	[[ "$ICON" == "yes" ]] 			&& get_icon_url

	[[ "$RATING" == "yes" ]] 		&& get_rating

	[[ "$REQUIREMENTS" == "yes" ]]	&& get_requirements

	[[ "$SIZE" == "yes" ]] 			&& get_size

	[[ "$OFFICIAL_URL" == "yes" ]] 	&& get_official_url

	[[ "$PRICE" == "yes" ]] 		&& get_price


done

exit $ERROR

#
#EOF
