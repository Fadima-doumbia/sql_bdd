-- Exercices :
-- 1.Afficher les 10 premiers éléments de la table Produit triés par leur prix unitaire 
SELECT * FROM `produit` 
ORDER BY prixUnit DESC 
limit 10;

-- 2.Afficher les trois produits les plus chers

SELECT * FROM `produit` ORDER BY prixUnit DESC limit 3

-- I.2- Restriction
-- Exercices :
-- 1.Lister les clients français installés à Paris dont le numéro de fax n'est pas 
-- renseigné
SELECT * FROM client WHERE Ville = 'Paris' AND Fax = 'NULL'
SELECT * FROM client WHERE Ville = 'Paris' AND Fax IS NULL
-- 2.Lister les clients français, allemands et canadiens
SELECT * FROM client WHERE Pays IN ('France','Germany','Canada')

-- 3.Lister les clients dont le nom de société contient "restaurant"
SELECT * FROM client WHERE Societe LIKE '%restaurant%'
select * from clientt where  instr(Societe, 'restaurant')!=0;


-- I.3- Projection
-- Exercices :
-- 1.Lister les descriptions des catégories de produits (table Categorie)
SELECT Disting  description, nomCateg FROM `categorie` 
INNER join produit on categorie.`codeCateg` = produit.codeCateg
-- 2.Lister les différents pays et villes des clients, le tout trié par ordre alphabétique 
-- croissant du pays et décroissant de la ville
SELECT DISTINCT pays, ville  FROM `client`
ORDER BY pays, ville DESC

-- 3.Lister les fournisseurs français, en affichant uniquement le nom, le contact et la 
-- ville, triés par ville

SELECT `ville`,`contact`, `societe`
FROM `fournisseur`
ORDER BY ville 
-- a corriger en haut
-- 4.Lister les produits (nom en majuscule et référence) du fournisseur n° 8 dont le prix
-- unitaire est entre 10 et 100 euros, en renommant les attributs pour que ça soit 
-- explicite
SELECT `refProd` AS REFERENCE , `nomProd` AS NOM
FROM `produit` 
WHERE `noFour` = 8 AND `prixUnit` 
between 10 AND  100


-- II- Calculs et Fonctions :
-- II.1- Calculs arithmétiques
-- Exercices :
-- La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande.
-- Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci, le
-- montant de la ligne d'achat en incluant la remise (stockée en proportion dans la table).
-- Afficher donc (dans une même requête) :
-- - le prix unitaire, 
-- - la remise, 
-- - la quantité, 
-- - le montant de la remise, 
-- - le montant à payer pour ce produit

SELECT *, 
    (`prixUnit` * `remise`) AS remiseUnitaire, 
    ((`prixUnit` * `remise`)*`qte`) AS remiseTotale,
    (`prixUnit`*`qte`) as totaAchat ,
    ((`prixUnit`*`qte`)-((`prixUnit` * `remise`)*`qte`)) AS sommeAPayer 
FROM `detailcommande` 
WHERE `noCom` =10251

-- II.2- Traitement conditionnel
-- Exercices :
-- 1.A partir de la table Produit, afficher "Produit non disponible" lorsque 
-- l'attribut Indisponible vaut 1, et "Produit disponible" sinon.
-- II.3- Fonctions sur chaînes de caractères

SELECT  *,
CASE 
    WHEN `indisponible` = 1 THEN 'Disponible'
    ELSE 'indisponible'
END AS disponibilité
FROM `produit`


-- Exercices :
-- Dans une même requête, sur la table Client :
-- * Concaténer les champs Adresse, Ville, CodePostal et Pays dans un nouveau 
-- champ nommé Adresse_complète, pour avoir : Adresse, CodePostal, Ville, Pays
-- * Extraire les deux derniers caractères des codes clients
-- * Mettre en minuscule le nom des sociétés
-- * Remplacer le terme "Owner" par "Freelance" dans Fonction
-- * Indiquer la présence du terme "Manager" dans Fonction
-- correct

SELECT `codeCli`, 
REPLACE(`fonction`, 'Owner', 'Freelance'), 
LOWER(`societe`),
CONCAT(adresse, " ", ville," ",codePostal," ",pays) AS adresseAuComplet, 
RIGHT(`codeCli`, 2) AS extrait
FROM `client`
WHERE `fonction` Like '%Manager%'


