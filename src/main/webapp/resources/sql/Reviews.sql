
CREATE TABLE Reviews (
    r_id INT NOT NULL AUTO_INCREMENT,
    p_id INT NOT NULL,
    u_id INT NOT NULL,
    r_content TEXT NOT NULL,
    r_rating INT NOT NULL DEFAULT 5, -- 별점 컬럼 추가 (1~5점)
    r_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (r_id),
    UNIQUE KEY unique_user_project (p_id, u_id), -- 한 사람이 한 프로젝트에 1번만 참여하도록 제한
    FOREIGN KEY (p_id) REFERENCES Projects(p_id) ON DELETE CASCADE,
    FOREIGN KEY (u_id) REFERENCES Users(u_id) ON DELETE CASCADE
);