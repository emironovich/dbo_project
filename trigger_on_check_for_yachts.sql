CREATE TRIGGER checking_yacht_in_port_for_check ON yachts
AFTER UPDATE AS
BEGIN
	IF(EXISTS (SELECT * 
			   FROM deleted
			   JOIN inserted
			   ON deleted.id = inserted.id
			   WHERE deleted.last_check <> inserted.last_check 
			   AND
			   deleted.placement <> 'in port'))
		BEGIN
		RAISERROR('Yacht should be in port to get checked', 16, 1);
		ROLLBACK;
		END
END

ENABLE TRIGGER checking_yacht_in_port_for_check ON yachts;