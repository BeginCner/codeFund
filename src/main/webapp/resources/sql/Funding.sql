

CREATE TABLE Funding (
  f_id INTEGER AUTO_INCREMENT PRIMARY KEY,
  u_id  INTEGER,
  p_id  INTEGER,
  f_amount INTEGER,
  FOREIGN KEY (u_id) REFERENCES Users(u_id),
  FOREIGN KEY (p_id) REFERENCES Projects(p_id)
);

  
commit;