SELECT 'alert' as component,
    'Oups' as title,
    'An error occurs. Changes not saved!' as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $error IS NOT NULL;

SELECT 'alert' as component,
    'Changes succefully saved!' as title,
    --'circle-check' as icon,
    'confetti' as icon,
    'green' as color
WHERE $success IS NOT NULL;