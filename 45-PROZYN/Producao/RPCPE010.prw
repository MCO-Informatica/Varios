#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao	 � RPCPE005 � Autor � Adriano Leonardo    � Data � 18/10/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para gera��o de combina��o simples sem repeti��o.   ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn               			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RPCPE010(_aItens)

Default _aItens 	:= {}
Private _nCont		:= 1
Private _nPermut	:= Len(_aItens)
Private _nColAtu	:= Len(_aItens)
Private _lZerar		:= .F.
Private _aCombin 	:= {}
Private _aPosAux	:= {} 
Private _aElemen	:= _aItens

Processa( {||GerarComb()}, "Aguarde...", "Definindo a melhor sequ�ncia...",.F.)

Return(_aCombin)

Static Function GerarComb()

Local _nCont	:= 0
Local _nColAux	:= 0

//Avalio a quantidade de combina��es esperadas
For _nCont := Len(_aElemen)-1 To 2 Step(-1)
	_nPermut := _nPermut * _nCont
Next

//In�cio array para controle de posicionamento dos elementos para la�o de repeti��o
For _nCont := 1 To Len(_aElemen)
	AAdd(_aPosAux,1)
Next

ProcRegua(_nPermut)
	
While Len(_aCombin)<_nPermut
	For _nCont := Len(_aPosAux) To 1 Step(-1)
		If _aPosAux[_nCont]<Len(_aPosAux)
			_aPosAux[_nCont]++
			
			If _lZerar
				_lZerar := .F.
				
				For _nColAux := _nCont+1 To Len(_aPosAux)
					_aPosAux[_nColAux] := 1
									
					If ValidComb()
						AAdd(_aCombin,aClone(_aPosAux))
				 		IncProc("Gerando combina��o " + AllTrim(Str(Len(_aCombin))) + " de " + AllTrim(Str(_nPermut)))
					EndIf
				Next
				
				Exit
				
			ElseIf _aPosAux[_nCont]==Len(_aPosAux)
				_lZerar := .T.
				
				If ValidComb()
					AAdd(_aCombin,aClone(_aPosAux))
			 		IncProc("Gerando combina��o " + AllTrim(Str(Len(_aCombin))) + " de " + AllTrim(Str(_nPermut)))
				EndIf
			ElseIf ValidComb()
				AAdd(_aCombin,aClone(_aPosAux))
		 		IncProc("Gerando combina��o " + AllTrim(Str(Len(_aCombin))) + " de " + AllTrim(Str(_nPermut)))				
			EndIf
			
			Exit
			
		EndIf
	Next
EndDo
Return()

Static Function ValidComb()

Local _lRet 	:= .T.
Local _aValid 	:= {}
Local _nPos		:= 1

For _nPos := 1 To Len(_aPosAux)
	If aScan(_aValid,_aPosAux[_nPos])==0
		AAdd(_aValid,_aPosAux[_nPos])
	EndIf
Next

If Len(_aValid)<>Len(_aPosAux) .Or. ExistArr()
	_lRet := .F.
EndIf

Return(_lRet)

Static Function ExistArr()

	Local _lRet		:= .F.	
	Local _nQtdIg	:= 0
	Local _nZ		:= 0
	Local _nY		:= 0
	
	For _nY := 1 To Len(_aCombin)
		
		 _nQtdIg := 0
		
	   For _nZ := 1 To Len(_aCombin[_nY])
	   	If _aPosAux[_nZ]==_aCombin[_nY][_nZ]
	   		_nQtdIg++
	   	EndIf
		Next
	Next
	
	If _nQtdIg == Len(_aPosAux)
		_lRet := .T.
	EndIf
	
Return(_lRet)