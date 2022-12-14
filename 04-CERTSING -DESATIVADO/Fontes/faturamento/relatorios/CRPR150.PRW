#INCLUDE "totvs.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa ? CRPR150 ? Renato Ruy 		             ? Data ?  05/01/16   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Codigo gerado pelo AP6 IDE.                                ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP6 IDE                                                    ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function CRPR150


//?????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de Variaveis                                             ?
//???????????????????????????????????????????????????????????????????????

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat?rio de Controle da Biometria"
Local cPict          := ""
Local titulo       := "Relat?rio de Controle da Biometria"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "CRP150" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CRP150"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CRP150" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZ6"

Cabec1 := PadR("Descri??o AC"		,20," ")
Cabec1 += PadR("Descri??o CCR"		,50," ")
Cabec1 += PadR("Ped. Gar"			,10," ")
Cabec1 += PadR("Produto"			,30," ")
Cabec1 += PadR("Descri??o"			,50," ")
Cabec1 += PadR("Valor Pedido"		,17," ")
Cabec1 += PadR("Base Calculo"		,17," ")
Cabec1 += PadR("Valor Biometria"	,17," ")

dbSelectArea("SZ6")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//?????????????????????????????????????????????????????????????????????Ŀ
//? Monta a interface padrao com o usuario...                           ?
//???????????????????????????????????????????????????????????????????????

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//?????????????????????????????????????????????????????????????????????Ŀ
//? Processamento. RPTSTATUS monta janela com a regua de processamento. ?
//???????????????????????????????????????????????????????????????????????

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?RUNREPORT ? Autor ? AP6 IDE            ? Data ?  05/01/16   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ???
???          ? monta a janela com a regua de processamento.               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cLin	 := ""
Local cCodAc := ""
Local cHeader:= ""
Local nSubVal:= 0
Local nSubBas:= 0
Local nSubBio:= 0
Local nSubCon:= 0
Local nTotVal:= 0
Local nTotBas:= 0
Local nTotBio:= 0
Local nTotCon:= 0

Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif 

cHeader := "Descri??o AC;"
cHeader += "Descri??o CCR;"
cHeader += "Ped. Gar;"	
cHeader += "Produto;"	
cHeader += "Descri??o;"	
cHeader += "Valor Pedido;"
cHeader += "Base Calculo;"
cHeader += "Valor Biometria"
cHeader += cEOL

dbSelectArea(cString)
dbSetOrder(1)

//?????????????????????????????????????????????????????????????????????Ŀ
//? SETREGUA -> Indica quantos registros serao processados para a regua ?
//???????????????????????????????????????????????????????????????????????

SetRegua(RecCount())

//Fa?o a consulta para gerar o relat?rio.

If Select("QCRPRO150") > 0
	QCRPRO150->(DbCloseArea())
EndIf

BeginSql Alias "QCRPRO150"
		
	%NoParser%
	
	SELECT  Z6_CODENT CODENT,
			Z6_DESENT  DESAC,
	        SZ32.Z3_DESENT DESCCR,
	        Z6_PEDGAR PEDGAR,
	        Z6_PRODUTO PRODUTO, 
	        Z6_DESCRPR DESCRICAO, 
	        Z6_VLRPROD VALOR, 
	        Z6_BASECOM BASE, 
	        Z6_VLRPROD - Z6_BASECOM DIFER
	FROM %Table:SZ6% SZ6
	LEFT JOIN %Table:SZ3% SZ32 
	ON SZ32.Z3_FILIAL = ' ' AND SZ32.Z3_CODENT = Z6_CODCCR AND SZ32.%NOTDEL%
	WHERE
	Z6_FILIAL = ' ' AND
	Z6_PERIODO Between %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
	Z6_CODENT = %Exp:MV_PAR03% AND
	Z6_VALCOM > 0 AND
	Z6_CATPROD = '2' AND
	Z6_TPENTID IN ('2','5') AND
	SUBSTR(Z6_TIPED,1,9) = 'BIOMETRIA' AND
	SZ6.%NOTDEL%
	ORDER BY Z6_CODENT	
	
EndSql

QCRPRO150->(DbGoTop()) 

