DELIMITER $$

CREATE TRIGGER after_post_status_change
AFTER UPDATE ON post
FOR EACH ROW
BEGIN
    -- 승인 처리
    IF OLD.post_status = '대기중' AND NEW.post_status = '승인' THEN
        INSERT INTO log_list (
            user_id,
            action,
            entity_type,
            performed_at,
            details
        ) VALUES (
            NEW.user_id,
            '승인',
            'post',
            NOW(),
            CONCAT('post_id=', NEW.post_id, '이 승인됨')
        );
    
    -- 반려 처리
    ELSEIF OLD.post_status = '대기중' AND NEW.post_status = '반려' THEN
        INSERT INTO log_list (
            user_id,
            action,
            entity_type,
            performed_at,
            details
        ) VALUES (
            NEW.user_id,
            '반려',
            'post',
            NOW(),
            CONCAT('post_id=', NEW.post_id, '이 반려됨. ')
        );
    END IF;
END$$

DELIMITER ;