video-encoding
==============

Description
-----------

Some useful scripts for video encoding jobs.

Supported Formats
-----------------

* MiniSD proposed by The Last Fantasy (TLF), see doc for details 

Prerequisites
--------------

* [HandBrakeCLI](http://handbrake.fr/downloads2.php "Download HandBrakeCLI")
* Bash: available on most Unix-like operating systems

Usage
------

	# To encode in MiniSD format
	$ src/encodeMiniSD.sh video_file_name # Non-interactively
	$ src/encodeMiniSD.sh video_file_name -i # Interactively
