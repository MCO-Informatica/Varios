#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch" 
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA060� Autor � Darcio R. Sporl    � Data �  13/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � MVC para o Cadastro de Voucher. A fun��o principal exibe   ���
���          � a lista de cadastro em um FWMBrowse                        ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VNDA060()
	Local oBrowse
	Local cArqLck := ''
	Local nHandle := 0
	Local lContinua := .T.
	Local cSemaforo := ''
	
	cSemaforo := GetPathSemaforo()
	cArqLck := cSemaforo + 'vnda060' + __cUserID + cEmpAnt + ".lck"
	MakeDir( cSemaforo )
	
	If File(cArqLck)
		If (nHandle := FOpen(cArqLck,16)) < 0
			lContinua := .F.
		Endif
	Else
		If ( nHandle := FCreate(cArqLck)) < 0
			lContinua := .F.
		Endif
	Endif
	
	If lContinua
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias("SZF")
		oBrowse:SetDescription('Cadastro de Voucher')
		oBrowse:Activate()
	Else
		MsgAlert( 'Rotina em execut��o pelo usu�rio ' + RTrim( cUserName ) + '.', 'Restri��o de uso - VNDA060' )
	Endif
	FClose( nHandle )
	FErase( cArqLck )
Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef   � Autor �                   � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Modelo de dados para o cadastro de Voucher                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ModelDef()

Local oStruSZF := FWFormStruct(1,"SZF")    
Local oModel  

oModel:= MPFormModel():New('Voucher', , { |oModel| VoucherTOK( oModel )})
oModel:AddFields('SZFMASTER',/*owner*/,oStruSZF)
oModel:SetDescription('Cadastro de Voucher')
oModel:GetModel('SZFMASTER'):SetDescription('Cadastro de Voucher')      
oModel:SetPrimaryKey( { "ZF_FILIAL", "ZF_COD" } )
oModel:SetVldActivate({|oModel| U_VNDA420(__CUSERID)})

Return oModel

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   � Autor �                   � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Interface para o Cadastro de Voucher                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ViewDef()
Local oModel := FWLoadModel('VNDA060')
Local oStruSZF := FWFormStruct(2,"SZF")     
Local oView          
Local nOperation := oModel:GetOperation()

oStruSZF:RemoveField("ZF_QTDFLUX") 
oView:= FWFormView():New()
oView:SetModel(oModel)
oView:SetCloseOnOk({|| .T. })
oView:AddField( 'VIEW_SZF', oStruSZF, 'SZFMASTER' )  

IF nOperation == 1
	oView:AddUserButton( 'Exportar', 'PMSEXCEL', {|oView| ToExcel(oModel)} )
Endif

    
oView:CreateHorizontalBox( 'TELA' , 100 )
oView:SetOwnerView( 'VIEW_SZF', 'TELA' )

Return oView

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   � Autor �                   � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Menu para o cadastro de Voucher                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 

Static Function MenuDef()  

Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'       Action 'VIEWDEF.VNDA060' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'          Action 'VIEWDEF.VNDA060' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'          Action 'VIEWDEF.VNDA060' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'          Action 'VIEWDEF.VNDA060' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Imprimir'         Action 'VIEWDEF.VNDA060' OPERATION 8 ACCESS 0
ADD OPTION aRotina Title 'Gera Banco'       Action 'VIEWDEF.VNDA180' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Consulta Voucher' Action 'VIEWDEF.VNDA480' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Cancela Fluxo'    ACTION 'U_VNDA530()'     OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Can.Ped.Site'     ACTION 'U_VNDA690()'     OPERATION 9 ACCESS 0

Return aRotina              

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VoucherTOK   � Autor �                   � Data �  10/10/11  ���
�������������������������������������������������������������������������͹��
���Descricao � Realiza p�s-valida��o do Voucher                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/       

Static Function VoucherTOK(oModel)

