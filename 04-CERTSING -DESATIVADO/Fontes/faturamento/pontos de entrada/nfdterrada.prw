#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFDTERRADA ºAutor  ³Rene Lopes          º Data ³  12/07/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa ajusta tabelas campo de data de emissão NFS       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                     

USER FUNCTION  NFDTERRADA() 

Local cArquivo
Local nOpca := 0
Local aRegs	:={}

Local aSays:={ }, aButtons:= { } 

cCadastro := OemToAnsi("Alterar emissão das notas fiscais erradas") 

Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"01","Serie da Nota            ?","","","mv_cha","C",003,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"02","Data de Emissão NF       ?","","","mv_chb","D",008,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"03","Numero da NF de		     ?","","","mv_chc","C",009,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"04","Numero da NF Até	     ?","","","mv_chd","C",009,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"05","Data Correta             ?","","","mv_che","D",008,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"06","Filial de		         ?","","","mv_chf","C",002,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","",""})
Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"07","Filial Até			     ?","","","mv_chg","C",002,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","",""})
Aadd(aRegs,{PADR("NFDTER",len(SX1->X1_GRUPO)),"08","Tipo da Nota  			 ?","","","mv_chh","N",001,0,1,"C",'',"mv_par08","Saída","Salida","Sell",'','',"Entrada","Entrada","Buy","","","","","","","","","","","","","","","","","","N" })  
ValidPerg(aRegs,PADR("NFDTER",len(SX1->X1_GRUPO))) 

                                                                                       
Pergunte(PADR("NFDTER",len(SX1->X1_GRUPO)),.F.)


