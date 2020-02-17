get8bitCode()
{
	CODE=$1
	case $CODE in
		default)
			echo 9
			;;
		none)
			echo 9
			;;
		black)
			echo 0
			;;
		red)
			echo 1
			;;
		green)
			echo 2
			;;
		yellow)
			echo 3
			;;
		blue)
			echo 4
			;;
		magenta|purple|pink)
			echo 5
			;;
		cyan)
			echo 6
			;;
		light-gray)
			echo 7
			;;
		dark-gray)
			echo 60
			;;
		light-red)
			echo 61
			;;
		light-green)
			echo 62
			;;
		light-yellow)
			echo 63
			;;
		light-blue)
			echo 64
			;;
		light-magenta)
			echo 65
			;;
		light-cyan)
			echo 66
			;;
		white)
			echo 67
			;;
		*)
			echo 0
	esac
}

getColorCode()
{
	COLOR=$1

	## Check if color is a 256-color code
	if [ $COLOR -eq $COLOR ] 2> /dev/null; then
		if [ $COLOR -gt 0 -a $COLOR -lt 256 ]; then
			echo "38;5;$COLOR"
		else
			echo 0
		fi
	## Or if color key-workd
	else
		BITCODE=$(get8bitCode $COLOR)
		COLORCODE=$(($BITCODE + 30))
		echo $COLORCODE
	fi
}

getBackgroundCode()
{
	COLOR=$1

	## Check if color is a 256-color code
	if [ $COLOR -eq $COLOR ] 2> /dev/null; then
		if [ $COLOR -gt 0 -a $COLOR -lt 256 ]; then
			echo "48;5;$COLOR"
		else
			echo 0
		fi
	## Or if color key-workd
	else
		BITCODE=$(get8bitCode $COLOR)
		COLORCODE=$(($BITCODE + 40))
		echo $COLORCODE
	fi
}

getFormattingSequence()
{
	START='\e[0;'
	MIDLE=$1
	END='m'
	echo -n "$START$MIDLE$END"
}

applyCodeToText()
{
	local RESET=$(getFormattingSequence $(getEffectCode none))
	TEXT=$1
	CODE=$2
	echo -n "$CODE$TEXT$RESET"
}

getEffectCode()
{
	EFFECT=$1
	NONE=0

	case $EFFECT in
	none)
		echo $NONE
		;;
	default)
		echo $NONE
		;;
	bold)
		echo 1
		;;
	bright)
		echo 1
		;;
	dim)
		echo 2
		;;
	underline)
		echo 4
		;;
	blink)
		echo 5
		;;
	reverse)
		echo 7
		;;
	hidden)
		echo 8
		;;
	strikeout)
		echo 9
		;;
	*)
		echo $NONE
	esac
}

getFormatCode()
{
	local RESET=$(getFormattingSequence $(getEffectCode none))

	## NO ARGUMENT PROVIDED
	if [ "$#" -eq 0 ]; then
		echo -n "$RESET"

	## 1 ARGUMENT -> ASSUME TEXT COLOR
	elif [ "$#" -eq 1 ]; then
		TEXT_COLOR=$(getFormattingSequence $(getColorCode $1))
		echo -n "$TEXT_COLOR"

	## ARGUMENTS PROVIDED
	else
		FORMAT=""
		while [ "$1" != "" ]; do

			## PROCESS ARGUMENTS
			TYPE=$1
			ARGUMENT=$2
			case $TYPE in
			-c)
				CODE=$(getColorCode $ARGUMENT)
				;;
			-b)
				CODE=$(getBackgroundCode $ARGUMENT)
				;;
			-e)
				CODE=$(getEffectCode $ARGUMENT)
				;;
			*)
				CODE=""
			esac

			## ADD CODE SEPARATOR IF NEEDED
			if [ "$FORMAT" != "" ]; then
				FORMAT="$FORMAT;"
			fi

			## APPEND CODE
			FORMAT="$FORMAT$CODE"

			# Remove arguments from stack
			shift
			shift
		done

		## APPLY FORMAT TO TEXT
		FORMAT_CODE=$(getFormattingSequence $FORMAT)
		echo -n "${FORMAT_CODE}"
	fi

}

