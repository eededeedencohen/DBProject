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
Name=BOOKSTATUSES
Count=400

[Record]
Name=BOOK_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=STATUS
Type=VARCHAR2
Size=50
Data=list('available', 'borrowed', 'lost', 'damaged')
Master=

[Record]
Name=NUMBER_OF_COPIES
Type=NUMBER
Size=
Data=number
Master=
