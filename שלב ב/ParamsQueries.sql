--==========
---------1:
--==========

--################################################################
-- Accept parameter for author ID or name
--################################################################
ACCEPT author_identifier CHAR PROMPT 'Enter Author ID, First Name, or Last Name: ';

--################################################################
-- Define a reusable variable for the parameter
--################################################################
DEFINE author_param = '&author_identifier';

--################################################################
-- Query to retrieve books by author
--################################################################
SELECT 
    B.Book_id,
    B.Book_name,
    TO_CHAR(B.Publication_date, 'YYYY-MM-DD') AS Publication_Date, 
    BA.Author_id AS Author_ID, 
    BA.author_academic_title || ' ' || BA.Author_first_name || ' ' || BA.Author_last_name AS Author_Name, 
    BC.Category AS Book_Category, 
    BC.Subcategory AS Book_Subcategory,
    NVL(ROUND(AVG(R.Rating), 2), 0) AS Avg_Rating 
FROM 
    Books B
JOIN 
    BookAuthors BA ON B.Author_id = BA.Author_id 
JOIN 
    BookCategories BC ON B.Category_id = BC.Category_id 
LEFT JOIN 
    Reviews R ON B.Book_id = R.Book_id 
WHERE 
    (
        (REGEXP_LIKE('&&author_param', '^[0-9]+$') AND TO_CHAR(BA.Author_id) = '&&author_param') 
        OR 
        (LOWER(BA.Author_first_name) LIKE LOWER('&&author_param') OR 
            LOWER(BA.Author_last_name) LIKE LOWER('&&author_param'))
    )
GROUP BY 
    B.Book_id, B.Book_name, B.Publication_date, 
    BA.Author_id, BA.author_academic_title, BA.Author_first_name, BA.Author_last_name,
    BC.Category, BC.Subcategory
ORDER BY 
    BA.Author_id ASC, Avg_Rating DESC, B.Book_name ASC; 

--################################################################
-- Undefine the parameter to ensure it prompts again next time
--################################################################
UNDEFINE author_param;





--===========
---------2:
--===========
ACCEPT student_id NUMBER PROMPT 'Enter Student ID: ';

SELECT 
    B.Book_id,
    B.Book_name,
    ROUND(AVG(R.Rating), 2) AS Avg_Rating, 
    SR.Rating AS Student_Rating, 
    DBMS_LOB.SUBSTR(SR.Review_text, 4000, 1) AS Student_Review 
FROM 
    Books B
JOIN 
    Reviews SR ON B.Book_id = SR.Book_id 
LEFT JOIN 
    Reviews R ON B.Book_id = R.Book_id 
WHERE 
    SR.Reviewer_id = &student_id 
GROUP BY 
    B.Book_id, B.Book_name, SR.Rating, DBMS_LOB.SUBSTR(SR.Review_text, 4000, 1) 
ORDER BY 
    Avg_Rating DESC, B.Book_name ASC;





--===========
---------3:
--===========
ACCEPT student_id NUMBER PROMPT 'Enter Student ID: ';
ACCEPT max_hours NUMBER PROMPT 'Enter Maximum Approved Hours: ';

DELETE FROM RequestsRooms
WHERE (Student_id, Request_time) IN (
    SELECT 
        RR.Student_id,
        RR.Request_time
    FROM 
        RequestsRooms RR
    LEFT JOIN 
        RequestsRooms PreviousRR
    ON 
        RR.Student_id = PreviousRR.Student_id
        AND PreviousRR.Start_time < RR.Start_time 
        AND PreviousRR.Status = 'approved'
    WHERE 
        RR.Status = 'approved' 
        AND RR.Start_time >= TRUNC(SYSDATE + 1) 
        AND RR.Student_id = &student_id 
    GROUP BY 
        RR.Student_id,
        RR.Request_time,
        RR.Start_time,
        RR.Duration_hours 
    HAVING 
        NVL(SUM(PreviousRR.Duration_hours), 0) + RR.Duration_hours > &max_hours 
);




--===========
---------4:
--===========
ACCEPT author_id NUMBER PROMPT 'Enter Author ID: ';
ACCEPT additional_copies NUMBER PROMPT 'Enter Number of Copies to Add: ';

UPDATE BookStatuses BS
SET 
    BS.Number_of_copies = BS.Number_of_copies + &additional_copies
WHERE 
    BS.Status = 'available' 
    AND BS.Book_id IN (
        SELECT 
            B.Book_id
        FROM 
            Books B
        JOIN 
            BookAuthors BA ON B.Author_id = BA.Author_id 
        JOIN 
            BookCategories BC ON B.Category_id = BC.Category_id 
        LEFT JOIN 
            Reviews R ON B.Book_id = R.Book_id 
        WHERE 
            BA.Author_id = &author_id 
        GROUP BY 
            B.Book_id, B.Book_name, BC.Category_id, BC.Category, BC.Subcategory
        HAVING 
            NVL(ROUND(AVG(R.Rating), 2), 0) > (
                SELECT 
                    NVL(ROUND(AVG(R2.Rating), 2), 0) 
                FROM 
                    Books B2
                JOIN 
                    BookCategories BC2 ON B2.Category_id = BC2.Category_id
                LEFT JOIN 
                    Reviews R2 ON B2.Book_id = R2.Book_id
                WHERE 
                    BC2.Category_id = BC.Category_id
            )
    );