-- II.4- Fonctions sur les dates
-- Exercices :
-- 1.Afficher le jour de la semaine en lettre pour toutes les dates de commande, 
-- afficher "week-end" pour les samedi et dimanche, 
SELECT NoCom, DateCom,
 CASE
      WHEN DATE_FORMAT(DateCom, "%W") IN ('Saturday', 'Sunday') THEN 'week-end'
      ELSE DATE_FORMAT(DateCom, "%W")
    END
    AS 'jour_commande'

FROM Commande;

SELECT *,
CASE
WHEN DATE_FORMAT(DateCom, '%W') = 'Sunday' THEN 'week-end'
WHEN DATE_FORMAT(DateCom, '%W') = 'Saturday' THEN 'week-end'
ELSE DATE_FORMAT(DateCom, '%W')
END
FROM commande ;

-- 2.Calculer le nombre de jours entre la date de la commande (DateCom) et la date 
-- butoir de livraison (ALivAvant), pour chaque commande, On souhaite aussi 
-- contacter les clients 1 mois après leur commande. ajouter la date correspondante 
-- pour chaque commande
SELECT `noCom`,
`aLivAvant`,
`dateCom`,
DATEDIFF(  `aLivAvant`, `dateCom`) AS nbrJours,
DATE_ADD(dateCom, INTERVAL 1 MONTH) AS dateAVenir
FROM commande 

-- III- Aggrégats
-- III.1- Dénombrements
-- Exercices :
-- 1.Calculer le nombre d'employés qui sont "Sales Manager"
SELECT  COUNT(`fonction`) AS nbEmploye FROM `employe` 
WHERE `fonction`="Sales Manager" 

-- 2.Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18
SELECT COUNT(*) as "nbr de produit"  
FROM `produit` 
WHERE `codeCateg`codeCateg = 1 and noFour in (1, 18)
-- correct

-- 3.Calculer le nombre de pays différents de livraison
SELECT COUNT(DISTINCT PaysLiv) 
FROM Commande
-- correct

-- 4.Calculer le nombre de commandes réalisées le en Aout 2006.
SELECT COUNT(`noCom`) 
FROM `commande`
WHERE `dateCom` LIKE '%06-08%'




-- III.2- Calculs statistiques simples

-- Exercices
-- 1.Calculer le coût du port minimum et maximum des commandes , ainsi que le coût
-- moyen du port pour les commandes du client dont le code est "QUICK"
-- (attribut CodeCli)

SELECT `codeCli`, 
    MAX(`port`) AS "Port maximum", 
    MIN(`port`) AS "Port minimum", 
    AVG(port) AS "Port moyenne"
FROM `commande`
WHERE `codeCli` = "QUICK"

-- 2.Pour chaque messager (par leur numéro : 1, 2 et 3), donner le montant total des 
-- frais de port leur correspondant

-- SELECT `noMess`, COUNT(`noMess`), COUNT(`port`) 
-- FROM `commande`
-- GROUP BY `noMess`

SELECT SUM(Port)
    FROM Commande
    WHERE NoMess = 1;
SELECT SUM(Port)
    FROM Commande
    WHERE NoMess = 2; 
SELECT SUM(Port)
    FROM Commande
    WHERE NoMess = 3;

-- III.3- Agrégats selon attribut(s)
-- Exercices
-- 1.Donner le nombre d'employés par fonction
SELECT `fonction`, COUNT(`fonction`) as "nombre employe" 
FROM `employe`
GROUP BY `fonction`

-- 2.Donner le nombre de catégories de produits fournis par chaque fournisseur

SELECT NoFour AS "num Frs",
        COUNT(`codeCateg`) AS "Produit Fournis"  ,
        COUNT(DISTINCT CodeCateg) AS "Nbr Categories"
    FROM Produit
    GROUP BY NoFour

-- 3.Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie 
-- de produits fournis par celui-ci
SELECT `noFour`,`codeCateg`, AVG(`prixUnit`) AS PrixMoyen
FROM produit
GROUP By `noFour`, `codeCateg`



-- III.4- Restriction sur agrégats
-- Exercices
-- 1.Lister les fournisseurs ne fournissant qu'un seul produit
SELECT `noFour`, COUNT( DISTINCT `nomProd`) as "Total Produit"
FROM `Produit` 
GROUP BY `noFour`
HAVING COUNT(`refProd`) = 1

