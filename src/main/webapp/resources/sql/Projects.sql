
CREATE TABLE  Projects (
  p_id		INTEGER AUTO_INCREMENT PRIMARY KEY,
  u_id		INTEGER,
  p_title		VARCHAR(40),
  p_description		TEXT,
  p_goal	integer,
  p_current integer,
  p_end		DATE,
  p_status	varchar(20), /*진행중,성공,마감*/
  FOREIGN KEY(u_id) REFERENCES Users(u_id)
);


commit;

-- 기존 테이블에 이미지 파일명 저장 칼럼 추가
ALTER TABLE Projects ADD COLUMN p_image VARCHAR(255);