formatText()
{
	local RESET=$(getFormattingSequence $(getEffectCode none))

	## NO ARGUMENT PROVIDED
	if [ "$#" -eq 0 ]; then
		echo -n "${RESET}"

	## ONLY A STRING PROVIDED -> Append reset sequence
	elif [ "$#" -eq 1 ]; then
		TEXT=$1
		echo -n "${TEXT}${RESET}"

	## ARGUMENTS PROVIDED
	else
		TEXT=$1
		FORMAT_CODE=$(getFormatCode "${@:2}")
		applyCodeToText "$TEXT" "$FORMAT_CODE"
	fi
}

colorSmall()
{
	local char="▀▀"

	local palette=$(printf '%s'\
	"$(formatText "$char" -c black -b dark-gray)"\
	"$(formatText "$char" -c red -b light-red)"\
	"$(formatText "$char" -c green -b light-green)"\
	"$(formatText "$char" -c yellow -b light-yellow)"\
	"$(formatText "$char" -c blue -b light-blue)"\
	"$(formatText "$char" -c magenta -b light-magenta)"\
	"$(formatText "$char" -c cyan -b light-cyan)"\
	"$(formatText "$char" -c light-gray -b white)")

	printf "$palette"
}

colorFancy()
{
	local palette_top=$(printf '%s'\
		"$(formatText "▄" -c dark-gray)$(formatText "▄" -c dark-gray -b black)$(formatText "█" -c black) "\
		"$(formatText "▄" -c light-red)$(formatText "▄" -c light-red -b red)$(formatText "█" -c red) "\
		"$(formatText "▄" -c light-green)$(formatText "▄" -c light-green -b green)$(formatText "█" -c green) "\
		"$(formatText "▄" -c light-yellow)$(formatText "▄" -c light-yellow -b yellow)$(formatText "█" -c yellow) "\
		"$(formatText "▄" -c light-blue)$(formatText "▄" -c light-blue -b blue)$(formatText "█" -c blue) "\
		"$(formatText "▄" -c light-magenta)$(formatText "▄" -c light-magenta -b magenta)$(formatText "█" -c magenta) "\
		"$(formatText "▄" -c light-cyan)$(formatText "▄" -c light-cyan -b cyan)$(formatText "█" -c cyan) "\
		"$(formatText "▄" -c white)$(formatText "▄" -c white -b light-gray)$(formatText "█" -c light-gray) ")

	local palette_bot=$(printf '%s'\
		"$(formatText "██" -c dark-gray)$(formatText "▀" -c black) "\
		"$(formatText "██" -c light-red)$(formatText "▀" -c red) "\
		"$(formatText "██" -c light-green)$(formatText "▀" -c green) "\
		"$(formatText "██" -c light-yellow)$(formatText "▀" -c yellow) "\
		"$(formatText "██" -c light-blue)$(formatText "▀" -c blue) "\
		"$(formatText "██" -c light-magenta)$(formatText "▀" -c magenta) "\
		"$(formatText "██" -c light-cyan)$(formatText "▀" -c cyan) "\
		"$(formatText "██" -c white)$(formatText "▀" -c light-gray) ")

	printf "$palette_top\n$palette_bot"
}

colorWords() {
	reset=$(tput sgr0)
	black=$(tput setaf 0)
	cyan=$(tput setaf 37)
	green=$(tput setaf 64)
	orange=$(tput setaf 166)
	purple=$(tput setaf 125)
	red=$(tput setaf 124)
	violet=$(tput setaf 61)
	white=$(tput setaf 15)
	yellow=$(tput setaf 136)

	echo "${black}black"
	echo "${cyan}cyan"
	echo "${green}green"
	echo "${orange}orange"
	echo "${purple}purple"
	echo "${red}red"
	echo "${violet}violet"
	echo "${white}white"
	echo "${yellow}yellow"
}