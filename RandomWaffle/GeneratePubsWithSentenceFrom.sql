DECLARE @JSONBarName NVARCHAR(MAX)='{
  "club":["The Red Lion","The Royal Oak","Red Lion","Royal Oak","The Crown Inn",
"The White Hart","The Crown","The Plough Inn","The New Inn","New Inn",
"Crown Inn","The Ship Inn","The Wheatsheaf","The White Horse","Kings Arms",
"ROYAL BRITISH LEGION","The Swan","The Plough","The Bell Inn", 
"The *** Golf Club","*** Bowling Club","The Royal *** Cricket Club","*** Conservative Club","*** RUGBY CLUB",
"The *** Rugby Football Club","The *** Town Football Club","*** Masonic Hall","The *** Football Club",
"North-East *** Social Club","The *** Bowls Club","*** Sailing Club ","The *** Sports Club","West *** Working Mens Club",
"*** Masonic Club","*** Arms","*** Club","*** Constitutional Club","North *** Yacht Club","*** Snooker Club",
"*** Town Cricket Club","East *** Lawn Tennis Club","*** Inn","The *** Rugby Union Football Club",
"*** Sports & Social Club","West Ward *** Labour Club","The *** Snooker Centre","*** United Football Club",
"*** Conservative Club Ltd"]
 }'
Select replace (dbo.SentenceFrom (@JSONBarName,'$.club',1),'***',town) as [Best Bar],
   town from (values
('Bristol'),('Hartlepool'),('Harlow'),('Cardiff'),('Hawick'),('Rugby'),('Billingham'),('Eastbourne
'),('Boston'),('Enfield'),('Herne Bay'),('Hereford'),('Coventry'),('Gateshead'),('Bedford'),('Wigan
'),('Brighton'),('Harrogate'),('Exeter'),('Scarborough'),('Southport'),('Lincoln'),('York'),('Darlington
'),('Leeds'),('Cheltenham'),('Ayr'),('Whitby'),('Durham')
)f(town)