create database finalproject;
use finalproject;

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,  
    category_name VARCHAR(50) UNIQUE NOT NULL
);
INSERT INTO Categories (category_name) VALUES 
('한식'), ('일식'), ('중식'), ('양식');

CREATE TABLE weather_data (
weatherId INT AUTO_INCREMENT PRIMARY KEY,
weatherType VARCHAR(50) NOT NULL
);
INSERT INTO weather_data (weatherType) VALUES
('맑음'), ('비'), ('흐림'), ('눈');

select * from recipes;
create table Recipes(
 recipes_id int auto_increment primary key,
 foodName Varchar(50),
 foodImg Varchar(255),
 step1 Varchar(255),
 step2 Varchar(255),
 step3 Varchar(255),
 step4 Varchar(255),
 step5 Varchar(255),
 step6 Varchar(255),
 stepImg1 Varchar(255),
 stepImg2 Varchar(255),
 stepImg3 Varchar(255),
 stepImg4 Varchar(255),
 stepImg5 Varchar(255),
 stepImg6 Varchar(255),
 view Int default 0,
 foodTime Int,
 category_id Int,
 weatherId int,
 foreign key (weatherId) references weather_data(weatherId),
 FOREIGN KEY (category_id) REFERENCES Categories(category_id) 
);

create table User_Recipes(
 user_recipes_id int auto_increment primary key,
 foodName Varchar(50),
 foodImg Varchar(255),
 step1 Varchar(255),
 step2 Varchar(255),
 step3 Varchar(255),
 step4 Varchar(255),
 step5 Varchar(255),
 step6 Varchar(255),
 stepImg1 Varchar(255),
 stepImg2 Varchar(255),
 stepImg3 Varchar(255),
 stepImg4 Varchar(255),
 stepImg5 Varchar(255),
 stepImg6 Varchar(255),
 view Int default 0,
 user_id BIGINT,
 foodTime Int,
 category_id Int,
 status VARCHAR(20) DEFAULT 'off', -- 승인 시 on
 FOREIGN KEY (category_id) REFERENCES Categories(category_id),
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE Ingredients (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Recipe_Ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipes_id INT,
    ingredient_id INT,
    user_recipes_id INT,
    FOREIGN KEY (recipes_id) REFERENCES Recipes(recipes_id) ON DELETE CASCADE,
    FOREIGN KEY (user_recipes_id) REFERENCES User_Recipes(user_recipes_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE
);

CREATE TABLE favorite (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    recipe_id INT ,
    UserRecipesId int,
    foreign key(UserRecipesId) references User_Recipes(user_recipes_id) on delete cascade,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
		foreign key(recipe_id) references recipes(recipes_id) ON DELETE CASCADE
);

CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,      
    recipes_id INT,                                
    user_id BIGINT,                                   
    review_text TEXT,     
    rating INT,   -- 평점                                                            
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UserRecipesId int,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    foreign key(UserRecipesId) references User_Recipes(user_recipes_id) on delete cascade,
    FOREIGN KEY (recipes_id) REFERENCES Recipes(recipes_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);



CREATE TABLE board (
    boardId INT AUTO_INCREMENT PRIMARY KEY,  -- 순번 (PK)
    title VARCHAR(255) NOT NULL,  -- 제목
    content TEXT NOT NULL,  -- 내용 (써머노트 사용할 예정)
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 생성일자
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 수정일자
    authorId BIGINT NOT NULL,  -- 글쓴이 아이디 (회원 테이블과 JOIN)
    author varchar(50) not null, -- 글쓴이 name
    authorEmail VARCHAR(255) NOT NULL,  -- 글쓴이 이메일 (동하님 거 추가해두었습니다.)
    views INT DEFAULT 0,  -- 조회수
    likes INT DEFAULT 0,  -- 좋아요 수
    dislikes INT DEFAULT 0,  -- 싫어요 수
    FOREIGN KEY (authorId) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE comment (
    commentId INT AUTO_INCREMENT PRIMARY KEY,  -- 순번 (PK)
    replyId INT NOT NULL DEFAULT 0,            -- 부모 댓글 ID (0이면 일반 댓글)
    boardId INT NOT NULL,  -- 게시글 ID (어느 게시글의 댓글인지)
    authorId BIGINT NOT NULL,  -- 댓글 작성자 id (회원 테이블과 JOIN)
    author varchar(50) not null, -- 댓글 작성자 name
    content TEXT NOT NULL,  -- 댓글 내용
    authorEmail VARCHAR(255) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 생성일자
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 수정일자
    FOREIGN KEY (boardId) REFERENCES board(boardId) ON DELETE CASCADE,
    FOREIGN KEY (authorId) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE boardLike(
    boardId INT NOT NULL,      -- 게시물 ID (게시판에서의 게시물 식별자)
    userEmail VARCHAR(255) NOT NULL,
		likeType VARCHAR(10), -- 좋아요, 안 좋아요 타입 수정 완료
    PRIMARY KEY (boardId, userId),  -- 게시물 ID와 사용자 ID를 복합키로 설정 (중복 방지)
    FOREIGN KEY (boardId) REFERENCES board(boardId) ON DELETE CASCADE, -- 게시물 테이블과 연결
    FOREIGN KEY (userEmail) REFERENCES users(email) ON DELETE CASCADE  -- 사용자 테이블과 연결
);

CREATE TABLE reports (
    reportId INT AUTO_INCREMENT PRIMARY KEY,
    boardId INT,  -- 신고한 게시글 ID
    reporterId BIGINT,  -- 신고자 ID
    reporter VARCHAR(50), -- 신고자 이름 (user.name)
    reason VARCHAR(255),  -- 신고 사유
    reportedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 신고 날짜
    FOREIGN KEY (boardId) REFERENCES board(boardId) ON DELETE CASCADE,   -- 게시물 테이블과 연결
    FOREIGN KEY (reporterId) REFERENCES users(id)  -- 사용자 테이블과 연결
);

ALTER TABLE reports
DROP FOREIGN KEY reports_ibfk_2;

ALTER TABLE reports
ADD CONSTRAINT reports_ibfk_2
FOREIGN KEY (reporterId) REFERENCES users(id)
ON DELETE CASCADE;

CREATE TABLE club (
    clubId INT AUTO_INCREMENT PRIMARY KEY,         -- 동호회 ID
    clubName VARCHAR(255) NOT NULL,                 -- 동호회 이름
    clubFeatures TEXT,                              -- 동호회 특징
    location VARCHAR(255),                          -- 모임 장소
    date DATE,                                      -- 모집 마감일
    recruiterEmail VARCHAR(255) NOT NULL,    -- 모집자 이메일
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 생성일자
    clubImage VARCHAR(255),                         -- 대표 이미지 (파일 경로)
    clubUrl VARCHAR(255),  -- 클럽 활동 진행할 url
    status ENUM('active', 'closed') DEFAULT 'active', -- 모집 상태
    FOREIGN KEY (recruiterEmail) REFERENCES users(email) ON DELETE CASCADE
);

CREATE TABLE clubtag (
		clubId INT NOT NULL,          -- 동호회 ID (외래키)
    tagId INT NOT NULL,           -- 태그 ID (외래키)
    id INT AUTO_INCREMENT PRIMARY KEY,
    FOREIGN KEY (clubId) REFERENCES club(clubId) ON DELETE CASCADE, 
    FOREIGN KEY (tagId) REFERENCES tag(tagId) ON DELETE CASCADE
);

CREATE TABLE tag (
    tagId INT AUTO_INCREMENT PRIMARY KEY,   -- 태그 ID
    tagName VARCHAR(255) NOT NULL UNIQUE     -- 태그 이름
);

CREATE TABLE applications (
    applicationId INT AUTO_INCREMENT PRIMARY KEY,  -- 신청 ID (자동 증가)
    clubId INT NOT NULL,                           -- 신청한 동호회 ID
    applicantName VARCHAR(255) NOT NULL,           -- 신청자 이름
    applicantEmail VARCHAR(255) NOT NULL,          -- 신청자 이메일
    applicantAge INT NOT NULL,                     -- 신청자 나이
    applicantGender VARCHAR(10) NOT NULL,          -- 신청자 성별
    applyDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 신청한 날짜
    privacyAgreement BOOLEAN NOT NULL,                -- 개인정보 동의 여부 (true/false)
    FOREIGN KEY (clubId) REFERENCES club(clubId)   -- clubId는 club 테이블과 연결
);

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    profile_image VARCHAR(500) DEFAULT NULL,
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    phone_number VARCHAR(20) DEFAULT NULL,
    is_verified TINYINT(1) DEFAULT 0
);
ALTER TABLE users ADD COLUMN last_login DATETIME DEFAULT NULL;
ALTER TABLE users ADD COLUMN last_login_update DATETIME DEFAULT NULL;
ALTER TABLE users MODIFY COLUMN is_verified BOOLEAN DEFAULT FALSE NOT NULL;
ALTER TABLE users
ADD COLUMN login_count INT DEFAULT 0;

CREATE TABLE inquiries (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    reply TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_email) REFERENCES users(email) ON DELETE CASCADE
);

CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    receiver_email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (receiver_email) REFERENCES users(email) ON DELETE CASCADE
);

CREATE TABLE user_deletion_requests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    reason TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE
);

