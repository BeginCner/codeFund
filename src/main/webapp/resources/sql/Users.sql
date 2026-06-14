

CREATE TABLE Users (
  u_id		INTEGER AUTO_INCREMENT PRIMARY KEY,
  u_nickname	VARCHAR(50),
  u_password	VARCHAR(100),
  u_login_id	VARCHAR(100)
);

commit;

select * from Users;