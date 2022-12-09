#INCLUDE "rwmake.ch"                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFDTERRADA ºAutor  ³Rene Lopes          º Data ³  24/10/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta nota de serviço que deveria ser produto     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP10                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                     

USER FUNCTION  AjustSerieNF() 

Local cArquivo
Local nOpca := 0
Local aRegs	:={}
Local cCliente 
Local cNota
Local cSerie

/*Local aSays:={ }, aButtons:= { } 

cCadastro := OemToAnsi("Alterar emissão das notas fiscais erradas") 

Aadd(aRegs,{"NFDTER","01","Serie da Nota           	?","","","mv_cha","C",003,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"NFDTER","02","Numero da NF De     ?","","","mv_chc","C",009,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"NFDTER","03","Numero da NF Ate     ?","","","mv_chc","C",009,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"NFDTER","04","Data Correta             ?","","","mv_chd","D",008,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"NFDTER","05","Entrada/Saída           ?","","","mv_chA","N",01,00,01,"C","","mv_pa05","Saída","Saída","Saída","","Entrada","Entrada","Entrada","Entrada","","","","","","",""})


ValidPerg(aRegs,"NFDTER") 

 
Pergunte("NFDTER",.F.)


AADD(aSays,OemToAnsi("Este programa ajusta da emissão da NF") )   
AADD(aButtons, { 5,.T.,{|| Pergunte("NFDTER",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons ) 

IF nOpca == 1                                                           
  Processa({|lEnd| NFDTProcessa(),"Iniciado Ajuste"})
Endif
                                    
Static Function NFDTProcessa()
*/

//cDataCor := fConvData(mv_par04, "AAAAMMDD")
cAliasTrb := "TRC"     


BeginSql Alias cAliasTrb

		SELECT F3_NFISCAL AS NOTA, F3_SERIE AS SERIE, F3_CLIEFOR AS CLIENTE
		FROM %TABLE:SF3% INNER JOIN %TABLE:SFT% ON F3_NFISCAL = FT_NFISCAL AND F3_SERIE = FT_SERIE AND  F3_CLIEFOR = FT_CLIEFOR 
		WHERE 
		F3_EMISSAO >= '20121101' AND
		F3_SERIE = 'RP2' AND
		FT_PRODUTO LIKE ('MR%') AND
		SF3010.D_E_L_E_T_ = ' ' AND
		SFT010.D_E_L_E_T_ = ' '
ENDSQL	

TRC->(DBGOTOP())
ProcRegua(RecCount())
IncProc("Alterando LIVRO")                                

While !TRC->(EOF())

	cNota 	 := Alltrim(TRC->NOTA)
	cSerie 	 := Alltrim(TRC->SERIE)
	cCliente := Alltrim(TRC->CLIENTE) 
	        
cUpd:="UPDATE  							"+Chr(13)+Chr(10)
cUpd+="" +RetSQLName("SFT")+ "			"+Chr(13)+Chr(10)
cUpd+="SET								"+Chr(13)+Chr(10)
cUpd+="FT_PRODUTO = 'CC010001', 		"+Chr(13)+Chr(10)   
cUpd+="FT_TIPO = 'S' ,					"+Chr(13)+Chr(10)
cUpd+="FT_CODISS = '02798' 					"+Chr(13)+Chr(10)
cUpd+="WHERE							"+Chr(13)+Chr(10)
cUpd+="FT_NFISCAL = '"+cNota+"' AND		"+Chr(13)+Chr(10)
cUpd+="FT_SERIE = '"+cSerie+"'	AND 	"+Chr(13)+Chr(10)
cUpd+="FT_CLIEFOR = '"+cCliente+"' 		"+Chr(13)+Chr(10)

TCSQLEXEC(cUpd)
SFT->(dbCommitAll())


cUpd:= " "

cUpd:="UPDATE  								"+Chr(13)+Chr(10)
cUpd+="" +RetSQLName("SF3")+ "				"+Chr(13)+Chr(10)
cUpd+="SET 	 								"+Chr(13)+Chr(10)
cUpd+="F3_CODISS = '02798'					, 	"+Chr(13)+Chr(10)
cUpd+="F3_TIPO = 'S'    					"+Chr(13)+Chr(10)
cUpd+="WHERE   								"+Chr(13)+Chr(10)
cUpd+="F3_NFISCAL = '" +cNota+ "' AND		"+Chr(13)+Chr(10)
cUpd+="F3_SERIE = '" +cSerie+ "'  AND		"+Chr(13)+Chr(10)
cUpd+="F3_CLIEFOR = '"+cCliente+"' 			"+Chr(13)+Chr(10)

TCSQLEXEC(cUpd)
SF3->(dbCommitAll())

cUpd:= " " 

	
	cUpd:="UPDATE							"+Chr(13)+Chr(10)
	cUpd+="" +RetSQLName("SD2")+ " 			"+Chr(13)+Chr(10)
	cUpd+="SET								"+Chr(13)+Chr(10)	
	cUpd+="D2_COD ='CC010001'				"+Chr(13)+Chr(10)
	cUpd+="WHERE							"+Chr(13)+Chr(10)
	cUpd+="	D2_DOC   ='" +cNota+ "' AND		"+Chr(13)+Chr(10)
	cUpd+="	D2_SERIE ='" +cSerie+ "'AND		"+Chr(13)+Chr(10)                                 
    cUpd+=" D2_CLIENTE = '"+cCliente+"' 	"+Chr(13)+Chr(10)
    
	TCSQLEXEC(cUpd)
	SD2->(dbCommitAll())
	TRC->(DbSkip())   
Enddo

TRC->(dbCommit())
TRC->(DbCloseArea())
ALERT("Processo finalizado")

Return()


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