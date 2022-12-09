#include 'TOTVS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOPXVENDAS บAutor  ณ Adinfo Consultoria บ Data ณ  20/08/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRela็ใo de OP amarrado a nota fiscal emitida no dia da      บฑฑ
ฑฑบ          ณprodu็ใo da OP.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProjeto Verion                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function OPXVENDAS()
Local aSays := {}, aButtons := {}
Local nOpca := 0
Private cPerg := "OPXVENDAS"
Private lEnd  := .F.
Private nRegs :=0
Private aDtINI 	:= {}	//array com a data do primeiro fechamento
Private aMeses	:= {}	//array com os meses para calculo (12)
Private cCadastro := 'Geracao de planilha excel com as OPดs amarrada com as vendas'
Private nMeses
Private nTotalRec 
Private nRowCount

AjustaSX1(cPerg)

AADD(aSays,OemToAnsi( "	Este programa tem o objetivo de gerar uma planilha " ) )  
AADD(aSays,OemToAnsi( "em Excel com as OPดs e as vendas amarradas a elas.  " ) )  
AADD(aSays,OemToAnsi( "" ) )  
AADD(aSays,OemToAnsi( "" ) )  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa o log de processamento                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ProcLogIni( aButtons )

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| (nOpca:= 1, FechaBatch()) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons ,,,370)

If nOpca == 1     
	Pergunte(cPerg,.F.)
	Processa( {|| lEnd :=  GeraQRY() })		
	Processa( {|| GeraArquivo() })
	Processa( {|| Totaliza() })
	Processa( {|| GeraXML() })
Endif 
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_PMSSR  บAutor  ณMicrosiga           บ Data ณ  07/31/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraQRY()
Local cQuery 	:= ''
Local lRet  	:= .T.

cQuery := " SELECT COUNT(*) AS TOT "
cQuery += " FROM " + retsqlname('SB1')
cQuery += " WHERE B1_FILIAL = '" + xFilial('SB1') + "' "
cQuery += " AND   B1_GRUPO  >= '" + MV_PAR03 + "' "
cQuery += " AND   B1_GRUPO  <= '" + MV_PAR04 + "' "
cQuery += " AND   B1_TIPO   >= '" + MV_PAR05 + "' "
cQuery += " AND   B1_TIPO   <= '" + MV_PAR06 + "' "
cQuery += " AND   B1_COD    >= '" + MV_PAR07 + "' "
cQuery += " AND   B1_COD    <= '" + MV_PAR08 + "' "
cQuery += " AND   D_E_L_E_T_ = ' ' "

IF Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
nTotalRec := TRB->TOT
nRowCount := TRB->TOT + 5000

cQuery := " SELECT B1_GRUPO, B1_COD, B1_DESC, B1_MSBLQL "
cQuery += " FROM " + retsqlname('SB1')
cQuery += " WHERE B1_FILIAL = '" + xFilial('SB1') + "' "
cQuery += " AND   B1_GRUPO  >= '" + MV_PAR03 + "' "
cQuery += " AND   B1_GRUPO  <= '" + MV_PAR04 + "' "
cQuery += " AND   B1_TIPO   >= '" + MV_PAR05 + "' "
cQuery += " AND   B1_TIPO   <= '" + MV_PAR06 + "' "
cQuery += " AND   B1_COD    >= '" + MV_PAR07 + "' "
cQuery += " AND   B1_COD    <= '" + MV_PAR08 + "' "
cQuery += " AND   D_E_L_E_T_ = ' ' "

IF Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
ENDIF

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)

If Eof() .and. Bof()
	ApMsgStop('Nใo foram encontrados projetos para os parametros digitados, por favor verifique.')
	lRet := .F.
Endif
return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_PMSSR  บAutor  ณMicrosiga           บ Data ณ  07/31/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraArquivo()
Local 	aStru		:= {}
Local   _y, _x, _dData
Local   dDataINI

//Define a data inicial
//dDataINI := MV_PAR01 - 365
dDataINI := MV_PAR01
dDataFim := MV_PAR02
aDtINI   := { LastDay(dDataINI-20) }	//Inicial, fechamento estoque anterior, para buscar no SB9

For _dData := dDataINI to dDataFim//MV_PAR01
	_cMesAno := LastDay( _dData )
	
	If aScan( aMeses, _cMesAno ) == 0
		aadd( aMeses, _cMesAno )			//array com meses a serem processados
	Endif

	If Len( aMeses ) >= 12
		Exit
	Endif
Next  

nMeses := len( aMeses )

AADD(aStru,{"GRUPO"		,"C",04,0})		//Grupo
AADD(aStru,{"CODIGO"		,"C",15,0})		//Codigo
AADD(aStru,{"DESCRICAO"		,"C",50,0})		//Descricao
AADD(aStru,{"FATOR"			,"N",10,0})		//Fator
AADD(aStru,{"MOEDA"			,"C",10,0})		//Moeda
AADD(aStru,{"VALORCOM"		,"N",14,4})		//Valor Compra
AADD(aStru,{"VALORVEN"		,"N",14,4})		//Valor Venda
AADD(aStru,{"BLOQUEADO"		,"C",03,0})		//Bloqueado
AADD(aStru,{"POSESTINI"		,"N",14,0})		//Posicao Estoque Inicial
AADD(aStru,{"DTPOSEST"		,"D",10,0})		//Data Posicao estoque

