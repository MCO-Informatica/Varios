#include "rwmake.ch"
#include "topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ESTP001   �Autor  �Marcelo Scibarauskas� Data �  11/02/08   ���
���          �          �       �Ricardo Felipelli   � Data �  03/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera Arquivo de inventario.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Laselva                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ESTP001()

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0
Private dData		:= CTOD("  /  /  ")
Private _cCadastro	:= "Geracao de Dados do Inventario"
Private cPerg		:= Padr("ESTP01",len(SX1->X1_GRUPO)," ")
Private _cEmpFil	:= ""
//ValidPerg()
//PERGUNTE(cPerg, .F.)

dData := MV_PAR02

AADD(aSays,"Este programa tem o objetivo de gerar os dados ")
AADD(aSays,"para inventario com base em tabela fornecida ")
AADD(aSays,"pelo cliente. ")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( _cCadastro, aSays, aButtons )
	
If nOpcA == 1
	//If Pergunte(cPerg, .T.)
		//ValidPerg()
		//Processa({|| DefFilial() },"Gerando Movimentacoes de Entrada...  "+mv_par03)
		Processa({|| GeraSD3() },"Gerando Movimentacoes de Entrada...  ")
		GeraSD3()
	//Endif
EndIf	
		
Return
	
Static Function DefFilial()
	
Local aEmpFil  := {}
Local nHdlLock := 0
	
Local cArqLock := "estp001.lck"
Local aparam   := {"01","01"}
	
	
	//��������������������������������������������������������������Ŀ
	//� Efetua o Lock de gravacao da Rotina - Monousuario            �
	//����������������������������������������������������������������
	//FErase(cArqLock)
	//nHdlLock := MsFCreate(cArqLock)
	//IF nHdlLock < 0
		//Conout("Rotina "+FunName()+" ja em execu��o.")
		//Return(.T.)
	//EndIF
	
	//�������������������������������������������������������Ŀ
	//� Inicializa ambiente.                                  �
	//���������������������������������������������������������
	RpcSetType(3)
	IF FindFunction('WFPREPENV')
		WfPrepEnv( aParam[1], aParam[2])
	Else
		Prepare Environment Empresa aParam[1] Filial aParam[2]
	EndIF
	ChkFile("SM0")
	
	//�������������������������������������������������������Ŀ
	//� Seleciona filiais.   						   �
	//���������������������������������������������������������
	DbSelectArea("SM0")
	DbSetOrder(1)
	DbGoTop()
	While !Eof()
		//if mv_par03 == alltrim(SM0->M0_EMERGEN)  
			//_cEmpFil := alltrim(SM0->M0_EMERGEN)  
			//AAdd(aEmpFil,{SM0->M0_CODIGO,SM0->M0_CODFIL,Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)})
		//EndIf
		If  SM0->M0_CODFIL == "01" 
			AAdd(aEmpFil,{SM0->M0_CODIGO,SM0->M0_CODFIL,Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)})	
		EndIf
		DbSkip()
	EndDo
	
	//�������������������������������������������������������Ŀ
	//� Fecha filial corrente.						   �
	//���������������������������������������������������������
	Reset Environment
	
	//�������������������������������������������������������Ŀ
	//� Executa rotinas por Empresa/filial.  			   �
	//���������������������������������������������������������
	For nX := 1 To Len(aEmpFil)
		
		//AutoGrLog(mv_par03)
		//�������������������������������������������������������Ŀ
		//� Comando para nao comer licensas.     				  �
		//���������������������������������������������������������
		RpcSetType(3)
		
		//�������������������������������������������������������Ŀ
		//� Abre a respectiva filial.            				  �
		//���������������������������������������������������������
		IF FindFunction('WFPREPENV')
			WfPrepEnv( aEmpFil[nX,1], aEmpFil[nX,2])
		Else
			Prepare Environment Empresa aEmpFil[nX,1] Filial aEmpFil[nX,2]
		EndIF
		ChkFile("SM0")
		
		GeraSD3()
		
		Reset Environment
	Next
	
	//��������������������������������������������������������������Ŀ
	//� Cancela o Lock de gravacao da rotina                         �
	//����������������������������������������������������������������
	//FClose(nHdlLock)
	//FErase(cArqLock)
	
	Return(.T.)
	
	Static Function GeraSD3()
	Local aVetor := {}
	
	Local CR 		:= chr(13) + chr(10)
	Local cQuery	:= " "
	Local dDtInv    := ddatabase
	
	
	cQuery    += " SELECT M0_CODFIL, PROD, ALM, SUM(QDE) QDE ,SUM(CUSTO) CUSTO FROM ("
	
	cQuery    += " SELECT M0_CODFIL, B1_COD PROD, "
	cQuery    += " '01' ALM, "
	cQuery    += " estoque QDE, "
	cQuery    += " CUSTO CUSTO "
	cQuery    += " FROM SIGA.dbo.ESTOQUENF "
	cQuery    += " WHERE "
	cQuery    += " M0_CODFIL = 'C0' "
	cQuery    += " ) TT "
	cQuery    += " GROUP BY M0_CODFIL, PROD, ALM "
	
	U_GravaQuery('ESTP001.SQL',_cQuery)
	
	
	// Executa a query principal
	TcQuery cQuery NEW ALIAS "QRY1"
	
	// Conta os registros da Query
	TcQuery "SELECT COUNT(*) AS TOTALREG FROM (" + cQuery + ") AS T" NEW ALIAS "QRYCONT"
	QRYCONT->(dbgotop())
	nReg := QRYCONT->TOTALREG
	QRYCONT->(dbclosearea())
	
	If nReg > 0
		While QRY1->(!Eof())
			
			lMsErroAuto := .F.
			
			aVetor:={{"D3_TM","010",NIL},;
			{"D3_COD",QRY1->PROD,NIL},;
			{"D3_LOCAL",QRY1->ALM,NIL},;
			{"D3_EMISSAO",ddatabase,NIL},;
			{"D3_QUANT",QRY1->QDE,NIL},;
			{"D3_CUSTO1",Round(QRY1->CUSTO*QRY1->QDE,2),NIL}}
			
			MSExecAuto({|x,y| mata240(x,y)},aVetor,3) //Inclusao
			
			
			If lMsErroAuto
				Mostraerro()
			Endif
			
			QRY1->(dbskip())
		EndDo
		
	Endif
	QRY1->(dbclosearea())
	
	//MsgBox("As movimentacoes foram geradas com sucesso" ,"Fim Processamento","INFO")
	
