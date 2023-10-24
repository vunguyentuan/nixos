#!/opt/homebrew/bin/fish

# custom functions
function lf-pick --description 'lf file picker'
    if ! type -q lf
        echo "lf not installed"
    end

    set -l TEMP (mktemp)
    lf -selection-path=$TEMP
    echo >>"$TEMP"
    # echo $TEMP
    cat $TEMP | pbcopy
    # while read -r line
    #     echo "$line"
    # end <"$TEMP"
end

lf-pick