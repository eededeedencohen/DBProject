

CREATE OR REPLACE FUNCTION has_high_debt(v_student_id IN NUMBER)
RETURN BOOLEAN IS
    v_total_debt NUMBER;
BEGIN
    SELECT SUM(Fine_amount)
    INTO v_total_debt
    FROM Lent
    WHERE Student_id = v_student_id;

    RETURN NVL(v_total_debt, 0) > 200;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No debt records found for the student.');
        RETURN FALSE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while checking the student debt: ' || SQLERRM);
        RETURN FALSE;
END;

