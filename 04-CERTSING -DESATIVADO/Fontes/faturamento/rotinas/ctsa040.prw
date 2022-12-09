#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA040   �Autor  �Opvs (David)        � Data �  22/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para Cadastros de Concorrentes na Oportunidade       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTSA040(nOpc)
Local oDlg
Local aButtons	:= {}
Local aCampos	:= {}
Local nI		:= 0
Local nUsado	:= 0
Local aSize		:= {}
Local aObjects	:= {}
Local aPosObj	:= {}
Local aInfo		:= {}
Local aButtons	:= {}
//Local aHeaderAnt:= aClone(aHeader)
//Local aColsAnt	:= aClone(aCols)
Local aYesFields	:= {}	
Local oModelx 		:= FWModelActive() //Abre o modelo ativo MVC
Local oModelxDet 	:= oModelx:GetModel('AD3DETAIL') //Abre o aCols do MVC
Local aHeaderAnt 	:= oModelxDet:GetOldData()[1]
Local aColsAnt		:= oModelxDet:GetOldData()[2]
Local nCols			:= 0
Local nCpos			:= 0

Private oMsGetD 	
Private _nPosCon   := Ascan(aHeaderAnt,{|x| x[2] = "AD3_CODCON" })
Private _nPosDesCon:= Ascan(aHeaderAnt,{|x| x[2] = "AD3_NOMCON" })

//Tratamento para "criar" o aCols, pois a fun��o GetOldData retorna o aCols vazio.
If Len(aColsAnt) == 0
	
	//Pega o numero de linhas do "aCols"
	For nCols := 1 To oModelxDet:Length()
		
		//Insere uma "linha" no aCols
		aAdd(aColsAnt, {})
		
		//Alimenta os campos baseado no aHeader
		For nCpos := 1 To Len(aHeaderAnt)
			aAdd(aTail(aColsAnt), oModelxDet:GetValue(aHeaderAnt[nCpos][2], nCols))
		Next nCpos
		
		//Campo de controle de linha deletada do aCols
		aAdd(aTail(aColsAnt), .F.)
	Next nCols
	l
EndIf

aHeader	:= {}
aCols	:= {}

aSize 	:= MsAdvSize()

AaDd(aObjects, {50,50,.t.,.t.})

aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aPosObj := MsObjSize(aInfo,aObjects)

aadd(aYesFields,"U2_COD")
aadd(aYesFields,"U2_PRECO")
aadd(aYesFields,"U2_OBS")
aadd(aYesFields,"U2_CODOPOR")
aadd(aYesFields,"U2_XCODCON") 

cAlias1 	:= "SU2"
nSavRegSOL	:= SU2->(Recno())
//cSeek		:= xFilial("SU2")+M->AD1_NROPOR+oGetDad2:aCols[oGetDad2:nAt,_nPosCon]
cSeek		:= xFilial("SU2") + M->AD1_NROPOR + oModelxDet:GetValue("AD3_CODCON", oModelxDet:nLine) //aColsAnt[oModelxDet:nLine,_nPosCon]
cWhile		:= "SU2->(U2_FILIAL+U2_CODOPOR+U2_XCODCON)"                                                            	

dbSelectArea("SU2")
SU2->( DbOrderNickName("CRM1") )		

FillGetDados(4,cAlias1,SU2->(INDEXORD()),cSeek,{|| &cWhile },{|| .T. },/*aNoFields*/,aYesFields,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/)

DEFINE MSDIALOG oDlg TITLE "Oportunidade x Concorrente x Produto" FROM 0,0 TO aSize[6], aSize[5] OF oMainWnd PIXEL

EnchoiceBar(oDlg,{|| IIF(CTSA40GRV(oMsGetD,oModelxDet),oDlg:End(),.F.) },{|| oDlg:End() },,aButtons)

oMsGetD := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],GD_INSERT+GD_DELETE+GD_UPDATE,"u_CTSA040OK()","u_CTSA040OK()",,,,4096,"u_CTSA040COK()",,,oDlg,aHeader,aCols)

ACTIVATE MSDIALOG oDlg

/*aHeader	:= aHeaderAnt
aCols	:= aColsAnt*/	

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA40GRV �Autor  �Opvs (David)        � Data �  22/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CTSA40GRV(oMsGetD, oModelxDet)

Local cLog		:= ""
Local nI		:= 0
Local nPosProd	:= Ascan(oMsGetD:aHeader,{|x| x[2] = "U2_COD" }) 
Local nPosPrec	:= Ascan(oMsGetD:aHeader,{|x| x[2] = "U2_PRECO" }) 
Local nPosObs	:= Ascan(oMsGetD:aHeader,{|x| x[2] = "U2_OBS" }) 

