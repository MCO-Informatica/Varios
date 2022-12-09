#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MultIMCD � Autor � Luiz Oliveira      � Data � 25/08/2018  ���
�������������������������������������������������������������������������͹��
���Descricao � Programa inserido no x3_valid do campo C6_QTDVEN      ���
���          � VALIDA��O DE MULTIPLOS BASEADO NO CAMPO B1_QE              ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MultIMCD(nNum)

	Local lRet := .F.
	Local lCodi := " "
	Local cTipo := " "

	IF IsInCallStack("MATA110") .or. IsInCallStack("MATA113")
		cCodPrd := aCols[N,GDFieldPos("C1_PRODUTO")]
	ELSE
		cCodPrd := aCOLS[N,2]
	Endif

	cTipo := POSICIONE("SB1",1,xFilial("SB1") + cCodPrd, "B1_TIPO")

	If cTipo $ "MR/MA"

		lCodi := POSICIONE("SB1",1,xFilial("SB1") + cCodPrd, "B1_LOTEMUL")
		If lCodi > 0
			If nNum % lCodi == 0                  // Deixa passar se for Multiplo
				lRet:= .T.
			Else
				Alert("Quantidade informada n�o � multipla, verifique o cadastro do produto (Quantidade por embalagem)")     // Se nao exibe mensagem ao usuario.
			Endif
		Else
			Alert("N�o existe quantidade por embalagem cadastrada (Quantidade por embalagem)")
		endif
	else
		lRet:=.T.
	endif


Return lRet

User Function MultIMC2(nNum)

	Local lRet := .F.
	Local lCodi := " "
	Local cTipo := " "

	IF IsInCallStack("MATA110") .or. IsInCallStack("MATA113")
		cCodPrd := aCols[N,GDFieldPos("C1_PRODUTO")]
	ELSE
		cCodPrd := aCOLS[N,2]
	Endif

	cTipo := POSICIONE("SB1",1,xFilial("SB1") + cCodPrd, "B1_TIPO")

	If cTipo $ "MR/MA"

		lCodi := POSICIONE("SB1",1,xFilial("SB1") +cCodPrd , "B1_LOTEMUL")

		If lCodi > 0
			If nNum % lCodi == 0                  // Deixa passar se for Multiplo
				lRet:= .T.
			Else
				Alert("Quantidade informada n�o � multipla, verifique o cadastro do produto (Quantidade por embalagem)")     // Se nao exibe mensagem ao usuario.
			Endif
		Else
			Alert("N�o existe quantidade por embalagem cadastrada (Quantidade por embalagem)")     // Se nao exibe mensagem ao usuario.
		endif

	else
		lRet:=.T.
	endif

Return lRet
