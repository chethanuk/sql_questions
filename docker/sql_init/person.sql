DROP TABLE IF EXISTS person;
CREATE TABLE IF NOT EXISTS person
(
    PersonID	varchar(300),
    Name	varchar(300),
    Email	varchar(300),
    Score	varchar(300)
);

INSERT INTO person (PersonID,Name,Email,Score) VALUES ('1', 'Alice', 'alice2018@hotmail.com', '88');
INSERT INTO person (PersonID,Name,Email,Score) VALUES ('2', 'Bob', 'bob2018@hotmail.com', '11');
INSERT INTO person (PersonID,Name,Email,Score) VALUES ('3', 'Davis', 'davis2018@hotmail.com', '27');
INSERT INTO person (PersonID,Name,Email,Score) VALUES ('4', 'Tara', 'tara2018@hotmail.com', '45');
INSERT INTO person (PersonID,Name,Email,Score) VALUES ('5', 'John', 'john2018@hotmail.com', '63');
# USED https://tableconvert.com/excel-to-sql