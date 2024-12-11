--==========
----------1:
--==========
ALTER TABLE Students
ADD CONSTRAINT check_student_phone_format CHECK (
    REGEXP_LIKE(Phone, '^05[0-9]-[0-9]{7}$')
);

ALTER TABLE Librarians 
ADD CONSTRAINT check_librarian_phone_format CHECK (
    REGEXP_LIKE(Phone, '^05[0-9]-[0-9]{7}$')
);


--==========
----------2:
--==========
ALTER TABLE Students
ADD CONSTRAINT check_student_email_validity CHECK (
    REGEXP_LIKE(
        Email,
        '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+(\.ac\.il|\.co\.il|\.com)$'
    )
);

ALTER TABLE Librarians
ADD CONSTRAINT check_librarian_email_validity CHECK (
    REGEXP_LIKE(
        Email,
        '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+(\.ac\.il|\.co\.il|\.com)$'
    )
);


--==========
----------3:
--==========
ALTER TABLE Reviews
ADD CONSTRAINT check_valid_rating CHECK (
    Rating BETWEEN 1 AND 5 AND MOD(Rating, 1) = 0
);


--==========
----------4:
--==========
ALTER TABLE RequestsRooms
ADD CONSTRAINT check_valid_people_count CHECK (
    Number_of_people BETWEEN 1 AND 15
);


--==========
----------5:
--==========
ALTER TABLE RequestsRooms
MODIFY Status DEFAULT 'waiting';


--==========
----------6:
--==========
ALTER TABLE BookAuthors
MODIFY Biography  NOT NULL;


