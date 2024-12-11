[General]
Version=1

[Preferences]
Username=
Password=2276
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=SYSTEM
Name=STUDYROOMS
Count=400

[Record]
Name=ROOM_NUMBER
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=LIBRARY_FLOOR
Type=NUMBER
Size=
Data=list(1,2,3,4)
Master=

[Record]
Name=LIBRARY_SECTION
Type=VARCHAR2
Size=50
Data=list('A', 'B', 'C', 'D')
Master=

[Record]
Name=ROOM_CAPACITY
Type=NUMBER
Size=
Data=number
Master=

[Record]
Name=BOARD
Type=VARCHAR2
Size=1
Data=list('Y', 'N')
Master=

[Record]
Name=SCREEN
Type=VARCHAR2
Size=1
Data=list('Y', 'N')
Master=
