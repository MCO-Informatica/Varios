#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"

User Function HCIMR001()

	Local _cPerg		:= "HCIMR01"
	Local aOrd    		:= {}//{"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
	
	Private cpTamanho	:= "G"
	Private cpTitulo	:= "Impressão de Relatório - Ordem de Produção"
	Private cpDesc1		:= "Este programa destina-se a impressão de Relatório de ordem de produção."
	Private cpDesc2		:= ""
	Private cpDesc3		:= ""
	Private cpWnRel		:= "HCIMR001"
	Private aReturn		:= {"Zebrado",1,"Administracao",2,2,1,"",1}
	Private nLastKey	:= 00
	Private lEnd		:= .F.
	Private _lItemNeg	:= .F.
	
	AjustaSX1(_cPerg)
	Pergunte(_cPerg,.T.)
	
	If MV_PAR12 == 1
		_fImpExc()
	Else
		cpWnRel 	:= SetPrint("",cpWnRel,"",@cpTitulo,cpDesc1,cpDesc2,cpDesc3,.F.,aOrd,,cpTamanho,,)
		_lItemNeg	:= GetMv("MV_NEGESTR") .And. mv_par10 == 1
		
		If nLastKey == 27
			Set Filter To
			Return()
		EndIf
		SetDefault(aReturn,"")
		If nLastKey == 27
			Set Filter To
			Return()
		EndIf
		
		Processa({||_fImpSpo()},cpTitulo,,.T.)
	EndIf

Return()

Static Function _fImpExc()

Return()

