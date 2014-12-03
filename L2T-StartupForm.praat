if !variableExists("defaulInitials$")
	defaultInitials$ = ""
endif

if !variableExists("defaultParticipantID$")
	defaultParticipantID$ = ""
endif

if !variableExists("defaultTestwave")
	defaultTestwave = 1
endif

if !variableExists("defaultExpTask")
	defaultExpTask = 1
endif

if !variableExists("defaultActivity")
	defaultActivity = 1
endif

procedure workstations
	# Define vector of workstations.
	.slot$ [1] = "Default"
	.slot$ [2] = "Waisman Lab"
	.slot$ [3] = "Shevlin Hall Lab"
	.slot$ [4] = "Mac via RDC"
	.slot$ [5] = "Mac via VPN"
	.slot$ [6] = "Beckman"
	.slot$ [7] = "Reidy (VPN)"
	.slot$ [8] = "Reidy (Split)"
	.slot$ [9] = "Hannele"
	.slot$ [10] = "Rose (VPN)"
	.slot$ [11] = "Rose (Split)"
	.slot$ [12] = "Allie (Laptop)"
	.slot$ [13] = "Other"

	.length = 13
endproc

procedure experimental_tasks
	# Define the vector of tasks.
	.slot$ [1]= "NonWordRep"
	.slot$ [2] = "RealWordRep"
	.slot$ [3] = "GFTA"

	.length = 3
endproc

procedure testwaves
	# Define  vector of testwaves.
	.slot$ [1] = "TimePoint1"
	.slot$ [2]= "TimePoint2"
	.slot$ [3] = "TimePoint3"

	.length = 3
endproc

procedure praat_activities
	# Define vector of activities in Praat.
	.slot$ [1] = "Segment a recording"
	.slot$ [2] = "Check a segmented TextGrid"
	.slot$ [3] = "Transcribe a recording"
	.slot$ [4] = "Calibrate transcriptions"
	.slot$ [5] = "Add place-transcription to RWR TP1 turbulence tags"
	.slot$ [6] = "Tag turbulence events"
	.slot$ [7] = "Tag burst events"
	.slot$ [8] = "Other"

	.length = 8
endproc

procedure display_vector_as_options: .vector$, .default
	# Determine the .comment$ and .menu_title$ to display along with
	# the optionMenu.
	if .vector$ == "workstations"
		.comment$ = "Please select your workstation from the menu below."
		.menu_title$ = "Workstation"
	elif .vector$ == "experimental_tasks"
		.comment$    = "Please select the experimental task from the menu below."
		.menu_title$ = "Experimental task"
	elif .vector$ == "testwaves"
		.comment$ = "Please select the testwave from the menu below."
		.menu_title$ = "Testwave"
	elif .vector$ == "praat_activities"
		.comment$ = "What would you like to do?"
		.menu_title$ = "Activity"
	endif
	# Call the procedure named by .vector$
	@'.vector$'
	# Display that vector as an optionMenu.
	comment (.comment$)
	optionMenu (.menu_title$, .default)
	for i from 1 to '.vector$'.length
		option ('.vector$'.slot$ [i])
	endfor
endproc

procedure session_parameters

	beginPause ("Hi, How Are You?")
		# Prompt the user to enter her initials.
		# --> Global variable [your_initials$].
		comment ("Please enter your initials in the field below.")
		word ("Your initials", defaultInitials$)
		# Prompt the user to enter the participant's ID number.
		# --> Global variable [participant_ID$].
		comment ("Please enter the participant's ID number in the field below.")
		word ("Participant number", defaultParticipantID$)
		# Prompt the user to select her workstation.
		# --> Global variable [workstation$].
		@display_vector_as_options: "workstations", 1
		# Prompt the user to select the experimental task.
		# --> Global variable [experimental_task$]. 
		@display_vector_as_options: "experimental_tasks", defaultExpTask
		# Prompt the user to select the testwave.
		# --> Global variable [testwave$].
		@display_vector_as_options: "testwaves", defaultTestwave
		# Prompt the user to select her activity.
		# --> Global variable [activity$].
		@display_vector_as_options: "praat_activities", defaultActivity
	endPause ("Quit", "Continue", 2)

	# Bind all the global variables created by the form to
	# local variables of [session_parameters].
	.initials$ = your_initials$
	.workstation$ = workstation$
	.experimental_task$ = experimental_task$
	.testwave$ = testwave$
	.participant_number$ = participant_number$
	.activity$ = activity$

	# Local variable for the path to <Tier2>/DataAnalysis on the filesystem 
	# of the [.workstation$].
	if .workstation$ == workstations.slot$ [1]
		# Default setup. 14 = the string length for "\PraatScripts\"
		.dirLength = rindex_regex (defaultDirectory$, "/|\\") - 14
		.analysis_directory$ = left$(defaultDirectory$, .dirLength)
	elif .workstation$ ==  workstations.slot$ [2]
		# Waisman Lab (UW) setup...
		.analysis_directory$ = "L:/DataAnalysis"
	elif .workstation$ == workstations.slot$ [3]
		# Shevlin Hall (UMN) setup...count_nwr_wordlist_structurescount_nwr_wordlist_structures
		.analysis_directory$ = "//l2t.cla.umn.edu/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [4]
		.analysis_directory$ = "I:/DataAnalysis"
	elif .workstation$ == workstations.slot$ [5]
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [6]
		# Mary's set-up, where audio is accessed locally...
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [7]
		# Pat's setup where the sharepoint is accessed through a VPN connection...
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [8]
		# Pat's setup where the audio is accessed locally, but the other data
		# are accessed through a VPN connection...
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [9]
		.analysis_directory$ = "Z:/DataAnalysis"
	elif .workstation$ == workstations.slot$ [10]
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [11]
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [12]
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == workstations.slot$ [13]
		# Some previously un-encountered setup...
		.analysis_directory$ = ""
	endif

	# Local variable for the path to the directory of the experimental condition,
	# i.e. the pair of experimental task and testwave.
	if .analysis_directory$ <> ""
		.experiment_directory$ = .analysis_directory$ + "/" + 
			... .experimental_task$ + "/" + 
			... .testwave$
	else
		.experiment_directory$ = ""
	endif
endproc