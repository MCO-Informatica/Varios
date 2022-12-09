#include 'protheus.ch'

#DEFINE CLIENTEDE	1
#DEFINE CLIENTEATE	2
#DEFINE LOJADE		3
#DEFINE LOJAATE		4

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVA004	�Autor  �Microsiga		     � Data �  30/05/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza��o de grupo de vendas do cliente					  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVA004()

	Local aArea 	:= GetArea()
	Local aParam	:= {}

	If PergRetFil(@aParam)
		Processa( {|| ProcAtuGrp(aParam[CLIENTEDE], aParam[CLIENTEATE], aParam[LOJADE], aParam[LOJAATE]) },"Aguarde...","" )
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ProcAtuGrp	�Autor  �Microsiga		 � Data �  30/05/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento da rotina de rupo de cliente				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcAtuGrp(cCliDe, cCliAte, cLojaDe, cLojaAte)

	Local aArea 	:= 	GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nCnt		:= 0

	Default cCliDe		:= "" 
	Default cCliAte		:= "" 
	Default cLojaDe		:= "" 
	Default cLojaAte	:= ""

	cQuery	:= " SELECT A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, R_E_C_N_O_ RECSA1 FROM "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD BETWEEN '"+cCliDe+"' AND '"+cCliAte+"' "+CRLF
	cQuery	+= " AND SA1.A1_LOJA BETWEEN '"+cLojaDe+"' AND '"+cLojaAte+"' "+CRLF
	cQuery	+= " AND SA1.A1_GRPVEN = '' "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cArqTmp)->( DbGoTop() )

	ProcRegua(nCnt)

	While (cArqTmp)->(!Eof())

		IncProc("Processando...")
		
		//Realiza a cria��o do grupo e a atualiza��o do cadastro do cliente
		GrvGrpCli((cArqTmp)->A1_NREDUZ, (cArqTmp)->RECSA1)

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GrvGrpCli		�Autor  �Microsiga		 � Data �  30/05/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava o rupo de cliente									  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvGrpCli(cNomeGrp, nRecSa1)

	Local aArea 	:= GetArea()
	Local cCodGrp	:= ""

	Default cNomeGrp 	:= ""
	Default nRecSa1		:= 0

	If !Empty(cNomeGrp) .And. nRecSa1 != 0
		cCodGrp := GetSx8Num("ACY","ACY_GRPVEN")
		ConfirmSX8()
		
		//Cria��o do grupo
		DbSelectArea("ACY")
		DbSetOrder(1)

		RecLock("ACY",.T.)
		ACY->ACY_GRPVEN := cCodGrp
		ACY->ACY_DESCRI	:= cNomeGrp
		ACY->ACY_ORIGRV	:= "PZCVA004"
		ACY->ACY_YDTINC	:= MsDate()
		ACY->ACY_YHORA 	:= Time()
		ACY->ACY_YCODUS	:= Alltrim(RetCodUsr())
		ACY->(MsUnLock())
		
		//Atualiza��o do cadastro do cliente
		DbSelectArea("SA1")
		DbSetOrder(1)
		SA1->(DbGoTo(nRecSa1))
		
		RecLock("SA1",.F.)
		SA1->A1_GRPVEN := cCodGrp
		SA1->(MsUnLock())
		
		
	EndIf

	RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PergRetFil	�Autor  �Microsiga	     � Data �  27/05/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Perguntas a serem utilizadas no filtro				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PergRetFil(aParams)

	Local aParamBox := {}
	Local lRet      := .T.
	Local cLoadArq	:= "PzCva004"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt) 

	AADD(aParamBox,{1,"Cliente de"	,Space(TAMSX3("A1_COD")[1])		,"" ,"","SA1","",50,.F.})
	AADD(aParamBox,{1,"Cliente At�"	,Space(TAMSX3("A1_COD")[1])		,"" ,"","SA1","",50,.T.})
	AADD(aParamBox,{1,"Loja de"		,Space(TAMSX3("A2_LOJA")[1])	,""	,"","","",30,.F.})
	AADD(aParamBox,{1,"Loja at�"	,Space(TAMSX3("A2_LOJA")[1])	,""	,"","","",30,.T.})

	lRet := ParamBox(aParamBox, "Par�metros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet
