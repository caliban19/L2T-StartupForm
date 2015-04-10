your_initials$ = ""
workstation$ = "Default"
participant_number$ = ""

defaultTestwave = 1
defaultExpTask = 1
defaultActivity = 1
defaultRWRPerceptionExperiment = 1
defaultRWRPerceptionActivity = 1
loadStartUpForm = 1

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
	.slot$ [8] = "Prep RWR_Perception stimuli"
	.slot$ [9] = "Other"

	.length = 9
endproc

procedure rwr_perception_experiments
	# Define the vector of experiment names.
	.slot$ [1]= "TP2_SibilantGoodness_VAS"
	.slot$ [2] = "TP1_t-k_VAS"
	.slot$ [3] = "TP2_S-SH_VAS"
	.slot$ [4] = "TP2_ObstruentsGender_VAS"

	.length = 4
endproc

procedure rwr_perception_activities
	# Define vector of activities in Praat.
	.slot$ [1] = "Define word/CV boundaries for candidate stimuli"
	.slot$ [2] = "Check a boundary-tagged stimulus TextGrid"
	.slot$ [3] = "Extract audio files for candidate stimuli"
	.slot$ [4] = "Listen to all extracted stimulus files"
	.slot$ [5] = "Other"

	.length = 5
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
	elif .vector$ == "rwr_perception_experiments"
		.comment$ = "For which experiment?"
		.menu_title$ = "rwr_perception_experiment"
	elif .vector$ == "rwr_perception_activities"
		.comment$ = "How would you like to prep the stimuli?"
		.menu_title$ = "rwr_perception_activity"
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
	if loadStartUpForm
		beginPause ("Hi, How Are You?")
			# Prompt the user to enter initials.
			# --> Global variable [your_initials$].
			comment ("Please enter your initials in the field below.")
			word ("Your initials", your_initials$)
			# Prompt the user to enter the participant's ID number.
			# --> Global variable [participant_ID$].
			comment ("Please enter the participant's ID number in the field below.")
			word ("Participant number", participant_number$)
			# Prompt the user to select workstation.
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
	endif
	# Bind all the global variables created by the form to
	# local variables of [session_parameters].
	.initials$ = your_initials$
	.workstation$ = workstation$
	.experimental_task$ = experimental_task$
	.testwave$ = testwave$
	.participant_number$ = participant_number$
	.activity$ = activity$

	@setWorkstation: .workstation$

	# Local variable for the path to the directory of the experimental condition,
	# i.e. the pair of experimental task and testwave.
	if .analysis_directory$ <> ""
		.experiment_directory$ = .analysis_directory$ + "/" + 
			... .experimental_task$ + "/" + 
			... .testwave$
	else
		.experiment_directory$ = ""
	endif

	if .activity$ == "Prep RWR_Perception stimuli"
		beginPause ("Which RWR_Perception Experiment?")
			# Prompt the user to enter initials.
			# --> Global variable [your_initials$].
			comment ("Please enter your initials in the field below.")
			word ("Your initials", your_initials$)
			# --> Global variable [workstation$].
			@display_vector_as_options: "workstations", 1
			# Prompt the user to select the experiment name.
			# --> Global variable [rwr_perception_experiment$]. 
			@display_vector_as_options: "rwr_perception_experiments", defaultRWRPerceptionExperiment
			# Prompt the user to select activity.
			# --> Global variable [rwr_perception_activity$].
			@display_vector_as_options: "rwr_perception_activities", defaultRWRPerceptionActivity
			# Prompt the user to enter the participant's ID number.
			# --> Global variable [participant_ID$].
			comment ("If you want to analyze a specific participant, enter ID.")
			word ("Participant number", participant_number$)
		endPause ("Quit", "Continue", 2)

		.initials$ = your_initials$
		.workstation$ = workstation$
		.participant_number$ = participant_number$
		@setWorkstation: .workstation$

		.rwr_perception_experiment$ = rwr_perception_experiment$
		.rwr_perception_activity$ = rwr_perception_activity$

		@testwaves
		.whichTimePoint$ = mid$ (.rwr_perception_experiment$, 3, 1)
		.testwave$ = testwaves.slot$ ['.whichTimePoint$']

		# Local variable for the path to the perception experiment directory for the 
		# experiment -- i.e. the subdirectory under .../DataCollection/RWR_PerceptionExperiments
		# where the relevant Stimuli directory and StimPrep directory are.
		if (.analysis_directory$ <> "")
			.rwr_perception_experiment_directory$ = .analysis_directory$ - "Analysis" + 
				... "Collection/RWR_PerceptionExperiments/" + .rwr_perception_experiment$
		else
			.rwr_perception_experiment_directory$ = ""
		endif
	endif
endproc

procedure setWorkstation .workstation$
	# Local variable for the path to <Tier2>/DataAnalysis on the filesystem 
	# of the [.workstation$].
	if .workstation$ == "Default"
		# Default setup. 14 = the string length for "\PraatScripts\"
		.dirLength = rindex_regex (defaultDirectory$, "/|\\") - 14
		.analysis_directory$ = left$(defaultDirectory$, .dirLength)
	elif .workstation$ ==  "Waisman Lab"
		# Waisman Lab (UW) setup...
		.analysis_directory$ = "L:/DataAnalysis"
	elif .workstation$ == "Shevlin Hall Lab"
		# Shevlin Hall (UMN) setup...count_nwr_wordlist_structurescount_nwr_wordlist_structures
		.analysis_directory$ = "//l2t.cla.umn.edu/tier2/DataAnalysis"
	elif .workstation$ == "Mac via RDC"
		.analysis_directory$ = "I:/DataAnalysis"
	elif .workstation$ == "Mac via VPN"
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == "Beckman"
		# Mary's set-up, where audio is accessed locally...
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == "Reidy (VPN)"
		# Pat's setup where the sharepoint is accessed through a VPN connection...
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == "Reidy (Split)"
		# Pat's setup where the audio is accessed locally, but the other data
		# are accessed through a VPN connection...
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == "Hannele"
		.analysis_directory$ = "Z:/DataAnalysis"
	elif .workstation$ == "Rose (VPN)"
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == "Rose (Split)"
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == "Allie (Laptop)"
		.analysis_directory$ = "/Volumes/tier2/DataAnalysis"
	elif .workstation$ == "Other"
		# Some previously un-encountered setup...
		.analysis_directory$ = ""
	endif

	session_parameters.analysis_directory$ = .analysis_directory$
endproc