For _y := nMeses to 1 step -1
	AADD(aStru,{"DES_MES"+Strzero(_y,2)		,"C",20,0})		//Descricao do Mes
	AADD(aStru,{"MIE_MES"+Strzero(_y,2)		,"N",14,4})		//MIE 
	AADD(aStru,{"MIS_MES"+Strzero(_y,2)		,"N",14,4})		//MIS 	
	AADD(aStru,{"COM_MES"+Strzero(_y,2)		,"N",14,4})		//COMPRA
	AADD(aStru,{"VEN_MES"+Strzero(_y,2)		,"N",14,4})		//VENDA 
	AADD(aStru,{"KAR_MES"+Strzero(_y,2)		,"N",14,4})		//KARDEX
	AADD(aStru,{"KAR_CUS"+Strzero(_y,2)		,"N",14,4})		//KARDEX	CUSTO
Next

If SELECT("cArqTmp") > 0
	DbSelectArea("cArqTmp")
	DbCloseArea()
Endif

cArqPrinc := CriaTrab(aStru,.T.)
dbUseArea(.T.,__LocalDriver,cArqPrinc,"cArqTmp",.T.)

//Abre arquivo de trabalho e grava os dados gerados pela Query dentro do mesmo
DbSelectArea("TRB")
ProcRegua( nTotalRec )

While !Eof()
	
	DbSelectArea("cArqTmp")
	RecLock("cArqTmp",.T.)
	
		//Alteracao 01, retirada de Posicione
		DbSelectArea('SB1')
		DbSetOrder(1)
		dbgotop()
		dbseek( xFilial('SB1')+alltrim(TRB->B1_COD) )
		
		//Alteracao 02, retirada de Posicione
		DbSelectArea('SBM')
		DbSetOrder(1)
		dbgotop()
		DbSeek( xFilial('SBM')+alltrim(TRB->B1_GRUPO) )
	
		cArqTmp->GRUPO		:= TRB->B1_GRUPO
		cArqTmp->CODIGO		:= TRB->B1_COD
		cArqTmp->DESCRICAO	:= TRB->B1_DESC
		cArqTmp->BLOQUEADO	:= IIF(TRB->B1_MSBLQL =='1','Sim','Nao')
		cArqTmp->DTPOSEST	:= EstoqueINI( 1 )
		cArqTmp->POSESTINI	:= EstoqueINI( 2 )
		
		cGrupo := SB1->B1_GRUPO //Posicione('SB1',1,xFilial('SB1')+alltrim(TRB->B1_COD),'B1_GRUPO')
		nFator := SBM->BM_FATOR //Posicione('SBM',1,xFilial('SBM')+cGrupo,'BM_FATOR') 
		cMoed  := SBM->BM_MOEDA //Posicione('SBM',1,xFilial('SBM')+cGrupo,'BM_MOEDA')
		
		cArqTmp->FATOR			:= nFator
		cArqTmp->MOEDA			:= IIF( cMoed == 'R','REAL',IIF( cMoed == 'D', 'DOLAR', 'EURO') )
		cArqTmp->VALORCOM		:= SB1->B1_VERCOM //Posicione('SB1',1,xFilial('SB1')+alltrim(TRB->B1_COD),'B1_VERCOM')	
		cArqTmp->VALORVEN		:= SB1->B1_VERVEN //Posicione('SB1',1,xFilial('SB1')+alltrim(TRB->B1_COD),'B1_VERVEN')	
		
		_x := nMeses //12
		For _y := 1 to nMeses
			aMovMes := MovGer( subs(dtos(aMeses[_x]),1,6), aMeses[_x]  )	
					
			cArqTmp->&("DES_MES"+Strzero(_y,2))	:= strzero(_y,2) 
			cArqTmp->&("MIE_MES"+Strzero(_y,2))	:= aMovMes[1]//MovMes( 'EI', subs(dtos(aMeses[_x]),1,6), aMeses[_x]  )	
			cArqTmp->&("MIS_MES"+Strzero(_y,2))	:= aMovMes[2]//MovMes( 'SI', subs(dtos(aMeses[_x]),1,6), aMeses[_x]  )				
			cArqTmp->&("COM_MES"+Strzero(_y,2))	:= aMovMes[3]//MovMes( 'CE', subs(dtos(aMeses[_x]),1,6), aMeses[_x]  )	
			cArqTmp->&("VEN_MES"+Strzero(_y,2))	:= aMovMes[4]//MovMes( 'VE', subs(dtos(aMeses[_x]),1,6), aMeses[_x]  )	
			cArqTmp->&("KAR_MES"+Strzero(_y,2))	:= MovMes( 'KA', subs(dtos(aMeses[_x]),1,6), aMeses[_x]  )	
			cArqTmp->&("KAR_CUS"+Strzero(_y,2))	:= MovMes( 'KA2', subs(dtos(aMeses[_x]),1,6), aMeses[_x]  )
			_x:=_x-1
		Next		
	MsUnlock()
	
	DbSelectArea("TRB")
	DbSkip()
	IncProc('Processando produto '+ strzero(recno(),5) + ' de ' + strzero(nTotalRec, 5 ))