Static Function _fImpSpo()
	
	Local nlLin 		:= 0050
	Local _nTotHrs		:= 0
	Local lSH8			:= .F.
	Local _nLinTotHr	:= 0
	Local _cNumOp		:= ""
	Local _cPrd			:= ""
	Local _cBenef		:= ""
	Local _cRetCom		:= ""
	
	Private _oFonte1	:= TFont():New("Arial",,20,,.T.,,,,,.F.)
	Private _oFonte2	:= TFont():New("Arial",,14,,.T.,,,,,.F.)
	Private _oFonte3	:= TFont():New("Arial",,10,,.F.,,,,,.F.)
	Private _oFonte4	:= TFont():New("Arial",,10,,.T.,,,,,.F.)
	Private _oFonte5	:= TFont():New("Arial",,07,,.F.,,,,,.F.)
	Private _oFonte6	:= TFont():New("Arial",,07,,.T.,,,,,.F.)
	Private _oReport	:= Nil
	Private _cTitulo	:= "Ordem de Produção"
	Private _cAliasTmp	:= GetNextAlias()
	Private aArray		:= {}
		
	_oReport := TmsPrinter():New("Ordem de Produção")
	_oReport:SetPortrait()
	_oReport:SetLandscape(.T.)

	_fQryTmp(_cAliasTmp)
	
	ProcRegua(RecCount())
	
	(_cAliasTmp)->(dbGoTop())
	While (_cAliasTmp)->(!EOF())
	
		If !MtrAValOP(mv_par09,"SC2",_cAliasTmp)
			dbSkip()
			Loop
		EndIf
	
		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+(_cAliasTmp)->C2_PRODUTO)
		aArray	:= {}
		MontStruc((_cAliasTmp)->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD))
		
		If mv_par08 == 1
			aSort( aArray,2,, { |x, y| (x[1]+x[8]) < (y[1]+y[8]) } )
		Else
			aSort( aArray,2,, { |x, y| (x[8]+x[1]) < (y[8]+y[1]) } )
		ENDIF
		
		If _cNumOp <> (_cAliasTmp)->C2_NUM+ (_cAliasTmp)->C2_ITEM + (_cAliasTmp)->C2_SEQUEN + (_cAliasTmp)->C2_ITEMGRD .And.;
			_cBenef <> (_cAliasTmp)->BENEFI .And. _cRetCom <> (_cAliasTmp)->C2_XRETCOM //_cPrd <> (_cAliasTmp)->C2_PRODUTO .And. 
			_oReport:StartPage()
			
			_lRec := .T.
			nlLin := 0050		
			
			_oReport:Saybitmap(0120,2670, "lgrl" + cEmpAnt + ".BMP",0480,0140,)
			_oReport:Say(0070		,1300	,_cTitulo													,_oFonte1)
			_oReport:Line(nlLin		,0050	,nlLin														,3400)
			_oReport:Line(nlLin		,0050	,nlLin + 0370												,0050)
			_oReport:Line(nlLin		,3400	,nlLin + 0370												,3400)
			_oReport:Say(nlLin+0050	,0075	,SM0->M0_NOME												,_oFonte4)
			_oReport:Say(nlLin+0100	,0075	,(_cAliasTmp)->A1_NREDUZ									,_oFonte4)
			_oReport:Say(nlLin+0150	,0075	,"PO - " + (_cAliasTmp)->C6_PV+ "/" +STRZERO(VAL((_cAliasTmp)->C6_ITEMCLI),3)							,_oFonte4)
			_oReport:Say(nlLin+0200	,0075	,"PI - " + (_cAliasTmp)->C6_NUM + "/" +STRZERO(VAL((_cAliasTmp)->C6_ITEM),3)									,_oFonte4)
			_oReport:Say(nlLin+0250	,0075	,"PN - " + (_cAliasTmp)->A7_CODCLI + "-" + (_cAliasTmp)->A7_DESCCLI													,_oFonte4)
			_oReport:Say(nlLin+0300	,0075	,"Total Hrs. - " + AllTrim(Str(0))											,_oFonte4)

			_oReport:Say(nlLin+0300	,2512	,"No. OP:"													,_oFonte4)
			_oReport:Say(nlLin+0300	,2812	,(_cAliasTmp)->C2_NUM+ (_cAliasTmp)->C2_ITEM + (_cAliasTmp)->C2_SEQUEN + (_cAliasTmp)->C2_ITEMGRD												,_oFonte2)
			nlLin+=0370
			_oReport:Line(nlLin		,0050	,nlLin														,3400)
			
			nlLin+=0050
			_oReport:Say(nlLin		,0060	,"Produto:"													,_oFonte6)
			_oReport:Say(nlLin+0030	,0060	,"Unid. Med.:"												,_oFonte6)
			_oReport:Say(nlLin+0060	,0060	,"Emissão"													,_oFonte6)
			_oReport:Say(nlLin+0090	,0060	,"C.Custo"													,_oFonte6)
			
			_oReport:Say(nlLin		,0315	,(_cAliasTmp)->C2_PRODUTO +" - " + (_cAliasTmp)->B1_DESC	,_oFonte6)
			_oReport:Say(nlLin+0030	,0315	,(_cAliasTmp)->C2_UM										,_oFonte5)
			_oReport:Say(nlLin+0060	,0315	,"22/07/2015"												,_oFonte5)
			_oReport:Say(nlLin+0090	,0315	,(_cAliasTmp)->C2_CC										,_oFonte5)
			
			_oReport:Say(nlLin		,1715	,"Cliente:"													,_oFonte6)
			_oReport:Say(nlLin+0030	,1715	,"Qtde. Prod.:"												,_oFonte6)
			_oReport:Say(nlLin+0030	,2455	,"Qtde. Orig.:"												,_oFonte6)
			_oReport:Say(nlLin+0060	,1715	,"Atrib.Material:"											,_oFonte6)
			
			_oReport:Say(nlLin		,2015	,(_cAliasTmp)->C6_CLI+"-"+(_cAliasTmp)->C6_LOJA +" "+ (_cAliasTmp)->A1_NREDUZ					,_oFonte5)
			_oReport:Say(nlLin+0030	,2015	,Transform(0,"@E 999,999,999.99")							,_oFonte5)
			_oReport:Say(nlLin+0030	,2755	,Transform(0,"@E 999,999,999.99")							,_oFonte5)
			_oReport:Say(nlLin+0060	,2015	,"Comercialização"											,_oFonte5)
			
			If SB1->B1_FANTASM == 'S'
				_oReport:Say(nlLin+0060		,2455	,"Endereço:"													,_oFonte6)
				_oReport:Say(nlLin+0060		,2755	,_fGetEnd()					,_oFonte5)
			EndIf
			
			nlLin+=0140
			_oReport:Say(nlLin		,0060	,"Componente:"												,_oFonte6)
			nlLin+=0030
			_oReport:Say(nlLin		,0060	,"Código"													,_oFonte5)
			_oReport:Say(nlLin		,0415	,"Descrição"												,_oFonte5)
			_oReport:Say(nlLin		,1500	,"Qtde"														,_oFonte5)
			_oReport:Say(nlLin		,1700	,"UN"														,_oFonte5)
			_oReport:Say(nlLin		,1900	,"AM"														,_oFonte5)
			_oReport:Say(nlLin		,2100	,"Endereço"													,_oFonte5)
			_oReport:Say(nlLin		,2700	,"Seq"														,_oFonte5)
			If mv_par11 == 1
				_oReport:Say(nlLin		,2900	,"Lote/Corrida"												,_oFonte5)
				_oReport:Say(nlLin		,3100	,"Sub.Lote"													,_oFonte5)
			EndIf
			
			For _nI	:= 1 To Len(aArray)
				nlLin+=0030
				_oReport:Say(nlLin		,0060	,aArray[_nI,1]												,_oFonte5)
				_oReport:Say(nlLin		,0415	,aArray[_nI,2]												,_oFonte5)
				_oReport:Say(nlLin		,1500	,Transform(aArray[_nI,5],"@E 999,999,999.99")					,_oFonte5)
				_oReport:Say(nlLin		,1700	,aArray[_nI,4]												,_oFonte5)
				_oReport:Say(nlLin		,1900	,aArray[_nI,6]												,_oFonte5)
				_oReport:Say(nlLin		,2100	,aArray[_nI,7]												,_oFonte5)
				_oReport:Say(nlLin		,2700	,aArray[_nI,8]												,_oFonte5)
				If mv_par11 == 1
					_oReport:Say(nlLin		,2900	,aArray[_nI,10]												,_oFonte5)
					_oReport:Say(nlLin		,3100	,aArray[_nI,11]												,_oFonte5)
				EndIf
			Next _nI
			nlLin+=0080
		EndIf

		If _lRec
			_oReport:Line(nlLin		,0050	,nlLin														,3400)
			_oReport:Line(nlLin		,0050	,nlLin + 0050												,0050)
			_oReport:Line(nlLin		,0150	,nlLin + 0050												,0150)
			_oReport:Line(nlLin		,0750	,nlLin + 0050												,0750)
			_oReport:Line(nlLin		,0950	,nlLin + 0050												,0950)
			_oReport:Line(nlLin		,1180	,nlLin + 0050												,1180)
			_oReport:Line(nlLin		,1490	,nlLin + 0050												,1490)
			_oReport:Line(nlLin		,2090	,nlLin + 0050												,2090)
			_oReport:Line(nlLin		,2290	,nlLin + 0050												,2290)
			_oReport:Line(nlLin		,2490	,nlLin + 0050												,2490)
			_oReport:Line(nlLin		,2690	,nlLin + 0050												,2690)
			_oReport:Line(nlLin		,2890	,nlLin + 0050												,2890)
			_oReport:Line(nlLin		,3090	,nlLin + 0050												,3090)
			_oReport:Line(nlLin		,3400	,nlLin + 0050												,3400)
					
			_oReport:Say(nlLin+0010	,0060	,"Fase"														,_oFonte5)
			_oReport:Say(nlLin+0010	,0160	,"Descrição"												,_oFonte5)
			_oReport:Say(nlLin+0010	,0760	,"Dur.(Hora)"												,_oFonte5)
			_oReport:Say(nlLin+0010	,0960	,"Prazo Contratual"											,_oFonte5)		
			_oReport:Say(nlLin+0010	,1190	,"Recurso"													,_oFonte5)
			_oReport:Say(nlLin+0010	,1500	,"Desenho/Doc"												,_oFonte5)		
			_oReport:Say(nlLin+0010	,2100	,"Inic.Aloc"												,_oFonte5)		
			_oReport:Say(nlLin+0010	,2300	,"Term.Aloc"												,_oFonte5)		
			_oReport:Say(nlLin+0010	,2500	,"Inic.Real"												,_oFonte5)		
			_oReport:Say(nlLin+0010	,2700	,"Term.Real"												,_oFonte5)		
			_oReport:Say(nlLin+0010	,2900	,"Data Exec."												,_oFonte5)		
			_oReport:Say(nlLin+0010	,3100	,"Visto"													,_oFonte5)		
			nlLin+=0050
			_oReport:Line(nlLin		,0050	,nlLin														,3400)
			_lRec := .F.
			nlLin+=0005
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((_cAliasTmp)->C2_ROTEIRO)
			cRoteiro:=(_cAliasTmp)->C2_ROTEIRO
		Else
			If !Empty(SB1->B1_OPERPAD)
				cRoteiro:=SB1->B1_OPERPAD
			Else
				dbSelectArea("SG2")
				If dbSeek(xFilial()+(_cAliasTmp)->C2_PRODUTO+"01")
					cRoteiro:="01"
				EndIf
			EndIf
		EndIf
		
		If (_cAliasTMP)->G2_CODIGO == cRoteiro
			_oReport:Line(nlLin		,0050	,nlLin														,3400)
			_oReport:Line(nlLin		,0050	,nlLin + 0040												,0050)
			_oReport:Line(nlLin		,0150	,nlLin + 0040												,0150)
			_oReport:Line(nlLin		,0750	,nlLin + 0040												,0750)
			_oReport:Line(nlLin		,0950	,nlLin + 0040												,0950)
			_oReport:Line(nlLin		,1180	,nlLin + 0040												,1180)
			_oReport:Line(nlLin		,1490	,nlLin + 0040												,1490)
			_oReport:Line(nlLin		,2090	,nlLin + 0040												,2090)
			_oReport:Line(nlLin		,2290	,nlLin + 0040												,2290)
			_oReport:Line(nlLin		,2490	,nlLin + 0040												,2490)
			_oReport:Line(nlLin		,2690	,nlLin + 0040												,2690)
			_oReport:Line(nlLin		,2890	,nlLin + 0040												,2890)
			_oReport:Line(nlLin		,3090	,nlLin + 0040												,3090)
			_oReport:Line(nlLin		,3400	,nlLin + 0040												,3400)
	
			If !Empty((_cAliasTMP)->H8_RECURSO)				
				
				If !Empty((_cAliasTMP)->H8_HRINI)
					_nTotHrs	:= VAL((_cAliasTMP)->H8_HRFIM) - VAL((_cAliasTMP)->H8_HRINI)//Val(ElapTime((_cAliasTMP)->H8_HRINI,(_cAliasTMP)->H8_HRFIM))
				EndIf
				
				_oReport:Say(nlLin+0010	,0060	,(_cAliasTMP)->G2_OPERAC														,_oFonte5)
				_oReport:Say(nlLin+0010	,0160	,(_cAliasTMP)->G2_DESCRI							,_oFonte5)
				_oReport:Say(nlLin+0010	,0760	,Transform(_nTotHrs,"@E 999,999,999.99")							,_oFonte5)
				_oReport:Say(nlLin+0010	,0960	,SubStr(DtoS((_cAliasTMP)->C6_ENTREG),7,2) + "/" + SubStr(DtoS((_cAliasTMP)->C6_ENTREG),5,2) + "/" + SubStr(DtoS((_cAliasTMP)->C6_ENTREG),1,4)												,_oFonte5)		
				_oReport:Say(nlLin+0010	,1190	,(_cAliasTMP)->H8_RECURSO										,_oFonte5)
				_oReport:Say(nlLin+0010	,1500	,(_cAliasTMP)->G2_XDESDOC												,_oFonte5)		
				_oReport:Say(nlLin+0010	,2100	,SubStr(DtoS((_cAliasTMP)->H8_DTINI),7,2) + "/" + SubStr(DtoS((_cAliasTMP)->H8_DTINI),5,2) + "/" + SubStr(DtoS((_cAliasTMP)->H8_DTINI),1,4)												,_oFonte5)		
				_oReport:Say(nlLin+0010	,2300	,SubStr(DtoS((_cAliasTMP)->H8_DTFIM),7,2) + "/" + SubStr(DtoS((_cAliasTMP)->H8_DTFIM),5,2) + "/" + SubStr(DtoS((_cAliasTMP)->H8_DTFIM),1,4)												,_oFonte5)		
				_oReport:Say(nlLin+0010	,2500	,""															,_oFonte5)		
				_oReport:Say(nlLin+0010	,2700	,""															,_oFonte5)		
				_oReport:Say(nlLin+0005	,2900	,"___/___/____"												,_oFonte5)		
			Else
				_oReport:Say(nlLin+0010	,0060	,(_cAliasTMP)->G2_OPERAC														,_oFonte5)
				_oReport:Say(nlLin+0010	,0160	,(_cAliasTMP)->G2_DESCRI							,_oFonte5)
				_oReport:Say(nlLin+0010	,0760	,Transform(0,"@E 999,999,999.99")							,_oFonte5)
				_oReport:Say(nlLin+0010	,0960	,SubStr(DtoS((_cAliasTmp)->C6_ENTREG),7,2) + "/" + SubStr(DtoS((_cAliasTmp)->C6_ENTREG),5,2) + "/" + SubStr(DtoS((_cAliasTmp)->C6_ENTREG),1,4)												,_oFonte5)		
				_oReport:Say(nlLin+0010	,1190	,(_cAliasTMP)->G2_RECURSO										,_oFonte5)
				_oReport:Say(nlLin+0010	,1500	,(_cAliasTMP)->G2_XDESDOC												,_oFonte5)		
				_oReport:Say(nlLin+0010	,2100	,""												,_oFonte5)		
				_oReport:Say(nlLin+0010	,2300	,""												,_oFonte5)		
				_oReport:Say(nlLin+0010	,2500	,""															,_oFonte5)		
				_oReport:Say(nlLin+0010	,2700	,""															,_oFonte5)		
				_oReport:Say(nlLin+0005	,2900	,"___/___/____"												,_oFonte5)		
			EndIf
