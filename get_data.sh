#!/bin/bash

# Create todays notebook from template.
FILE=$(date +%Y)/lucka_$(date +%-d).ipynb

if ! test -f "$FILE"
then 

    while IFS= read -r line
    do  
        if [[ $line == '    "# Lucka \n"' ]]  # Change day
        then
            echo "    \"# Lucka $(date +%-d)\\n\"" >> $FILE
        elif [[ $line == '    "day = \n",' ]] # Change day
        then
            echo "    \"day = $(date +%-d)\n\"," >> $FILE
        else
            echo "$line" >> $FILE
        fi
        
    done < $(date +%Y)/lucka_template.ipynb 
fi

# Get todays input file
aocd > $(date +%Y)/input_data/input_$(date +%-d).txt

# Get exampel input data
example_n=1
keep_text=false

while IFS= read -r line
do
   
    echo "$line" 
    
    if [[ $keep_text == true && "$line" == "--------------------------------------------------------------------------------"* ]]
    then
        keep_text=false
        ((example_n++))
    fi
    
    if [[ $keep_text == true ]]
    then 
        echo "$line" >> $(date +%Y)/input_data/input_$(date +%-d)_"$example_n"_ex.txt
    fi

    if [[ "$line" == *"-- Example data "* ]]
    then
        
        keep_text=true
        rm -f $(date +%Y)/input_data/input_$(date +%-d)_"$example_n"_ex.txt
    fi

done <<< $(aocd --example)
