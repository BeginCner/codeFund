-- 이름: codecrew.sql


CREATE TABLE Users (
  u_id		INTEGER AUTO_INCREMENT PRIMARY KEY,
  u_nickname	VARCHAR(50),
  u_password	VARCHAR(100),
  u_login_id	VARCHAR(100)
);

CREATE TABLE  Projects (
  p_id		INTEGER PRIMARY KEY,
  u_id		INTEGER,
  p_title		VARCHAR(40),
  p_description		TEXT,
  p_goal	integer,
  p_current integer,
  p_end		DATE,
  p_status	varchar(20), /*진행중,성공,마감*/
  FOREIGN KEY(u_id) REFERENCES Users(u_id)
);


CREATE TABLE Funding (
  f_id INTEGER PRIMARY KEY,
  u_id  INTEGER,
  p_id  INTEGER,
  f_amount INTEGER,
  FOREIGN KEY (u_id) REFERENCES Users(u_id),
  FOREIGN KEY (p_id) REFERENCES Projects(p_id)
);

  
commit;