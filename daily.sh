#!/bin/bash
# Andrew Black
# June 15, 2018

base_url='https://www.alphavantage.co'

while [[ $# -ge 1 ]]; do
case "$1" in
	-s|--symbol)
		symbol="$2"; shift 2
		;;
	-o|--output)
		ofile="$2"; shift 2
		;;
	--key)
		api_key="$2"; shift 2
		;;
	*)
		echo "Unexpected argument '$1'">&2
		exit -1
		;;
esac
done

if [[ -z "$symbol" ]]; then
	echo "Symbol not specified.">&2
	exit -1
fi

if [[ -z "$ofile" ]]; then
	ofile="./${symbol}.csv"
else
	if [[ -d "$ofile" ]]; then
		ofile="${ofile}/${symbol}.csv"
	fi
fi

if [[ -z "$api_key" ]]; then
	if [[ -z "$ALPHAVANTAGE_API_KEY" ]]; then
		echo "No API key provided, and 'ALPHAVANTAGE_APIKEY' not in environment.">&2
		exit -2
	else
		api_key="$ALPHAVANTAGE_API_KEY"
	fi
fi

echo "Symbol: '$symbol'"
echo "Output: '$ofile'"
echo "Key: '$api_key'"

curl "${base_url}/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=${symbol}&datatype=csv&outputsize=full&apikey=${api_key}" > "$ofile"


