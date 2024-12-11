--================================
-- SELECT QUERIES:
--================================


--===========
--=======  1:
--===========
SELECT 
    B.Book_id,
    B.Book_name,
    B.Language,
    B.Publication_date,
    BC.Category,
    BA.author_academic_title || ' ' || BA.Author_first_name || ' ' || BA.Author_last_name AS Author,
    ROUND(NVL(AVG(R.Rating), 0), 2) AS Avg_Rating,
    COUNT(R.Reviewer_id) AS Total_Ratings
FROM 
    Books B
JOIN 
    BookCategories BC ON B.Category_id = BC.Category_id
JOIN 
    BookAuthors BA ON B.Author_id = BA.Author_id
LEFT JOIN 
    Reviews R ON B.Book_id = R.Book_id
GROUP BY 
    B.Book_id, 
    B.Book_name, 
    B.Language, 
    B.Publication_date, 
    BC.Category, 
    BA.author_academic_title, 
    BA.Author_first_name, 
    BA.Author_last_name
ORDER BY 
    Avg_Rating DESC, Total_Ratings DESC;


--===========
--=======  2:
--===========
SELECT 
    SR.Room_number,
    SR.Library_floor,
    SR.Library_section,
    SR.Room_capacity,
    CASE 
        WHEN SR.Board = 'Y' THEN 'Has Board'
        ELSE 'No Board'
    END AS Board_Status,
    CASE 
        WHEN SR.Screen = 'Y' THEN 'Has Screen'
        ELSE 'No Screen'
    END AS Screen_Status,
    TO_CHAR(
        NVL(MIN(RR.Start_time), SYSDATE + 1), 
        'YYYY-MM-DD HH24:MI:SS'
    ) AS Available_Until,
    ROUND(
        NVL(
            (MIN(RR.Start_time) - SYSDATE) * 24 * 60, 
            24 * 60
        )
    ) AS Available_Minutes
FROM 
    StudyRooms SR
LEFT JOIN 
    RequestsRooms RR 
    ON SR.Room_number = RR.Assigned_room
    AND RR.Start_time > SYSDATE
    AND RR.Status = 'approved'
WHERE 
    SR.Room_number IN (
        SELECT 
            SR.Room_number
        FROM 
            StudyRooms SR
        MINUS
        SELECT 
            RR.Assigned_room
        FROM 
            RequestsRooms RR
        WHERE 
            SYSDATE BETWEEN RR.Start_time AND RR.Start_time + (RR.Duration_hours / 24)
              AND RR.Status = 'approved'
    )
GROUP BY 
    SR.Room_number, SR.Library_floor, SR.Library_section, SR.Room_capacity, SR.Board, SR.Screen
ORDER BY 
    SR.Room_number;

 

--===========
--=======  3:
--===========
SELECT 
    S.Student_id,
    S.Student_first_name || ' ' || S.Student_last_name AS Student_Name,
    S.Phone AS Phone_Number,
    S.Email AS Email_Address,
    COUNT(L.Book_id) AS Total_Books_Borrowed,
    SUM(L.Fine_amount) AS Total_Fines
FROM 
    Students S
LEFT JOIN 
    Lent L ON S.Student_id = L.Student_id
GROUP BY 
    S.Student_id, S.Student_first_name, S.Student_last_name, S.Phone, S.Email
HAVING 
    SUM(L.Fine_amount) > 0  -- Only students who have paid fines
    AND COUNT(L.Book_id) >= 1  -- Only students who have borrowed at least one book
ORDER BY 
    Total_Fines DESC, Total_Books_Borrowed DESC;


--===========
--=======  4:
--===========
SELECT 
    BA.Author_id,
    BA.Author_academic_title || ' ' || BA.Author_first_name || ' ' || BA.Author_last_name AS Author_Name,
    BA.Nationality,
    TO_CHAR(BA.Author_birth_date, 'YYYY-MM-DD') AS Birth_Date,
    COUNT(B.Book_id) AS Total_Books_Written,
    NVL(SUM(R.Total_Ratings), 0) AS Total_Ratings_Received,
    ROUND(NVL(SUM(R.Total_Score) / SUM(R.Total_Ratings), 0), 2) AS Avg_Rating