/*	cQryA := " insert into PROGET.Informatica.SMS.fila (para,sms) values ('92513645','Finalizada importacao filiais peso:  '"+_cEmpFil+"' ') "
	TcSQLExec(cQryA)
	
	cQryB := " insert into PROGET.Informatica.SMS.fila (para,sms) values ('92513645','Finalizada importacao filiais peso:  '"+_cEmpFil+"' ') "
	TcSQLExec(cQryB)
	
	cQryC := " insert into PROGET.Informatica.SMS.fila (para,sms) values ('92513645','Finalizada importacao filiais peso:  '"+_cEmpFil+"' ') "
	TcSQLExec(cQryC)
	
	cQryD := " insert into PROGET.Informatica.SMS.fila (para,sms) values ('92513645','Finalizada importacao filiais peso:  '"+_cEmpFil+"' ') "
	TcSQLExec(cQryD)
	*/
	Return()
	
	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Programa  �VALIDPERG �Autor  �Marcelo Sciba       � Data �  15/12/06   ���
	�������������������������������������������������������������������������͹��
	���Desc.     � Cria as perguntas do SX1                                   ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	*/
	
	static function VALIDPERG()
	
	// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
	// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Documento"			,"Documento"		    ,"Documento" 			,"mv_ch1","C",06,0,0,"G","",""	 ,"",,"mv_par01","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"02","Data"        		,"Data"     		    ,"Data"     	    	,"mv_ch2","D",08,0,0,"G","",""	 ,"",,"mv_par02","","","","","","","","","","","","","","","","")
	PutSX1(cPerg,"03","Peso"        		,"Peso"     		    ,"Peso"     	    	,"mv_ch3","C",01,0,0,"G","",""	 ,"",,"mv_par03","","","","","","","","","","","","","","","","")
	
	return()
