

CREATE OR REPLACE FUNCTION is_librarian_assigned(v_librarian_id INT)
RETURN BOOLEAN IS
    v_count INT;
BEGIN
    -- Check if the librarian ID is valid 
    IF v_librarian_id IS NULL OR v_librarian_id <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid librarian ID.');
        RETURN FALSE;
    END IF;

    -- Check if the librarian is assigned to any tasks - return TRUE if assigned, FALSE otherwise
    SELECT COUNT(*)
    INTO v_count
    FROM RequestAssignments ra
    JOIN LibraryRequests lr ON ra.request_id = lr.request_id
    WHERE ra.assigned_librarian = v_librarian_id
    AND lr.request_status = 'in progress';

    RETURN v_count > 0;
END;


