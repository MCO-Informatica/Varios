User Function F240IND()

	LOCAL aIndTemp := { CriaTrab( , .F. ) }

	SE2->( dbOrderNickName('VALOR') )
	IndRegua( cAliasSE2, aIndTemp[1], SE2->( IndexKey() ), , , 'Indexando arquivo....' )

Return aIndTemp