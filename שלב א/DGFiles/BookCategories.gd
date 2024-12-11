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
Name=BOOKCATEGORIES
Count=400

[Record]
Name=CATEGORY_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=CATEGORY
Type=VARCHAR2
Size=50
Data=list('Fiction', 'Science', 'Technology')
Master=

[Record]
Name=SUBCATEGORY
Type=VARCHAR2
Size=50
Data=list('Novel', 'Physics', 'Programming')
Master=

[Record]
Name=DESCRIPTION
Type=CLOB
Size=
Data=text
Master=
