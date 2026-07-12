# elv pandora v 0.2
# this version shall be very different than the nushell version
# while still implementing more or less the same functions
#
# written by graefchen
#
# NOTE: (2026-06-05) FINISHED!

use path
use str

var ident = $E:HOMEPATH"/.ssh/id_ed25519"
var dir = $E:HOMEPATH"/.pandora/"

fn yn {|msg|
	var msg = $msg" [y/N]"
	var ans = (gum input --no-show-help --header $msg)
	str:contains-any $ans "yY"
}

fn add {|name| 
	if (not (eq (e:fd -d 1 -c never -1 $name $dir) "")) {
		echo $name" already exists"
		return
	}

	var pass = (gum input --no-show-help --password --header "enter a password")
	if (eq $pass "") { echo "password can't be empty"; return }
	var p2 = (gum input --no-show-help --password --header "enter a password (again)")

	if (not (eq $pass $p2)) { echo "passwords don't match"; return }
	
	echo $pass | age --encrypt --recipients-file $ident".pub" -o $dir"/"$name".age"

	echo "added "$name" to the store"
}

fn delete {|name|
	if (eq (e:fd -d 1 -c never -1 $name $dir) "") {
		echo "the password "$name" doesn't exists"
		return
	}

	if (yn "Do you want to delete "$name"?") {
		e:rm $dir"/"$name".age"
	} else {
		echo "did not delete "$name""
	}
}

fn list {||
	var lst = [(e:ls -1 $dir)]
	# First we get a list of all the age files in the directory, then we run
	# remove the .age and then we echo it.
	each {|in| echo (str:replace ".age" "" $in) } $lst
}

fn show {|name|
	# NOTE: this seems to not work correctly, fix
	if (eq (e:fd -d 1 -c never -1 $name $dir) "") {
		echo "the password "$name" doesn't exists"
		return
	}

	echo (e:age --decrypt --identity $ident $dir"/"$name".age")
}

# a passwort manager
fn pandora {|@words|
	if (eq $words []) {
		echo "nothing to do..."
	} else {
		var sub = $words[0]
		var subcommands = [add delete list show]
		if (has-value $subcommands $sub) {
			if (eq $sub "list") {
				list
			} elif (eq $sub "add") {
				if (== (count $words) 1) { echo "need a name"; return }
				add $words[1]
			} elif (eq $sub "delete") {
				if (== (count $words) 1) { echo "need a name"; return }
				delete $words[1]
			} elif (eq $sub "show") {
				if (== (count $words) 1) { echo "need a name"; return }
				show $words[1]
			}
		} else {
			echo "Unknown command: "$sub
		}
	}
}

# edit ...
# TODO: remake and use the base edit library
use github.com/zzamboni/elvish-completions/comp

var subcommands = [
	&list
	&add
	&delete
	&show
]

set edit:completion:arg-completer[pandora] = (comp:subcommands $subcommands)

# adding it as the "pandora" function/command
edit:add-var pandora~ $pandora~
