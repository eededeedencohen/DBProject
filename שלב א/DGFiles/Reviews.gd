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
Name=REVIEWS
Count=400

[Record]
Name=BOOK_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=REVIEWER_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=REVIEW_TEXT
Type=CLOB
Size=
Data=text
Master=

[Record]
Name=RATING
Type=NUMBER
Size=
Data=list(1,2,3,4,5)
Master=

[Record]
Name=REVIEW_DATE
Type=DATE
Size=
Data=date
Master=

[Record]
Name=REVIEW_TITLE
Type=VARCHAR2
Size=255
Data=text
Master=