End
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_POSEST บAutor  ณMicrosiga           บ Data ณ  11/29/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function totaliza()
//Efetua a soma do TOTAL DE SAIDAS E ENTRADAS POR MES
DbSelectArea("cArqTmp")
ProcRegua( reccount() )
dbgotop()
aTotais := {}

For _y := 1 to nMeses //12 
	aadd( aTotais, { 0, 0, 0, 0, 0, 0 } ) //MIE, MIS, COM, VEN, KAR, CUS
Next

aSubTot := {}

While !Eof()

	nPos := aScan( aSubTot, { |x| alltrim(x[1]) == alltrim(cArqTmp->GRUPO) } )
	If nPos == 0
		aadd( aSubTot, { alltrim(cArqTmp->GRUPO),{{}} } ) //MIE, MIS, COM, VEN                                
		nPos := aScan( aSubTot, { |x| alltrim(x[1]) == alltrim(cArqTmp->GRUPO) } )	
		For _y := 1 to nMeses //12 			
			aadd( aSubTot[nPos,2,1], { 0,0,0,0,0,0} )
			aSubTot[nPos,2,1,_y,1] += cArqTmp->&("MIE_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,2] += cArqTmp->&("MIS_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,3] += cArqTmp->&("COM_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,4] += cArqTmp->&("VEN_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,5] += cArqTmp->&("KAR_MES"+Strzero(_y,2))			
			aSubTot[nPos,2,1,_y,6] += cArqTmp->&("KAR_CUS"+Strzero(_y,2))			
      Next
	Else
		For _y := 1 to nMeses //12 
			aSubTot[nPos,2,1,_y,1] += cArqTmp->&("MIE_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,2] += cArqTmp->&("MIS_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,3] += cArqTmp->&("COM_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,4] += cArqTmp->&("VEN_MES"+Strzero(_y,2))
			aSubTot[nPos,2,1,_y,5] += cArqTmp->&("KAR_MES"+Strzero(_y,2))			
			aSubTot[nPos,2,1,_y,6] += cArqTmp->&("KAR_CUS"+Strzero(_y,2))						
		Next
	Endif

	For _y := 1 to nMeses //12 
			aTotais[_y,1] += cArqTmp->&("MIE_MES"+Strzero(_y,2))
			aTotais[_y,2] += cArqTmp->&("MIS_MES"+Strzero(_y,2))
			aTotais[_y,3] += cArqTmp->&("COM_MES"+Strzero(_y,2))
			aTotais[_y,4] += cArqTmp->&("VEN_MES"+Strzero(_y,2))
			aTotais[_y,5] += cArqTmp->&("KAR_MES"+Strzero(_y,2))
			aTotais[_y,6] += cArqTmp->&("KAR_CUS"+Strzero(_y,2))
	Next		

	DbSelectArea("cArqTmp")
	DbSkip()
	incproc()
End

DbSelectArea("cArqTmp")

For _x := 1 to Len( aSubTot )
	RecLock("cArqTmp",.T.)
	
		cArqTmp->GRUPO		:= aSubTot[_x,1]
		cArqTmp->CODIGO		:= 'SUBTOTAL->'
		cArqTmp->DESCRICAO	:= Posicione('SBM',1,xFilial('SBM')+alltrim(aSubTot[_x,1]),'BM_DESC')
		cArqTmp->BLOQUEADO	:= ''
		
		For _y := 1 to nMeses //12 
			cArqTmp->&("MIE_MES"+Strzero(_y,2))	:= aSubTot[1,2,1,_y,1]
			cArqTmp->&("MIS_MES"+Strzero(_y,2))	:= aSubTot[1,2,1,_y,2]
			cArqTmp->&("COM_MES"+Strzero(_y,2))	:= aSubTot[1,2,1,_y,3]
			cArqTmp->&("VEN_MES"+Strzero(_y,2))	:= aSubTot[1,2,1,_y,4]
			cArqTmp->&("KAR_MES"+Strzero(_y,2))	:= aSubTot[1,2,1,_y,5]
			cArqTmp->&("KAR_CUS"+Strzero(_y,2))	:= aSubTot[1,2,1,_y,6]			
		Next		
	MsUnlock()
Next

DbSelectArea("cArqTmp")
RecLock("cArqTmp",.T.)

	cArqTmp->GRUPO		:= ''
	cArqTmp->CODIGO		:= 'TOTAL->'
	cArqTmp->DESCRICAO	:= ''
	cArqTmp->BLOQUEADO	:= ''
	
	For _y := 1 to nMeses //12 
		cArqTmp->&("MIE_MES"+Strzero(_y,2))	:= aTotais[_y,1]
		cArqTmp->&("MIS_MES"+Strzero(_y,2))	:= aTotais[_y,2]
		cArqTmp->&("COM_MES"+Strzero(_y,2))	:= aTotais[_y,3]
		cArqTmp->&("VEN_MES"+Strzero(_y,2))	:= aTotais[_y,4]
		cArqTmp->&("KAR_MES"+Strzero(_y,2))	:= aTotais[_y,5]		
		cArqTmp->&("KAR_CUS"+Strzero(_y,2))	:= aTotais[_y,6]				
	Next		
	
MsUnlock()
dbgotop()
	
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_PMSSR  บAutor  ณMicrosiga           บ Data ณ  07/31/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraXML()
Local nlHandle  := 0
Local clArqExl	:= criatrab(,.f.) + '.xml'//"ES_POSEST.XML"
Local clArq3  	:= ""
Local cDirTemp    := GetTempPath()

nRegs := cArqTmp->(RECCOUNT())

IF Right(Alltrim(cDirTemp),1) # "\"
	cDirTemp := Alltrim(cDirTemp)+"\"
Endif	

nlHandle := FCreate(Alltrim(cDirTemp) + clArqExl)

If FERROR() != 0
	Alert("Nใo foi possํvel abrir ou criar o arquivo: " + clArqExl )
	return
else

	clArq3	:= '<?xml version="1.0"?>'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= '<?mso-application progid="Excel.Sheet"?>'+CRLF
	FWRITE(nlHandle, clArq3)        
	clArq3	:= '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= ' xmlns:o="urn:schemas-microsoft-com:office:office"'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CRLF
	FWRITE(nlHandle, clArq3)
	clArq3	:= ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= '  <Author>Gelson</Author>'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= '  <LastAuthor>Gelson</LastAuthor>'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= '  <Created>2012-10-26T22:20:39Z</Created>'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= '  <LastSaved>2012-10-26T23:04:19Z</LastSaved>'+CRLF
	FWRITE(nlHandle, clArq3)	
	clArq3	:= '  <Version>14.00</Version>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' </DocumentProperties>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <AllowPNG/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' </OfficeDocumentSettings>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <WindowHeight>7995</WindowHeight>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <WindowWidth>20115</WindowWidth>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <WindowTopX>240</WindowTopX>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <WindowTopY>75</WindowTopY>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <ProtectStructure>False</ProtectStructure>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <ProtectWindows>False</ProtectWindows>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' </ExcelWorkbook>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Styles>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Style ss:ID="Default" ss:Name="Normal">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Style ss:ID="s95">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Borders/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= 'ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Interior ss:Color="#92CDDC" ss:Pattern="Solid"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
		
	clArq3	:= '<Style ss:ID="s96">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Style ss:ID="s97" ss:Name="Separador de milhares">'+CRLF
	FWRITE(nlHandle, clArq3)
	
//	clArq3	+= '<NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CRLF
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)

	clArq3	:= '<Style ss:ID="s98">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= 'ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Interior ss:Color="#92CDDC" ss:Pattern="Solid"/>'+CRLF
	FWRITE(nlHandle, clArq3)
		
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Style ss:ID="s99">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11" ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)	

	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Style ss:ID="s16">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Interior ss:Color="#002060" ss:Pattern="Solid"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Style ss:ID="s88">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" ss:Size="11"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<NumberFormat ss:Format="_-* #,##0_-;\-* #,##0_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)

	clArq3	:= '<Style ss:ID="s37">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Style>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Styles>'+CRLF
	FWRITE(nlHandle, clArq3)
		
	clArq3	:= ' <Worksheet ss:Name="Estoque ultimos 12 meses">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <Table ss:ExpandedColumnCount="74" ss:ExpandedRowCount="' + alltrim(str(nRowCount)) + '" x:FullColumns="1"'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   x:FullRows="1" ss:DefaultColumnWidth="87.75" ss:DefaultRowHeight="15">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="34.5"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="79.5"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="196.5"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="74.25"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="90"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Column ss:AutoFitWidth="0" ss:Width="66.75" ss:Span="59"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Row ss:Height="15.75">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
