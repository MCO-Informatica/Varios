#Include 'Protheus.ch'

#Define ENTER Chr(13) + Chr(10)

/*
* Funcao		:	PCOA0502
* Autor			:	Jo�o Zabotto
* Data			: 	24/03/2014
* Descricao		:	Analise de divergencia dos movimentos gerados como invalidos
* Retorno		: 	
*/
User Function PCOA0502
	Local aBotao := {}

	AADD(aBotao,{"#Divergencia",{|| ZDIVERG()},'#Divergencia'})

Return (aBotao)

/*
* Funcao		:	ZDIVERG
* Autor			:	Jo�o Zabotto
* Data			: 	24/03/2014
* Descricao		:	Executa analise por entidade do PCO
* Retorno		: 	
*/
Static Function ZDIVERG()
	Local nPosID := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_ID"})
	Local nPosCO := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_CO"})
	Local nPosCC := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_CC"})
	Local nPosIT := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_ITCTB"})
	Local nPosCV := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_CLVLR"})
	Local nPosCL := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_CLASSE"})
	Local nPosTP := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_TPSALD"})
	Local nPosOP := Ascan(oGdAKD:aHeader,{|X| Upper(AllTrim(X[2]))=="AKD_OPER"})
	Local lRet   := .T.

	AK5->(DbSetOrder(1))
	AK6->(DbSetOrder(1))
	CTT->(DbSetOrder(1))

	For nX:= 1 To Len(oGdAKD:aCols)

		&& Conta or�ament�ria
		IF  !Empty(oGdAKD:aCols[nX,nPosCO])
			If AK5->(DbSeek(xFilial('AK5') + oGdAKD:aCols[nX,nPosCO]))
				If AK5->AK5_MSBLQL = '1'
					Aviso('Conta Or�ament�ria', 'Conta Or�ament�ria Bloqueada: ' + Alltrim(oGdAKD:aCols[nX,nPosCO]) + ENTER + 'Linha: '  + oGdAKD:aCols[nX,nPosID],{'OK'})
					Return .F.
				EndIF
			Else
				Aviso('Conta Or�ament�ria', 'Conta Or�ament�ria Invalida: ' + Alltrim(oGdAKD:aCols[nX,nPosCO]) + ENTER +  'Linha: '  + oGdAKD:aCols[nX,nPosID],{'OK'})
				Return .F.
			EndIf
		Else
			Aviso('Conta Or�ament�ria', 'Conta Or�ament�ria N�o Informada: ' + Alltrim(oGdAKD:aCols[nX,nPosCO]) + ENTER +  'Linha: '  + oGdAKD:aCols[nX,nPosID],{'OK'})
			Return .F.
		EndIF
	
		&& Opera��o
		IF  !Empty(oGdAKD:aCols[nX,nPosOP])
			If AKF->(DbSeek(xFilial('AKF') + oGdAKD:aCols[nX,nPosOP]))
				If AKF->AKF_MSBLQL = '1'
					Aviso('IOpera��o', 'Opera��o Bloqueada: ' + Alltrim(oGdAKD:aCols[nX,nPosOP]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
					Return .F.
				EndIF
			Else
				Aviso('Opera��o', 'Opera��o Invalida: ' + Alltrim(oGdAKD:aCols[nX,nPosOP]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
				Return .F.
			EndIf
		EndIF
				
		&& Item Cont�bil
		IF  !Empty(oGdAKD:aCols[nX,nPosIT])
			If CTD->(DbSeek(xFilial('CTD') + oGdAKD:aCols[nX,nPosIT]))
				If CTD->CTD_MSBLQL = '1'
					Aviso('Item Contabil', 'Item Contabil Bloqueada: ' + Alltrim(oGdAKD:aCols[nX,nPosIT]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
					Return .F.
				EndIF
			Else
				Aviso('Item Contabil', 'Item Contabil Invalida: ' + Alltrim(oGdAKD:aCols[nX,nPosIT]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
				Return .F.
			EndIf
		EndIf
		
		&& Classe de Valor
		IF  !Empty(oGdAKD:aCols[nX,nPosIT])
			If CTH->(DbSeek(xFilial('CTH') + oGdAKD:aCols[nX,nPosCV]))
				If CTH->CTH_MSBLQL = '1'
					Aviso('Classe Contabil', 'Classe Contabil Bloqueada: ' + Alltrim(oGdAKD:aCols[nX,nPosCV]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
					Return .F.
				EndIF
			Else
				Aviso('Classe Contabil', 'Classe Contabil Invalida: ' + Alltrim(oGdAKD:aCols[nX,nPosCV]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
				Return .F.
			EndIf
		EndIf
		
		&& Classe Or�ament�ria		
		IF  !Empty(oGdAKD:aCols[nX,nPosCL])
			If AK6->(DbSeek(xFilial('AK6') + oGdAKD:aCols[nX,nPosCL]))
				If AK6->AK6_MSBLQL = '1'
					Aviso('Classe Or�ament�ria', 'Classe Or�ament�ria Bloqueada: ' + Alltrim(oGdAKD:aCols[nX,nPosCL]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
					Return .F.
				EndIF
			Else
				Aviso('Classe Or�ament�ria', 'Classe Or�ament�ria Invalida: ' + Alltrim(oGdAKD:aCols[nX,nPosCL]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
				Return .F.
			EndIf
		Else
			Aviso('Classe Or�ament�ria', 'Classe Or�ament�ria N�o Informada: ' + Alltrim(oGdAKD:aCols[nX,nPosCL]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
			Return .F.
		EndIf

		&& Centro de Custo
		IF  !Empty(oGdAKD:aCols[nX,nPosCC])
			If CTT->(DbSeek(xFilial('CTT') + oGdAKD:aCols[nX,nPosCC]))
				If CTT->CTT_BLOQ = '1'
					Aviso('Centro Custo', 'Centro Custo Bloqueado: ' + Alltrim(oGdAKD:aCols[nX,nPosCC]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
					Return .F.
				EndIF
			Else
				Aviso('Centro Custo', 'Centro Custo Invalido: ' + Alltrim(oGdAKD:aCols[nX,nPosCC]) + ENTER + 'Linha: '  + oGdAKD:aCols[nX,nPosID],{'OK'})
				Return .F.
			EndIf
		EndIf

		&& Tipo de Saldo
		IF  !Empty(oGdAKD:aCols[nX,nPosTP])
			If AL2->(DbSeek(xFilial('AL2') + oGdAKD:aCols[nX,nPosTP]))
				If AL2->AL2_MSBLQL = '1'
					Aviso('Tipo Saldo', 'Tipo Saldo Bloqueado: ' + Alltrim(oGdAKD:aCols[nX,nPosTP]) + ENTER + 'Linha: ' + oGdAKD:aCols[nX,nPosID],{'OK'})
					Return .F.
				EndIF
			Else
				Aviso('Tipo Saldo', 'Tipo Saldo Invalido: ' + Alltrim(oGdAKD:aCols[nX,nPosCC]) + ENTER + 'Linha: '  + oGdAKD:aCols[nX,nPosID],{'OK'})
				Return .F.
			EndIf
		EndIf

	Next

	If lRet
		Aviso('Diverg�ncia', 'N�o Existe diverg�ncias nos lan�amentos ',{'OK'})
	EndIf


Return

	
