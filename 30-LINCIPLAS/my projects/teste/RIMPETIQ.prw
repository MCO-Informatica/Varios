#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � INTWORD  �   Thiago Queiroz - STCH       � Data �30.09.2012���
�������������������������������������������������������������������������Ĵ��
���Descricao � Faz a integracao do Protheus com o MS Word                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
O objetivo eh fazer a integracao entre o Protheus e o MS Word.
/*/

User Function RIMPETIQ()
/*
@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
@ 08,005 TO 048,190
@ 18,010 SAY OemToAnsi("Esta rotina ira imprimir os orcamentos conforme os parametros digitados.")

@ 56,130 BMPBUTTON TYPE 1 ACTION WordImp()
@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED
*/

WordImp()

Return()

Static Function WordImp()

Local cVENDNOME		:= ""
Local cVENDEND 		:= ""
Local cVENDTEL		:= ""
Local cVENDCEL 		:= ""
Local cVENDEMAIL	:= ""
Local cCLINOME		:= ""
Local cCLIEND		:= ""
Local cCLICEP		:= ""
Local cCLICONTATO	:= ""

Local aVENDNOME		:= {}
Local aVENDEND 		:= {}
Local aVENDTEL		:= {}
Local aVENDCEL 		:= {}
Local aVENDEMAIL	:= {}
Local aCLINOME		:= {}
Local aCLIEND		:= {}
Local aCLICEP		:= {}
Local aCLICONTATO	:= {}

Local nValOrc		:= 0
Local nK
Local nSeq			:= 0
//Local cPathDot	    := "G:\TOTVS\Asiatex.dot"
Local cPathDot	    := "C:\Asiatex.dot"

Private cPerg		:= "RIMPETIQ"
Private	hWord

ValiDPerg()
IF Pergunte(cPerg,.T.)
	
	// deleta o arquivo caso ele j� exista
	//winexec("del c:\Or�amentos\Asiatex.dot")
	// copia o .dot para o drive c:\
	//CpyS2T( "\system\asiatex.dot", "C:\Or�amentos\", .T. )
	
	//Close(oDlg)
	if Select("TRB") > 0
		dbSelectArea("TRB")
		DbCloseArea()
	Endif
	
	cQuery := " SELECT A1_VEND, A3_NOME, LTRIM(RTRIM(A3_MUN))+' - '+A3_EST AS 'VENDEND' "
	cQuery += " ,'('+LTRIM(RTRIM(11))+') '+SUBSTRING(A3_TEL,1,4)+'-'+SUBSTRING(A3_TEL,5,4) AS 'VENDTEL' "
	cQuery += " ,'('+LTRIM(RTRIM(11))+') '+SUBSTRING(A3_TEL,1,4)+'-'+SUBSTRING(A3_TEL,5,4) AS 'VENDCEL' "
	cQuery += " , A3_EMAIL "
	cQuery += " , A1_NREDUZ, A1_NOME, LTRIM(RTRIM(A1_END))+' - '+LTRIM(RTRIM(A1_BAIRRO))+' - '+LTRIM(RTRIM(A1_MUN))+' - '+A1_EST AS 'CLIEND' "
	cQuery += " , SUBSTRING(A1_CEP,1,5)+'-'+SUBSTRING(A1_CEP,6,3) AS 'CLICEP', A1_CONTATO "
	cQuery += " FROM "+RetSqlName('SA1') + " A1, "+ RetSqlName('SA3') + " A3 "
	cQuery += " WHERE LTRIM(RTRIM(A1_VEND)) != '' "
	cQuery += " AND A3_COD					>= '" +MV_PAR01+ "' "
	cQuery += " AND A3_COD					<= '" +MV_PAR02+ "' "
	cQuery += " AND A1_VEND					= A3_COD "
	cQuery += " AND A1_EST					>= '" +MV_PAR03+ "' "
	cQuery += " AND A1_EST					<= '" +MV_PAR04+ "' "
	cQuery += " AND A1_MSBLQL				= '2' "