aCols := aClone(oMsGetD:aCols)
//�����������������������������������������������������������������������������������������Ŀ
//�Aqui comeca a gravacao dos dados depois de validar se as informacoes estao todas corretas.�
//��������������������������������������������������������������������������������������������
Begin Transaction
	// Define a ordem para o seek dentro do loop abaixo
	SU2->( DbOrderNickName("CRM1") )		
	
	For nI := 1 To Len(aCols)
		
		// Se o registro foi deletado no browser, verifica se acha na base pra deletar tambem
		If aCols[nI][Len(aCols[nI])]
			If SU2->( MsSeek( xFilial("SU2")+M->AD1_NROPOR + oModelxDet:GetValue("AD3_CODCON", oModelxDet:nLine) + aCols[nI,nPosProd] ) )
				SU2->( RecLock("SU2",.F.) )
					SU2->( DbDelete() )
				SU2->( MsUnLock() )
			Endif
			Loop
		Endif
		
		// Se o registro eh valido no browser e achar na base ele altera, senaum ele inclui
		SU2->( MsSeek( xFilial("SU2") + M->AD1_NROPOR + oModelxDet:GetValue("AD3_CODCON", oModelxDet:nLine) + aCols[nI,nPosProd] ) )
		SU2->( RecLock( "SU2", SU2->(!Found()) ) )
		
			SU2->U2_FILIAL	:= xFilial("SU2")
			SU2->U2_CODOPOR	:= M->AD1_NROPOR
			SU2->U2_XCODCON	:= oModelxDet:GetValue("AD3_CODCON", oModelxDet:nLine)
			SU2->U2_COD		:= aCols[nI,nPosProd]
			SU2->U2_PRECO	:= aCols[nI,nPosPrec]
			MSMM(,TAMSX3("U2_OBS")[1],,aCols[nI,nPosObs],1,,,"SU2","U2_CODOBS")
			SU2->U2_CONCOR	:= SU2->U2_CODOPOR + "-" + SU2->U2_XCODCON + "-" + oModelxDet:GetValue("AD3_NOMCON", oModelxDet:nLine)
		
		SU2->( MsUnLock() )
		
	Next
	
End Transaction

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA040OK �Autor  �Opvs (David)        � Data �  23/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTSA040OK

Local nGDLin := oMsGetD:nAt
Local nGDCol := 1
Local lRet := .T.

//Valida campos obrigatorios do MsNewGetDados
For nGDCol:=1 To Len(oMsGetD:aHeader)
	If X3OBRIGAT(oMsGetD:aHeader[nGDCol,2]) .And. Empty(oMsGetD:aCols[nGDLin,nGDCol])
		lRet := .F.
		Help(" ",1,"OBRIGAT2",,AllTrim(RetTitle(oMsGetD:aHeader[nGDCol,2])),3,1)
		nGDCol:=Len(oMsGetD:aHeader)
	EndIf
Next nGDCol

Return(lRet)     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA040COk�Autor  �Opvs (David)        � Data �  09/23/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTSA040COk()

Local nGDLin := oMsGetD:nAt
Local nGDCol := oMsGetD:oBrowse:ColPos
Local cGDCpo := &("M->"+oMsGetD:aHeader[nGDCol,2])
Local cVCpos := "U2_COD/U2_CODOPOR/U2_XCODCON"
Local nConta := 1
Local lRet := .T.

//Trava altera��o caso arquivo deletado
If oMsGetD:aCols[nGDLin,Len(oMsGetD:aHeader)+1] .And. lRet
	lRet := .F.
	Help(" ",1,"HELP","PROIBIDO","Restaurar Linha para depois alterar",3,1) //"PROIBIDO"##"Favor restaurar linha exclu�da para "##"depois alterar."
Endif

//Valida duplicidade de alguns campos do MsNewGetDados
//conforme definido acima na variavel cVCpos
If AllTrim(oMsGetD:aHeader[nGDCol,2]) $ cVCpos .And. lRet
	For nConta:=1 To Len(oMsGetD:aCols)
		If nConta != nGDLin
			If AllTrim(cGDCpo) == AllTrim(oMsGetD:aCols[nConta,nGDCol])
				lRet := .F.
				Help(" ",1,"EXISTE",,"Ja existe registro com esse Produto",3,1) //"J� existe um registro com esta "##"informa��o!"
				nConta := Len(oMsGetD:aCols)
			EndIf
		EndIf
	Next nConta
EndIf

Return(lRet)