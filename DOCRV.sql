CREATE DATABASE gestion_rdv;


USE gestion_rdv;


CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_utilisateur VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telephone VARCHAR(20) NOT NULL
);

CREATE TABLE rendez_vous (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT,
    date DATE NOT NULL,
    heure TIME NOT NULL,
    motif TEXT NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateurs(id) ON DELETE CASCADE
);