FROM 
    BookAuthors BA
LEFT JOIN 
    Books B ON BA.Author_id = B.Author_id
LEFT JOIN 
    (
        SELECT 
            Book_id, 
            COUNT(*) AS Total_Ratings,
            SUM(Rating) AS Total_Score
        FROM 
            Reviews
        GROUP BY 
            Book_id
    ) R ON B.Book_id = R.Book_id
GROUP BY 
    BA.Author_id, 
    BA.Author_academic_title, 
    BA.Author_first_name, 
    BA.Author_last_name, 
    BA.Nationality, 
    BA.Author_birth_date
ORDER BY 
    Total_Books_Written DESC, Avg_Rating DESC, Author_Name ASC;


--===========
--=======  5:
--===========
SELECT *
FROM (
    SELECT 
        B.Book_id,
        B.Book_name,
        B.Language,
        B.Publication_date,
        BC.Category AS Category_Name, 
        BC.Subcategory AS Subcategory_Name, 
        ROUND(AVG(R.Rating), 2) AS Avg_Rating,
        NULL AS Total_Borrows
    FROM 
        Books B
    LEFT JOIN 
        Reviews R ON B.Book_id = R.Book_id
    LEFT JOIN 
        BookCategories BC ON B.Category_id = BC.Category_id 
    GROUP BY 
        B.Book_id, B.Book_name, B.Language, B.Publication_date, BC.Category, BC.Subcategory
    ORDER BY 
        Avg_Rating DESC
) WHERE ROWNUM <= 5

UNION ALL

SELECT *
FROM (
    SELECT 
        B.Book_id,
        B.Book_name,
        B.Language,
        B.Publication_date,
        BC.Category AS Category_Name, 
        BC.Subcategory AS Subcategory_Name, 
        NULL AS Avg_Rating,
        COUNT(L.Book_id) AS Total_Borrows
    FROM 
        Books B
    LEFT JOIN 
        Lent L ON B.Book_id = L.Book_id
    LEFT JOIN 
        BookCategories BC ON B.Category_id = BC.Category_id 
    GROUP BY 
        B.Book_id, B.Book_name, B.Language, B.Publication_date, BC.Category, BC.Subcategory
    ORDER BY 
        Total_Borrows DESC
) WHERE ROWNUM <= 5;

--===========
--=======  6:
--===========
SELECT 
    B.Book_id,
    B.Book_name,
    B.Language,
    B.Publication_date,
    BC.Category AS Book_Category,
    BA.Author_academic_title || ' ' || BA.Author_first_name || ' ' || BA.Author_last_name AS Author_Name,
    AVG_R.Avg_Rating,
    BORROWS.Total_Borrows
FROM (
    SELECT 
        Book_id
    FROM (
        SELECT 
            B.Book_id
        FROM 
            Books B
        LEFT JOIN 
            Reviews R ON B.Book_id = R.Book_id
        GROUP BY 
            B.Book_id
        HAVING 
            ROUND(AVG(R.Rating), 2) < (
                SELECT ROUND(AVG(Avg_Rating), 2)
                FROM (
                    SELECT 
                        B.Book_id,
                        ROUND(AVG(R.Rating), 2) AS Avg_Rating
                    FROM 
                        Books B
                    LEFT JOIN 
                        Reviews R ON B.Book_id = R.Book_id
                    GROUP BY 
                        B.Book_id
                )
            )
    )
    INTERSECT
    SELECT 
        Book_id
    FROM (
        SELECT 
            B.Book_id
        FROM 
            Books B
        LEFT JOIN 
            Lent L ON B.Book_id = L.Book_id
        GROUP BY 
            B.Book_id
        HAVING 
            COUNT(L.Book_id) > (
                SELECT ROUND(AVG(Total_Borrows), 2)
                FROM (
                    SELECT 
                        B.Book_id,
                        COUNT(L.Book_id) AS Total_Borrows
                    FROM 
                        Books B
                    LEFT JOIN 
                        Lent L ON B.Book_id = L.Book_id
                    GROUP BY 
                        B.Book_id
                )
            )
    )
) INTERSECT_BOOKS
JOIN Books B ON INTERSECT_BOOKS.Book_id = B.Book_id
JOIN BookCategories BC ON B.Category_id = BC.Category_id
JOIN BookAuthors BA ON B.Author_id = BA.Author_id
LEFT JOIN (
    SELECT 
        B.Book_id,
        ROUND(AVG(R.Rating), 2) AS Avg_Rating
    FROM 
        Books B
    LEFT JOIN 
        Reviews R ON B.Book_id = R.Book_id
    GROUP BY 
        B.Book_id
) AVG_R ON B.Book_id = AVG_R.Book_id
LEFT JOIN (
    SELECT 
        B.Book_id,
        COUNT(L.Book_id) AS Total_Borrows
    FROM 
        Books B
    LEFT JOIN 
        Lent L ON B.Book_id = L.Book_id
    GROUP BY 
        B.Book_id
) BORROWS ON B.Book_id = BORROWS.Book_id
ORDER BY B.Book_name;