//			nlLin+=0008

			nlLin+=0040
			_oReport:Line(nlLin		,0050	,nlLin														,3400)

		Endif		
/*		nlLin+=0030
		_oReport:Line(nlLin		,0050	,nlLin + 0050												,0050)
		_oReport:Line(nlLin		,0150	,nlLin + 0050												,0150)
		_oReport:Line(nlLin		,0750	,nlLin + 0050												,0750)
		_oReport:Line(nlLin		,0950	,nlLin + 0050												,0950)
		_oReport:Line(nlLin		,1180	,nlLin + 0050												,1180)
		_oReport:Line(nlLin		,1490	,nlLin + 0050												,1490)
		_oReport:Line(nlLin		,2090	,nlLin + 0050												,2090)
		_oReport:Line(nlLin		,2290	,nlLin + 0050												,2290)
		_oReport:Line(nlLin		,2490	,nlLin + 0050												,2490)
		_oReport:Line(nlLin		,2690	,nlLin + 0050												,2690)
		_oReport:Line(nlLin		,2890	,nlLin + 0050												,2890)
		_oReport:Line(nlLin		,3090	,nlLin + 0050												,3090)
		_oReport:Line(nlLin		,3400	,nlLin + 0050												,3400)
		_oReport:Say(nlLin+0010	,1190	,"VERTICAIS"												,_oFonte5)

			
*/		
		
		If 	nlLin > 1900
			_oReport:EndPage()
			_oReport:StartPage()
			nlLin := 0050		
		EndIf
		
		_cNumOp		:= (_cAliasTmp)->C2_NUM+ (_cAliasTmp)->C2_ITEM + (_cAliasTmp)->C2_SEQUEN + (_cAliasTmp)->C2_ITEMGRD
		_cPrd 		:= (_cAliasTmp)->C2_PRODUTO
		_cBenef		:= (_cAliasTmp)->BENEFI
		_cRetCom	:= (_cAliasTmp)->C2_XRETCOM
		
		(_cAliasTmp)->(dbSkip())
		
		If _cNumOp <> (_cAliasTmp)->C2_NUM+ (_cAliasTmp)->C2_ITEM + (_cAliasTmp)->C2_SEQUEN + (_cAliasTmp)->C2_ITEMGRD .And.;
			_cBenef <> (_cAliasTmp)->BENEFI .And. _cRetCom <> (_cAliasTmp)->C2_XRETCOM //_cPrd <> (_cAliasTmp)->C2_PRODUTO .And. 
			
			nlLin:=2050
			_oReport:Line(nlLin		,0050	,nlLin														,3400)
			_oReport:Line(nlLin		,0050	,nlLin + 0390												,0050)
			_oReport:Line(nlLin		,3400	,nlLin + 0390												,3400)
			_oReport:Say(nlLin+0010	,0060	,"ELABORADOR"												,_oFonte5)
			_oReport:Say(nlLin+0060	,0060	,"NOME: __________________________________________________"	,_oFonte5)
			_oReport:Say(nlLin+0110	,0060	,"DATA: ___/___/____"										,_oFonte5)
			_oReport:Say(nlLin+0110	,0550	,"VISTO: ______________________________"					,_oFonte5)
			
			_oReport:Say(nlLin+0190	,0060	,"GERENTE DE PRODUÇÃO"										,_oFonte5)
			_oReport:Say(nlLin+0240	,0060	,"NOME: __________________________________________________"	,_oFonte5)
			_oReport:Say(nlLin+0290	,0060	,"DATA: ___/___/____"										,_oFonte5)
			_oReport:Say(nlLin+0290	,0550	,"VISTO: ______________________________"					,_oFonte5)
			
			_oReport:Line(nlLin		,1193	,nlLin + 0390												,1193)
			_oReport:Say(nlLin+0010	,1203	,"VERIFICADO"												,_oFonte5)
			_oReport:Say(nlLin+0060	,1203	,"NOME: __________________________________________________"	,_oFonte5)
			_oReport:Say(nlLin+0110	,1203	,"DATA: ___/___/____"										,_oFonte5)
			_oReport:Say(nlLin+0110	,1653	,"VISTO: ______________________________"					,_oFonte5)
			
			_oReport:Say(nlLin+0190	,1203	,"RESPONSÁVEL"												,_oFonte5)
			_oReport:Say(nlLin+0240	,1203	,"NOME: __________________________________________________"	,_oFonte5)
			_oReport:Say(nlLin+0290	,1203	,"DATA: ___/___/____"										,_oFonte5)
			_oReport:Say(nlLin+0290	,1653	,"VISTO: ______________________________"					,_oFonte5)
			
			_oReport:Line(nlLin		,2296	,nlLin + 0390												,2296)
			_oReport:Say(nlLin+0010	,2306	,"APROVADO"													,_oFonte5)
			_oReport:Say(nlLin+0060	,2306	,"NOME: __________________________________________________"	,_oFonte5)
			_oReport:Say(nlLin+0110	,2306	,"DATA: ___/___/____"										,_oFonte5)
			_oReport:Say(nlLin+0110	,2756	,"VISTO: ______________________________"					,_oFonte5)
			
			_oReport:Say(nlLin+0190	,2306	,"ENCERRADO"												,_oFonte5)
			_oReport:Say(nlLin+0240	,2306	,"NOME: __________________________________________________"	,_oFonte5)
			_oReport:Say(nlLin+0290	,2306	,"DATA: ___/___/____"										,_oFonte5)
			_oReport:Say(nlLin+0290	,2756	,"VISTO: ______________________________"					,_oFonte5)
			
			nlLin+=0390
			_oReport:Line(nlLin		,0050	,nlLin														,3400)
			_oReport:EndPage()
		
		EndIF
	EndDo
	
	_oReport:EndPage()	
	
	(_cAliasTmp)->(dbCloseArea())

	_oReport:Preview()
 	MS_FLUSH()

