#shibang 

#bin options (for now just time in hours)
while getopts ":h" option; do
	case $option in 
		h)
			usage
			exit;;
		esac
	done

#help option
usasge(){
	#The purpose of this script
	#options of this script include
	#-h show script usage
	# others 
	
}

#catch term out and run stop script
murderProcess(){
echo 'I am being killed'
exit
}

trap murderProcess SIGINT SIGTERM

#convert time to hours 

#run sauron
#run sentry
#run start script 

#sleep for number of hours 
#run end script 