Local lRet := .T.
Local nOperation := oModel:GetOperation() 
Local cPedido	:= oModel:GetValue("SZFMASTER","ZF_PEDIDOV") 
Local cProd		:= oModel:GetValue("SZFMASTER","ZF_PRODEST")  
Local nQtd 		:= oModel:GetValue("SZFMASTER","ZF_QTDFLUX")
Local cCodOrig	:= oModel:GetValue("SZFMASTER","ZF_CODORIG") 
Local aCpoObr	:= {}
Local cCpoLog	:= ""
Local GrpAltVou:= GetNewPar("MV_XALTVOU", "000001" )

DbSelectArea("SZH")
SZH->(DbSetOrder(1))

If SZH->(FieldPos("ZH_CPOVER"))>0 .AND. SZH->(DbSeek(xFilial("SZH")+oModel:GetValue("SZFMASTER","ZF_TIPOVOU") )) .and. !Empty(SZH->ZH_CPOVER)
	aCpoObr := strtokarr(SZH->ZH_CPOVER,",")
    
	For nI:=1 to Len(aCpoObr)
		If Empty( oModel:GetValue("SZFMASTER",aCpoObr[nI]) ) 
			cCpoLog += Alltrim(GetSx3Cache(aCpoObr[nI],"X3_TITULO"))+", "
		EndIf
	Next
	If !Empty(cCpoLog)
		Help( ,, 'VoucherTOK',, 'De Acordo o Tipo do Voucher os seguintes campos s�o obrigat�rios:';
		+CRLF+cCpoLog, 1, 0 ) 
		lRet:=.F.   
	EndIf	
EndIf

If lRet .and. !Empty(cPedido)
	 SG1->(DbSetOrder(1)) //G1_FILIAL+G1_COD+G1_COMP+G1_TRT
	 SC5->(DbSetOrder(1)) //C5_FILIAL+C5_NUM
	 SC6->(DbSetOrder(2)) //C6_FILIAL+C6_PRODUTO+C6_NUM+C6_ITEM   
	 
	 If SC5->(DbSeek(xFilial("SC5")+cPedido))
		 If SG1->(DbSeek(xFilial("SG1")+cProd))
		 	While !SG1->(EoF()) .and. SG1->(G1_FILIAL+G1_COD) == xFilial("SG1")+cProd
			 	
			 	If SC6->(DbSeek(xFilial("SC6")+SG1->G1_COMP+cPedido))
			     	If nQtd <> SC6->C6_QTDVEN .AND. !SC5->C5_XORIGPV $ "1,4,5,6"
			     		Help( , , 'VoucherTOK', , "Quantidade informada no Pedido diferente da Quantidade do Fluxo considerando Kit. Por favor, verifique os produtos da estrutura junto ao Pedido.", 1, 0)
					    lRet := .F.
			     	EndIf
			     ElseIf SC5->C5_EMISSAO > StoD('20130410')
			     	Help( , , 'VoucherTOK', , "N�o foi Encontrado Pedido+Produto informado no Voucher considerando Kit. Por favor, verifique os produtos da estrutura junto ao Pedido.", 1, 0)
				    lRet := .F.
			     EndIf
			 	SG1->(DbSkip())
			 	
		 	EndDo
		 Else	     
		     If SC6->(DbSeek(xFilial("SC6")+cProd+cPedido))
		     	If nQtd <> SC6->C6_QTDVEN .AND. !SC5->C5_XORIGPV $ "1,4,5,6"
		     		Help( , , 'VoucherTOK', , "Quantidade informada no Pedido diferente da Quantidade do Fluxo", 1, 0)
				    lRet := .F.
		     	EndIf
		     Else
		     	Help( , , 'VoucherTOK', , "N�o foi Encontrado Pedido+Produto informado no Voucher. Por favor, verifique.", 1, 0)
			    lRet := .F.
		     EndIf
		 EndIf
	 Else
		Help( , , 'VoucherTOK', , "N�o foi Encontrado Pedido informado no Voucher. Por favor, verifique.", 1, 0)
	    lRet := .F.
	 EndIf
