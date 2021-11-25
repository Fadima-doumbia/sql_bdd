Drop database if EXISTS foody; 
CREATE DATABASE foody;

drop table if exists categorie;
drop table if exists client;
drop table if exists messager;
drop table if exists fournisseur;
drop table if exists employe;
drop table if exists produit;
drop table if exists Detailcommande;
drop table if exists commande;

CREATE TABLE categorie (
    codeCateg INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nomCateg VARCHAR(25) NOT NULL,
    description VARCHAR(210)
);

CREATE TABLE client (
    codeCli VARCHAR(5) PRIMARY KEY NOT NULL,
    societe VARCHAR(45) NOT NULL,
    contact VARCHAR(45) NOT NULL,
    fonction VARCHAR(45) NOT NULL,
    adresse VARCHAR(45),
    ville VARCHAR(25),
    region VARCHAR (25),
    codePostal VARCHAR (10),
    pays VARCHAR (25),
    tel VARCHAR (25),
    fax VARCHAR (25)
    );


CREATE TABLE messager (
    noMess INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nomMess VARCHAR(50) NOT NULL,
    tel VARCHAR(20)
);


CREATE TABLE fournisseur (
    noFour INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    societe VARCHAR(45) NOT NULL,
    contact VARCHAR(45) ,
    fonction VARCHAR(45) ,
    adresse VARCHAR(255) ,
    ville VARCHAR(45),
    region VARCHAR(45),
    codePostal VARCHAR(10) ,
    pays VARCHAR(45) ,
    tel VARCHAR(20) ,
    fax VARCHAR(20)
);

CREATE TABLE employe (
    noEmp INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    fonction VARCHAR(50) ,
    titreCourtoisie VARCHAR(50),
    dateNaissance DATETIME,
    dateEmbauche DATETIME ,
    adresse VARCHAR(60),
    ville VARCHAR(50),
    region VARCHAR(50),
    codepostal VARCHAR(50) ,
    pays VARCHAR(50) ,
    telDom VARCHAR(20) ,
    extension VARCHAR(50),
    rendCompteA INT ,
    CONSTRAINT FOREIGN KEY (rendCompteA) REFERENCES employe (noEmp)
);


CREATE TABLE produit (
    refProd INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nomProd VARCHAR(50) NOT NULL,
    noFour INT ,
    codeCateg INT,
    qteParUnit VARCHAR(20) ,
    prixUnit DECIMAL(10,4) default 0,
    unitesStock SMALLINT DEFAULT 0,
    unitesCom SMALLINT DEFAULT 0,
    niveauReap SMALLINT DEFAULT 0,
    indisponible BIT NOT NULL default 0,
  CONSTRAINT FOREIGN KEY (CodeCateg) REFERENCES categorie (CodeCateg),
  CONSTRAINT FOREIGN KEY (noFour) REFERENCES fournisseur (noFour)
);

CREATE TABLE Detailcommande (
    noCom INT NOT NULL,
    refProd INT NOT NULL,
    prixUnit DECIMAL(10,4) NOT NULL DEFAULT 0,
    qte INT NOT NULL DEFAULT 1,
    remise Double NOT NULL DEFAULT 0,
    CONSTRAINT PRIMARY KEY (noCom , refProd),
    CONSTRAINT FOREIGN KEY (refProd) REFERENCES produit (refProd)
);

CREATE TABLE commande (
    noCom INT PRIMARY key NOT NULL AUTO_INCREMENT,
    codeCli VARCHAR(10),
    noEmp INT,
    dateCom DATETIME ,
    aLivAvant DATETIME,
    dateEnv DATETIME,
    noMess INT ,
    port DECIMAL(10,4) DEFAULT 0,
    destinataire VARCHAR(50) ,
    adrLiv VARCHAR(50) ,
    villeLiv VARCHAR(50) ,
    regionLiv VARCHAR(50),
    codePostalLiv VARCHAR(20),
    paysLiv VARCHAR(25),
    CONSTRAINT FOREIGN KEY (noEmp) REFERENCES employe (noEmp),
    CONSTRAINT FOREIGN KEY (codeCli) REFERENCES client (codeCli),
    CONSTRAINT FOREIGN KEY (noMess) REFERENCES messager (noMess)
);

-- ALTER TABLE commande
-- ADD FOREIGN KEY (codeCli) REFERENCES client (codeCli);

-- CREATE INDEX `dateCom` ON `commande` (`dateCom`);
-- CREATE INDEX `dateEnv` ON `commande` (`dateEnv`);
-- CREATE INDEX `codePostalLiv` ON `commande` (`codePostalLiv`);

-- chemin de mon dossier 
-- C:\Users\Fadima\3D Objects\CDA_Alternance\back-end\sql\exo1\data\data 
-- commande a rentrer dans l'invite de commande
LOAD DATA LOCAL INFILE 'C:/Users/Fadima/3D Objects/CDA_Alternance/back-end/sql/exo1/data/data/fournisseur.csv' INTO TABLE fournisseur FIELDS TERMINATED BY "," LINES TERMINATED BY "\n" IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/Fadima/3D Objects/CDA_Alternance/back-end/sql/exo1/data/data/client.csv' INTO TABLE client FIELDS TERMINATED BY "," LINES TERMINATED BY "\n" IGNORE 1 LINES;









