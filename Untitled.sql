-- -----------------------------------------------------
-- 1. Usuarios y Roles
-- -----------------------------------------------------
CREATE TABLE roles (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(50) NOT NULL UNIQUE,  -- e.g. 'adoptante', 'fundacion', 'admin'
  description  VARCHAR(255) NULL
) ENGINE=InnoDB;

CREATE TABLE users (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  role_id      INT NOT NULL,
  name         VARCHAR(100) NOT NULL,
  email        VARCHAR(150) NOT NULL UNIQUE,
  password     VARCHAR(255) NOT NULL,        -- hashed
  created_at   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 2. Mascotas
-- -----------------------------------------------------
CREATE TABLE pets (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(100) NOT NULL,
  species        VARCHAR(50)  NOT NULL,      -- e.g. 'Perro', 'Gato'
  breed          VARCHAR(100) NULL,
  age            INT          NULL,          -- en meses o años
  gender         ENUM('M','F')   NULL,
  description    TEXT         NULL,
  health_status  VARCHAR(100) NULL,
  image_url      VARCHAR(255) NULL,
  created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 3. Adopciones
-- -----------------------------------------------------
CREATE TABLE adoptions (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  user_id       INT NOT NULL,                -- solicitante
  pet_id        INT NOT NULL,
  status        ENUM('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
  requested_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  processed_at  DATETIME NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (pet_id)  REFERENCES pets(id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 4. Donaciones
-- -----------------------------------------------------
CREATE TABLE donations (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  user_id          INT NOT NULL,
  amount           DECIMAL(10,2) NOT NULL,
  payment_ref      VARCHAR(100) NULL,
  donation_date    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 5. Blog y Comentarios
-- -----------------------------------------------------
CREATE TABLE posts (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  author_id     INT NOT NULL,
  title         VARCHAR(200) NOT NULL,
  content       TEXT         NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (author_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE comments (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  post_id       INT NOT NULL,
  user_id       INT NOT NULL,
  content       TEXT        NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 6. Notificaciones
-- -----------------------------------------------------
CREATE TABLE notifications (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  user_id       INT NOT NULL,
  type          VARCHAR(50) NOT NULL,        -- e.g. 'solicitud', 'donacion', 'aprobacion'
  message       VARCHAR(255) NOT NULL,
  is_read       TINYINT(1)  NOT NULL DEFAULT 0,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- 7. Reportes (ejemplo simple)
-- -----------------------------------------------------
CREATE TABLE adoption_reports (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  month         INT  NOT NULL,                -- 1–12
  year          INT  NOT NULL,
  total_requests   INT NOT NULL DEFAULT 0,
  total_approved   INT NOT NULL DEFAULT 0,
  total_rejected   INT NOT NULL DEFAULT 0,
  UNIQUE KEY (month,year)
) ENGINE=InnoDB;
