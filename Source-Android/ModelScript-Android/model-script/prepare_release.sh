#!/bin/sh

ARCHIVE_DIR="$HOME/Library/Developer/Xcode/Archives"

file_exclusion_array=(
"constants.py"
"external_class_template.txt"
"fileimporter.py"
"generator.py"
"instantiator.py"
"instantiator_template.txt"
"internal_class_template.txt"
"modelgen-swift.py"
"nil_serialization_template.txt"
"openstep_parser"
"validator.py"
"pbxproj"
)

array_contains ()
{
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}

find $ARCHIVE_DIR -name 'JMJSONKit.framework' | while read line;
do
  for i in $(ls "$line/")
  do
    if array_contains file_exclusion_array $i; then
      echo "Deleting file $i"
      rm -f -r "$line/$i"
    fi
  done
done