If Select("QCRPRO151") > 0
	QCRPRO151->(DbCloseArea())
EndIf

BeginSql Alias "QCRPRO151"
		
	%NoParser%
	
	SELECT  COUNT(*) CONTAR
	FROM %Table:SZ6% SZ6
	WHERE
	Z6_FILIAL = ' ' AND
	Z6_PERIODO Between %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
	Z6_CODENT = %Exp:MV_PAR03% AND
	Z6_CATPROD = '2' AND
	Z6_TPENTID IN ('2','5') AND
	SUBSTR(Z6_TIPED,1,9) = 'BIOMETRIA' AND
	SZ6.%NOTDEL%
	
EndSql

QCRPRO151->(DbGoTop())

//Seta a regua.
SetRegua(QCRPRO151->CONTAR)

//Armazena o caminho para grava??o.
cArq    := AllTrim(MV_PAR04) +"Rel_Biometria.csv"
nHdl    := fCreate(cArq)

cCodAc := QCRPRO150->DESAC

//Adiciono o cabe?alho para o relat?rio.
If nHdl != -1

	//Efetuo grava??o de dados do relat?rio em arquivo.
	fWrite(nHdl,cHeader)

EndIf

While !QCRPRO150->(EOF())

   //?????????????????????????????????????????????????????????????????????Ŀ
   //? Verifica o cancelamento pelo usuario...                             ?
   //???????????????????????????????????????????????????????????????????????

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //?????????????????????????????????????????????????????????????????????Ŀ
   //? Impressao do cabecalho do relatorio. . .                            ?
   //???????????????????????????????????????????????????????????????????????

   If nLin > 55 // Salto de P?gina. Neste caso o formulario tem 55 linhas...
      
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
   //Adiciono o cabe?alho para o relat?rio.
   If nHdl != -1 .And. cCodAc != QCRPRO150->DESAC
   		
   		//Atualizo AC
   		cCodAc := QCRPRO150->DESAC
   		
       //Gravo Subtotais
       cLin := "--;"
	   cLin += "Contagem dos Pedidos - "+ cCodAc +" --->;"
	   cLin += TRANSFORM( nSubCon , "@E 999,999,999.99") + ";"
	   cLin += "--;"
	   cLin += "--;"
	   cLin += TRANSFORM( nSubVal , "@E 999,999,999.99") + ";"
	   cLin += TRANSFORM( nSubBas , "@E 999,999,999.99") + ";"
	   cLin += TRANSFORM( nSubBio , "@E 999,999,999.99") 
       cLin += cEOL
       
		//Gravo SubTotal
		fWrite(nHdl,cLin)
		
		//Pulo uma linha e Gravo o cabe?alho novamente
		fWrite(nHdl," " + cEOL)
		fWrite(nHdl,cHeader)
		
		//Zero Subtotais
		nSubVal:= 0
		nSubBas:= 0
		nSubBio:= 0
		nSubCon:= 0
		
	EndIf
	
	//Gravo itens
	If QCRPRO150->VALOR != QCRPRO150->BASE 
	    cLin := PadR(QCRPRO150->DESAC	,20," ") + ";"
	    cLin += PadR(QCRPRO150->DESCCR	,50," ") + ";"
	    cLin += PadR(QCRPRO150->PEDGAR	,10," ") + ";"
	    cLin += PadR(QCRPRO150->PRODUTO	,30," ") + ";"
	    cLin += PadR(QCRPRO150->DESCRICAO,50," ") + ";"
	    cLin += PadR(TRANSFORM( QCRPRO150->VALOR, "@E 999,999,999.99")	,17," ") + ";"
	    cLin += PadR(TRANSFORM( QCRPRO150->BASE , "@E 999,999,999.99")	,17," ") + ";"
	    cLin += PadR(TRANSFORM( QCRPRO150->DIFER, "@E 999,999,999.99")	,17," ") + ";"
	    cLin += cEOL
	       
		//Gravo itens
		fWrite(nHdl,cLin)
		
		//Armazeno Subtotais e Totais
		nSubVal+= QCRPRO150->VALOR
		nSubBas+= QCRPRO150->BASE
		nSubBio+= QCRPRO150->DIFER
		nSubCon+= 1
		nTotVal+= QCRPRO150->VALOR
		nTotBas+= QCRPRO150->BASE
		nTotBio+= QCRPRO150->DIFER
		nTotCon+= 1 
	   
	   cLin := PadR(QCRPRO150->DESAC	,20," ")
	   cLin += PadR(QCRPRO150->DESCCR	,50," ")
	   cLin += PadR(QCRPRO150->PEDGAR	,10," ")
	   cLin += PadR(QCRPRO150->PRODUTO	,30," ")
	   cLin += PadR(QCRPRO150->DESCRICAO,50," ")
	   cLin += PadR(TRANSFORM( QCRPRO150->VALOR, "@E 999,999,999.99")	,17," ")
	   cLin += PadR(TRANSFORM( QCRPRO150->BASE , "@E 999,999,999.99")	,17," ")
	   cLin += PadR(TRANSFORM( QCRPRO150->DIFER, "@E 999,999,999.99")	,17," ")
	   
	   @nLin,00 PSAY cLin
	
	   nLin := nLin + 1 // Avanca a linha de impressao
   EndIf
   
   //Incrementa regua
   IncRegua()        
   
   QCRPRO150->(DbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

//Gravo Subtotais
cLin := "--;"
cLin += "Contagem dos Pedidos - "+ cCodAc +" --->;"
cLin += TRANSFORM( nSubCon , "@E 999,999,999.99") + ";"
cLin += "--;"
cLin += "--;"
cLin += TRANSFORM( nSubVal , "@E 999,999,999.99") + ";"
cLin += TRANSFORM( nSubBas , "@E 999,999,999.99") + ";"
cLin += TRANSFORM( nSubBio , "@E 999,999,999.99") 
cLin += cEOL

//Gravo SubTotal
fWrite(nHdl,cLin)

//Gravo totais
cLin := "--;"
cLin += "Contagem dos Pedidos --->;"
cLin += TRANSFORM( nTotCon , "@E 999,999,999.99") + ";"
cLin += "--;"
cLin += "--;"
cLin += TRANSFORM( nTotVal , "@E 999,999,999.99") + ";"
cLin += TRANSFORM( nTotBas , "@E 999,999,999.99") + ";"
cLin += TRANSFORM( nTotBio , "@E 999,999,999.99") 
cLin += cEOL 

//Gravo SubTotal
fWrite(nHdl,cLin)

//Fecho o arquivo anterior
fClose(nHdl)

//?????????????????????????????????????????????????????????????????????Ŀ
//? Finaliza a execucao do relatorio...                                 ?
//???????????????????????????????????????????????????????????????????????

SET DEVICE TO SCREEN

//?????????????????????????????????????????????????????????????????????Ŀ
//? Se impressao em disco, chama o gerenciador de impressao...          ?
//???????????????????????????????????????????????????????????????????????

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa ?LCRCO007 ?Autor  ?Renato Ruy Bernardo    ? Data ?  04/06/2013???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Fun??o Responsavel por criar as perguntas utilizadas no    ???
???          ? Relat?rio.                                                 ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? LOCAR                                                     ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Per?odo De ?"		   		,"Per?odo De ?"		   		,"Per?odo De ?"		   		,"mv_ch1" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Per?odo Ate?"		   		,"Per?odo Ate?"		   		,"Per?odo Ate?"		   		,"mv_ch2" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"AC ?"				   		,"AC ?"				   		,"AC ?"				   		,"mv_ch3" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,"SZ3"	    ,""         ,"S"        ,"mv_par03"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Pasta ?"		  			,"Pasta ?"	   		  		,"Pasta ?" 			  		,"mv_ch4" 	,"C" 		,75     		,0      		,0     		,"G"		,"U_CRPR150A",""	    ,""         ,"S"        ,"mv_par04"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?CTSA01   ?Autor  ?Microsiga           ? Data ?  01/05/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function CRPR150A()
Local cAux 	 := ""
Local cDirIn := ""

MV_PAR04 := IIF(!Empty(cAux:=(cGetFile("\", "Diret?rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

Return(.T.) 