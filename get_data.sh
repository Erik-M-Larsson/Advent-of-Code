#!/bin/bash

aocd > $(date +%Y)/input_data/input_$(date +%-d).txt

example_n=1
keep_text=false

while IFS= read -r line
do
    ## take some action on $line
    echo "$line" 
    
    if [[ $keep_text == true && "$line" == "--------------------------------------------------------------------------------"* ]]; then
        echo "slut"
        keep_text=false
        ((example_n++))
    fi
    
    if [[ $keep_text == true ]]; then
        echo $example_n
        echo "$line" >> $(date +%Y)/input_data/input_$(date +%-d)_"$example_n"_ex.txt
    fi

    if [[ "$line" == *"-- Example data "* ]]; then
        echo "start"
        keep_text=true
        rm -f $(date +%Y)/input_data/input_$(date +%-d)_"$example_n"_ex.txt
    fi

done <<< $(aocd --example)