CREATE TABLE verification_codes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE login_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE tarot_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(255) NOT NULL,
    tarot_card_id INT NOT NULL,
    drawn_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_email) REFERENCES users(email) ON DELETE CASCADE,
    FOREIGN KEY (tarot_card_id) REFERENCES tarot_cards(id) ON DELETE CASCADE
);

CREATE TABLE tarot_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    image_url VARCHAR(255) NOT NULL
);
ALTER TABLE tarot_cards
ADD created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

INSERT INTO tarot_cards (name, description, image_url) VALUES
('The Sun', '이 카드는 기쁨과 성공을 상징합니다. 마치 요리의 마지막 한 스푼이 완벽한 맛을 만들어내듯, 모든 것이 순조롭게 풀릴 것입니다. 지금은 긍정적인 에너지가 넘치는 시기이며, 어떤 일이든 밝고 좋은 결과를 맞이하게 될 것입니다. 자신감을 가지고 나아가세요. 오늘은 당신에게 행운과 기쁨이 가득할 것입니다.', 'The_Sun.webp'),
('The Moon', '이 카드는 불확실성과 직관을 상징합니다. 마치 요리에서 처음에는 정확한 맛을 알 수 없지만, 한 번 더 맛을 보고 조정하는 과정처럼, 겉으로 보이는 것만 믿지 말고 깊이 고민해 보아야 할 시기입니다. 오늘은 신중한 판단이 필요한 하루입니다. 직관을 믿되, 모든 결정을 내리기 전에 충분히 생각하고 검토하는 것이 중요합니다. 상황을 면밀히 살펴보고, 내면의 목소리에 귀 기울이세요.', 'The_Moon.webp'),
('The Star', '이 카드는 희망과 영감을 상징합니다. 마치 요리를 시작할 때, 좋은 재료와 열정을 가지고 있으면 맛있는 결과를 얻을 수 있는 것처럼, 지금은 마음을 편히 먹고 꿈을 향해 나아갈 때입니다. 당신의 노력과 긍정적인 에너지가 좋은 결과를 이끌어낼 것입니다. 희망을 가지고 자신감을 갖고 나아가세요. 당신이 원하는 목표는 충분히 이룰 수 있습니다.', 'The_Star.webp'),
('The Moon', '이 카드는 감성적이고 내면의 소리에 귀 기울여야 할 시기를 의미합니다. 마치 요리할 때, 감각을 세심하게 다듬는 과정처럼, 지금은 마음의 소리에 집중하고 잠시 쉬어가는 것이 필요한 때입니다. 외부의 소음에 휘둘리지 말고, 내면의 목소리를 들으며 조용히 자신을 돌아보세요. 휴식을 취하고, 잠시 멈추면 더 나은 방향을 찾을 수 있을 것입니다.', 'The_Moon(other).webp'),
('The Sun', '이 카드는 밝고 순수한 에너지가 충만한 하루를 의미합니다. 마치 요리에서 재료가 완벽하게 어우러져 최고의 맛을 낸 것처럼, 오늘은 당신의 노력에 따라 성취를 얻을 수 있는 날입니다. 주변 사람들과의 관계도 더욱 원만해지고, 긍정적인 에너지가 당신을 따라올 것입니다. 자신감을 가지고 나아가세요. 당신이 원하는 모든 것이 이루어질 수 있는 시기입니다.', 'The_Sun(Other).webp'),
('Strength', '이 카드는 부드러운 힘, 인내심, 내면의 강함을 상징합니다. 마치 요리에서 모든 재료가 조화를 이루기 위해 인내와 세심한 배려가 필요한 것처럼, 오늘은 감정을 다스리고 차분히 상황을 받아들이는 것이 중요합니다. 당신의 내면에는 어떤 어려움도 이겨낼 수 있는 강함이 있습니다. 평정심을 잃지 않고 감정을 조절하면, 어떤 문제든 해결할 수 있을 것입니다. 오늘은 그 강한 내면의 힘을 믿고 나아가세요.', 'Strength.webp'),
('The Lovers', '이 카드는 사랑, 관계, 조화를 상징합니다. 마치 요리에서 여러 재료가 조화롭게 섞여 완벽한 맛을 내듯, 오늘은 사람들과의 관계에서 중요한 변화나 특별한 인연이 다가올 수 있는 시기입니다. 선택의 순간이 다가오고 있으니, 마음의 소리에 귀 기울이며 자연스럽게 따라가세요. 당신의 직감과 감정이 이끌어주는 방향으로 움직인다면, 좋은 결과를 얻을 수 있을 것입니다.', 'The_Lovers.webp'),
('The Star', '이 카드는 희망의 빛이 어둠을 밝히듯, 긍정적인 마음이 중요한 시기를 의미합니다. 마치 어두운 밤을 지나 밝은 아침이 오는 것처럼, 지금 당신에게 필요한 건 긍정적인 에너지와 인내입니다. 조용히 기다리며 믿음을 가지고 나아가세요. 좋은 일이 곧 다가올 것이며, 모든 것이 제자리를 찾을 것입니다. 희망을 잃지 말고, 차분하게 기다리면 원하는 결과가 찾아올 거예요.', 'The_Star(other).webp');

CREATE TABLE chat_rooms (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,       -- 유저 ID
  admin_id BIGINT NOT NULL,      -- 관리자 ID (users.role = 'admin')
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_chat (user_id, admin_id), -- 유저-관리자 1:1 고정
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE chat_messages (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  room_id BIGINT NOT NULL,
  sender_id BIGINT,  -- ← 여기서 NOT NULL 제거!
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE TABLE chat_notifications (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  receiver_id BIGINT NOT NULL,
  room_id BIGINT NOT NULL,
  message_preview TEXT,
  is_checked BOOLEAN DEFAULT FALSE,
  notified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (room_id) REFERENCES chat_rooms(id) ON DELETE CASCADE
);

