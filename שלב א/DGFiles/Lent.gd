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
Name=LENT
Count=400

[Record]
Name=BOOK_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=STUDENT_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=STATUS
Type=VARCHAR2
Size=50
Data=list('borrowed', 'returned')
Master=

[Record]
Name=FINE_AMOUNT
Type=NUMBER
Size=
Data=number
Master=

[Record]
Name=BORROW_DATE
Type=DATE
Size=
Data=date
Master=

[Record]
Name=RETURN_DATE
Type=DATE
Size=
Data=date
Master=
