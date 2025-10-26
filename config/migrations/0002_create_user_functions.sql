-- Return if user IsAdmin or not
CREATE OR REPLACE FUNCTION checkUserIsAdmin(
    _session text
) 
RETURNS boolean AS $$
BEGIN
    RETURN (
        SELECT IsAdmin 
        FROM GetUserFromSession 
        WHERE Session = _session
    );
EXCEPTION 
    WHEN OTHERS THEN
        -- Log error or handle as needed
        RETURN false;
END;
$$ LANGUAGE plpgsql;

-- Return the user rights for this systemname and dbitemid
CREATE OR REPLACE FUNCTION checkUserPermission(
    _session text,
    _systemname text,
    _dbitemid integer = NULL
) 
RETURNS TABLE (
    CanRead boolean,
    CanWrite boolean,
    CanCreate boolean,
    CanDelete boolean
) AS $$
BEGIN
    -- First check if user is admin
    IF EXISTS (
        SELECT 1 
        FROM GetUserFromSession 
        WHERE Session = _session 
        AND IsAdmin = true
    ) THEN
        RETURN QUERY SELECT true, true, true, true;
        RETURN;
    END IF;

    -- If not admin, check specific permissions
    IF _dbitemid IS NULL THEN
        -- Query without DbItemId check
        RETURN QUERY
        SELECT 
            COALESCE(spi.CanRead, false) as CanRead,
            COALESCE(spi.CanWrite, false) as CanWrite,
            COALESCE(spi.CanCreate, false) as CanCreate,
            COALESCE(spi.CanDelete, false) as CanDelete
        FROM GetUserFromSession gus
        LEFT JOIN CoreSecurityProfileItem spi 
            ON gus.SecurityProfileId = spi.SecurityProfileId 
            AND spi.SystemName = _systemname
        WHERE gus.Session = _session
        LIMIT 1;
    ELSE
        -- Query with DbItemId check
        RETURN QUERY
        SELECT 
            COALESCE(spi.CanRead, false) as CanRead,
            COALESCE(spi.CanWrite, false) as CanWrite,
            COALESCE(spi.CanCreate, false) as CanCreate,
            COALESCE(spi.CanDelete, false) as CanDelete
        FROM GetUserFromSession gus
        LEFT JOIN CoreSecurityProfileItem spi 
            ON gus.SecurityProfileId = spi.SecurityProfileId 
            AND spi.SystemName = _systemname
            AND spi.DbItemId = _dbitemid
        WHERE gus.Session = _session
        LIMIT 1;
    END IF;

    -- If no rows returned, return all false
    IF NOT FOUND THEN
        RETURN QUERY SELECT false, false, false, false;
    END IF;
EXCEPTION 
    WHEN OTHERS THEN
        -- Log error or handle as needed
        RETURN QUERY SELECT false, false, false, false;
END;
$$ LANGUAGE plpgsql;