//	cQuery += " AND A1_ETIQ					= 'S' "
	cQuery += " AND A1.D_E_L_E_T_			!= '*' "
	cQuery += " ORDER BY 1, A1_COD "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TRB',.F.,.T. )
	
	dbSelectArea("TRB")
	dbGoTop()
	
	//wcData		:= AllTrim(Str(Day(dDataBase),2))+' de '+AllTrim(MesExtenso(dDataBase))+' de '+AllTrim(Str(Year(dDataBase),4))
	//cCliente	:= ALLTRIM(GETADVFVAL("SA1","A1_NOME",XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,1,""))
	
	// -----------------------------------------------------------
	
	//for nK := 1 to 10
	DO WHILE !EOF()
		
		cVENDNOME		:= TRB->A3_NOME
		cVENDEND 		:= TRB->VENDEND
		cVENDTEL		:= TRB->VENDTEL
		cVENDCEL 		:= TRB->VENDCEL
		cVENDEMAIL		:= TRB->A3_EMAIL
		cCLINOME		:= TRB->A1_NREDUZ
		cCLIEND			:= TRB->CLIEND
		cCLICEP			:= TRB->CLICEP
		cCLICONTATO		:= TRB->A1_CONTATO
		
		
		aadd(aVENDNOME		,cVENDNOME)
		aadd(aVENDEND		,cVENDEND)
		aadd(aVENDTEL		,cVENDTEL)
		aadd(aVENDCEL		,cVENDCEL)
		aadd(aVENDEMAIL		,cVENDEMAIL)
		aadd(aCLINOME		,cCLINOME)
		aadd(aCLIEND		,cCLIEND)
		aadd(aCLICEP		,cCLICEP)
		aadd(aCLICONTATO	,cCLICONTATO)
		
		nSeq := nSeq + 1
		DBSKIP()
	ENDDO
	
	//Conecta ao word
	hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord, cPathDot)
		
	//Montagem das variaveis do cabecalho
	/*
	OLE_SetDocumentVar(hWord, 'VENDNOME'	, aVENDNOME)
	OLE_SetDocumentVar(hWord, 'VENDEND'		, aVENDEND)
	OLE_SetDocumentVar(hWord, 'VENDTEL'		, aVENDTEL)
	OLE_SetDocumentVar(hWord, 'VENDCEL'		, aVENDCEL)
	OLE_SetDocumentVar(hWord, 'VENDEMAIL'	, aVENDEMAIL)
	OLE_SetDocumentVar(hWord, 'CLINOME'		, aCLINOME)
	OLE_SetDocumentVar(hWord, 'CLIEND'		, aCLIEND)
	OLE_SetDocumentVar(hWord, 'CLICEP'		, aCLICEP)
	OLE_SetDocumentVar(hWord, 'CLICONTATO'	, aCLICONTATO)
	
	OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(nSeq))	//variavel para identificar o numero total de
	*/
	//linhas na parte variavel
	//Sera utilizado na macro do documento para execucao
	//do for next
	
	//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
	// prt_cod1, prt_cod2 ... prt_cod10
	
	//for nK := 1 to nSeq
	//	pula := pula + nseq
	//	OLE_ExecuteMacro(hWord,"pula")//str(+nSeq))
	//next
	
	for nK := 1 to nSeq                                                         
		
		IF nK == 1
			OLE_ExecuteMacro(hWord,"Linha1")
		ENDIF
		
		OLE_SetDocumentVar(hWord,"VENDNOME"+alltrim(str(nK))	,aVENDNOME[nK])
		OLE_SetDocumentVar(hWord,"VENDEND"+alltrim(str(nK))		,aVENDEND[nK])
		OLE_SetDocumentVar(hWord,"VENDTEL"+alltrim(str(nK))		,aVENDTEL[nK])
		OLE_SetDocumentVar(hWord,"VENDCEL"+alltrim(str(nK))		,aVENDCEL[nK])
		OLE_SetDocumentVar(hWord,"VENDEMAIL"+alltrim(str(nK))	,aVENDEMAIL[nK])
		OLE_SetDocumentVar(hWord,"CLINOME"+alltrim(str(nK))		,aCLINOME[nK])
		OLE_SetDocumentVar(hWord,"CLIEND"+alltrim(str(nK))		,aCLIEND[nK])
		OLE_SetDocumentVar(hWord,"CLICEP"+alltrim(str(nK))		,aCLICEP[nK])
		OLE_SetDocumentVar(hWord,"CLICTT"+alltrim(str(nK))		,aCLICONTATO[nK])
        
		IF nK <= nSeq .AND. nK > 1
			OLE_ExecuteMacro(hWord,"Linha"+alltrim(str(nK)))
		ENDIF
		
	next
	
	//OLE_ExecuteMacro(hWord,"tabitens")
	
	//OLE_SetDocumentVar(hWord, 'nValOrc', Transform(nValOrc,"@E 999,999.99"))
	
	//�����������������������������������������������������������������������Ŀ
	//� Atualizando as variaveis do documento do Word                         �
	//�������������������������������������������������������������������������
	OLE_UpdateFields(hWord)
	
	//OLE_ExecuteMacro(hWord,"pdf")
	
	//If MsgYesNo("Imprime o Documento ?")
	//Ole_PrintFile(hWord,"ALL",,,1)
	//EndIf
	
	If MsgYesNo("Fecha o Word e Corta o Link ?")
		OLE_CloseFile( hWord )
		OLE_CloseLink( hWord )
	Endif
	
ENDIF
Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VALIDPERG � Autor � RAIMUNDO PEREIRA      � Data � 01/08/02 ���
�������������������������������������������������������������������������Ĵ��
���          � Verifica as perguntas inclu�ndo-as caso n"o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg()

cPerg		:= "RIMPETIQ"

_aAreaVP := GetArea()

DBSelectArea("SX1")
DBSetOrder(1)

cPerg  := PADR(cPerg,10)
aRegs  :={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
/*�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  Ordem Pergunta Portugues   Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  Tamanho Decimal Presel  GSC   Valid                 Var01     	 Def01      DefSPA1      DefEng1      Cnt01          					  Var02  Def02    DefSpa2  DefEng2	Cnt02  Var03 Def03  DefSpa3 DefEng3 Cnt03  Var04  Def04  DefSpa4    DefEng4  Cnt04 		 Var05  Def05  DefSpa5 DefEng5   Cnt05  	XF3  GrgSxg   cPyme   aHelpPor  aHelpEng	 aHelpSpa    cHelp      �
���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/

AADD(aRegs,{cPerg,"01","Do Represent. "	,"","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"02","Ate Represent."	,"","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"03","Do Estado"		,"","","mv_ch3","C",2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Estado"		,"","","mv_ch4","C",2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
/*
AADD(aRegs,{cPerg,"05","De C. Custo"	,"","","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Ate C. Custo"	,"","","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"07","De Data"		,"","","mv_ch7","D",8,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Data"		,"","","mv_ch8","D",8,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Verbas PLR"		,"","","mv_ch9","C",50,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Verbas Ferias"	,"","","mv_cha","C",50,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Verbas Bonus"	,"","","mv_ch9","C",50,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Verbas 13o. Salario","","","mv_cha","C",50,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
*/

aHelpP := {}

For i:=1 to Len(aRegs)
	If !DBSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

RestArea(_aAreaVP)
Return
