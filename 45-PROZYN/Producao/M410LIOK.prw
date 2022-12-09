#Include "Protheus.ch"
#Include "Topconn.ch"           

/*                                      
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410LIOK  �Autor  �Henio Brasil        � Data � 03/05/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto Entrada para tratar se e' permitido gerar (C6_LOCAL)    ���
���          �faturamento no armazem indicado.                            ���
�������������������������������������������������������������������������͹�� 
���Chamada   �MATA410 - Inclusao de Pedido de Vendas                      ���
�������������������������������������������������������������������������͹�� 
���Template  �Validacao de campos no Item do Pedido de Vendas             ���
�������������������������������������������������������������������������͹��
���Empresa   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function M410LIOK() 

	Local lReturn 	:= .T.               
	Local lLocFat	:= .T.   	// Grupo de Armazens habilitados a faturar 
	Local cMensa 	:= "" 
	Local cQuery	:= ""  
	Local cMensag	:= "" 
	Local cAliasDA1 := GetNextAlias()
	Local dHoje		:= Dtos(dDataBase) 
	Local lDeleted	:= aCols[n][Len(aCols[n])]
	Local nPosLoc   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})
	Local nPosPrd   := aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"}) 
	Local cProd 	:= Alltrim((aCols[n][nPosPrd])) 
	Local cFunName	:= Substr(Procname(),3,Len(Procname()))    
	Local aArea     := getArea()
	Local aAreaSA7  := SA7->(getArea())
	Local cArmCq  	:= SuperGetMv('MV_CQ',,"98")

	Private lNbRet := .F.
	Private oDlgPvt
	//Says e Gets
	Private oSayUsr
	Private oGetUsr, cGetUsr := Space(25)
	Private oSayPsw
	Private oGetPsw, cGetPsw := Space(20)
	Private oGetErr, cGetErr := ""
	//Dimens�es da janela
	Private nJanLarg := 200
	Private nJanAltu := 200

	// DbSelectArea("CB7")
	// CB7->(DbSetOrder(2))
	// If CB7->(DbSeek(xFilial("CB7")+SC5->C5_NUM))
	// 	MsgAlert("Este pedido possui ordem de separa��o: "+trim(CB7->CB7_ORDSEP)+", imposs�vel alterar a data de entrega.","Aten��o!")
	// 	Return .F.
	// EndIf

	If Alltrim(aCols[n][nPosLoc]) == Alltrim(cArmCq)
		Help(" ",1,"ARMZCQ",,GetMv("MV_CQ"),2,15)
		Return .F.
	EndIf

	/* 
	�������������������������������������������������������������������Ŀ
	�Valida os armazens digitados para ver se estao haptos a faturar    �
	���������������������������������������������������������������������*/ 
	lLocFat := Posicione("NNR", 1, xFilial("NNR")+aCols[n][nPosLoc],"NNR_XTPFAT")=='1'
	If !lLocFat 
		cMensa := "Este almoxarifado n�o est� habilitado para uso no Faturamento. Em caso de d�vida acione o Administrador!" 
		MsgStop(cMensa,FunName()+" - Valida��o de Almoxarifado")   			
		lReturn := .F. 	
	Endif 		
	/* 
	�������������������������������������������������������������������Ŀ
	�Valida a Moeda dos itens com a Moeda do Cabecalho do Pedido        �
	���������������������������������������������������������������������*/         
	If lReturn
		If !Empty(M->C5_TABELA) .And. !lDeleted
			cQuery:= "SELECT TOP 1 * FROM "+RetSqlName('DA1')+" WHERE DA1_CODTAB = '"+M->C5_TABELA+"' "
			cQuery+= "	 AND DA1_CODPRO = '"+cProd+"' AND DA1_DATVIG <= '"+dHoje+"' AND D_E_L_E_T_ = ' ' ORDER BY DA1_DATVIG DESC "	
			TcQuery cQuery New Alias (cAliasDA1)
			DbSelectArea(cAliasDA1)              
			If (cAliasDA1)->(Eof()) 
				cMensag	:= 'N�o exite tabela de pre�o definida para este produto: '+cProd 
				lReturn := .F. 
			ElseIf (M->C5_MOEDA <> (cAliasDA1)->DA1_MOEDA) 
				cMensag	:= 'Moeda da tabela de precos do produto '+cProd+' , diferente da moeda do Pedido !'
				lReturn := .F. 		  
			Endif 
			If !lReturn 			// .And. !lDeleted	 
				MsgAlert(cMensag,cFunName+" - Valida��o de Tabela de Pre�o")    			
			Endif  
			(cAliasDA1)->(DbCloseArea())
		Endif 
	Endif  




	RestArea(aArea)
	RestArea(aAreaSA7)

Return lReturn 


//fun��o criada para validar o login e comparar com o parametro que identifica se o usuario � um aprovador do ciclo do pedido. 

