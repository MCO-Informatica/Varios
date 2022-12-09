#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*

04/12/2015
DE x PARA de contas contabeis
QS DO BRASIL

*/

***********************
User Function DExPARA()
***********************


@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Executa De x Para do plano de contas e CC"
@ 8,10 TO 84,222
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa tem o objetivo de fazer a troca das contas contabeis para a "
@ 33,14 SAY "nova estrutura. "
@ 43,14 SAY "RODAR EM MODO EXCLUSIVO.        "
@ 53,14 SAY "Esta rotina e Rdmake.                   
ACTIVATE DIALOG oDlg5

Return nil

Static Function OkProc()
Close(oDlg5)

Processa( {|| RunProc1() } )
Processa( {|| RunProc2() } )

Return

Static Function RunProc1()

aStru:={}
AADD(aStru,{"X3_ARQUIVO" ,"C",03,0})
AADD(aStru,{"X3_CAMPO"   ,"C",15,0})
cNomArq:= CriaTrab(aStru,.T.)
dbusearea(.T.,,cNomArq,"SX3T",.T.,.F.)
cNomArq1:= CriaTrab("",.F.) // arquivo de indice
dbSelectArea("SX3T")
Append from \system\SX3010.dbf for X3_F3 = 'CT1' .OR. X3_F3 = 'SI1' .OR. X3_GRPSXG = '003'
IndRegua("SX3T",cNomArq,"X3_CAMPO",,,"Selecionando Registros...")
dbGoTop()                                         

//_cFiltro := "X3_F3 = 'CT1' .OR. X3_F3 = 'SI1' .OR. X3_GRPSXG = '003' "
//dbSelectArea("SX3")
//cNomArq := CriaTrab(NIL,.F.)

dbSelectArea("SX3T")
dbGoTop()

While !Eof()
	
	If SX3T->X3_ARQUIVO $ "CT1/CT5/CLL/CNV/CTK/CT3/CT4/CT7/CTU/CTV/CTW/CTX/CTY/CT4/SN7"
		dbSelectArea("SX3T")
		dbSkip()
		Loop
	Endif

	If left(SX3T->X3_ARQUIVO,1) $ "B/D/E/F/G/H/I/J/V"
		dbSelectArea("SX3T")
		dbSkip()
		Loop
	Endif
/*
	_cSqlName:=retSqlName(SX3->X3_ARQUIVO)
	If !MSFILE( _cSqlName,, "TOPCONN" )	
		dbSelectArea("SX3")
		dbSkip()
		Loop
	Endif     
	If !tccanopen(_cSqlName)
		dbSelectArea("SX3")
		dbSkip()
		Loop
	Endif     
*/
	
	_cTabela := SX3T->X3_ARQUIVO
	_cCampo  := SX3T->X3_ARQUIVO+"->"+SX3T->X3_CAMPO
	ProcRegua(RecCount(_cTabela))

 	dbSelectArea(_cTabela)
	dbSetOrder(1)
	dbGoTop()
	
	If Select('CQRY') > 0
		CQRY->( dbCloseArea() )
	Endif
	_cQuery := "SELECT R_E_C_N_O_ AS REGISTRO FROM "+RetSqlName(_cTabela)
	_cQuery += " Where "+SX3T->X3_CAMPO+" <> ' ' AND SUBSTRING("+SX3T->X3_CAMPO+",8,1) <> ' ' AND D_E_L_E_T_ <> '*' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"cQRY",.T.,.T.)
	dbSelectArea("cQRY")
	dbGoTop()
	While !Eof() 
		IncProc("Processando..."+SX3T->X3_ARQUIVO+" "+SX3T->X3_CAMPO)
		dbSelectArea(_cTabela)
		dbGoTo(cQRY->REGISTRO)
		If !Empty(&_cCampo)      
			CT1->(dbSetOrder(1))
			If CT1->(dbSeek(xFilial("CT1")+&_cCampo))
				If !Empty(CT1->CT1_XNEWCT) .AND. Upper(Left(CT1->CT1_XNEWCT,1)) <> "N"
					RecLock(_cTabela)
					&_cCampo := CT1->CT1_XNEWCT
					MsUnlock()
				Endif
			Endif
		Endif
		dbSelectArea("cQRY")
		dbSkip()
	End
	dbSelectArea("SX3T")
	dbSkip()
End	
					
dbSelectArea("SX3T")
dbCloseArea("SX3T")

//dbSelectArea("SX3")
//Retindex("SX3")

MsgInfo("Fim De x Para Plano de contas!")

Return		


Static Function RunProc2()

ProcRegua(1000)

aStru:={}
AADD(aStru,{"X3_ARQUIVO" ,"C",03,0})
AADD(aStru,{"X3_CAMPO"   ,"C",15,0})
cNomArq:= CriaTrab(aStru,.T.)
dbusearea(.T.,,cNomArq,"SX3T",.T.,.F.)
cNomArq1:= CriaTrab("",.F.) // arquivo de indice
dbSelectArea("SX3T")
Append from \system\SX3010.dbf for X3_F3 = 'CTT' .OR. X3_F3 = 'SI3' .OR. X3_GRPSXG = '004' 
IndRegua("SX3T",cNomArq,"X3_CAMPO",,,"Selecionando Registros...")
dbGoTop()                                         

dbSelectArea("SX3T")
dbGoTop()

While !Eof()
	IncProc("Processando...Centro de Custos")
	
	If SX3T->X3_ARQUIVO $ "CT1/CT5/CTT/CLL/CNV/CTK/CT3/CT4/CT7/CTU/CTV/CTW/CTX/CTY/CT4/SH9/SN7/STC" .OR. Left(SX3T->X3_ARQUIVO,1)="T" //.OR. Left(SX3T->X3_ARQUIVO,2)="SR"
		dbSelectArea("SX3T")
		dbSkip()
		Loop
	Endif

	_cTabela := SX3T->X3_ARQUIVO
	_cCampo  := SX3T->X3_ARQUIVO+"->"+SX3T->X3_CAMPO
 	dbSelectArea(_cTabela)
	ProcRegua(RecCount(_cTabela))
	dbGoTop()

	If Select('CQRY') > 0
		CQRY->( dbCloseArea() )
	Endif
	_cQuery := "SELECT R_E_C_N_O_ AS REGISTRO FROM "+RetSqlName(_cTabela)
	_cQuery += " Where "+SX3T->X3_CAMPO+" <> ' ' AND SUBSTRING("+SX3T->X3_CAMPO+",1,1) < '4' AND D_E_L_E_T_ <> '*' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"cQRY",.T.,.T.)
	dbSelectArea("cQRY")
	dbGoTop()
	While !Eof() 
		IncProc("Processando..."+SX3T->X3_ARQUIVO+" "+SX3T->X3_CAMPO)
		dbSelectArea(_cTabela)
		dbGoTo(cQRY->REGISTRO)
		If !Empty(&_cCampo)      
			CTT->(dbSetOrder(1))
			If CTT->(dbSeek(xFilial("CTT")+&_cCampo))
				If !Empty(CTT->CTT_XNEWCC)
					RecLock(_cTabela)
					&_cCampo := CTT->CTT_XNEWCC
					MsUnlock()
				Endif
			Endif
		Endif
	 	dbSelectArea("CQRY")
		dbSkip()
	End
	dbSelectArea("SX3T")
	dbSkip()
End	
					
dbSelectArea("SX3T")
dbCloseArea("SX3T")

//dbSelectArea("SX3")
//Retindex("SX3")

MsgInfo("Fim De x Para Centro de Custo!")

Return		
