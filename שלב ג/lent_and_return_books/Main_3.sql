DECLARE
    v_student_id NUMBER: 271247496; -- Student ID
    v_book_ids SYS.ODCINUMBERLIST:= SYS.ODCINUMBERLIST(3313, 3015, 3016); -- List of Book IDs to return
    v_conditions SYS.ODCIVARCHAR2LIST:= SYS.ODCIVARCHAR2LIST('good', 'damaged', 'lost'); -- Conditions for each book
BEGIN
    -- Call the return_books procedure
    return_books(
        v_student_id => v_student_id,
        v_book_ids => v_book_ids,
        v_conditions => v_conditions
    );
END;