Return()

Static Function AddAr820(nQuantItem)

	Local cDesc   := SB1->B1_DESC
	Local cLocal  := ""
	Local cKey    := ""
	Local cRoteiro:= ""   
	Local nQtdEnd    
	Local lExiste
	
	Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime nome cientifico do produto. Se Sim    ³
	//³ verifica se existe registro no SB5 e se nao esta vazio    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par06 == 1
		dbSelectArea("SB5")
		dbSeek(xFilial()+SB1->B1_COD)
		If Found() .and. !Empty(B5_CEME)
			cDesc := B5_CEME
		EndIf
	ElseIf mv_par06 == 2
		cDesc := SB1->B1_DESC
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se imprime descricao digitada ped.venda, se sim  ³
		//³ verifica se existe registro no SC6 e se nao esta vazio    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (_cAliasTmp)->C2_DESTINA == "P"
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial()+(_cAliasTmp)->C2_PEDIDO+(_cAliasTmp)->C2_ITEM)
			If Found() .and. !Empty(C6_DESCRI) .and. C6_PRODUTO==SB1->B1_COD
				cDesc := C6_DESCRI
			ElseIf C6_PRODUTO # SB1->B1_COD
				dbSelectArea("SB5")
				dbSeek(xFilial()+SB1->B1_COD)
				If Found() .and. !Empty(B5_CEME)
					cDesc := B5_CEME
				EndIf
			EndIf
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se imprime ROTEIRO da OP ou PADRAO do produto    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty((_cAliasTmp)->C2_ROTEIRO)
		cRoteiro:=(_cAliasTmp)->C2_ROTEIRO
	Else
		If !Empty(SB1->B1_OPERPAD)
			cRoteiro:=SB1->B1_OPERPAD
		Else
			dbSelectArea("SG2")
			If dbSeek(xFilial()+(_cAliasTmp)->C2_PRODUTO+"01")
				cRoteiro:="01"
			EndIf
		EndIf
	EndIf
	 
	If lVer116
		dbSelectArea("NNR")
		dbSeek(xFilial()+SD4->D4_LOCAL)
	Else
		dbSelectArea("SB2")
		dbSeek(xFilial()+SB1->B1_COD+SD4->D4_LOCAL) 
	EndIf
	
	dbSelectArea("SD4")
	cKey:=SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
	cLocal:=SB2->B2_LOCALIZ
	                                  
	lExiste := .F.
	
	If !lVer116
		DbSelectArea("SDC")
		DbSetOrder(2)
		DbSeek(xFilial("SDC")+cKey)
		//If !Eof() .And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey 
			While !Eof().And. SDC->(DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == cKey 
				cLocal  :=DC_LOCALIZ      
				nQtdEnd :=DC_QTDORIG 
			
				AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQtdEnd,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par11 == 1,SD4->D4_LOTECTL,""),If(mv_par11 == 1,SD4->D4_NUMLOTE,"") } )
				lExiste := .T. 
				dbSkip()
			end
		//EndIf
	endif 
	
	dbSelectArea("SD4")
	
	if !lExiste 
		If lVer116
			AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,NNR->NNR_DESCRI,SD4->D4_TRT,cRoteiro,If(mv_par11 == 1,SD4->D4_LOTECTL,""),If(mv_par11 == 1,SD4->D4_NUMLOTE,"") } )
		Else
			AADD(aArray, {SB1->B1_COD,cDesc,SB1->B1_TIPO,SB1->B1_UM,nQuantItem,SD4->D4_LOCAL,cLocal,SD4->D4_TRT,cRoteiro,If(mv_par11 == 1,SD4->D4_LOTECTL,""),If(mv_par11 == 1,SD4->D4_NUMLOTE,"") } )
		EndIf
	endif

Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MontStruc³ Autor ³ Ary Medeiros          ³ Data ³ 19/10/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Monta um array com a estrutura do produto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ MontStruc(ExpC1,ExpN1,ExpN2)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade base a ser explodida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MontStruc(cOp,nQuant)

