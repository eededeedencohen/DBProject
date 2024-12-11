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
Name=REQUESTSROOMS
Count=400

[Record]
Name=STUDENT_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=REQUEST_TIME
Type=DATE
Size=
Data=date
Master=

[Record]
Name=START_TIME
Type=DATE
Size=
Data=date
Master=

[Record]
Name=DURATION_HOURS
Type=NUMBER
Size=
Data=number
Master=

[Record]
Name=NUMBER_OF_PEOPLE
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

[Record]
Name=HANDLED_LIBRARIAN
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=ASSIGNED_ROOM
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=STATUS
Type=VARCHAR2
Size=50
Data=list('waiting', 'approved', 'denied')
Master=
