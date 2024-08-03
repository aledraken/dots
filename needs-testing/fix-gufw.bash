#!/bin/bash

file="/usr/bin/gufw"

sed -i 's/pkexec gufw-pkexec/pkexec \/usr\/bin\/gufw-pkexec/g' "$file"