-- 2.Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
SELECT `noFour`,`codeCateg`, COUNT( DISTINCT `refProd`) as "TotalProduit"
FROM `Produit` 
GROUP BY `noFour`
HAVING TotalProduit = 1
-- correct

-- 3.Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro
SELECT NoFour, RefProd, NomProd, PrixUnit
FROM Produit
WHERE PrixUnit > 50
GROUP BY NoFour, refProd
HAVING PrixUnit = MAX(PrixUnit)
-- correct


-- IV- Jointures :
-- IV.1- Jointures naturelles
-- Exercices
-- 1.Récupérer les informations des fournisseurs pour chaque produit

SELECT *
FROM Produit NATURAL JOIN Fournisseur;

-- 2.Afficher les informations des commandes du client "Lazy K Kountry Store"
SELECT *
FROM Client NATURAL JOIN Commande
WHERE Societe = "Lazy K Kountry Store";

-- 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom)
SELECT NomMess, COUNT(*) as "Nb Commandes"
FROM Messager NATURAL JOIN Commande
GROUP BY NomMess;
-- correct
-- IV.2- Jointures internes
-- Exercices
-- 1.Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
SELECT * 
FROM `produit`
INNER JOIN fournisseur ON produit.noFour = fournisseur.noFour

-- 2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec une jointure interne
SELECT * FROM `commande` 
INNER join client on commande.`codeCli` =  client.codeCli
WHERE client.societe = "Lazy K Kountry Store"

-- 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec une jointure interne
SELECT COUNT(`noCom`) AS "nbr commande", messager.noMess AS "num message", messager.nomMess AS "contenu" FROM Commande 
INNER JOIN Messager ON Commande.NoMess = Messager.NoMess
GROUP BY NomMess
-- correct

-- IV.3- Jointures externes
-- Exercices
-- 1.Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
SELECT `nomProd`, COUNT(DISTINCT detailcommande.noCom)
FROM Produit 
LEFT OUTER JOIN detailcommande ON Produit.refProd = detailcommande.refProd
GROUP BY `nomProd`

-- 2.Lister les produits n'apparaissant dans aucune commande


-- 3.Existe-t'il un employé n'ayant enregistré aucune commande ?
SELECT E.Nom
FROM employe E 
LEFT OUTER JOIN commande C 
ON E.NoEmp = C.NoEmp
WHERE C.NoCom is NULL;

-- IV.4- Jointures à la main
-- Exercices
-- 1.Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
SELECT fournisseur.NoFour, fournisseur.Societe, produit.NomProd
    FROM fournisseur, produit
    WHERE fournisseur.NoFour = produit.NoFour

-- 2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main


-- 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main


-- V- Sous-requêtes
-- V.1- Sous-requêtes
-- Exercices
-- 1.Lister les employés n'ayant jamais effectué une commande, via une sous-requête
SELECT employe.NoEmp, employe.Nom, employe.Prenom
    FROM employe
    WHERE employe.NoEmp NOT IN (SELECT commande.NoEmp FROM commande)

-- 2.Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête


-- 3.Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
SELECT COUNT(commande.NoCom) AS NbCom
    FROM commande
    WHERE commande.NoEmp 
    IN 
    (SELECT employe.NoEmp 
    FROM employe WHERE employe.RendCompteA 
    = 
    (SELECT employe.NoEmp 
    FROM employe 
    WHERE employe.Nom = "Buchanan" 
    AND employe.Prenom = "Steven"))

-- V.2- Opérateur EXISTS
-- Exercices
-- 1.Lister les produits n'ayant jamais été commandés, à l'aide de l'opérateur EXISTS

SELECT produit.RefProd, produit.NomProd
    FROM produit
    WHERE NOT EXISTS (
        SELECT detailscommande.RefProd 
        FROM detailscommande 
        WHERE produit.RefProd = detailscommande.RefProd
    )
-- 2.Lister les fournisseurs dont au moins un produit a été livré en France
SELECT fournisseur.Societe
    FROM fournisseur
    WHERE EXISTS 
        (SELECT * FROM produit, categorie WHERE produit.NoFour = fournisseur.NoFour AND             produit.CodeCateg = categorie.CodeCateg AND categorie.NomCateg = "drinks")
    AND NOT EXISTS 
        (SELECT * FROM produit, categorie WHERE produit.NoFour = fournisseur.NoFour AND             produit.CodeCateg = categorie.CodeCateg AND categorie.NomCateg <> "drinks")

