#!/bin/bash


# 1.a
cd "$HOME"
mkdir -p students

file="LCP_22-23_students.csv"

wget -O "$file" "https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7&e=1&dl=1"

cp "$file" ./students/

if [ -f "./students/$file" ]; then
    echo "The file '$file' has been downloaded successfully and copied to the ./students directory."
else
    echo "Error: file '$file' was not copied successfully."
fi

echo ""


# 1.b
cd students
touch PoD.txt Physics.txt
> PoD.txt
> Physics.txt

tail -n +2 "$file" | while IFS=',' read -r FamilyName Surname Email MasterProgram; do
    
    MasterProgram="${MasterProgram//$'\r'/}"
    
    if [ "$MasterProgram" = "PoD" ] || [ "$MasterProgram" = "POD" ]; then
        echo "$FamilyName,$Surname" >> PoD.txt
    elif [ "$MasterProgram" = "Physics" ]; then
        echo "$FamilyName,$Surname" >> Physics.txt
    else
        echo "Found '$MasterProgram' master program in $file; did not save the student in PoD.txt or Physics.txt"
    fi
done

echo "Students' names are correctly saved in PoD.txt and Physics.txt."
echo ""


# 1.c
declare -A counter  # dictionary

for letter in {A..Z}; do
    counter[$letter]=0
done

while IFS=',' read -r FamilyName Surname Email MasterProgram; do
    initial="${Surname:0:1}"
    (( counter[$initial]++ ))
done < <(tail -n +2 "$file") 
# note: in this way the variables modified inside the loop are available outside the loop

echo "Number of Students that start with:"
for letter in {A..Z}; do
    echo " - letter $letter: ${counter[$letter]}"
done

echo ""


# 1.d
max=0
maxletter='A'
for letter in {A..Z}; do
    if [ ${counter[$letter]} -gt $max ]; then
        max=${counter[$letter]}
        maxletter=$letter
    fi
done

echo "Letter with the most students: $maxletter ($max students)"