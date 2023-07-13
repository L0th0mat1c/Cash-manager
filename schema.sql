CREATE TYPE user_type AS ENUM (
    'ADMIN',
    'USER');

CREATE TABLE IF NOT EXISTS users (
  id SERIAL,
  email varchar(80) NOT NULL CONSTRAINT email_unique UNIQUE,
  credentials varchar(250) NOT NULL,
  username varchar(50) NOT NULL CONSTRAINT username_unique UNIQUE,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  user_type user_type NOT NULL,
  is_verified BOOLEAN DEFAULT false,
  birthday TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tokens (
  id SERIAL,
  user_id INT NOT NULL,
  access_token varchar(400) NOT NULL,
  refresh_token varchar(400) NOT NULL,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS token_blocklist (
  id SERIAL,
  jti varchar(36) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (jti)
);

CREATE TABLE IF NOT EXISTS products (
  id serial,
  name varchar(70) NOT NULL,
  price numeric(5, 2) NOT NULL,
  origin varchar(50) NOT NULL,
  image_url varchar(250) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS carts (
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  deleted_at TIMESTAMP,
  PRIMARY KEY (user_id, product_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO users (email, username, first_name, last_name, credentials, user_type, is_verified)
VALUES
('jules.robineau@hotmail.fr', 'Drijux', 'Jules', 'Robineau', '$2a$16$LOrJmLbBsvN44gehCNEOPePsFi1SEQ/MlaJv/bR4rpIVHpf2RqNIO', 'ADMIN', true),
('client.clt@hotmail.fr', 'Client', 'Clt', 'Clt', '$2a$16$LOrJmLbBsvN44gehCNEOPePsFi1SEQ/MlaJv/bR4rpIVHpf2RqNIO', 'USER', true);


INSERT INTO products (name, price, origin, image_url)
VALUES
('promme', 3.99, 'france', 'https://www.senioractu.com/photo/art/default/7471863-11515915.jpg?v=1424077727'),
('poire', 2.99, 'france', 'https://tous-les-fruits.com/wp-content/uploads/2018/02/poire.jpg?ezimgfmt=ng%3Awebp%2Fngcb27%2Frs%3Adevice%2Frscb27-2'),
('banane', 4.99, 'france', 'https://www.aprifel.com/wp-content/uploads/2019/02/banane.jpg'),
('fruit du dragon', 7.99, 'france', 'https://produits.bienmanger.com/38126-0w600h600_Pitaya_Rouge.jpg'),
('mera mera no mi', 20.99, 'france', 'https://www.mugiwara-shop.com/wp-content/uploads/2018/04/Fruit-du-demon-1.jpg'),
('cerise', 5.99, 'france', 'https://www.aprifel.com/wp-content/uploads/2019/02/cerise.jpg'),
('fraise', 3.99, 'france', 'https://www.princedebretagne.com/sites/default/files/styles/540x350/public/2020-05/fraise-magnum.jpg?itok=scSCEO62');

INSERT INTO carts (user_id, product_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(2, 3);