--================================
-- UPDATE QUERIES:
--================================

--===========
--=======  1:
--===========
UPDATE BookStatuses BS
SET 
    BS.Number_of_copies = (
        SELECT 
            SUM(CASE WHEN InnerBS.Status = 'available' THEN InnerBS.Number_of_copies ELSE 0 END) +
            SUM(CASE WHEN InnerBS.Status = 'damaged' THEN InnerBS.Number_of_copies ELSE 0 END) +
            SUM(CASE WHEN InnerBS.Status = 'lost' THEN InnerBS.Number_of_copies ELSE 0 END) 
                    FROM 
            BookStatuses InnerBS
        WHERE 
            InnerBS.Book_id = BS.Book_id
    )
WHERE 
    BS.Status = 'available'
    AND BS.Book_id IN (
        SELECT 
            L.Book_id
        FROM 
            Lent L
        GROUP BY 
            L.Book_id
        HAVING 
            COUNT(*) >= (
                SELECT 
                    ROUND(AVG(Total_Borrows), 2) + 20
                FROM (
                    SELECT 
                        COUNT(*) AS Total_Borrows
                    FROM 
                        Lent
                    GROUP BY 
                        Book_id
                )
            )
    );


--===========
--=======  2:
--===========
UPDATE RequestsRooms
SET Status = 'approved only if paid'
WHERE Start_time > SYSDATE
AND Student_id IN (
    SELECT Student_id
    FROM Lent
    GROUP BY Student_id
    HAVING SUM(Fine_amount) > 200
) AND Status = 'approved';


--================================
-- DELETE QUERIES:
--================================

--===========
--=======  1:
--===========
DELETE FROM Librarians
WHERE Librarian_id IN (
    SELECT Librarian_id
    FROM (
        SELECT 
            L.Librarian_id,
            COUNT(RA.Request_id) AS Completed_Tasks,
            L.Hire_date
        FROM 
            Librarians L
        LEFT JOIN 
            RequestAssignments RA ON L.Librarian_id = RA.Assigned_librarian
        GROUP BY 
            L.Librarian_id, L.Hire_date
        HAVING 
            COUNT(RA.Request_id) = (
                SELECT MIN(TaskCount)
                FROM (
                    SELECT 
                        COUNT(RA2.Request_id) AS TaskCount
                    FROM 
                        Librarians L2
                    LEFT JOIN 
                        RequestAssignments RA2 ON L2.Librarian_id = RA2.Assigned_librarian
                    GROUP BY 
                        L2.Librarian_id
                    ORDER BY 
                        TaskCount ASC, L2.Hire_date ASC
                )
            )
        ORDER BY 
            Completed_Tasks ASC, Hire_date ASC
    )
    WHERE ROWNUM <= 5
);


--===========
--=======  2:
--===========
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
        AND PreviousRR.Start_time <= RR.Start_time 
        AND PreviousRR.Status = 'approved' 
    WHERE 
        RR.Status = 'approved' 
    GROUP BY 
        RR.Student_id,
        RR.Request_time,
        RR.Start_time,
        RR.Duration_hours,
        RR.Number_of_people,
        RR.Board,
        RR.Screen,
        RR.Status
    HAVING 
        RR.Start_time >= TRUNC(SYSDATE + 1) 
        AND NVL(SUM(PreviousRR.Duration_hours), 0) > 10 
);