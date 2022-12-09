#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFAT001   ºAutor  ³Alexandre Sousa     º Data ³  08/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o proximo numero de contrato disponivel no sistema. º±±
±±º          ³utilizando a regra das empresas cadastradas.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AFAT001()

	c_Ret := ''
	c_Ano := SubStr(DtoS(dDataBase), 3, 2)
	
	DbSelectArea('SM0')

	//If SM0->M0_CODIGO = '01' .and. SM0->M0_CODFIL = '04' //LISONDA
	//substituida linha acima pela abaixo [Mauro Nagata, 20160928]
	//lisonda alphaville foi desativada filial = 04
	If SM0->M0_CODIGO = '01' .and. SM0->M0_CODFIL = '01' //LISONDA
		c_Ret := FGEN003('CTT', 'CTT_CUSTO', " CTT_CUSTO like '"+c_Ano+"L%' ", 6)
		If c_Ret = '000001'
			c_Ret = c_Ano+'L001'
		EndIf
	ElseIf SM0->M0_CODIGO = '01' .and. SM0->M0_CODFIL = '02' //PLAYPISO
		c_Ret := FGEN003('CTT', 'CTT_CUSTO', " CTT_CUSTO like '"+c_Ano+"P%' ", 6)
		If c_Ret = '000001'
			c_Ret = c_Ano+'P001'
		EndIf
	Else //LISONDA RJ
		c_Ret := FGEN003('CTT', 'CTT_CUSTO', " CTT_CUSTO like '"+c_Ano+"R%' ", 6)
		If c_Ret = '000001'
			c_Ret = c_Ano+'R001'
		EndIf
	EndIf


Return c_Ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGEN003   ºAutor  ³Alexandre Martins   º Data ³  09/26/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o proximo numero do alias informado.               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FGEN003(c_Alias, c_campo, c_where, n_tam)

	Local c_Ret   := ""
	Local c_query := ""
	Local n_taman := Iif(n_tam=nil, 0, n_tam)
	Local a_Area  := GetArea()
	Local a_AreaX3:= SX3->(GetArea())

	c_where 	  := Iif(c_where=Nil, '', c_where)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o tamanho do campo              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If n_taman = 0
		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek(c_campo)
		n_taman := SX3->X3_TAMANHO
	EndIf

	c_query := "select max(" + c_campo + ") as NUM from "+RetSqlName(c_Alias)+" where D_E_L_E_T_ <> '*'"
	If !Empty(c_where)
		c_query += " and " + c_where
	EndIf

	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	
	TcQuery c_Query New Alias "QRY"

	If QRY->(EOF()) .or. Empty(QRY->NUM)
		c_Ret 	:= StrZero(1,n_taman)
	Else
		c_Ret	:= substr(QRY->NUM,1,3) + StrZero(val(substr(QRY->NUM,4,3))+1,3)
	EndIf

	RestArea(a_AreaX3)
	RestArea(a_Area)
	
Return c_Ret
