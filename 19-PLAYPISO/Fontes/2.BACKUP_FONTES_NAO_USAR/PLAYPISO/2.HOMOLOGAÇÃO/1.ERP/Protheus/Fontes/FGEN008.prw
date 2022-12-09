#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFGEN008   บAutor  ณAlexandre Sousa     บ Data ณ  04/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao generica para mostrar o resultado de uma query.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณc_Query: Query a ser excutada para obter informacoes.       บฑฑ
ฑฑบ          ณa_campos:Array contendo uma coluna com a descricao dos cam- บฑฑ
ฑฑบ          ณpos que sera mostrada na List, e outra contendo o nome dos  บฑฑ
ฑฑบ          ณcampos que serao retornados pela query.                     บฑฑ
ฑฑบ          ณc_tit: Titulo da janela.                                    บฑฑ
ฑฑบ          ณn_pos: Posicao do campo a ser retornado pela consulta.      บฑฑ
ฑฑบ          ณc_Ret: String com o valor do campo informado.               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FGEN008(c_Query, a_campos, c_tit, n_pos)

	Local aVetor   := {}
	Local cTitulo  := Iif( c_tit = Nil, "Tํtulo", c_tit)
	Local nPos		:= Iif(n_pos = Nil, 1, n_pos)
	Local n_x		:= 0
	Local c_Lst		:= ''
//	Local c_Query := "select distinct EA_FILIAL, EA_NUMBOR from "+RetSqlName("SEA")+" where EA_FILIAL = '"+xFilial("SEA")+"' EA_CART = 'R' and D_E_L_E_T_ <> '*'"
//	Local a_campos := {{"Filial", "Bordero" }, {"EA_FILIAL", "EA_NUMBOR"}}
//	Local c_tit := "Consulta de Borderos"

	Private oDlg	:= Nil
	Private oLbx	:= Nil
	Private c_Ret	:= ''
	Private aSalvAmb := GetArea()

 	If Select("QRX") > 0
		DbSelectArea("QRX")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRX"

	//+-------------------------------------+
	//| Carrega o vetor conforme a condicao |
	//+-------------------------------------+
	While QRX->(!EOF())
		aAdd(aVetor, Array(len(a_campos[2])))
		
		For n_x := 1 to len(a_campos[2])
			aVetor[len(aVetor),n_x] := &("QRX->"+a_campos[2,n_x])
		Next
		QRX->(dbSkip())
	End

	If Len( aVetor ) == 0
	   Aviso( cTitulo, "Nao existe dados para a consulta", {"Ok"} )
	   Return
	Endif

	//+-----------------------------------------------+
	//| Limitado a dez colunas                        |
	//+-----------------------------------------------+
	c_A := IIf(len(a_campos[1])>=1,a_campos[1,1],'' )
	c_B := IIf(len(a_campos[1])>=2,a_campos[1,2],'' )
	c_C := IIf(len(a_campos[1])>=3,a_campos[1,3],'' )
	c_D := IIf(len(a_campos[1])>=4,a_campos[1,4],'' )
	c_E := IIf(len(a_campos[1])>=5,a_campos[1,5],'' )
	c_F := IIf(len(a_campos[1])>=6,a_campos[1,6],'' )
	c_G := IIf(len(a_campos[1])>=7,a_campos[1,7],'' )
	c_H := IIf(len(a_campos[1])>=8,a_campos[1,8],'' )
	c_I := IIf(len(a_campos[1])>=9,a_campos[1,9],'' )
	c_J := IIf(len(a_campos[1])>=10,a_campos[1,10],'' )

	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 240,500 PIXEL
	@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D, c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) SIZE 230,095 OF oDlg PIXEL	
	                                                			
	oLbx:SetArray( aVetor )
		                    
	c_Lst := '{|| {aVetor[oLbx:nAt,1],'
	For n_x := 2 to len(a_campos[2])-1
		c_Lst += '     aVetor[oLbx:nAt,'+Str(n_x)+'],'
	Next
	c_Lst += '    aVetor[oLbx:nAt,'+Str(len(a_campos[2]))+']}}'

	oLbx:bLine := &c_Lst
	c_Ret := &c_Lst
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg Centered
	
	RestArea( aSalvAmb )

Return c_Ret
