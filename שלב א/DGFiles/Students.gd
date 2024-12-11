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
Name=STUDENTS
Count=400

[Record]
Name=STUDENT_ID
Type=NUMBER
Size=
Data=sequence
Master=

[Record]
Name=STUDENT_FIRST_NAME
Type=VARCHAR2
Size=100
Data=name
Master=

[Record]
Name=STUDENT_LAST_NAME
Type=VARCHAR2
Size=100
Data=name
Master=

[Record]
Name=EMAIL
Type=VARCHAR2
Size=100
Data=email
Master=

[Record]
Name=PHONE
Type=VARCHAR2
Size=40
Data=phone
Master=

[Record]
Name=BIRTH_DATE
Type=DATE
Size=
Data=date
Master=

[Record]
Name=DEGREE
Type=VARCHAR2
Size=50
Data=list('BA', 'BSc', 'MA', 'MSc', 'PhD')
Master=

[Record]
Name=START_DATE
Type=DATE
Size=
Data=date
Master=
