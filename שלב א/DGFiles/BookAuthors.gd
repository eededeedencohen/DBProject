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
Name=BOOKAUTHORS
Count=400

[Record]
Name=AUTHOR_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=AUTHOR_ACADEMIC_TITLE
Type=VARCHAR2
Size=10
Data=list('Dr.', 'Prof.')
Master=

[Record]
Name=AUTHOR_FIRST_NAME
Type=VARCHAR2
Size=100
Data=name
Master=

[Record]
Name=AUTHOR_LAST_NAME
Type=VARCHAR2
Size=100
Data=name
Master=

[Record]
Name=AUTHOR_BIRTH_DATE
Type=DATE
Size=
Data=date
Master=

[Record]
Name=NATIONALITY
Type=VARCHAR2
Size=50
Data=country
Master=

[Record]
Name=BIOGRAPHY
Type=CLOB
Size=
Data=text
Master=
