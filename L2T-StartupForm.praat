

procedure workstations
  # Define string constants for each workstation.
  .waisman$      = "Waisman Lab"
  .shevlin$      = "Shevlin Hall Lab"
  .mac_rdc$      = "Mac via RDC"
  .mac_vpn$      = "Mac via VPN"
  .beckman$      = "Beckman"
  .reidy_vpn$    = "Reidy (VPN)"
  .reidy_split$  = "Reidy (Split)"
  .hannele$      = "Hannele"
  .rose_vpn$     = "Rose (VPN)"
  .rose_split$   = "Rose (Split)"
  .allie_laptop$ = "Allie (Laptop)"
  # Functionality for .reidy_local$ has not yet been implemented.
  .reidy_local$ = "Reidy (Local)"
  .other$       = "Other"
  # Gather the string constants into a vector.
  .slot1$  = .waisman$
  .slot2$  = .shevlin$
  .slot3$  = .mac_rdc$
  .slot4$  = .mac_vpn$
  .slot5$  = .beckman$
  .slot6$  = .reidy_vpn$
  .slot7$  = .reidy_split$
  .slot8$  = .hannele$
  .slot9$  = .rose_vpn$
  .slot10$ = .rose_split$
  .slot11$ = .allie_laptop$
  .slot12$ = .other$
  .length  = 12
endproc


procedure experimental_tasks
  # Define string constants for each task.
  .nwr$ = "NonWordRep"
  .rwr$ = "RealWordRep"
  # Gather the string constants into a vector.
  .slot1$ = .nwr$
  .slot2$ = .rwr$
  .length = 2
endproc


procedure testwaves
  # Define string constants for each testwave.
  .wave1$ = "TimePoint1"
  .wave2$ = "TimePoint2"
  # Gather the string constants into a vector.
  .slot1$ = .wave1$
  .slot2$ = .wave2$
  .length = 2
endproc


procedure praat_activities
  # Define string constants for each activity in Praat.
  .segment$        = "Segment a recording"
  .check$          = "Check a segmented TextGrid"
  .transcribe$     = "Transcribe a recording"
  .calibrate$      = "Calibrate transcriptions"
  .tag_turbulence$ = "Tag turbulence events"
  .tag_burst$      = "Tag burst events"
  # Gather the string constants into a vector.
  .slot1$ = .segment$
  .slot2$ = .check$
  .slot3$ = .transcribe$
  .slot4$ = .calibrate$
  .slot5$ = .tag_turbulence$
  .slot6$ = .tag_burst$
  .length = 6
endproc


procedure display_vector_as_options: .vector$
  # Determine the .comment$ and .menu_title$ to display along with
  # the optionMenu.
  if   .vector$ == "workstations"
         .comment$    = "Please select your workstation from the menu below."
         .menu_title$ = "Workstation"
         .default     = 2
  elif .vector$ == "experimental_tasks"
         .comment$    = "Please select the experimental task from the menu below."
         .menu_title$ = "Experimental task"
         .default     = 2
  elif .vector$ == "testwaves"
         .comment$    = "Please select the testwave from the menu below."
         .menu_title$ = "Testwave"
         .default     = 2
  elif .vector$ == "praat_activities"
         .comment$    = "What would you like to do?"
         .menu_title$ = "Activity"
         .default     = 1
  endif
  # Call the procedure named by .vector$
  @'.vector$'
  # Display that vector as an optionMenu.
  comment (.comment$)
  optionMenu (.menu_title$, .default)
  for i from 1 to '.vector$'.length
    option ('.vector$'.slot'i'$)
  endfor
endproc


procedure session_parameters
  beginPause ("Hi, How Are You?")
    # Prompt the user to enter her initials.
    # --> Global variable [your_initials$].
    comment ("Please enter your initials in the field below.")
    word    ("Your initials", "")
    # Prompt the user to select her workstation.
    # --> Global variable [workstation$].
    @display_vector_as_options: "workstations"
    # Prompt the user to select the experimental task.
    # --> Global variable [experimental_task$]. 
    @display_vector_as_options: "experimental_tasks"
    # Prompt the user to select the testwave.
    # --> Global variable [testwave$].
    @display_vector_as_options: "testwaves"
    # Prompt the user to enter the participant's ID number.
    # --> Global variable [participant_ID$].
    comment ("Please enter the participant's ID number in the field below.")
    word    ("Participant number", "")
    # Prompt the user to select her activity.
    # --> Global variable [activity$].
    @display_vector_as_options: "praat_activities"
  endPause ("Quit", "Continue", 2)
  # Bind all the global variables created by the form to
  # local variables of [session_parameters].
  .initials$           = your_initials$
  .workstation$        = workstation$
  .experimental_task$  = experimental_task$
  .testwave$           = testwave$
  .participant_number$ = participant_number$
  .activity$           = activity$
  # Local variable for the path to <Tier2>/DataAnalysis on the filesystem 
  # of the [.workstation$].
  if .workstation$ == workstations.waisman$
    # Waisman Lab (UW) setup...
    .analysis_directory$ = "L:/DataAnalysis"
  elif .workstation$ == workstations.shevlin$
    # Shevlin Hall (UMN) setup...
    .analysis_directory$ = "//l2t.cla.umn.edu/tier2/DataAnalysis"
  elif .workstation$ == workstations.mac_rdc$
    .analysis_directory$ = "I:/DataAnalysis"
  elif .workstation$ == workstations.mac_vpn$
    .analysis_directory$ = "/Volumes/tier2/DataAnalysis"
  elif .workstation$ == workstations.beckman$
    # Mary's set-up, where audio is accessed locally...
    .analysis_directory$ = "/Volumes/tier2/DataAnalysis"
  elif .workstation$ == workstations.reidy_vpn$
    # Pat's setup where the sharepoint is accessed through a VPN connection...
    .analysis_directory$ = "/Volumes/tier2/DataAnalysis"
  elif .workstation$ == workstations.reidy_split$
    # Pat's setup where the audio is accessed locally, but the other data
    # are accessed through a VPN connection...
    .analysis_directory$ = "/Volumes/tier2/DataAnalysis"
  elif .workstation$ == workstations.hannele$
    .analysis_directory$ = "Z:/DataAnalysis"
  elif .workstation$ == workstations.rose_vpn$
    .analysis_directory$ = "/Volumes/tier2/DataAnalysis"
  elif .workstation$ == workstations.rose_split$
    .analysis_directory$ = "/Volumes/tier2/DataAnalysis"
  elif .workstation$ == workstations.allie_laptop$
    .analysis_directory$ = "/Volumes/tier2/DataAnalysis"
  elif .workstation$ == workstations.other$
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



