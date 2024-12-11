

CREATE VIEW book_lending_details AS
SELECT
    b.book_name AS book_name,
    b.book_id AS book_id,
    bc.category AS category,
    bc.subcategory AS subcategory,
    ba.author_academic_title || ' ' || p.first_name || ' ' || p.last_name AS author_full_name,
    b.language AS language,
    s.student_id AS student_id,
    sp.first_name || ' ' || sp.last_name AS student_full_name, 
    cp.email AS student_email,
    cp.phone_number AS student_phone_number,
    l.borrow_date AS borrow_date,
    l.return_date AS return_date,
    l.status AS status,
    l.fine_amount AS fine_amount

FROM BookAuthors ba
JOIN Books b
    ON ba.author_id = b.author_id
JOIN bookcategories bc 
    ON b.category_id = bc.category_id
JOIN person p 
    ON b.author_id = p.person_id
JOIN lent l 
    ON b.book_id = l.book_id
JOIN students s     
    ON l.student_id = s.student_id
JOIN person sp 
    ON s.student_id = sp.person_id 
JOIN comunicationPerson cp 
    ON s.student_id = cp.c_person_id;

COMMIT;


SELECT 
    student_id,
    student_full_name,
    student_email,
    student_phone_number,
    SUM(fine_amount) AS total_fine_amount
FROM book_lending_details
GROUP BY 
    student_id, 
    student_full_name, 
    student_email, 
    student_phone_number
ORDER BY total_fine_amount DESC;


SELECT 
    book_id,
    book_name,
    author_full_name,
    category,
    subcategory,
    language,
    COUNT(borrow_date) AS times_borrowed_in_2024
FROM book_lending_details
WHERE EXTRACT(YEAR FROM borrow_date) = 2024
GROUP BY 
    book_id, 
    book_name, 
    category, 
    subcategory, 
    author_full_name, 
    language
ORDER BY times_borrowed_in_2024 DESC;


