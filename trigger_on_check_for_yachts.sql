CREATE TRIGGER checking_yacht_in_port_for_check ON yachts
INSTEAD OF UPDATE AS
BEGIN
	IF(EXISTS (SELECT * 
			   FROM deleted
			   JOIN inserted
			   ON deleted.id = inserted.id
			   WHERE deleted.last_check <> inserted.last_check 
			   AND
			   deleted.placement <> 'in port'))
		RAISERROR('Yacht should be in port to get checked', 16, 1);
	ELSE

	DELETE FROM yachts
	WHERE id IN (SELECT id FROM deleted);

	INSERT INTO yachts
	SELECT * FROM inserted;
END

--ENABLE TRIGGER checking_yacht_in_port_for_check ON yachts;