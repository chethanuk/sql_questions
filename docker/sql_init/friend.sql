DROP TABLE IF EXISTS friend;
CREATE TABLE IF NOT EXISTS friend
(
    PersonID varchar(300),
    FriendID varchar(300)
);

INSERT INTO friend (PersonID, FriendID)
VALUES ('1', '2');
INSERT INTO friend (PersonID, FriendID)
VALUES ('1', '3');
INSERT INTO friend (PersonID, FriendID)
VALUES ('2', '1');
INSERT INTO friend (PersonID, FriendID)
VALUES ('2', '3');
INSERT INTO friend (PersonID, FriendID)
VALUES ('3', '5');
INSERT INTO friend (PersonID, FriendID)
VALUES ('4', '2');
INSERT INTO friend (PersonID, FriendID)
VALUES ('4', '3');
INSERT INTO friend (PersonID, FriendID)
VALUES ('4', '5');
