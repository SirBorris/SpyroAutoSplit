# SpyroAutoSplit

This file is used in conjunction with the LiveSplit to allow SRT to be autosplit based on memory pointers. 

Comments within the code explain how each line works, however the general gist is below: 

- Dinopony (@DinoponyRuns) wrote the original script.
- Checks a string based memory location for the name of the current map, as well as the loading status of the game. 
- When this changes and both values are present in the dictionary tables, LiveSplit should split. (With some exceptions)

This should only be updated in conjunction with the Spyro Leaderboard team to ensure any changes do not impact the timing method of the loadless timer. Please reach out to myself (@TheSirBorris) if any changes are required.