AADD(aSays,OemToAnsi("Este programa ajusta da emissão da NF") )   
AADD(aButtons, { 5,.T.,{|| Pergunte(PADR("NFDTER",len(SX1->X1_GRUPO)),.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons ) 

IF nOpca == 1                                                           
  Processa({|lEnd| NFDTProcessa(),"Iniciado Ajuste"})
Endif

Static Function NFDTProcessa()
cDataCor := fConvData(mv_par05, "AAAAMMDD")
cAliasTrb := "TRC"

If MV_PAR08 == 1
BeginSql Alias cAliasTrb

SELECT F2.F2_FILIAL, F2.F2_DOC, F2.F2_EMISSAO, F2.F2_HORA,F2_SERIE, 'S' AS TIPO
FROM  
	%TABLE:SF2% F2
WHERE 
	F2.F2_FILIAL Between %exp:mv_par06% AND %exp:mv_par07% AND 
	F2.F2_SERIE = %exp:mv_par01% AND
	F2.F2_EMISSAO = %exp:mv_par02% AND
	F2.F2_DOC Between %exp:mv_par03% AND %exp:mv_par04% AND
	F2.%NOTDEL%
ENDSQL
Else
BeginSql Alias cAliasTrb

SELECT F1.F1_FILIAL, F1.F1_DOC, F1.F1_EMISSAO, F1.F1_HORA,F1_SERIE, 'E' AS TIPO
FROM  
	%TABLE:SF1% F1
WHERE 
	F1.F1_FILIAL Between %exp:mv_par06% AND %exp:mv_par07% AND 
	F1.F1_SERIE = %exp:mv_par01% AND
	F1.F1_EMISSAO = %exp:mv_par02% AND
	F1.F1_DOC Between %exp:mv_par03% AND %exp:mv_par04% AND
	F1.%NOTDEL%
ENDSQL
EndIf	
TRC->(DBGOTOP())

ProcRegua(RecCount())
IncProc("Alterando Data de Emissão")                                

While !TRC->(EOF())

If MV_PAR08 == 1
cFilial := TRC->F2_FILIAL
cNota 	:= TRC->F2_DOC 
cSerie 	:= TRC->F2_SERIE

cUpd:="UPDATE " +RetSQLName("SF2")+ " F2 "+Chr(13)+Chr(10)
cUpd+="SET								"+Chr(13)+Chr(10)
cUpd+="F2.F2_EMISSAO = '" +cDataCor+ "'"+Chr(13)+Chr(10)
cUpd+="WHERE							"+Chr(13)+Chr(10)
cUpd+="F2.F2_DOC = '" +cNota+ "' AND	"+Chr(13)+Chr(10)
cUpd+="F2.F2_SERIE = '" +cSerie+ "'	"+Chr(13)+Chr(10)

TCSQLEXEC(cUpd)	

cUpd:= " "

cUpd:="UPDATE" +RetSQLName("SD2")+ " D2		"+Chr(13)+Chr(10)
cUpd+="SET								"+Chr(13)+Chr(10)
cUpd+="D2.D2_EMISSAO = '" +cDataCor+ "' "+Chr(13)+Chr(10)
cUpd+="WHERE							"+Chr(13)+Chr(10)
cUpd+="	D2.D2_DOC   ='" +cNota+ "' AND	"+Chr(13)+Chr(10)
cUpd+="	D2.D2_SERIE ='" +cSerie+ "'		"+Chr(13)+Chr(10)
TCSQLEXEC(cUpd)

cUpd:= " " 

Else
cFilial := TRC->F1_FILIAL
cNota 	:= TRC->F1_DOC 
cSerie 	:= TRC->F1_SERIE

cUpd:="UPDATE " +RetSQLName("SF1")+ " F1 "+Chr(13)+Chr(10)
cUpd+="SET								"+Chr(13)+Chr(10)
cUpd+="F1.F1_EMISSAO = '" +cDataCor+ "'"+Chr(13)+Chr(10)
cUpd+="WHERE							"+Chr(13)+Chr(10)
cUpd+="F1.F1_DOC = '" +cNota+ "' AND	"+Chr(13)+Chr(10)
cUpd+="F1.F1_SERIE = '" +cSerie+ "'	"+Chr(13)+Chr(10)

TCSQLEXEC(cUpd)	

cUpd:= " "

cUpd:="UPDATE" +RetSQLName("SD1")+ " D1		"+Chr(13)+Chr(10)
cUpd+="SET								"+Chr(13)+Chr(10)
cUpd+="D1.D1_EMISSAO = '" +cDataCor+ "' "+Chr(13)+Chr(10)
cUpd+="WHERE							"+Chr(13)+Chr(10)
cUpd+="	D1.D1_DOC   ='" +cNota+ "' AND	"+Chr(13)+Chr(10)
cUpd+="	D1.D1_SERIE ='" +cSerie+ "'		"+Chr(13)+Chr(10)
TCSQLEXEC(cUpd)

cUpd:= " " 

EndIf
	         
cUpd:="UPDATE " +RetSQLName("SFT")+ " FT	"+Chr(13)+Chr(10)
cUpd+="SET	   							"+Chr(13)+Chr(10)
cUpd+="FT.FT_EMISSAO = '" +cDataCor+ "', FT_ENTRADA = '" +cDataCor+ "'"+Chr(13)+Chr(10)
cUpd+="WHERE								"+Chr(13)+Chr(10)
cUpd+="FT.FT_FILIAL  = '" +cFilial+ "' AND	"+Chr(13)+Chr(10)
cUpd+="FT.FT_NFISCAL = '" +cNota+ "' AND	"+Chr(13)+Chr(10)
cUpd+="FT.FT_SERIE 	 = '" +cSerie+ "'			"+Chr(13)+Chr(10)
TCSQLEXEC(cUpd)

cUpd:= " "

cUpd:="UPDATE " +RetSQLName("SF3")+ " SF3 		"+Chr(13)+Chr(10)
cUpd+="SET 	 								"+Chr(13)+Chr(10)
cUpd+="SF3.F3_ENTRADA = '" +cDataCor+ "', SF3.F3_EMISSAO = '" +cDataCor+ "'	"+Chr(13)+Chr(10)
cUpd+="WHERE   								"+Chr(13)+Chr(10)
cUpd+="SF3.F3_NFISCAL = '" +cNota+ "' AND	"+Chr(13)+Chr(10)
cUpd+="SF3.F3_SERIE = '" +cSerie+ "'   		"+Chr(13)+Chr(10)

TCSQLEXEC(cUpd)

cUpd:= " "

TRC->(dbSkip()) 			
			
Enddo
TRC->(DbCloseArea())
ALERT("Processo finalizado")

Static Function fConvData( dData, cTipo )

Local uRet
Local i, cTmp
Local nPosDia, nPosMes, nPosAno
Local nTamDia, nTamMes, nTamAno
Local cDia, cMes, cAno
//Local lBarra, cBarra

cTipo  := Upper(cTipo)
//lBarra := "/" $ cTipo

nPosDia := At( "D", cTipo )
nPosMes := At( "M", cTipo )
nPosAno := At( "A", cTipo )

nTamDia := 0 ; nTamMes := 0 ; nTamAno := 0

// Verifica Quantidade de Digitos para os Itens da Data
For i := 1 To Len(cTipo)
	If SubStr(cTipo,i,1) == "D"
		nTamDia++
	ElseIf SubStr(cTipo,i,1) == "M"
		nTamMes++
	ElseIf SubStr(cTipo,i,1) == "A"
		nTamAno++
	EndIf
Next

cDia := StrZero( Day( dData ),nTamDia )
cMes := StrZero( Month( dData ),nTamMes )
cAno := StrZero( Year( dData ),4 )
cAno := Right(cAno,nTamAno )

//cBarra := If(lBarra,"/","")

//cTmp := Space( nTamDia ) + cBarra + Space( nTamMes ) + cBarra + Space( nTamAno )
cTmp := cTipo

If nPosDia > 0
	cTmp := Stuff( cTmp,nPosDia,nTamDia,cDia )
EndIf
If nPosMes > 0
	cTmp := Stuff( cTmp,nPosMes,nTamMes,cMes )
EndIf
If nPosAno > 0
	cTmp := Stuff( cTmp,nPosAno,nTamAno,cAno )
EndIf

uRet := cTmp

Return( uRet ) 


Return()