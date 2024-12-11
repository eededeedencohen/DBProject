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
Name=BOOKS
Count=400

[Record]
Name=BOOK_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=BOOK_NAME
Type=VARCHAR2
Size=255
Data=text
Master=

[Record]
Name=PUBLICATION_DATE
Type=DATE
Size=
Data=date
Master=

[Record]
Name=CATEGORY_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=AUTHOR_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=LANGUAGE
Type=VARCHAR2
Size=50
Data=list('English', 'French', 'German', 'Spanish')
Master=

[Record]
Name=BOOK_DESCRIPTION
Type=CLOB
Size=
Data=text
Master=
