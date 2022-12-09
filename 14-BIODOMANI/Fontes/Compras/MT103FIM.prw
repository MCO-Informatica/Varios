#Include 'Protheus.ch'

User Function MT103FIM()
	Local aAreaAtu := getarea()
	Local aAreaSD1 := sd1->(getarea())

	Local nRotina  := paramixb[1]  //3=Incluir 4=Classificar 5=Excluir
	Local nOpca    := paramixb[2]  //1= Ok

	//Local nOpc     := 3 //inclusão da movimentação interna
	//Local aMovInt  := {}

	Local l01a3 := .f.

	//Private lMsErroAuto := .f.
IF Alltrim(Funname()) == "MATA103"
	If nOpca == 1 .and. nRotina == 4

		sd1->( dbSetOrder(1) )
		sd1->( dbSeek(xfilial()+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja) )
		While !sd1->(Eof()) .And. sd1->(d1_filial+d1_doc+d1_serie+d1_fornece+d1_loja) == sf1->(f1_filial+F1_doc+F1_serie+F1_fornece+F1_loja)

			if sd1->d1_local == "01A3"
				l01a3 := .t.
			endif
			/*
			If sd1->d1_xqtdlab > 0 .and. ;
				cA100For == '001900' .and. cLoja == '01' .and. cEspecie == 'NFE  ' .and. cSerie == 'F03' .and. cTipo == 'N'

				Begin Transaction
					aMovInt := {}
					aadd(aMovInt,{"D3_FILIAL",xfilial("SD3"),})
					aadd(aMovInt,{"D3_TM","600",})		//Se precisar dar entrada seria o TM 300
					aadd(aMovInt,{"D3_COD",SD1->D1_COD,})
					aadd(aMovInt,{"D3_UM",SD1->D1_UM,})
					aadd(aMovInt,{"D3_LOCAL",SD1->D1_LOCAL,})
					aadd(aMovInt,{"D3_LOTECTL",SD1->D1_LOTECTL,})
					aadd(aMovInt,{"D3_DTVALID",SD1->D1_DTVALID,})
					aadd(aMovInt,{"D3_QUANT",sd1->d1_xqtdlab,})
					aadd(aMovInt,{"D3_EMISSAO",dDataBase,})
					aadd(aMovInt,{"D3_DOC",SD1->D1_DOC,})
					//SD3->D3_CF    	:=	"DE4"
					//SD3->D3_CHAVE		:=	"E0"
					MSExecAuto({|x,y| mata240(x,y)},aMovInt,nOpc)
					If lMsErroAuto
						MessageBox("Erro na Inclusão de movimentação interna!","ATENÇÃO", 16)
					EndIf
				End Transaction
			EndIf
			*/
			sd1->(dbSkip())
		End

		if l01a3
			u_rcoma001()
			u_docgrf(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA)
			u_etq05()
		endif

	EndIf
ENDIF

	RestArea(aAreaSD1)
	RestArea(aAreaAtu)

Return