//mais 4 colunas
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)


//mais 5 colunas
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	//Numero de meses - descricao do mes, coluna superior
	For _y := 1 to Len(aMeses)
		clArq3	:= '    <Cell ss:MergeAcross="4" ss:StyleID="s95"><Data ss:Type="String">' + mesextenso(month(aMeses[_y]))+ '/' + subs(dtos(aMeses[_y]),1,4) + '</Data></Cell> '+CRLF
		FWRITE(nlHandle, clArq3)
	Next
	
	clArq3	:= '    <Cell ss:StyleID="s96"/>'+CRLF
	FWRITE(nlHandle, clArq3)

	clArq3	:= '   </Row>	'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Row ss:Height="15.75">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	//4 novas colunas
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">II</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
	
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">PIS</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COFINS</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">NCM</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Grupo</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Codigo</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Descricao</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	
	//4 novas colunas
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Fator</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Moeda</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Valor Compra</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Valor Venda</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)		

	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Bloqueado</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">' + dtoc(cArqTmp->DTPOSEST) +'</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
			
	//Meses - buscar do contador de numero de meses no arquivo ou do array
	For _y := nMeses to 1 step -1
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">R$ Kardex</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

	
	Next
	
	/*	
  	clArq3	:= '	  <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
  	FWRITE(nlHandle, clArq3)
  	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIE</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">MIS</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">COMPRA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)

	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">VENDA</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">Kardex</Data></Cell>'+CRLF
	FWRITE(nlHandle, clArq3)	
   */

	//MAIS UMA COLUNA
//		clArq3	:= '    <Cell ss:StyleID="s98"><Data ss:Type="String">CUSTO R$</Data></Cell>'+CRLF
//		FWRITE(nlHandle, clArq3)
	
	
	clArq3	:= '   </Row>		'+CRLF
	FWRITE(nlHandle, clArq3)

	//Efetua a gravacao aqui com o Fwrite