-- 3.Liste des fournisseurs qui ne proposent que des boissons (drinks)
SELECT fournisseur.Societe
    FROM fournisseur
    WHERE EXISTS 
        (SELECT * FROM produit, categorie 
        WHERE produit.NoFour = fournisseur.NoFour 
        AND   produit.CodeCateg = categorie.CodeCateg 
        AND categorie.NomCateg = "drinks")
    AND NOT EXISTS 
        (SELECT * FROM produit, categorie 
        WHERE produit.NoFour = fournisseur.NoFour 
        AND produit.CodeCateg = categorie.CodeCateg 
        AND categorie.NomCateg <> "drinks")
        -- correct
-- VI- Opérations Ensemblistes
-- VI.1- Union
-- Exercices
-- En utilisant la clause UNION :
-- 1.Lister les employés (nom et prénom) étant "Representative" ou étant basé au Royaume-Uni (UK)
SELECT Nom, Prenom
    FROM Employe
    WHERE Fonction = "Représentant(e)"
UNION  
SELECT Nom, Prenom
    FROM Employe
    WHERE Pays = "UK"
-- corrige
-- 2.Lister les clients (société et pays) ayant commandés via un employé situé à 
-- Londres ("London" pour rappel) ou ayant été livré par "Speedy Express"
SELECT Societe, Cl.Pays
    FROM Client Cl, Commande Co, Employe E
    WHERE Cl.CodeCli = Co.CodeCli
    AND Co.NoEmp = E.NoEmp
    AND E.Ville = "London"
UNION
SELECT Societe, Cl.Pays
    FROM Client Cl, Commande Co, Messager M
    WHERE Cl.CodeCli = Co.CodeCli
    AND Co.NoMess = M.NoMess
    AND NomMess = "Speedy Express"

-- VI.2- Intersection
-- Exercices
-- 1.Lister les employés (nom et prénom) étant "Representative" et étant basé au Royaume-Uni (UK)
SELECT Nom, Prenom
    FROM Employe
    WHERE Fonction lIKE  "%Representative%"
    INTERSECT 
SELECT Nom, Prenom
    FROM Employe
    WHERE Pays = "UK";

-- 2.Lister les clients (société et pays) ayant commandés via un employé basé 
-- à "Seattle" et ayant commandé des "Desserts"
SELECT Societe, Cl.Pays
    FROM Client Cl, Commande Co, Employe E
    WHERE Cl.CodeCli = Co.CodeCli
    AND Co.NoEmp = E.NoEmp
    AND E.Ville = "Seattle"
INTERSECT
SELECT Societe, Cl.Pays
    FROM Client Cl, Commande Co, DetailCommande DC,
         Produit P, Categorie Ca
    WHERE Cl.CodeCli = Co.CodeCli
    AND Co.NoCom = DC.NoCom
    AND DC.RefProd = P.RefProd
    AND P.CodeCateg = Ca.CodeCateg
    AND NomCateg = "Desserts";

-- VI.3- Différence
-- Exercices
-- 1.Lister les employés (nom et prénom) étant "Representative" mais n'étant pas basé au Royaume-Uni (UK)
SELECT Nom, Prenom
    FROM Employe
    WHERE Fonction = "Représentant(e)"
EXCEPT
SELECT Nom, Prenom
    FROM Employe
    WHERE Pays = "Royaume-Uni";

-- 2.Lister les clients (société et pays) ayant commandés via un employé situé à 
-- Londres ("London" pour rappel) et n'ayant jamais été livré par "United Package

SELECT Societe, Cl.Pays
    FROM Client Cl, Commande Co, Employe E
    WHERE Cl.CodeCli = Co.CodeCli
    AND Co.NoEmp = E.NoEmp
    AND E.Ville = "London"
EXCEPT
SELECT Societe, Cl.Pays
    FROM Client Cl, Commande Co, Messager M
    WHERE Cl.CodeCli = Co.CodeCli
    AND Co.NoMess = M.NoMess
    AND NomMess = "United Package";



