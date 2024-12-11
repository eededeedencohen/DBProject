

CREATE OR REPLACE FUNCTION get_least_busy_librarian
RETURN INT IS
    v_librarian_id INT;
BEGIN
    -- Check if there are any librarians in the system
    DECLARE
        v_librarians_count INT;
    BEGIN
        SELECT COUNT(*) INTO v_librarians_count FROM Librarians;
        IF v_librarians_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: No librarians found in the system.');
            RETURN NULL;
        END IF;
    END;

    -- Find the least busy librarian based on the number of assigned tasks and hire date
    DECLARE
        CURSOR librarian_cursor IS
            SELECT l.Librarian_id
            FROM Librarians l
            LEFT JOIN RequestAssignments ra ON l.Librarian_id = ra.Assigned_librarian
            GROUP BY l.Librarian_id, l.Hire_date
            ORDER BY COUNT(ra.Request_id) ASC, l.Hire_date ASC;

    BEGIN
        OPEN librarian_cursor;
        FETCH librarian_cursor INTO v_librarian_id;
        CLOSE librarian_cursor;
        
        RETURN v_librarian_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: No available librarian found.');
            RETURN NULL;
    END;
END;