//	nlHandle := FOpen(Alltrim(cDirTemp) + clArqExl) 
//	FSEEK(nlHandle,0,2)		
//	FWRITE(nlHandle, clArq3)
//	fClose(nlHandle)
//	cTst := memoread( Alltrim(cDirTemp) + clArqExl )
//	alert( cTst )
	
	DbSelectArea('cArqTmp')
	dbgotop()
	
	While !Eof()    
	
		If MV_PAR10 == '2'
			If  !cArqTmp->CODIGO		$ 'TOTAL->'
				dbskip()
				loop
			Endif
		
		Endif

		clArq3	:= '   <Row>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		//4 COLUNAS NOVAS
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + str(Posicione('SB1',1,xFilial('SB1')+cArqTmp->CODIGO,'B1_IMPIMPO')) + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + str(Posicione('SB1',1,xFilial('SB1')+cArqTmp->CODIGO,'B1_PPISE')) + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + str(Posicione('SB1',1,xFilial('SB1')+cArqTmp->CODIGO,'B1_PCOFE')) + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)

		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' +Posicione('SB1',1,xFilial('SB1')+cArqTmp->CODIGO,'B1_POSIPI') + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + cArqTmp->GRUPO + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + cArqTmp->CODIGO + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + cArqTmp->DESCRICAO + '</Data></Cell>'+CRLF 
		FWRITE(nlHandle, clArq3)
			
		//4 NOVAS COLUNAS
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + alltrim(str(cArqTmp->FATOR)) + '</Data></Cell>'+CRLF 
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + cArqTmp->MOEDA + '</Data></Cell>'+CRLF 
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->VALORCOM,'@E 999,999,999.9999') + '</Data></Cell>'+CRLF 
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->VALORVEN,'@E 999,999,999.9999') + '</Data></Cell>'+CRLF 								
		FWRITE(nlHandle, clArq3)
				
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + cArqTmp->BLOQUEADO + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->POSESTINI,'@E 999,999,999') + '</Data></Cell>'+CRLF
		FWRITE(nlHandle, clArq3)
		
		For _y := nMeses to 1 step -1
			clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->&("MIE_MES"+Strzero(_y,2)),'@E 999,999,999') + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->&("MIS_MES"+Strzero(_y,2)),'@E 999,999,999') + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->&("COM_MES"+Strzero(_y,2)),'@E 999,999,999') + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->&("VEN_MES"+Strzero(_y,2)),'@E 999,999,999') + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->&("KAR_MES"+Strzero(_y,2)),'@E 999,999,999') + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			
			clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' + Transform(cArqTmp->&("KAR_CUS"+Strzero(_y,2)),'@E 999,999,999.99') + '</Data></Cell>'+CRLF
			FWRITE(nlHandle, clArq3)
			
		Next

//		clArq3	:= '    <Cell ss:StyleID="s99"><Data ss:Type="String">' +Transform(cArqTmp->VALKAR,'@E 999,999,999') + '</Data></Cell>'+CRLF
//		FWRITE(nlHandle, clArq3)
		
		clArq3	:= '   </Row>'+CRLF
		FWRITE(nlHandle, clArq3)
			
		DbSelectArea('cArqTmp')
		DbSkip()
		
	Enddo

	// Linha em Branco
	clArq3	:= ' <Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' <Cell ss:StyleID="s99"/>'+CRLF	
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' </Row>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' </Table>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <PageSetup>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Header x:Margin="0.31496062000000002"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Footer x:Margin="0.31496062000000002"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   </PageSetup>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Print>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <ValidPrinterInfo/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <PaperSizeIndex>9</PaperSizeIndex>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <HorizontalResolution>-1</HorizontalResolution>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <VerticalResolution>-1</VerticalResolution>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   </Print>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Selected/>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <Panes>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    <Pane>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '     <Number>3</Number>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '     <ActiveRow>2</ActiveRow>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '     <ActiveCol>4</ActiveCol>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '    </Pane>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   </Panes>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <ProtectObjects>False</ProtectObjects>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '   <ProtectScenarios>False</ProtectScenarios>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '  </WorksheetOptions>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= ' </Worksheet>'+CRLF
	FWRITE(nlHandle, clArq3)
	
	clArq3	:= '</Workbook>'+CRLF
	FWRITE(nlHandle, clArq3)
		
	fClose(nlHandle)

                   
//	alert( Alltrim(cDirTemp) + clArqExl )
	
	If File(Alltrim(cDirTemp) + clArqExl)
		If ApOleClient("MsExcel")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(Alltrim(cDirTemp) + clArqExl) // Abre uma planilha
			oExcelApp:SetVisible(.T.)
			oExcelApp:Destroy()
		Else
			ApMsgStop( "Nao foi possivel Abrir Microsoft Excel.", "ATENวรO" )
		Endif

	Endif


Endif


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_POSEST บAutor  ณMicrosiga           บ Data ณ  10/26/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EstoqueINI( nOpc )
Local aArea := GetArea()
Local aRet	:= { '', 0 }
Local cQuery 
Local dData :=  aDtINI[1]
Local cProduto:= TRB->B1_COD

cRet := 0

DbSelectArea('SB2')
DbSetOrder(1)
dbgotop()
DbSeek( xFilial('SB2') + alltrim(cProduto) )
While !Eof() .and. alltrim(cProduto) == alltrim(SB2->B2_COD)

	If SB2->B2_LOCAL < MV_PAR09 .or. SB2->B2_LOCAL > MV_PAR10
		DbSkip()
		Loop
	Endif

	cRet += CalcEst(cProduto,SB2->B2_LOCAL, dData  )[1]
	
	DbSelectArea('SB2')
	DbSkip()
	
