#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF010TOK  �Autor  �                				20/05/2015���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validar utilzia��o de campo Codigo de ���
��           �Imobilziado em Curso                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AF010TOK()

Local _lRet     := .T.
Local _cTipo    := ''
Local aAlias	:= GetArea()
Local aSN1Alias	:= GetArea('SN1')
Local aSN3Alias := GetArea('SN3')
Local aSN2Alias := GetArea('SN2')
Local I := 0          
Local aHeader := {}
Local aCols   := {}
Local _nPosPIC := ''
Local _nPosTIP := '' 

//Local aAlias	:= GetArea()
//Depois de aplica��o de patch do Documento de Entrada o ponto de entrada AF010TOK, passou a ser chamado....
//Para n�o dar error.log na Rotina de Inclus�o de Notas de Entrada, foi criado o IF abaixo....
//Adicionado IF dia 27/04/2018
If !ISINCALLSTACK("MATA103") 
	_nPosPIC := Ascan(aHeader,{|x| ALlTrim(x[2]) == "N3_XPROJIM"} )
	_nPosTIP := Ascan(aHeader,{|x| ALlTrim(x[2]) == "N3_TIPO"} )
	
	For I := 1 to Len(aCols)
		If !aCols[I,Len(aHeader)+1]
			If !Empty(aCols[I,_nPosPIC]) .AND. aCols[I,_nPosTIP] <> "03"
				DbSelectArea("SX5")
				DbSetOrder(1)
				If MsSeek(xFilial("SX5")+"G1"+aCols[I,_nPosTIP])
					_cTipo := SX5->X5_DESCRI
				EndIf
				
				If !Empty(_cTipo)
					MsgInfo("Este bem � um Imobilizado em Curso, seu tipo de classifica��o deve ser '03-Imob. em Curso' e est� tentando classificar como: "+aCols[n,_nPosTIP]+" - "+_cTipo+"!!!")
					_lRet := .F.
				Else
					MsgInfo("Este bem � um Imobilizado em Curso, seu tipo de classifica��o deve ser '03-Imob. em Curso'!")
					_lRet := .F.
				EndIf
				
			EndIf
			//Adicionado condi��o dia 19/06/2015
			If Empty(aCols[I,_nPosPIC]) .AND. aCols[I,_nPosTIP] = "03"
				DbSelectArea("SX5")
				DbSetOrder(1)
				If MsSeek(xFilial("SX5")+"G1"+aCols[I,_nPosTIP])
					_cTipo := SX5->X5_DESCRI
				EndIf
				
				If !Empty(_cTipo)
					MsgInfo("Este bem n�o � um Imobilizado em Curso, seu tipo de classifica��o deve ser '03-Imob. em Curso' e est� tentando classificar como: "+aCols[n,_nPosTIP]+" - "+_cTipo+"!!!")
					_lRet := .F.
				Else
					MsgInfo("Este bem n�o � um Imobilizado em Curso, seu tipo de classifica��o deve ser '03-Imob. em Curso'!")
					_lRet := .F.
				EndIf
				
			EndIf
			//Final da Adi��o
			
		EndIf
	Next
	
EndIf

RestArea( aSN2Alias )
RestArea( aSN3Alias )
RestArea( aSN1Alias )
RestArea( aAlias )

Return(_lRet)