dbSelectArea("SD4")
dbSetOrder(2)
dbSeek(xFilial()+cOp)

While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOp
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no produto desejado                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	If dbSeek(xFilial()+SD4->D4_COD)
		If SD4->D4_QUANT > 0 .Or. (lItemNeg .And. SD4->D4_QUANT < 0)
			AddAr820(SD4->D4_QUANT)
		EndIf
	Endif
	dbSelectArea("SD4")
	dbSkip()
Enddo

dbSetOrder(1)

Return

Static Function _fQryTmp(_cAliasTmp)

	Local _cQuery	:= ""
	
 	_cQuery := "SELECT 	SC2.C2_FILIAL, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, SC2.C2_ITEMGRD, SC2.C2_DATPRF, "
 	_cQuery += "		SC2.C2_DATRF, SC2.C2_PRODUTO, SC2.C2_DESTINA, SC2.C2_PEDIDO, SC2.C2_ROTEIRO, SC2.C2_QUJE, "
 	_cQuery += "		SC2.C2_PERDA, SC2.C2_QUANT, SC2.C2_DATPRI, SC2.C2_CC, SC2.C2_DATAJI, SC2.C2_DATAJF, "
 	_cQuery += " 		SC2.C2_STATUS, SC2.C2_OBS, SC2.C2_TPOP, SC2.C2_UM, SC2.C2_XRETCOM, 
 	_cQuery += " 		SC2.R_E_C_N_O_  SC2RECNO "
 	_cQuery += "		,SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_PV, SC6.C6_ITEMCLI, SC6.C6_ENTREG "
 	_cQuery += "		,SA1.A1_NREDUZ, SC6.C6_CLI, SC6.C6_LOJA "
 	_cQuery += "		,SA7.A7_CODCLI, SA7.A7_DESCCLI, SB1.B1_DESC "
 	_cQuery += "		,SG2.G2_OPERAC, SG2.G2_DESCRI, SG2.G2_XDESDOC, SG2.G2_CODIGO, SG2.G2_RECURSO "
 	_cQuery += "		,SH8.H8_HRINI, SH8.H8_HRFIM, SH8.H8_RECURSO, SH8.H8_DTINI, SH8.H8_DTFIM "
 	_cQuery += "		, CASE WHEN SH8.H8_RECURSO <>  ' '  THEN SH8.H8_RECURSO ELSE SG2.G2_RECURSO END  AS RECURSO "
	_cQuery += "		, CASE WHEN SH8.H8_RECURSO <>  ' '  THEN SH1H8.H1_XBENEFI ELSE SH1G2.H1_XBENEFI END  AS BENEFI "
 	_cQuery += " FROM "+RetSqlName("SC2")+" SC2 "
 	
 	_cQuery += " LEFT JOIN "+RetSqlName("SB1")+" SB1 "
 	_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "' "
 	_cQuery += " AND B1_COD = SC2.C2_PRODUTO "
 	_cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
 	
 	_cQuery += " LEFT JOIN "+RetSqlName("SC6")+" SC6 "
 	_cQuery += " ON C6_FILIAL = '" + xFilial("SC6") + "' "
 	_cQuery += " AND C6_NUM = SC2.C2_PEDIDO "
 	_cQuery += " AND C6_ITEM = SC2.C2_ITEMPV "
 	_cQuery += " AND C6_PRODUTO = SC2.C2_PRODUTO "
 	_cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
 	
 	_cQuery += " LEFT JOIN "+RetSqlName("SA1")+" SA1 "
 	_cQuery += " ON A1_FILIAL = '" + xFilial("SA1") + "' "
 	_cQuery += " AND A1_COD = SC6.C6_CLI "
 	_cQuery += " AND A1_LOJA = SC6.C6_LOJA "
 	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
 	
 	_cQuery += " LEFT JOIN "+RetSqlName("SA7")+" SA7 "
 	_cQuery += " ON A7_FILIAL = '" + xFilial("SA7") + "' "
 	_cQuery += " AND A7_CLIENTE = SC6.C6_CLI "
 	_cQuery += " AND A7_LOJA = SC6.C6_LOJA "
 	_cQuery += " AND A7_PRODUTO = SC6.C6_PRODUTO "
 	_cQuery += " AND SA7.D_E_L_E_T_ = ' ' "
 	
 	_cQuery += " LEFT JOIN "+RetSqlName("SG2")+" SG2 "
 	_cQuery += " ON G2_FILIAL = '" + xFilial("SG2") + "' "
 	_cQuery += " AND G2_PRODUTO = SC2.C2_PRODUTO "
 	_cQuery += " AND SG2.D_E_L_E_T_ = ' ' "
 	
 	_cQuery += " LEFT JOIN "+RetSqlName("SH8")+" SH8 "
 	_cQuery += " ON H8_FILIAL = '" + xFilial("SH8") + "' "
 	_cQuery += " AND H8_OP = SC2.C2_NUM||SC2.C2_ITEM||SC2.C2_SEQUEN||SC2.C2_ITEMGRD "
 	_cQuery += " AND H8_OPER = SG2.G2_OPERAC "
 	_cQuery += " AND SH8.D_E_L_E_T_ = ' ' "
 	
 	_cQuery += " LEFT JOIN "+RetSqlName("SH1")+" SH1H8 "
 	_cQuery += " ON SH1H8.H1_FILIAL = '" + xFilial("SH1") + "' "
 	_cQuery += " AND SH1H8.H1_CODIGO = H8_RECURSO "
 	_cQuery += " AND SH1H8.D_E_L_E_T_ = ' ' "
  
 	_cQuery += " LEFT JOIN "+RetSqlName("SH1")+" SH1G2 "
 	_cQuery += " ON SH1G2.H1_FILIAL = '" + xFilial("SH1") + "' "
 	_cQuery += " AND SH1G2.H1_CODIGO = G2_RECURSO "
 	_cQuery += " AND SH1G2.D_E_L_E_T_ = ' ' "
 	
 	_cQuery += " WHERE "
 	_cQuery += " SC2.C2_FILIAL='"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_=' ' AND "
 	If	Upper(TcGetDb()) $ 'ORACLE,DB2,POSTGRES,INFORMIX'
 		_cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD >= '" + mv_par01 + "' AND "
 		_cQuery += "SC2.C2_NUM || SC2.C2_ITEM || SC2.C2_SEQUEN || SC2.C2_ITEMGRD <= '" + mv_par02 + "' AND "
 	Endif
 	_cQuery += " SC2.C2_DATPRF BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "' "
 	If mv_par07 == 2
 		_cQuery += " AND SC2.C2_DATRF = ' '"
	Endif	
	//Ordem
	_cQuery += " ORDER BY SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SC2.C2_ITEMGRD,BENEFI,SC2.C2_XRETCOM,SG2.G2_OPERAC  "
	TcQuery _cQuery New Alias &(_cAliasTmp)
	
