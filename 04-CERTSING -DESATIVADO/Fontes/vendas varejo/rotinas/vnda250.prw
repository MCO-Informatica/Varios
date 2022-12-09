#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch" 
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef  � Autor �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Descricao � Modelo de dados para inclus�o de arquivo Cnab nas tabelas  ���
���          � de log                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������  
/*/
Static Function ModelDef()

Local oStruCab := FWFormStruct(1,"SZP")      

Local oModel                               

oModel:= MPFormModel():New('INCCNABMVC',,,{|oModel| GravaArq(oModel)})

oModel:AddFields('SZPMASTER',/*owner*/,oStruCab)    

oModel:SetDescription('Cnabs')
oModel:GetModel('SZPMASTER'):SetDescription('Arquivo')  

oModel:SetPrimaryKey( { "ZP_FILIAL", "ZP_ID"} )

oStruCab:SetProperty('ZP_STATUS', MODEL_FIELD_INIT, {||'1'} )  
oStruCab:SetProperty('ZP_ID', MODEL_FIELD_INIT, { || GetSx8SZP('SZP','ZP_ID') } )

Return oModel

Static Function GetSx8SZP(cAliasSZP,cCpoSZP)
Local cRet:= ""

cRet := GetSx8Num(cAliasSZP,cCpoSZP)  
confirmSx8()

DbSelectArea("SZP")
SZP->(DbSetOrder(1)) 

While SZP->(DbSeek(xFilial("SZP")+cRet)) 
	cRet := GetSx8Num(cAliasSZP,cCpoSZP)  
	confirmSx8()
EndDO

Return(cRet)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   � Autor �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Descricao � Interface para a inclus�o de Cnabs                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������  
/*/   

Static Function ViewDef()

Local oModel := FWLoadModel('VNDA250')   


Local oStruCab := FWFormStruct(2,"SZP")     
 
Local oView 

oView:= FWFormView():New()                           
oView:SetModel(oModel)                               
oView:SetCloseOnOk({|| .T. })

oView:AddField( 'VIEW_CAB', oStruCab, 'SZPMASTER' )        
    
oView:CreateHorizontalBox( 'TELA', 100 )

oView:SetOwnerView( 'VIEW_CAB', 'TELA' )

Return oView                                                                                                                                


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaArq  � Autor �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Descricao � Realiza a Grava��o do cnab na tabela de log                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������  
/*/   

Static Function GravaArq(oModel)

Processa( { || RotProc(oModel) } )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RotProc �Autor  �Microsiga           � Data �  07/17/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RotProc(oModel)
Local xBuffer
Local nHandle
Local nQtdRec := 0
Local nTamArq := 0  
Local cBanco := ""
Local cIdPed := ""                           
Local nTamDet	:= Iif( Empty (SEE->EE_NRBYTES), 400 , SEE->EE_NRBYTES + 2)
Local lRet 		:= .T.
Local cArq		:= oModel:GetValue("SZPMASTER","ZP_ARQUIVO") 
Local cSql		:= ""
Local cIdQry	:= ""
Local cIdCnab	:= ""

If Empty(cArq)           
    Help( , , 'VldCnbOk', , "Obrigat�rio informar um Arquivo", 1, 0)
	lRet := .F.
ElseIf !File(cArq)
		Help( , , 'VldCnbOk', , "Arquivo N�o Encontrado no Diret�rio Informado", 1, 0)
		lRet := .F.
Else
	cSql := " SELECT " 
	cSql += "   ZP_ID " 
	cSql += " FROM " 
	cSql += RetSqlName("SZP") 
	cSql += " WHERE 
	cSql += "   ZP_FILIAL = '"+xFilial("SZP")+"' AND 
	cSql += "   UPPER(ZP_ARQUIVO)  = '"+Upper(cArq)+"' AND
	cSql += "   D_E_L_E_T_ = ' '	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRYSZP",.F.,.T.)
	
	If !QRYSZP->(Eof())
	 	QRYSZP->(DbEval({|| cIdQry += " "+QRYSZP->ZP_ID      }))
	
		Help( , , 'VldCnbOk', , "Arquivo j� utilizado nos seguintes C�digos:"+cIdQry, 1, 0)
		lRet := .F.
		
	EndIf
	
	QRYSZP->(DbCloseArea())

EndIf

