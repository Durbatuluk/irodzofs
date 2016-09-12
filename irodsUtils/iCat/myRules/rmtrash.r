removeTrash {
	delay("<PLUSET>10s</PLUSET><EF>5m</EF>") {
   		writeLine("serverLog", " Trash removed !");
		msiExecCmd("rmtrash.sh","null","null","null","null",*Out)
	}
}
INPUT null
OUTPUT ruleExecOut
