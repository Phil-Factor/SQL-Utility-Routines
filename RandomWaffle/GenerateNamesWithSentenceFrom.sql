DROP TABLE IF EXISTS #TableWithExistingData --in case we rerun
CREATE TABLE #TableWithExistingData (Prefix NVARCHAR(40) NOT NULL, FullName NVARCHAR(255))
INSERT INTO #TableWithExistingData (Prefix) --insert sample prefixes into our table
  VALUES ('Mr'),('Mrs'),('Ms'),('Dr'),('Dr'),('Sir'),('Lady'),('Mr'),
    ('Miss'),('Professor'),('Captain'),('Bishop'),('Mr'),('Mrs'),('Ms')
--now we create a variable for our JSON
DECLARE @JSONNameData NVARCHAR(MAX)='{
  "malename":[
      "^malefirstname ^lastname ^suffix",
      "^malefirstname ^lastname",
      "^malefirstname ^lastname"
   ],
  "femalename":[
      "^femalefirstname ^lastname ^suffix",
      "^femalefirstname ^lastname",
      "^femalefirstname ^lastname"
   ],
  "name":["^malename","^femalename"],
  "malefirstname":["Noah","Oliver","William","Elijah","James","Benjamin",
   "Lucas,","Mason","Ethan","Alexander","Henry","Jacob","Michael","Daniel",
   "Logan","Jackson","Sebastian","Jack","Aiden"
   ],
  "femalefirstname":["Olivia","Emma","Ava","Sophia","Isabella","Charlotte",
   "Amelia","Mia","Harper","Evelyn","Abigail","Emily","Ella","Elizabeth",
   "Camila","Luna","Sofia","Avery","Mila","Aria","Scarlett","Penelope",
   "Layla","Chloe","Victoria","Madison","Eleanor","Grace","Nora","Riley"
   ],
  "lastname":["Smith","Johnson","Patel","Williams","Brown","Jones","Garcia",
   "Miller","Davis","Rodriguez","Martinez","Hernandez","Lopez","Gonzalez",
   "Wilson","Anderson","Li","Thomas","Taylor","Moore","Jackson","Martin","Lee",
   "Perez","Thompson","White","Wong","Harris","Sanchez","Clark","Ramirez","Lewis",
   "Robinson","Walker","Young","Allen","King","Wright","Scott","Torres",
   "Nguyen","Hill","Flores","Green" ],
   "suffix":[
      "3rd","MA","BSc","","","","",""
   ]
}'
/* now we can add the fullnames with random gender-appropriate names */UPDATE #TableWithExistingData 
SET FullName= dbo.SentenceFrom (@JSONNameData,'$.'
  +CASE WHEN Prefix IN ('Ms','Mrs','Lady','Miss')
          THEN 'femalename' 
        WHEN Prefix IN ('Mr','Sir') 
          THEN 'malename' 
        ELSE 'name' END,5)
  FROM #TableWithExistingData  
SELECT * FROM #TableWithExistingData