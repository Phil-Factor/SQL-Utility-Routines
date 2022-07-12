declare @Ranking nvarchar(max)='{"number":[],
  "sentence":[" a ^sincere ^number","^number, which was ^sincere",
              "^number, which was ^sincere"],
  "sincere": ["carefully judged","much debated",
              "fairly discussed","well-considered","carefully chosen"]}'
Select  'The '+[language]+' vote for this song is '+
        dbo.SentenceFrom (json_modify(@ranking, 'strict  $.number', 
          json_query('["'+one+'","'+two+'","'+three+'","'+four+'","'+five+'"]')), 
        '$.sentence', 1)
from (values
    ('English','one','two','three','four','five'),
    ('Spanish','uno','dos','tres','cuatro','cinco'),
    ('French','un','deux','trois','quatre','cinq'),
    ('German','eins','zwei','drei','vier','fünf'),
    ('Roman','unus','duo','tres','quattuor','quinque')
)OneToFive([Language],one,two,three,four,five)