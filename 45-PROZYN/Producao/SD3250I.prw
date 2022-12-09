
#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³SD3250I		ºAutor  ³Microsiga	     º Data ³  18/18/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. apos a gravação do apontamento de produção       	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ponto de entrada criado para endereçar automatico apenas as amostras criadas pelo
//laboratorio com TM 020 e apontada no armazem 10 que nao seráo enviados para o CQ, 
//para os demais produtos e condições esse ponto de entrada nao vai influenciar.

//Criado por Daniel Newbridge em 18/08/2020

User Function SD3250I  

	Local cTm:= SD3->D3_TM	
	Local cDocD3 := SD3->D3_DOC
	Local cEndDest:= '199.17.LAB.01'
	Local _cQry2:=''
	Local aItem:= {}
	Local aCabSDA := {}
	Local nCount := 0
	Local cItem := ''
	Local nTamanho := TamSX3('DB_ITEM')[01]
	Local nModAux := nModulo
	Local nX as numeric
	Local nF as numeric

	Private cLocDest:= SD3->D3_LOCAL
	Private lMsErroAuto := .F.


	IF INCLUI .AND. cTm == "020" .AND. cLocDest == "10"

		_cQry2 := "         SELECT * FROM SDA010 DA " +CRLF
		_cQry2 += " 		INNER JOIN SB1010 B1 ON B1_COD  = DA_PRODUTO " +CRLF
		_cQry2 += " 		AND B1.D_E_L_E_T_ <> '*'  " +CRLF
		_cQry2 += " 		INNER JOIN SD3010 D3 ON (TRIM(DA_PRODUTO)+TRIM(DA_DOC)+TRIM(DA_LOTECTL)) =   " +CRLF
		_cQry2 += " 		(TRIM(D3_COD)+TRIM(D3_DOC)+TRIM(D3_LOTECTL))  " +CRLF  
		_cQry2 += " 		WHERE  DA_SALDO <> 0 AND   DA.D_E_L_E_T_<> '*' and  " +CRLF
		_cQry2 += " 		D3.D3_DOC = '"+ cDocD3 +"' AND  " +CRLF 
		_cQry2 += " 		D3_ESTORNO <> 'S' AND  " +CRLF
		_cQry2 += " 		D3_LOCAL  = '"+ cLocDest +"' AND " +CRLF
		_cQry2 += " 		D3.D_E_L_E_T_<> '*'  " +CRLF


		Memowrite('queryENDAUTPRD.txt', _cQry2)

		_cAlias2 := GetNextAlias()

		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry2),_cAlias2,.T.,.F.)
		
		dbSelectArea(_cAlias2)

		(_cAlias2)->(dbEval( { || nCount++ } ))
		(_cAlias2)->(dbGoTop())

		if nCount == 0
			alert("Sem itens disponíveis para o endereçamento!")
		else
			nModulo := 4	// alteração para o modulo estoque para nao dar array out of bounds por motivo de uso de campo das tabelas sda e sdb no modulo de qualidade. 

			dbSelectArea("SDA")
			SDA->(dbSetOrder(1))


			While !(_cAlias2)->(EOF())
		
				SDA->(dbGoTop()) // posiciona o cabeçalho
				if SDA->(dbSeek( xfilial("SDA") + (_cAlias2)->DA_PRODUTO + (_cAlias2)->DA_LOCAL + (_cAlias2)->DA_NUMSEQ ))
					if SDA->DA_SALDO > 0
						lMsErroAuto := .F.


						aCabSDA := {}
							
						aAdd( aCabSDA, {"DA_PRODUTO" ,SDA->DA_PRODUTO, Nil} )
						aAdd( aCabSDA, {"DA_NUMSEQ" ,SDA->DA_NUMSEQ , Nil} )

						IF SDA->DA_SALDO>(_cAlias2)->B1_QE  
							nF:=(SDA->DA_SALDO/(_cAlias2)->B1_QE) // Calculo da quantidade de itens conforme qtde por embalagem. 
							nQuant:= (_cAlias2)->B1_QE
						Else	
							nF:= 1
							nQuant:= SDA->DA_SALDO
						endif

						//pega o ultimo item da sdb para nao dar item duplicado

						_cQry3 := "  SELECT ISNULL (MAX(DB_ITEM),0) AS ULTITEM FROM SDB010 DB WHERE "
						_cQry3 += "  DB_NUMSEQ = '" + SDA->DA_NUMSEQ + "' AND "
						_cQry3 += "  DB_PRODUTO = '" + SDA->DA_PRODUTO + "' AND "
						_cQry3 += "  DB_LOCAL = '" + SDA->DA_LOCAL + "' AND "
						_cQry3 += "  DB_LOCALIZ = '" + cEndDest + "'  AND "
						_cQry3 += "  DB.D_E_L_E_T_ <> '*' "

						_cAlias3 := GetNextAlias()
			
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry3),_cAlias3,.T.,.F.)
			
						dbSelectArea(_cAlias3)

						If val((_cAlias3)->ULTITEM) > 0
							nItem := val((_cAlias3)->ULTITEM)
						Else
							nItem:= 0
						EndIf
						(_cAlias3)->(DbCloseArea())

						aItem:= {}

						For nX := 1 To nF
							nItem += 1
							cItem  := PadL(nItem, nTamanho, "0")
							aAdd(aItem,{{"DB_ITEM",cItem,NIL},;
										{"DB_LOCALIZ",cEndDest,NIL},;
										{"DB_DATA",dDataBase,NIL},;
										{"DB_QUANT",nQuant,NIL}})
									
						Next

						MSExecAuto({|x,y,z| mata265(x,y,z)},aCabSDA,aItem,3) //Distribui

						If lMsErroAuto    
							MostraErro()
						Else    
							MsgAlert("Endereçamento Automatico Ok!" + CRLF + " Prod.: "+ SDA->DA_PRODUTO + " - " + (_cAlias2)->B1_DESC + CRLF + " Armz: " + SDA->DA_LOCAL + " Endereço: " + cEndDest)
						Endif

					endif
				endif

				(_cAlias2)->(dbSkip())
			enddo

    		(_cAlias2)->(dbCloseArea())

		Endif

	EndIf

	If INCLUI .and. cTm == "010" .AND. cLocCqOrig == "99"
		Processa( {||BaixaCQ() },"Aguarde", "Realizando processo de liberação automática do CQ...")
	EndIf

	// FIM DA EXECAUTO DO ENDEREÇAMENTO AUTOMATICO - DANIEL 16/08/2020

	nModulo := nModAux // Voltar variavel para o modulo corrente. 

