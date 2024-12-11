CREATE OR REPLACE FUNCTION calculate_fine(
    v_condition IN VARCHAR2,
    v_return_date IN DATE
) RETURN NUMBER IS
    v_days_late NUMBER := 0;
    v_fine NUMBER := 0;
BEGIN
    IF v_condition NOT IN ('good', 'damaged', 'lost') THEN
        DBMS_OUTPUT.PUT_LINE('Invalid condition specified for the book.');
        RETURN 0;
    END IF;

    IF v_condition = 'lost' THEN
        RETURN 100;
    END IF;

    v_days_late := GREATEST(0, TRUNC(SYSDATE) - TRUNC(v_return_date));

    CASE v_condition
        WHEN 'damaged' THEN
            v_fine := 50 + (v_days_late * 3);
        WHEN 'good' THEN
            v_fine := v_days_late * 3;
    END CASE;

    RETURN v_fine;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Issue occurred while calculating the fine: ' || SQLERRM);
        RETURN 0;
END;