//	TCSetField ( < cAlias>, < cCampo>, < cTipo>, [ nTamanho], [ nDecimais] ) 	
	TCSetField (_cAliasTmp, "C2_DATPRF"	, "D", TAMSX3("C2_DATPRF")[1]	, TAMSX3("C2_DATPRF")[1] ) 	
	TCSetField (_cAliasTmp, "C2_DATRF"	, "D", TAMSX3("C2_DATRF")[1]	, TAMSX3("C2_DATRF")[1] )
	TCSetField (_cAliasTmp, "C2_DATPRI"	, "D", TAMSX3("C2_DATPRI")[1]	, TAMSX3("C2_DATPRI")[1] )
	TCSetField (_cAliasTmp, "C2_DATAJF"	, "D", TAMSX3("C2_DATAJF")[1]	, TAMSX3("C2_DATAJF")[1] )
	TCSetField (_cAliasTmp, "C6_ENTREG"	, "D", TAMSX3("C6_ENTREG")[1]	, TAMSX3("C6_ENTREG")[1] )
	TCSetField (_cAliasTmp, "H8_DTINI"	, "D", TAMSX3("H8_DTINI")[1]	, TAMSX3("H8_DTINI")[1] )
	TCSetField (_cAliasTmp, "H8_DTFIM"	, "D", TAMSX3("H8_DTFIM")[1]	, TAMSX3("H8_DTFIM")[1] )
	TCSetField (_cAliasTmp, "C2_QUJE"	, "N", TAMSX3("C2_QUJE")[1]		, TAMSX3("C2_QUJE")[1] )
	TCSetField (_cAliasTmp, "C2_PERDA"	, "N", TAMSX3("C2_PERDA")[1]	, TAMSX3("C2_PERDA")[1] )
	TCSetField (_cAliasTmp, "C2_QUANT"	, "N", TAMSX3("C2_QUANT")[1]	, TAMSX3("C2_QUANT")[1] )
	
