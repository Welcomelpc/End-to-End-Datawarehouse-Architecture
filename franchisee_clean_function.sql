CREATE OR REPLACE FUNCTION "DwSales".clean_data(
    p_FranchiseeName varchar,
    p_Address varchar
)
RETURNS TABLE (
    cleaned_FranchiseeName varchar,
    cleaned_Address varchar
) 
LANGUAGE plpgsql
AS $$
BEGIN
    cleaned_FranchiseeName := TRIM(REPLACE(p_FranchiseeName, 'Mc', ''));
    cleaned_Address := TRIM(REPLACE(p_Address, 'Mc', ''));
    
    RETURN NEXT;
END;
$$;