Return



Static Function BaixaCQ
    Local dDataL := DATE()
    Local aLibera	:= {}
    PRIVATE lMsErroAuto := .F.
	
	DbSelectArea("SD7")
	SD7->(DbSetOrder(3))
	SD7->(DbGoTop())

	SD7->(dbSeek(xFilial("SD3")+SD3->D3_COD+SD3->D3_NUMSEQ,.f.))

    aAdd(aLibera,{	{"D7_TIPO",1,Nil},;  // 1=Libera o item do CQ / 2=Rejeita o item do CQ
    {"D7_DATA"  	,dDataL,Nil},;
    {"D7_QTDE"  	,SD3->D3_QUANT,Nil},;
    {"D7_OBS"  		,"",Nil},;
    {"D7_QTSEGUM"	,SD3->D3_QTSEGUM,Nil},;		
    {"D7_MOTREJE" 	,"",Nil},;
    {"D7_LOCDEST" 	,cLocCqOrig,Nil},;
	{"D7_LOCALIZ"	,"265.26.001.01  ",Nil},;
    {"D7_SALDO"  	,Nil,Nil},;
    {"D7_SALDO2"  	,NIL,Nil},;                                                                                     
    {"D7_ESTORNO"  	,NIL,Nil}})
    MSExecAuto({|x,y,z| MATA175(x,y)},aLibera,4)


    If !lMsErroAuto	
        MsgAlert("Liberação automática de CQ concluído.","Atenção!")
		return
	EndIf
	MsgAlert("A liberção não pôde ser feita automaticamente.","Atenção!")

Return