Enddo

RestArea( aArea )
return( IIF( nOpc == 1, dData, cRet ) )




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_POSEST บAutor  ณMicrosiga           บ Data ณ  10/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
cArqTmp->&("MIE_MES"+Strzero(_y,2))	:= MovMes( 'EI' )	
cArqTmp->&("COM_MES"+Strzero(_y,2))	:= MovMes( 'CE' )
cArqTmp->&("VEN_MES"+Strzero(_y,2))	:= MovMes( 'VE' )
cArqTmp->&("KAR_MES"+Strzero(_y,2))	:= MovMes( 'KA' )

RE = Requisi็ใo
DE = Devolu็ใo
Ex.: REX ou DEX, onde X pode ser:
0 - Opera็ใo Manual (Custo M้dio no Estoque)
1 - Opera็ใo Automแtica (Custo M้dio no Estoque)
2 - Opera็ใo Automแtica (Apropria็ใo Indireta)
3 - Opera็ใo Manual (Apropria็ใo Indireta)
4 - Transfer๊ncia (Custo M้dio no Estoque por Local)
5 - Requisi็ใo para OP na NF (Usa o custo da NF)
6 - Requisi็ใo Valorizada
7 - Transfer๊ncia Multipla (Desmontagem de Produtos)
8 - Integra็ใo com NF de Produtos Importados (SIGAEIC)

REQUISICAO, DEVOLUCAO E PRODUCAO BUSCA DO SD3
ENTRADAS NO SD1
SAIDAS DO SD2

*/
Static Function MovMes( cMov, cAnoMes, dData )
Local aArea := GetArea()
Local cRet  := 0
Local cQuery 
Local cproduto := TRB->B1_COD
Local cDataINI := cAnoMes+'01'
Local cDataFIM := cAnoMes+'31'

Do Case
	Case cMov == 'EI'	//ENTRADAS INTERNAS - DEVOLUCAO E PRODUCAO
	
		cQuery := " SELECT SUM(D3_QUANT) as D3_QUANT "
		cQuery += " FROM " + retsqlname('SD3') 
		cQuery += " WHERE D3_FILIAL  = '" + xFilial('SD3') + "' "
		cQuery += " AND   D3_COD    = '" + cProduto + "' "
		cQuery += " AND   D3_LOCAL >= '" + MV_PAR09 + "' "
		cQuery += " AND   D3_LOCAL <= '" + MV_PAR10 + "' "
		cQuery += " AND   D3_EMISSAO >= '" + cDataINI + "' "
		cQuery += " AND   D3_EMISSAO <= '" + cDataFIM + "' "
//		cQuery += " AND   SUBSTRING(D3_EMISSAO,1,6) = '" + cAnoMes + "' "
		cQuery += " AND   SUBSTRING( D3_CF, 1, 2 ) IN ('DE','PR') "
//		cQuery += " AND   D3_ESTORNO = ' ' "
		cQuery += " AND   D_E_L_E_T_ =  ' ' "		
		
		cQuery := ChangeQuery(cQuery)
		
		If SELECT("MOVMES") > 0
			DbSelectArea("MOVMES")
			DbCloseArea()
		Endif
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "MOVMES", .F., .T.)
		
		If !Eof() .and. !Bof()
			cRet := MOVMES->D3_QUANT
		Else
			cRet := 0
		Endif		
				
	Case cMov == 'SI'	//SAIDAS INTERNAS - DEVOLUCAO E PRODUCAO
	
		cQuery := " SELECT SUM(D3_QUANT) as D3_QUANT "
		cQuery += " FROM " + retsqlname('SD3')
		cQuery += " WHERE D3_FILIAL  = '" + xFilial('SD3') + "' "
		cQuery += " AND   D3_COD    = '" + cProduto + "' "
		cQuery += " AND   D3_LOCAL >= '" + MV_PAR09 + "' "
		cQuery += " AND   D3_LOCAL <= '" + MV_PAR10 + "' "
		cQuery += " AND   D3_EMISSAO >= '" + cDataINI + "' "
		cQuery += " AND   D3_EMISSAO <= '" + cDataFIM + "' "		
//		cQuery += " AND   SUBSTRING(D3_EMISSAO,1,6) = '" + cAnoMes + "' "
		cQuery += " AND   SUBSTRING( D3_CF, 1, 2 ) IN ('RE') "
		cQuery += " AND   D_E_L_E_T_ =  ' ' "
//		cQuery += " AND   D3_ESTORNO = ' ' "		
		
		cQuery := ChangeQuery(cQuery)
		
		If SELECT("MOVMES") > 0
			DbSelectArea("MOVMES")
			DbCloseArea()
		Endif
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "MOVMES", .F., .T.)
		
		If !Eof() .and. !Bof()
			cRet := MOVMES->D3_QUANT
		Else
			cRet := 0
		Endif		


		
	Case cMov == 'CE'	//COMPRAS - SD1

		cQuery := " SELECT SUM(SD1.D1_QUANT) as D1_QUANT "
		cQuery += " FROM " + retsqlname('SD1') + " SD1 "
		cQuery += " 	LEFT OUTER JOIN " + retsqlname('SF4') + " SF4 ON SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_ =  ' ' AND   SF4.F4_ESTOQUE = 'S' "
		cQuery += " WHERE D1_FILIAL = '" + xFilial('SD1') + "' "
		cQuery += " AND   D1_COD    = '" + cProduto + "' "
		cQuery += " AND   D1_LOCAL >= '" + MV_PAR09 + "' "
		cQuery += " AND   D1_LOCAL <= '" + MV_PAR10 + "' "
		cQuery += " AND   D1_DTDIGIT >= '" + cDataINI + "' "
		cQuery += " AND   D1_DTDIGIT <= '" + cDataFIM + "' "		
