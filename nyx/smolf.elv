# written by graefchen
# NOTE: I have no idea where that "font" is from
#       I only know, that i slightly modified it
use str

var MAP = ( echo '{
    "a":   {"upper": " ▄▀█",   "lower": " █▀█" },
    "b":   {"upper": " █▄▄",   "lower": " █▄█" },
    "c":   {"upper": " █▀▀",   "lower": " █▄▄" },
    "d":   {"upper": " █▀▄",   "lower": " █▄▀" },
    "e":   {"upper": " █▀▀",   "lower": " ██▄" },
    "f":   {"upper": " █▀▀",   "lower": " █▀ " },
    "g":   {"upper": " █▀▀",   "lower": " █▄█" },
    "h":   {"upper": " █░█",   "lower": " █▀█" },
    "i":   {"upper": " █",     "lower": " █" },
    "j":   {"upper": " ░░█",   "lower": " █▄█" },
    "k":   {"upper": " █▄▀",   "lower": " █░█" },
    "l":   {"upper": " █░░",   "lower": " █▄▄" },
    "m":   {"upper": " █▀▄▀█", "lower": " █░▀░█" },
    "n":   {"upper": " █▄░█",  "lower": " █░▀█" },
    "o":   {"upper": " █▀█",   "lower": " █▄█" },
    "p":   {"upper": " █▀█",   "lower": " █▀▀" },
    "q":   {"upper": " █▀█",   "lower": " ▀▀█" },
    "r":   {"upper": " █▀█",   "lower": " █▀▄" },
    "s":   {"upper": " █▀",    "lower": " ▄█" },
    "t":   {"upper": " ▀█▀",   "lower": " ░█░" },
    "u":   {"upper": " █░█",   "lower": " █▄█" },
    "v":   {"upper": " █░█",   "lower": " ▀▄▀" },
    "w":   {"upper": " █░█░█", "lower": " ▀▄▀▄▀" },
    "x":   {"upper": " ▀▄▀",   "lower": " █░█" },
    "y":   {"upper": " █▄█",   "lower": " ░█░" },
    "z":   {"upper": " ▀█",    "lower": " █▄" },
    "-":   {"upper": " ▄▄",    "lower": " ░░" },
    "+":   {"upper": " ▄█▄",   "lower": " ░▀░" },
    ".":   {"upper": " ░",     "lower": " ▄" },
    " ":   {"upper": "  ",     "lower": "  " }
}' | from-json)

fn smolf {|msg|
    var chars = [(str:split '' (str:to-lower $msg))]
    var upper = ""
    var lower = ""
    each {|c|
        # only take the chars, that are in the table
        if (has-key $MAP $c) {
            var map = $MAP[$c]
            # a weird hack to append chars to a string
            set upper = $upper""$map[upper]
            set lower = $lower""$map[lower]
        }
    } $chars
    echo $upper"\n"$lower
}

edit:add-var smolf~ $smolf~