#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SF2460I  บ Autor ณCristiano Figueiroa บ Data ณ  30/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada para gravar o Campo C5_FORMAPG nos Titulosบฑฑ
ฑฑบ          ณ a receber para se verificar a forma de pagamento escolhida บฑฑ
ฑฑบ          ณ pelo cliente.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ           BIOMARINE COSMOBEAUTY                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                                                            

User Function SF2460I

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGuarda Area do Sigaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	_alias := alias()
	_ind   := IndexOrd()
	_sRec  := Recno()
	_WBASEST := 0
	_WVLRST  := 0

	_indE1 := SE1->(IndexOrd())
	_sReE1 := SE1->(Recno())

	Setprvt("_alias,_ind,_sRec,_indE1,_sReE1,_Prefixo,_Num,_Filial,_Cliente,_Loja,_FormaPg,_WBASEST,_WVLRST")

	_Prefixo := SF2->F2_SERIE
	_Num     := SF2->F2_DOC
	_Filial  := SF2->F2_FILIAL
	_Cliente := SF2->F2_CLIENTE
	_Loja    := SF2->F2_LOJA
	_FormaPg := SC5->C5_FORMAPG
	_nCount	 := 0


	RecLock("SF2",.f.)
	SF2->F2_X_EMPFA := SC5->C5_X_EMPFA
	MsUnLock()

	RecLock("SC5",.f.)
	SC5->C5_X_DATFA := SF2->F2_EMISSAO
	MsUnLock()

	If sc5->c5_formapg != 'DV'

		DbselectArea("SE1")
		dbSetOrder(2)    // Cliente + Loja + Prefixo + Numero + Parcela + Tipo

		If dbSeek(xFilial("SE1")+ _Cliente + _Loja + _Prefixo + _Num)

			While _Filial==SE1->E1_FILIAL .AND. _Prefixo == SE1->E1_PREFIXO .And. ;
					_Num == SE1->E1_NUM .And. _Cliente == SF2->F2_CLIENTE .And. _Loja == SF2->F2_LOJA

				_nCount := _nCount+1

				reclock("SE1",.F.)

				If _nCount==1
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG01,_FormaPg)
				ElseIf _nCount==2
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG02,_FormaPg)
				ElseIf _nCount==3
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG03,_FormaPg)
				ElseIf _nCount==4
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG04,_FormaPg)
				ElseIf _nCount==5
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG05,_FormaPg)
				ElseIf _nCount==6
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG06,_FormaPg)
				ElseIf _nCount==7
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG07,_FormaPg)
				ElseIf _nCount==8
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG08,_FormaPg)
				ElseIf _nCount==9
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG09,_FormaPg)
				ElseIf _nCount==10
					SE1->E1_FORMAPG := Iif(_FormaPg$"DV",SC5->C5_X_FPG10,_FormaPg)
				EndIf

				SE1->E1_X_AUTCC	:= SC5->C5_X_AUTOR
				SE1->E1_X_TERMI	:= SC5->C5_X_TERMI
				SE1->E1_X_DATCC := SC5->C5_X_DATCC
				SE1->E1_X_OBS1	:= SC5->C5_OBS1
				SE1->E1_X_OBS2	:= SC5->C5_OBS2
				SE1->E1_X_OBS3	:= SC5->C5_OBS3
				msunlock()
				dbSkip()

			Enddo

		Endif
	EndIf

	_WBASEST := 0
	_WVLRST  := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRetorna Area do Sigaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SE1")
	DbSetOrder(_indE1)
	DbGoTo(_sReE1)


	DbSelectArea(_alias)
	dbSetOrder(_ind)
	DbGoto(_sRec)

Return