//		cQuery += " AND   SUBSTRING(SD1.D1_DTDIGIT,1,6) = '" + cAnoMes + "' "		
		cQuery += " AND   SD1.D_E_L_E_T_ =  ' ' "
//		cQuery += " AND   SF4.F4_ESTOQUE = 'S' "		
//		cQuery += " AND   SF4.D_E_L_E_T_ = ' ' "				
						
		cQuery := ChangeQuery(cQuery)
		
		If SELECT("MOVMES") > 0
			DbSelectArea("MOVMES")
			DbCloseArea()
		Endif
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "MOVMES", .F., .T.)
		
		If !Eof() .and. !Bof()
			cRet := MOVMES->D1_QUANT
		Else
			cRet := 0
		Endif		


	Case cMov == 'VE'	//VENDAS - SD2

		cQuery := " SELECT SUM(SD2.D2_QUANT) as D2_QUANT "
		cQuery += " FROM " + retsqlname('SD2') + " SD2 "
		cQuery += " 	LEFT OUTER JOIN " + retsqlname('SF4') + " SF4 ON SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ =  ' ' AND   SF4.F4_ESTOQUE = 'S' "
		cQuery += " WHERE SD2.D2_FILIAL  = '" + xFilial('SD2') + "' "
		cQuery += " AND   D2_COD    = '" + cProduto + "' "		
		cQuery += " AND   D2_LOCAL >= '" + MV_PAR09 + "' "
		cQuery += " AND   D2_LOCAL <= '" + MV_PAR10 + "' "
		cQuery += " AND   D2_EMISSAO >= '" + cDataINI + "' "
		cQuery += " AND   D2_EMISSAO <= '" + cDataFIM + "' "				
//		cQuery += " AND   SUBSTRING(SD2.D2_EMISSAO,1,6) = '" + cAnoMes + "' "
		cQuery += " AND   SD2.D_E_L_E_T_ =  ' ' "		
//		cQuery += " AND   SF4.F4_ESTOQUE = 'S' "
//		cQuery += " AND   SF4.D_E_L_E_T_ =  ' ' "		
						
		cQuery := ChangeQuery(cQuery)
		
		If SELECT("MOVMES") > 0
			DbSelectArea("MOVMES")
			DbCloseArea()
		Endif
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "MOVMES", .F., .T.)
		
		If !Eof() .and. !Bof()
			cRet := MOVMES->D2_QUANT
		Else
			cRet := 0
		Endif		
	
	
	Case cMov == 'KA'	//SALDO ATUAL
             
		cRet := 0
		
		DbSelectArea('SB2')
		DbSetOrder(1)
		dbgotop()
		DbSeek( xFilial('SB2') + alltrim(cProduto) )
		While !Eof() .and. alltrim(cProduto) == alltrim(SB2->B2_COD)

			If SB2->B2_LOCAL < MV_PAR09 .or. SB2->B2_LOCAL > MV_PAR10
				DbSkip()
				Loop
			Endif
		
			cRet += CalcEst(cProduto,SB2->B2_LOCAL, dData  )[1]
			
			DbSelectArea('SB2')
			DbSkip()
			
		Enddo

	Case cMov == 'KA2'	//valor kardex
             
		cRet := 0
		
		DbSelectArea('SB2')
		DbSetOrder(1)
		dbgotop()
		DbSeek( xFilial('SB2') + alltrim(cProduto) )
		While !Eof() .and. alltrim(cProduto) == alltrim(SB2->B2_COD)

			If SB2->B2_LOCAL < MV_PAR09 .or. SB2->B2_LOCAL > MV_PAR10
				DbSkip()
				Loop
			Endif
		
			cRet += CalcEst(cProduto,SB2->B2_LOCAL, dData  )[2]
			
			DbSelectArea('SB2')
			DbSkip()
		End
EndCase

RestArea( aArea )
return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณES_POSEST บAutor  ณMicrosiga           บ Data ณ  11/29/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MovGer( cAnoMes, dData )
Local aArea := GetArea()
Local aRet  := {0,0,0,0}
Local cQuery 
Local cProduto := TRB->B1_COD
Local cDataINI := cAnoMes+'01'
Local cDataFIM := cAnoMes+'31'

