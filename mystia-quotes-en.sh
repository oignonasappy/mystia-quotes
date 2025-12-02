#!/bin/bash

# Path
QUOTE_FILE="$(dirname $(readlink -f $0))/mystia-quotes.txt"

# Error if file does not exist
if [ ! -f "$QUOTE_FILE" ]; then
    echo "error: .txt file $QUOTE_FILE did not found." >&2
    exit 1
fi

awk -v RS='"' '
    BEGIN {
        srand()
        i = 0
    }

    (NR % 2 == 0) {
        i++;
        Q[i] = $0
    }
    
    END {
        TOTAL_QUOTES = i
        if (TOTAL_QUOTES % 2 != 0) {
            print "warn: valid number of quote is odd. Last quote will be ignored." > "/dev/stderr"
            TOTAL_QUOTES--
        }

        TOTAL_PAIRS = TOTAL_QUOTES / 2
        if (TOTAL_PAIRS == 0) {
            print "error: No valid quote pair" > "/dev/stderr"
            exit 1
        }
        
        RANDOM_PAIR_NUM = int(rand() * TOTAL_PAIRS) + 1
        
        START_INDEX = (RANDOM_PAIR_NUM * 2) - 1

        # Only English
        # gsub(/\\n/, "\n", Q[START_INDEX])
        # print "「" Q[START_INDEX] "」"
        
        gsub(/\\n/, "\n", Q[START_INDEX + 1])
        print "\"" Q[START_INDEX + 1] "\""
    }
' "$QUOTE_FILE"