If lRet
	nHandle := Fopen(oModel:GetValue('SZPMASTER','ZP_ARQUIVO'))  
	
	FSeek(nHandle,0,0)
	nTamArq:=FSeek(nHandle,0,2)
	FSeek(nHandle,0,0)
	
	nNumSeq:= 0	//Val(Substr(xBuffer,395,400))		//Pos.395 a 400	 ---> Numero sequencial
	
	ProcRegua( Int(nTamArq/nTamDet) )
	
	While .T.
		
		nQtdRec++
		IncProc( "Processando registro "+Alltrim(Str(nQtdRec)) )
		ProcessMessage()
		
		xBuffer:=Space(nTamDet)
		FREADLN(nHandle,@xBuffer,nTamDet)
		
		If Empty(xBuffer)		//Fim do arquivo
			Exit
		EndIf             
		
		If SubStr(xBuffer,1,1) == "1" //Detalhes (trailler)
		
			IF	((cBanco == '341') .and.  (SubStr(xBuffer,109,2) <> "06" .OR. .NOT. (SubStr(xBuffer,83,3) $ "175,176,178" ) ) ) .or.;
				((cBanco == '237') .and. !SubStr(xBuffer,109,2) $ "06|16" )     //06-Liquida��o//16-BAIXA POR FALTA DE PAGAMEMTO
				Loop
			Endif        
			
			If !Empty(Substr(xBuffer,38,25)) .AND. Substr(xBuffer,38,1)<>'0'
				Loop
			Endif
	
			If cBanco == '341'
					cIdPed := Substr(xBuffer,63,08)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10	
			ElseIf cBanco == '237'
					cIdPed := Substr(xBuffer,71,11)					//Numero da GAR gravado no Pedido de Venda (SC5)  C 10
			Endif  
	
			cIdPed := alltrim(str(val(cIdPed)))
			
			cSql := " SELECT "
			cSql += "   ZQ_ID "
			cSql += " FROM "
			cSql += RetSqlName("SZQ")
			cSql += " WHERE "
			cSql += "   ZQ_FILIAL = '"+xFilial("SZQ")+"' AND "
			cSql += "   ZQ_PEDIDO = '"+cIdPed+"' AND "
			cSql += "   D_E_L_E_T_ = ' ' " 
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRYSZQ",.F.,.T.)
		
		    nCount := 0
			While !QRYSZQ->(EoF())
				nCount++
				cIdCnab+= ","+QRYSZQ->ZQ_ID 	    
				QRYSZQ->(DbSkip())
			EndDo
		
			QRYSZQ->(DbCloseArea())
			SZQ->(DbselectArea("SZQ"))
			SZQ->(DbAppend(.F.))
			SZQ->ZQ_LINHA:= strzero(nQtdRec,5)
			SZQ->ZQ_PEDIDO:= cIdPed
			SZQ->ZQ_ID:= oModel:GetValue('SZPMASTER','ZP_ID')
			SZQ->ZQ_DATA := oModel:GetValue('SZPMASTER','ZP_DATA')			
			
			If nCount > 0
				SZQ->ZQ_OCORREN := "Ped. em v�rios arq.: "+cIdCnab
				SZQ->ZQ_STATUS := '5'
			Else
				SZQ->ZQ_STATUS:='1'			
			EndIf			
			
			SZQ->ZQ_HORA:=time()  
			SZQ->(MsUnlock())
	
		Elseif SubStr(xBuffer,1,1) == "0"
		    //Verifica o layout do arquivo validando se o mesmo se refere a rentorno de cobranca                                          
			If Upper(SubStr(xBuffer,3,7)) <> "RETORNO"
				MsgStop("Estrutura do Arquivo n�o se refere a Arquivo de Retorno de Cobran�a."+CRLF+"A importa��o ser� abortada")
			    Return(.F.)
			EndIf
			cBanco := SubStr(xBuffer,77,3)
		
		Endif
	
	Enddo
	
	FWFormCommit(oModel)  
	U_VNDA390(oModel:GetValue('SZPMASTER','ZP_ARQUIVO'), oModel:GetValue('SZPMASTER','ZP_ARQUIVO'), "Arquivo Cnab de Origem" , "SZP";
				, oModel:GetValue('SZPMASTER','ZP_ID') )
	FCLOSE(nHandle)
EndIf

Return(lRet)