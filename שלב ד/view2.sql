
CREATE VIEW book_details AS
SELECT
    b.book_id,
    b.book_name,
    b.publication_date,
    bc.category,
    bc.subcategory,
    b.language,
    p.person_id AS author_id,
    COALESCE(ba.author_academic_title || ' ', '') || p.first_name || ' ' || p.last_name AS author_full_name,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(DISTINCT r.book_id || r.reviewer_id) AS number_of_reviews, 
    MAX(CASE WHEN bs.status = 'available' THEN bs.number_of_copies ELSE 0 END) AS available_books,
    MAX(CASE WHEN bs.status = 'borrowed' THEN bs.number_of_copies ELSE 0 END) AS borrowed_books,
    MAX(CASE WHEN bs.status = 'damaged' THEN bs.number_of_copies ELSE 0 END) AS damaged_books,
    MAX(CASE WHEN bs.status = 'lost' THEN bs.number_of_copies ELSE 0 END) AS lost_books
FROM books b
JOIN bookcategories bc 
    ON b.category_id = bc.category_id
JOIN bookAuthors ba
    ON b.author_id = ba.author_id
JOIN person p 
    ON ba.author_id = p.person_id
LEFT JOIN reviews r
    ON b.book_id = r.book_id
LEFT JOIN BookStatuses bs
    ON b.book_id = bs.book_id
GROUP BY 
    b.book_id, 
    b.book_name, 
    b.publication_date, 
    bc.category, 
    bc.subcategory, 
    b.language, 
    ba.author_academic_title,
    p.person_id,
    p.first_name, 
    p.last_name;

COMMIT;

SELECT * FROM book_details;


SELECT 
    book_id,
    book_name,
    category,
    subcategory,
    author_id,
    author_full_name,
    avg_rating
FROM book_details
WHERE (category, avg_rating) IN (
    SELECT 
        category, 
        MAX(avg_rating) AS max_avg_rating
    FROM book_details
    GROUP BY category
);



SELECT DISTINCT
    author_id,
    author_full_name,
    book_id,
    book_name,
    avg_rating,
    number_of_reviews,
    'Highest Rating' AS criteria
FROM book_details
WHERE (author_id, avg_rating) IN (
    SELECT 
        author_id,
        MAX(avg_rating)
    FROM book_details
    GROUP BY author_id
)
UNION
SELECT DISTINCT
    author_id,
    author_full_name,
    book_id,
    book_name,
    avg_rating,
    number_of_reviews,
    'Most Reviews' AS criteria
FROM book_details
WHERE (author_id, number_of_reviews) IN (
    SELECT 
        author_id,
        MAX(number_of_reviews)
    FROM book_details
    GROUP BY author_id
)
ORDER BY author_id;