cQuery := " SELECT	SB1.B1_COD, "
cQuery += " 		( "
cQuery += " 		SELECT SUM(D3_QUANT) "
cQuery += " 		FROM " + RETSQLNAME('SD3') 
cQuery += " 		WHERE D3_FILIAL  = '" + xFilial('SD3') + "' "
cQuery += " 		AND   D3_COD    = SB1.B1_COD "
cQuery += " 		AND   D3_LOCAL >= '" + MV_PAR09 + "' "
cQuery += " 		AND   D3_LOCAL <= '" + MV_PAR10 + "' "
cQuery += " 		AND   D3_EMISSAO >= '" + cDataINI + "' "
cQuery += " 		AND   D3_EMISSAO <= '" + cDataFIM + "' "
cQuery += " 		AND   SUBSTRING( D3_CF, 1, 2 ) IN ('DE','PR') "
cQuery += " 		AND   D_E_L_E_T_ =  ' ' "
cQuery += " 		) AS EI, "
cQuery += " 		( "
cQuery += " 		SELECT SUM(D3_QUANT) "
cQuery += " 		FROM " + retsqlname('SD3') 
cQuery += " 		WHERE D3_FILIAL  = '" + xfilial('SD3') + "' "
cQuery += " 		AND   D3_COD     = SB1.B1_COD "
cQuery += " 		AND   D3_LOCAL >= '" + MV_PAR09 + "' "
cQuery += " 		AND   D3_LOCAL <= '" + MV_PAR10 + "' "
cQuery += " 		AND   D3_EMISSAO >= '" + cDataINI + "' "
cQuery += " 		AND   D3_EMISSAO <= '" + cDataFIM + "' "
cQuery += " 		AND   SUBSTRING( D3_CF, 1, 2 ) IN ('RE') "
cQuery += " 		AND   D_E_L_E_T_ =  ' '  "
cQuery += " 		) AS SI, "
cQuery += " 		( "
cQuery += " 		SELECT SUM(SD1.D1_QUANT) "
cQuery += " 		FROM " + retsqlname('SD1') + " SD1 "
cQuery += " 		 	LEFT OUTER JOIN " + retsqlname('SF4') + " SF4 ON SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_ =  ' ' AND   SF4.F4_ESTOQUE = 'S'  "
cQuery += " 		WHERE D1_FILIAL = '" + xfilial('SD1') + "' "
cQuery += " 		AND   D1_COD    = SB1.B1_COD "
cQuery += " 		AND   D1_LOCAL >= '" + MV_PAR09 + "' "
cQuery += " 		AND   D1_LOCAL <= '" + MV_PAR10 + "' "
cQuery += " 		AND   D1_DTDIGIT >= '" + cDataINI + "' "
cQuery += " 		AND   D1_DTDIGIT <= '" + cDataFIM + "' "
cQuery += " 		AND   SD1.D_E_L_E_T_ =  ' ' "
cQuery += " 		) AS CE, "
cQuery += " 		( "
cQuery += " 		SELECT SUM(SD2.D2_QUANT) "
cQuery += " 		FROM " + retsqlname('SD2') + " SD2 "
cQuery += " 			LEFT OUTER JOIN " + retsqlname('SF4') + " SF4 ON SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ =  ' ' AND   SF4.F4_ESTOQUE = 'S'  "
cQuery += " 		WHERE SD2.D2_FILIAL  = '" + xfilial('SD2') + "' "
cQuery += " 		AND   D2_COD    = SB1.B1_COD "
cQuery += " 		AND   D2_LOCAL >= '" + MV_PAR09 + "' "
cQuery += " 		AND   D2_LOCAL <= '" + MV_PAR10 + "' "
cQuery += " 		AND   D2_EMISSAO >= '" + cDataINI + "' "
cQuery += " 		AND   D2_EMISSAO <= '" + cDataFIM + "' "
cQuery += " 		AND   SD2.D_E_L_E_T_ =  ' ' "
cQuery += " 		) AS VE "
		
cQuery += " FROM " + retsqlname('SB1') + " SB1 "
cQuery += " WHERE SB1.B1_FILIAL  = '" + xFilial('SB1') + "' "
cQuery += " AND   SB1.B1_COD     = '" + cProduto + "' "
cQuery += " AND   SB1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

If SELECT("MOVMES") > 0
	DbSelectArea("MOVMES")
	DbCloseArea()
Endif

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "MOVMES", .F., .T.)

TcSetField("MOVMES", "EI", "N", 17, 2)
TcSetField("MOVMES", "SI", "N", 17, 2)
TcSetField("MOVMES", "CE", "N", 17, 2)
TcSetField("MOVMES", "VE", "N", 17, 2)

IF !eof() .and. !Bof()
	aRet := { MOVMES->EI, MOVMES->SI, MOVMES->CE, MOVMES->VE, }
Endif



RestArea( aArea )
return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ Adinfo Consultoria บ Data ณ  20/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Grupo de perguntas                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)
Local aRegs     := {}
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
aAdd(aRegs,{cPerg,'01' ,'Data De'			   ,'Data De'							 	,'Data De'						 	,'mv_ch1','D'  ,08     ,0      ,0     ,'G','                                ','MV_PAR01','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'',''})
aAdd(aRegs,{cPerg,'02' ,'Data Ate'			   ,'Data Ate'							 	,'Data Ate'						 	,'mv_ch2','D'  ,08     ,0      ,0     ,'G','                                ','MV_PAR02','               '  ,''		 ,''	 ,'                ',''   ,'        	   ',''   	 ,''  	  ,''	 ,''   ,'       ' ,''  		 ,''      ,''	 ,''	,'       ',''  		 ,''  	  ,''	 ,''	,''			,'' 	   ,''		 ,''	,'',''})
ValidPerg(aRegs,cPerg)

return