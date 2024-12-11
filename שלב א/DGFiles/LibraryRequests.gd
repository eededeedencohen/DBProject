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
Name=LIBRARYREQUESTS
Count=400

[Record]
Name=REQUEST_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=REQUEST_TYPE
Type=VARCHAR2
Size=50
Data=list('Acquisition', 'Repair', 'Other')
Master=

[Record]
Name=REQUEST_DESCRIPTION
Type=CLOB
Size=
Data=text
Master=

[Record]
Name=REQUEST_DATE
Type=DATE
Size=
Data=date
Master=

[Record]
Name=REQUEST_LIBRARIAN
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=REQUEST_STATUS
Type=VARCHAR2
Size=50
Data=list('open', 'closed', 'pending')
Master=
