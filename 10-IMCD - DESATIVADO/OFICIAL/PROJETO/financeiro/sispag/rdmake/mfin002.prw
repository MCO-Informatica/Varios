/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFIN002   บAutor  ณMarcos J.           บ Data ณ  12/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para gerar arquivo TXT p/envio ao EQUIFAX           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
#include "PROTHEUS.CH" 
#include "TOPCONN.CH"
User Function MFIN002()
	Local cPerg   	:= "MFIN002"
	Local nOpca 	:= 0
	Local aSays		:= {}
	Local aButtons	:= {}
	Local aArea		:= GetArea()
	Local cCadastro	:= "Exporta็ใo de dados para o EQUIFAX"
	Local aHelp     := {}

	aAdd(aSays, "Esta rotina gera um arquivo texto, com a finalidade de enviar")
	aAdd(aSays, "informa็๕es sobre os clientes para a EQUIFAX.")
	aAdd(aSays, "Os dados serใo gerados de acordo com os parโmetros informados")
	aAdd(aSays, "pelo usuแrio.")

	aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	aAdd(aButtons, { 1,.T.,{|o| nOpca := 1 , o:oWnd:End()}} )
	aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1
		Pergunte(cPerg, .F.)
		Processa({||MFI02GER()})
	EndIf
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMFIN002   บAutor  ณMicrosiga           บ Data ณ  01/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar arquivo texto para envio ao SERASA                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MFI02GER()
	Local cFile  := Alltrim(MV_PAR04)
	Local cTexto := ""
	Local cQuery := ""
	Local cEof   := Chr(13) + Chr(10)

	cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_VALLIQ, E1_BAIXA,"
	cQuery += " A1_PESSOA, A1_CGC, A1_NOME, A1_NREDUZ, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, A1_DDD, A1_TEL, A1_FAX, A1_EMAIL, A1_PRICOM"
	cQuery += " FROM " + RetSqlName("SE1") + " SE1"
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1"
	cQuery += "   ON A1_FILIAL = '" + xFilial("SA1") + "'"
	cQuery += "  AND A1_COD = E1_CLIENTE"
	cQuery += "  AND A1_LOJA = E1_LOJA"
	cQuery += "  AND SA1.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
	cQuery += "   AND E1_BAIXA >= '" + Dtos(MV_PAR01) + "'"
	cQuery += "   AND E1_BAIXA <= '" + Dtos(MV_PAR02) + "'"
	cQuery += "   AND E1_TIPO NOT IN " + FormatIn(MVABATIM, "|") 
	cQuery += "   AND E1_TIPO <> 'RA '"

	If MV_PAR03 == 1
		cQuery += "   AND A1_PESSOA = 'J'"
	Else
		cQuery += "   AND A1_PESSOA = 'F'"
	EndIf

	cQuery += "   AND SE1.D_E_L_E_T_ <> '*'"
	cQuery += " ORDER BY E1_FILIAL, E1_CLIENTE, E1_LOJA"
	cQuery := ChangeQuery( cQuery )
	DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery ), "TRB1", .T., .T.)

	TcSetField('TRB1', 'E1_EMISSAO', 'D', 08, 0)
	TcSetField('TRB1', 'E1_VENCREA', 'D', 08, 0)
	TcSetField('TRB1', 'E1_BAIXA'  , 'D', 08, 0)
	TcSetField('TRB1', 'A1_PRICOM' , 'D', 08, 0)

	TRB1->(DbGoTop())
	nHandle := Fcreate(cFile)
	While TRB1->(!Eof())
		cTexto := ""
		If MV_PAR03 == 1  //Pessoa Juridica
			cTexto += "J"  						//campo01
			cTexto += TRB1->A1_CGC  			//campo02
			cTexto += Padr(TRB1->A1_NOME, 55)   //campo03
			cTexto += Padr(TRB1->A1_NREDUZ, 55) //campo04
			cTexto += " "  						//campo05
			cTexto += Padr(TRB1->A1_END, 70)	//campo06
			cTexto += Padr(TRB1->A1_MUN, 30)	//campo07
			cTexto += TRB1->A1_EST 				//campo08
			cTexto += TRB1->A1_CEP				//campo09
			cTexto += Padr(TRB1->A1_DDD, 04)	//campo10
			cTexto += Padr(TRB1->A1_TEL, 10)	//campo11
			cTexto += Padr(TRB1->A1_DDD, 04)	//campo12
			cTexto += Padr(TRB1->A1_FAX, 10)	//campo13
			cTexto += Lower(Padr(TRB1->A1_EMAIL, 50))	//campo14
			cTexto += StrZero(Month(TRB1->A1_PRICOM), 2, 0) + StrZero(Year(TRB1->A1_PRICOM), 4, 0) //campo15
			cTexto += TRB1->(E1_PREFIXO + E1_NUM)	//campo16
			cTexto += "N"							//campo17
			cTexto += "R$  "						//campo18
			cTexto += StrZero(TRB1->E1_VALOR*100, 13, 0)	//campo19 e 20
			cTexto += StrZero(TRB1->E1_VALLIQ*100, 13, 0)	//campo21 e 22
			cTexto += GravaData(TRB1->E1_EMISSAO, .F., 5)	//campo23
			cTexto += GravaData(TRB1->E1_VENCREA, .F., 5)	//campo24
			cTexto += GravaData(TRB1->E1_BAIXA, .F., 5)		//campo25

		Else  //Pessoa Fisica
			cTexto += "F"  						//campo01
			cTexto += Padr(TRB1->A1_CGC, 11)	//campo02
			cTexto += Space(24)					//campo03 e 04
			cTexto += Padr(TRB1->A1_NOME, 55)   //campo05
			cTexto += " "  						//campo06
			cTexto += Padr(TRB1->A1_END, 70)	//campo07
			cTexto += Padr(TRB1->A1_MUN, 30)	//campo08
			cTexto += TRB1->A1_EST 				//campo09
			cTexto += TRB1->A1_CEP				//campo10
			cTexto += Padr(TRB1->A1_DDD, 04)	//campo11
			cTexto += Padr(TRB1->A1_TEL, 10)	//campo12
			cTexto += Padr(TRB1->A1_DDD, 04)	//campo13
			cTexto += Padr(TRB1->A1_FAX, 10)	//campo14
			cTexto += Lower(Padr(TRB1->A1_EMAIL, 1, 50))	//campo15
			cTexto += StrZero(Month(TRB1->A1_PRICOM), 2, 0) + StrZero(Year(TRB1->A1_PRICOM), 4, 0) //campo16
			cTexto += TRB1->(E1_PREFIXO + E1_NUM)	//campo17
			cTexto += "N"							//campo18
			cTexto += "R$  "						//campo19
			cTexto += StrZero(TRB1->E1_VALOR*100, 13, 0)	//campo20 e 21
			cTexto += StrZero(TRB1->E1_VALLIQ*100, 13, 0)	//campo22 e 23
			cTexto += GravaData(TRB1->E1_EMISSAO, .F., 5)	//campo24
			cTexto += GravaData(TRB1->E1_VENCREA, .F., 5)	//campo25
			cTexto += GravaData(TRB1->E1_BAIXA, .F., 5)		//campo26

		EndIF

		Fwrite(nHandle, cTexto + cEof)
		TRB1->(DbSkip())
	EndDo
	TRB1->(DbCloseArea())
	Fclose(nHandle)
Return