Return()

Static Function _fGetEnd()

	Local _cEnde		:= ""
	Local _cQuery		:= ""
	Local _cAliasEnd	:= GetNextAlias()
	
	_cQuery	:= "SELECT D1_ENDER "
	_cQuery	+= " FROM " + RetSqlName("SD1")
	_cQuery	+= " WHERE D1_FILIAL = '" + xFilial("SD1") + "'"
	_cQuery	+= " AND D1_COD = '" + SB1->B1_COD + "'"
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasEnd)

Return(_cEnde)

Static Function AjustaSX1(_cPerg)

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

aHelpPor := {'Nr OP inicial a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Nr OP inicial a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Nr OP inicial a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"01","Da O.P. ?","¿De O.P. ?","From Product.Order ?","mv_ch1","C",13,0,0,"G","","","","","mv_par01","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Nr OP final a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Nr OP final a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Nr OP final a ser considerado na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"02","Ate O.P. ?","¿A O.P. ?","To Product.Order ?","mv_ch2","C",13,0,0,"G","","","","","mv_par02","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Data OP inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Data OP inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Data OP inicial a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"03","Da data ?","¿De Fecha ?","From Date ?","mv_ch3","D",8,0,0,"C","","","","","mv_par03","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Data OP final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpEng := {'Data OP final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
aHelpSpa := {'Data OP final a ser considerada na  ','filtragem do cadastro de OPs (SC2).  '}
PutSx1(_cPerg,"04","Ate data ?","¿A Fecha ?","To Date ?","mv_ch4","D",8,0,0,"C","","","","","mv_par04","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Considera a impressao do código de  ','barras do número da ordem de produção.  '}
aHelpEng := {'Considera a impressao do código de  ','barras do número da ordem de produção.  '}
aHelpSpa := {'Considera a impressao do código de  ','barras do número da ordem de produção.  '}
PutSx1(_cPerg,"05","Imprime Cod. Barras ?","¿Imprime Cod. Barras ?","Print Barcode ?","mv_ch5","N",1,0,2,"C","","","","","mv_par05","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Considera a descrição do produto por  ','descrição científica ou generica ou o  ','que foi cadastrado no pedido de venda'}
aHelpEng := {'Considera a descrição do produto por  ','descrição científica ou generica ou o  ','que foi cadastrado no pedido de venda'}
aHelpSpa := {'Considera a descrição do produto por  ','descrição científica ou generica ou o  ','que foi cadastrado no pedido de venda'}
PutSx1(_cPerg,"06","Descricao Produto ?","¿Description Producto. ?","Product Description ?","mv_ch6","N",1,0,2,"C","","","","","mv_par06","Descr.Cient","Descr.Cient","Scient.Descr.","" ,"Descr.Generica","Descr.Generica","General Descr.","Pedido Venda","Pedido de Venta","Sales Order","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Imprime as Ordens de Produção  ','Encerradas.  '}
aHelpEng := {'Imprime as Ordens de Produção  ','Encerradas.  '}
aHelpSpa := {'Imprime as Ordens de Produção  ','Encerradas.  '}
PutSx1(_cPerg,"07","Impr. Op Encerrada ?","¿Impr. OP Cerrada ?","Print Finished Prod.Order ?","mv_ch7","N",1,0,2,"C","","","","","mv_par07","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Define se o relatorio sera impresso por','ordem de Produto ou de Sequencia na','Estrutura'}
aHelpEng := {'Define se o relatorio sera impresso por','ordem de Produto ou de Sequencia na','Estrutura'}
aHelpSpa := {'Define se o relatorio sera impresso por','ordem de Produto ou de Sequencia na','Estrutura'}
PutSx1(_cPerg,"08","Impr. por Ordem de ?","¿Impr. por Orden de ?","Print by ?","mv_ch8","N",1,0,2,"C","","","","","mv_par08","Codigo","Codigo","Code","" ,"Sequencia","Secuencia","Sequence","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Considera as OPs firmes, previstas ou ','ambas do cadastro de OPs (SC2). '}
aHelpEng := {'Considera as OPs firmes, previstas ou ','ambas do cadastro de OPs (SC2). '}
aHelpSpa := {'Considera as OPs firmes, previstas ou ','ambas do cadastro de OPs (SC2). '}
PutSx1(_cPerg,"09","Considera Ops ?","¿Considera OPs ?","Condis.Prod.Orders ?","mv_ch9","N",1,0,2,"C","","","","","mv_par09","Firmes","Firmes","Confirmed","" ,"Previstas","Previstas","Estimated","Ambas","Ambas","Both","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Indica se imprime ou não itens','negativos empenhados.','O parametro MV_NEGESTR tambem','sera avaliado'}
aHelpEng := {'Indica se imprime ou não itens','negativos empenhados.','O parametro MV_NEGESTR tambem','sera avaliado'}
aHelpSpa := {'Indica se imprime ou não itens','negativos empenhados.','O parametro MV_NEGESTR tambem','sera avaliado'}
PutSx1(_cPerg,"10","Item Neg. na Estrut ?","¿Item Neg. en la Estruct. ?","Neg. Item in Structure ?","mv_cha","N",1,0,2,"C","","","","","mv_par10","Imprime","Imprime","Print","" ,"Nao Imprime","No Imprime","Do Not Print","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Opcao para a impressao do produto com  ','rastreabilidade por Lote ou Sub-Lote.  '}
aHelpEng := {'Option to print the product with       ','trackability by Lot or Sub-lot.        '}
aHelpSpa := {'Opcion para la impresion del producto  ','con trazabilidad por Lote o Sublote.   '}
PutSx1(_cPerg,"11","Imprime Lote/S.Lote ?","¿Imprime Lote/Subl. ?","Print Lot/Sublot ?","mv_chb","N",1,0,2,"C","","","","","mv_par11","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Define o tipo de impressão do relaório  ','Excel ou Spool.  '}
aHelpEng := {'Define o tipo de impressão do relaório  ','Excel ou Spool.  '}
aHelpSpa := {'Define o tipo de impressão do relaório  ','Excel ou Spool.  '}
PutSx1(_cPerg,"12","Imprime em Excel ?","¿Imprime em Excel ?","Print in Excel ?","mv_chc","N",1,0,2,"C","","","","","mv_par12","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

Return