Static Function fVldUsr()       
	Local cAprCic 	:= SuperGetMv('MV_APRVCL1',,"newbridge") //definir os aprovadores 
	Local cUsrAux := Alltrim(cGetUsr)
	Local cPswAux := Alltrim(cGetPsw)
	Local cCodAux := ""

	//Pega o c�digo do usu�rio
	PswOrder(2)
	If !Empty(cUsrAux) .And. PswSeek(cUsrAux) .And. cUsrAux $ cAprCic //compara com o parametro de aprovadores 
		cCodAux := PswRet(1)[1][1]

		//Agora verifica se a senha bate com o usu�rio
		If !PswName(cPswAux)
			cGetErr := "Senha inv�lida!"
			oGetErr:Refresh()
			Return

			//Sen�o, atualiza o retorno como verdadeiro
		Else
			lNbRet := .T.
		endif

		//Sen�o atualiza o erro e retorna para a rotina
	Else
		cGetErr := "Usu�rio n�o Autorizado!"
		oGetErr:Refresh()
		Return
	EndIf



	//Se o retorno for v�lido, fecha a janela
	If lNbRet
		oDlgPvt:End()
	EndIf
Return


//**** GATILHO RESPONSAVEL POR VALIDAR DIA �TIL NO CAMPO DATA PREV FAT.

USer Function GAT010(dData)      

	dData1:= dData  
	//Verificar dia se � dia util
	dDtValid:= DataValida(dData, .T.)

	If dDtValid <> dData
		IF MSGYESNO("A Data: " + DTOC(dData) + " n�o � dia �til!!! "+ chr(13) + chr(10) + chr(13) + chr(10) +" Pr�ximo dia �til: " + DTOC(dDtValid), "Ciclo do Pedido_01")
			dData1:= dDtValid
			u_PZCVP004(1)
		ELSE
			dData1:= dData
		Endif
	Endif


RETURN dData1


//**** GATILHO RESPONSAVEL POR CONTROLAR A ALTERA��O DO CAMPO DATA PREV FAT.

USer Function GAT011(dData) 

	U_PZCVV004(dData)
	u_PZCVP004()
	// dDant:=SC5->C5_FECENT


	/*IF MSGYESNO(" Deseja Recalcular as Datas do Ciclo do Pedido? ","Ciclo do Pedido_02"  )

		For nW := 1 To len(aCols)                 
			aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_FLIB"})] := "N"   
			aCols[nW,aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LGCICLO"})]:="N"
		Next

	Else

		RETURN dDant

	Endif*/


RETURN dData


//**** GATILHO RESPONSAVEL POR CONTROLAR A INCLUS�O DE NOVAS LINHAS NA ALTERA�O

USer Function GAT012(cProd)      

	cAprCc := SuperGetMv('MV_APROVCL',,"newbridge") 
	cPrzAl := SuperGetMv('MV_PRZALT',,15)



	/*If (SC5->C5_FECENT <= ddatabase + cPrzAl).or.(M->C5_FECENT <= ddatabase + cPrzAl)

		If !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprCc)   
			MsgStop("Esse Pedido est� Fora do Prazo de Alter./Exclus�o,"+ chr(13) + chr(10) +"consulte o Gestor Comercial!","Aten��o_PROD")
			cprod1 := ''
		Else
			cProd1:=cProd
		EndIf
	Else*/

		cProd1:=cProd

	//EndIf

Return(cprod1) 


//**** GATILHO RESPONSAVEL POR CONTROLAR A ALTERA��O DA QUANTIDADE 

USer Function GAT013(nQuant)      

	cAprCc := SuperGetMv('MV_APROVCL',,"newbridge") 
	cPrzAl := SuperGetMv('MV_PRZALT',,15)

	nQant:= SC6->C6_QTDVEN

	/*If (SC5->C5_FECENT <= ddatabase + cPrzAl).or.(M->C5_FECENT <= ddatabase + cPrzAl)

		If !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprCc)   
			MsgStop("Esse Pedido est� Fora do Prazo de Alter./Exclus�o,"+ chr(13) + chr(10) +"consulte o Gestor Comercial!","Aten��o_QTDE")
			nQatu := nQant
		Else
			nQatu:=nQuant
		EndIf
	Else*/

		nQatu:=nQuant

	//EndIf

Return(nQatu) 



//****CALCULO DE DIAS UTEIS CONFORME PRAZO - SUBTRA��O                                                                

User function SubDiaUt(dData,nDias)
	
	Local nCont	:= 0
	
	For nCont:=1 to nDias   
		dData := dData - 1  
		If DataValida(dData,.t.) != dData 
			nCont--
		EndIf
	Next

Return dData

//****CALCULO DE DIAS UTEIS CONFORME PRAZO - SOMA                                                                

User function SumDiaUt(dData,nDias)
	
	Local nCont	:= 0

	For nCont:=1 to nDias
		dData := dData + 1

		If DataValida(dData,.t.) != dData 
			nCont--
		EndIf
	Next

Return dData