EndIf

If lRet
	//Validacao que impede alteracao por usuario diferente do que gerou o banco
	If nOperation == MODEL_OPERATION_UPDATE .AND. Alltrim(__CUSERID) <> Alltrim(oModel:GetValue('SZFMASTER','ZF_USERCOD'))
		
		DbSelectArea("SZO")
		SZO->(DbSetOrder(1))
		
		If SZO->(DbSeek(xFilial("SZO")+Alltrim(__CUSERID) )) .AND. SZO->ZO_EQATEND $ GrpAltVou 
	
			aRet := U_VNDA440()
	
			If !aRet[1]
				Help( , , 'VoucherTOK', , aRet[2], 1, 0)
			EndIf
			lRet := aRet[1] 
		
		Else
			Help( ,, 'VoucherTOK',, 'Usu�rio sem permiss�o para alterar o Voucher.';
					+' Apenas o usu�rio que criou o Voucher poder� alter�-lo', 1, 0 ) 
			lRet:=.F.
		EndIf
		
	ElseIf nOperation == MODEL_OPERATION_UPDATE .AND. Alltrim(__CUSERID) == Alltrim(oModel:GetValue('SZFMASTER','ZF_USERCOD'))
		aRet := U_VNDA440()
	
		If !aRet[1]
			Help( , , 'VoucherTOK', , aRet[2], 1, 0)
		EndIf
	
		Return(aRet[1])
		
	ElseIf nOperation == MODEL_OPERATION_DELETE 
	
		If Alltrim(__CUSERID) <> Alltrim(oModel:GetValue('SZFMASTER','ZF_USERCOD'))
		
			Help( ,, 'VoucherTOK',, 'Usu�rio sem permiss�o para excluir o Voucher.';
					+' Apenas o usu�rio que criou o Voucher poder� exclu�lo-lo', 1, 0 ) 
			lRet:=.F.   
		Else
			M->ZF_ATIVO	:= "N"
			
			aRet := U_VNDA440()
			
			If !aRet[1]
				Help( , , 'VoucherTOK', , aRet[2], 1, 0)
			EndIf
			
			Return(aRet[1])
		EndIf
	EndIf
	
EndIf

//Caso exista c�digo de voucher de origem
//bloqueia o mesmo
If lRet .and. !Empty(cCodOrig)
	lRet := U_VNDA520(cCodOrig)
EndIf

Return lRet
   
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VoucherGRV  � Autor �                   � Data �  10/10/11  ���
�������������������������������������������������������������������������͹��
���Descricao � Grava Voucher                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/       

Static Function VoucherGRV (oModel)    

Local nOperation := oModel:GetOperation()
Local cNumvou := oModel:GetValue("SZFMASTER","ZF_COD")
Local cNumFlu := oModel:GetValue("SZFMASTER","ZF_CODFLU")

FWFormCommit(oModel)
SZF->(CONFIRMSX8())  

If nOperation == MODEL_OPERATION_INSERT .or. nOperation == MODEL_OPERATION_UPDATE
	IF MSgYesNo("Deseja Exportar o arquivo de Voucher para Excel ???", "Exporta��o Excel")  	

		u_VNDA470(cNumFlu,cNumvou)
	Endif
Endif

Return(.T.)
      
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ToExcel   � Autor �                   � Data �  10/10/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Implementacao do Botao que exporta para Excel              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 

Static Function ToExcel(oModel)    

If MSGYESNO("Deseja Gerar Excel de todos Vouchers do Fluxo", "Exporta��o Excel")
	u_VNDA470(oModel:GetValue("SZFMASTER","ZF_CODFLU"))
Else 
	u_VNDA470(oModel:GetValue("SZFMASTER","ZF_CODFLU"),oModel:GetValue("SZFMASTER","ZF_COD"))
Endif

Return