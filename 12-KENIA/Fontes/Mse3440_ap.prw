#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mse3440()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_CREGIST,_CORDEM,_CEMP,_LDEVOL,_CXRSD1")
SetPrvt("_CXOSD1,_CREGSE1,_CORSE1,_CREGSE3,_CORDSE3,_CPREFIXO")
SetPrvt("_CTITULO,_CCHAVE,_CCHAVE1,_PATH,_CRSD1,_COSD1")

_cALIAS  := ALIAS()
_cREGIST := RECNO()
_cORDEM  := IndexOrd()

_cEmp    := SM0->M0_CODIGO
_lDevol  := .T.


////\\\\ Verifica se e' meia nota:
If SE3->E3_TIPO=="NCC" .and. _cEmp == "01" //.and. inclui
   DbSelectArea("SD1")
   _cXRSD1 := RECNO()
   _cXOSD1	:= IndexOrd()
   DbSetOrder(1)
   If DbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE )
	  If Len(SD1->D1_COD)<>7 .or. Substr(SD1->D1_COD,1)<>"1"
		 _lDevol := .F.
	  EndIf
   EndIf
   DbSelectArea("SD1")
   DbGoto( _cXRSD1 )
   DbSetOrder( _cXOSD1 )
Else
   _lDevol := .F.
EndIf

If _lDevol

	 DbSelectArea("SE1")
	 _cREGSE1 := RECNO()
	 _cORSE1  := IndexOrd()

	 DbSelectArea("SE3")
	 _cREGSE3 := RECNO()
	 _cORDSE3  := IndexOrd()

	_cPREFIXO	:= SE1->E1_PREFIXO
	_cTITULO	:= SE1->E1_NUM
	_cCHAVE 	:= xFilial("SE1") + _cPREFIXO + _cTITULO
	_cCHAVE1	:= xFilial("SE1") + _cPREFIXO + _cTITULO
	_PATH		:= "SE1030"

	DbUseArea( .T. ,"TOPCONN" , "SF1030" , "NSF1", .T., .F. )  // Abre arquivo Kenia - Matriz empresa 03
	DbUseArea( .T. ,"TOPCONN" , "SD1030" , "NSD1", .T., .F. )  // Abre arquivo Kenia - Filial empresa 03
	DbUseArea( .T. ,"TOPCONN" , "SE1030" , "NSE1", .T., .F. )  // Abre arquivo Kenia - Matriz empresa 03
	DbUseArea( .T. ,"TOPCONN" , "SE3030" , "NSE3", .T., .F. )  // Abre arquivo Kenia - Filial empresa 03

	DbSelectArea("NSF1")
	DbSetOrder(1)
	If !DbSeek( xFilial("SF1") + SF1->F1_DOC + SF1->F1_SERIE )
	   RecLock("NSF1", .t. )
		  NSF1->F1_FILIAL  := SF1->F1_FILIAL
		  NSF1->F1_DOC	   := SF1->F1_DOC
		  NSF1->F1_SERIE   := SF1->F1_SERIE
		  NSF1->F1_FORNECE := SF1->F1_FORNECE
		  NSF1->F1_LOJA    := SF1->F1_LOJA
		  NSF1->F1_COND    := SF1->F1_COND
		  NSF1->F1_DUPL    := SF1->F1_DUPL
		  NSF1->F1_EMISSAO := SF1->F1_EMISSAO
		  NSF1->F1_EST	   := SF1->F1_EST
		  NSF1->F1_FRETE   := SF1->F1_FRETE
		  NSF1->F1_DESPESA := SF1->F1_DESPESA
		  NSF1->F1_BASEICM := SF1->F1_BASEICM
		  NSF1->F1_VALICM  := SF1->F1_VALICM
		  NSF1->F1_BASEIPI := SF1->F1_BASEIPI
		  NSF1->F1_VALIPI  := SF1->F1_VALIPI
		  NSF1->F1_VALMERC := SF1->F1_VALMERC
		  NSF1->F1_VALBRUT := SF1->F1_VALBRUT
		  NSF1->F1_TIPO    := SF1->F1_TIPO
		  NSF1->F1_DESCONT := SF1->F1_DESCONT
		  NSF1->F1_NFORI   := SF1->F1_NFORI
		  NSF1->F1_SERIORI := SF1->F1_SERIORI
		  NSF1->F1_DTDIGIT := SF1->F1_DTDIGIT
		  NSF1->F1_CPROVA  := SF1->F1_CPROVA
		  NSF1->F1_BRICMS  := SF1->F1_BRICMS
		  NSF1->F1_ICMSRET := SF1->F1_ICMSRET
		  NSF1->F1_BASEFD  := SF1->F1_BASEFD
		  NSF1->F1_DTLANC  := SF1->F1_DTLANC
		  NSF1->F1_OK	   := SF1->F1_OK
		  NSF1->F1_ORIGLAN := SF1->F1_ORIGLAN
		  NSF1->F1_TX	   := SF1->F1_TX
		  NSF1->F1_CONTSOC := SF1->F1_CONTSOC
		  NSF1->F1_IRRF    := SF1->F1_IRRF
		  NSF1->F1_FORMUL  := SF1->F1_FORMUL
		  NSF1->F1_NFORIG  := SF1->F1_NFORIG
		  NSF1->F1_SERORIG := SF1->F1_SERORIG
		  NSF1->F1_ESPECIE := SF1->F1_ESPECIE
		  NSF1->F1_IMPORT  := SF1->F1_IMPORT
		  NSF1->F1_II	   := SF1->F1_II
		  NSF1->F1_REMITO  := SF1->F1_REMITO
		  NSF1->F1_BASIMP1 := SF1->F1_BASIMP1
		  NSF1->F1_BASIMP2 := SF1->F1_BASIMP2
		  NSF1->F1_BASIMP3 := SF1->F1_BASIMP3
		  NSF1->F1_BASIMP4 := SF1->F1_BASIMP4
		  NSF1->F1_BASIMP5 := SF1->F1_BASIMP5
		  NSF1->F1_BASIMP6 := SF1->F1_BASIMP6
		  NSF1->F1_VALIMP1 := SF1->F1_VALIMP1
		  NSF1->F1_VALIMP2 := SF1->F1_VALIMP2
		  NSF1->F1_VALIMP3 := SF1->F1_VALIMP3
		  NSF1->F1_VALIMP4 := SF1->F1_VALIMP4
		  NSF1->F1_VALIMP5 := SF1->F1_VALIMP5
		  NSF1->F1_VALIMP6 := SF1->F1_VALIMP6
		  NSF1->F1_ORDPAGO := SF1->F1_ORDPAGO
		  NSF1->F1_HORA    := SF1->F1_HORA
		  NSF1->F1_INSS    := SF1->F1_INSS
		  NSF1->F1_ISS	   := SF1->F1_ISS
		  NSF1->F1_HAWB    := SF1->F1_HAWB
		  NSF1->F1_TIPO_NF := SF1->F1_TIPO_NF
		  NSF1->F1_IPI	   := SF1->F1_IPI
		  NSF1->F1_ICMS    := SF1->F1_ICMS
		  NSF1->F1_PESOL   := SF1->F1_PESOL
		  NSF1->F1_FOB_R   := SF1->F1_FOB_R
		  NSF1->F1_SEGURO  := SF1->F1_SEGURO
		  NSF1->F1_CIF	   := SF1->F1_CIF
		  NSF1->F1_DT_CONT := SF1->F1_DT_CONT
		  NSF1->F1_DT_ESTO := SF1->F1_DT_ESTO
	  MsUnLock()
	EndIf

	DbSelectArea("SF1")

	DbSelectArea("SD1")
	_cRSD1 := RECNO()
	_cOSD1	:= IndexOrd()
	DbSetOrder(1)
	If DbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE )

	   While SD1->D1_FILIAL == xFilial("SD1") .and. ;
			 SD1->D1_DOC == SF1->F1_DOC .and. ;
			 SD1->D1_SERIE == SF1->F1_SERIE

			 DbSelectArea("NSD1")
			 DbSetOrder(1)
			 If !DbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE )
				 RecLock("NSD1" , .t. )
					NSD1->D1_FILIAL  := SD1->D1_FILIAL
					NSD1->D1_COD	 := SD1->D1_COD
					NSD1->D1_UM 	 := SD1->D1_UM
					NSD1->D1_SEGUM	 := SD1->D1_SEGUM
					NSD1->D1_QUANT	 := SD1->D1_QUANT
					NSD1->D1_VUNIT	 := SD1->D1_VUNIT
					NSD1->D1_TOTAL	 := SD1->D1_TOTAL
					NSD1->D1_VALIPI  := SD1->D1_VALIPI
					NSD1->D1_VALICM  := SD1->D1_VALICM
					NSD1->D1_TES	 := SD1->D1_TES
					NSD1->D1_CF 	 := SD1->D1_CF
					NSD1->D1_DESC	 := SD1->D1_DESC
					NSD1->D1_IPI	 := SD1->D1_IPI
					NSD1->D1_PICM	 := SD1->D1_PICM
					NSD1->D1_PESO	 := SD1->D1_PESO
					NSD1->D1_CONTA	 := SD1->D1_CONTA
					NSD1->D1_CC 	 := SD1->D1_CC
					NSD1->D1_ITEMCTA := SD1->D1_ITEMCTA
					NSD1->D1_OP 	 := SD1->D1_OP
					NSD1->D1_PEDIDO  := SD1->D1_PEDIDO
					NSD1->D1_ITEMPC  := SD1->D1_ITEMPC
					NSD1->D1_FORNECE := SD1->D1_FORNECE
					NSD1->D1_LOJA	 := SD1->D1_LOJA
					NSD1->D1_LOCAL	 := SD1->D1_LOCAL
					NSD1->D1_DOC	 := SD1->D1_DOC
					NSD1->D1_EMISSAO := SD1->D1_EMISSAO
					NSD1->D1_DTDIGIT := SD1->D1_DTDIGIT
					NSD1->D1_GRUPO	 := SD1->D1_GRUPO
					NSD1->D1_TIPO	 := SD1->D1_TIPO
					NSD1->D1_SERIE	 := SD1->D1_SERIE
					NSD1->D1_CUSTO	 := SD1->D1_CUSTO
					NSD1->D1_CUSTO2  := SD1->D1_CUSTO2
					NSD1->D1_CUSTO3  := SD1->D1_CUSTO3
					NSD1->D1_CUSTO4  := SD1->D1_CUSTO4
					NSD1->D1_CUSTO5  := SD1->D1_CUSTO5
					NSD1->D1_TP 	 := SD1->D1_TP
					NSD1->D1_QTSEGUM := SD1->D1_QTSEGUM
					NSD1->D1_NUMSEQ  := SD1->D1_NUMSEQ
					NSD1->D1_DATACUS := SD1->D1_DATACUS
					NSD1->D1_NFORI	 := SD1->D1_NFORI
					NSD1->D1_SERIORI := SD1->D1_SERIORI
					NSD1->D1_ITEMORI := SD1->D1_ITEMORI
					NSD1->D1_QTDEDEV := SD1->D1_QTDEDEV
					NSD1->D1_VALDEV  := SD1->D1_VALDEV
					NSD1->D1_ORIGLAN := SD1->D1_ORIGLAN
					NSD1->D1_ICMSRET := SD1->D1_ICMSRET
					NSD1->D1_BRICMS  := SD1->D1_BRICMS
					NSD1->D1_NUMCQ	 := SD1->D1_NUMCQ
					NSD1->D1_ITEM	 := SD1->D1_ITEM
					NSD1->D1_BASEICM := SD1->D1_BASEICM
					NSD1->D1_VALDESC := SD1->D1_VALDESC
					NSD1->D1_IDENTB6 := SD1->D1_IDENTB6
					NSD1->D1_LOTEFOR := SD1->D1_LOTEFOR
					NSD1->D1_SKIPLOT := SD1->D1_SKIPLOT
					NSD1->D1_BASEIPI := SD1->D1_BASEIPI
					NSD1->D1_SEQCALC := SD1->D1_SEQCALC
					NSD1->D1_LOTECTL := SD1->D1_LOTECTL
					NSD1->D1_NUMLOTE := SD1->D1_NUMLOTE
					NSD1->D1_DTVALID := SD1->D1_DTVALID
					NSD1->D1_PLACA	 := SD1->D1_PLACA
					NSD1->D1_CHASSI  := SD1->D1_CHASSI
					NSD1->D1_ANOFAB  := SD1->D1_ANOFAB
					NSD1->D1_MODFAB  := SD1->D1_MODFAB
					NSD1->D1_MODELO  := SD1->D1_MODELO
					NSD1->D1_COMBUST := SD1->D1_COMBUST
					NSD1->D1_COR	 := SD1->D1_COR
					NSD1->D1_EQUIPS  := SD1->D1_EQUIPS
					NSD1->D1_FORMUL := SD1->D1_FORMUL
					NSD1->D1_II 	 := SD1->D1_II
					NSD1->D1_TEC	 := SD1->D1_TEC
					NSD1->D1_CONHEC  := SD1->D1_CONHEC
   //				  NSD1->D1_GERAPV  := SD1->D1_GERAPV
					NSD1->D1_NUMPV	 := SD1->D1_NUMPV
					NSD1->D1_ITEMPV  := SD1->D1_ITEMPV
					NSD1->D1_CUSFF1  := SD1->D1_CUSFF1
					NSD1->D1_CUSFF2  := SD1->D1_CUSFF2
					NSD1->D1_CUSFF3  := SD1->D1_CUSFF3
					NSD1->D1_CUSFF4  := SD1->D1_CUSFF4
					NSD1->D1_CUSFF5  := SD1->D1_CUSFF5
					NSD1->D1_CLASFIS := SD1->D1_CLASFIS
					NSD1->D1_CODCIAP := SD1->D1_CODCIAP
					NSD1->D1_BASIMP1 := SD1->D1_BASIMP1
					NSD1->D1_REMITO  := SD1->D1_REMITO
					NSD1->D1_BASIMP2 := SD1->D1_BASIMP2
					NSD1->D1_BASIMP3 := SD1->D1_BASIMP3
					NSD1->D1_BASIMP4 := SD1->D1_BASIMP4
					NSD1->D1_BASIMP5 := SD1->D1_BASIMP5
					NSD1->D1_BASIMP6 := SD1->D1_BASIMP6
					NSD1->D1_VALIMP1 := SD1->D1_VALIMP1
					NSD1->D1_VALIMP2 := SD1->D1_VALIMP2
					NSD1->D1_VALIMP3 := SD1->D1_VALIMP3
					NSD1->D1_VALIMP4 := SD1->D1_VALIMP4
					NSD1->D1_VALIMP5 := SD1->D1_VALIMP5
					NSD1->D1_VALIMP6 := SD1->D1_VALIMP6
					NSD1->D1_CBASEAF := SD1->D1_CBASEAF
					NSD1->D1_ICMSCOM := SD1->D1_ICMSCOM
					NSD1->D1_CIF	 := SD1->D1_CIF
					NSD1->D1_TIPO_NF := SD1->D1_TIPO_NF
			 EndIf
			 MsUnLock()

			 DbSelectArea("SD1")
			 DbSkip()
	   EndDo
	EndIf

	DbSelectArea("SE1")  // le arquivo Kenia matriz
	DbSetOrder(1)
	If DbSeek( xFilial("SE1") + _cPREFIXO + _cTITULO )

	   While SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM ==	_cCHAVE .AND. !Eof()

		  DbSelectArea("NSE1")  // le arquivo Kenia matriz
		  RecLock("NSE1", .t. )
		  NSE1->E1_FILIAL  := SE1->E1_FILIAL
		  NSE1->E1_PREFIXO := SE1->E1_PREFIXO
		  NSE1->E1_NUM	   := SE1->E1_NUM
		  NSE1->E1_PARCELA := SE1->E1_PARCELA
		  NSE1->E1_TIPO    := SE1->E1_TIPO
		  NSE1->E1_NATUREZ := SE1->E1_NATUREZ
		  NSE1->E1_PORTADO := SE1->E1_PORTADO
		  NSE1->E1_CLIENTE := SE1->E1_CLIENTE
		  NSE1->E1_LOJA    := SE1->E1_LOJA
		  NSE1->E1_NOMCLI  := SE1->E1_NOMCLI
		  NSE1->E1_EMISSAO := SE1->E1_EMISSAO
		  NSE1->E1_VENCTO  := SE1->E1_VENCTO
		  NSE1->E1_VENCREA := SE1->E1_VENCREA
		  NSE1->E1_VALOR   := SE1->E1_VALOR
		  NSE1->E1_IRRF    := SE1->E1_IRRF
		  NSE1->E1_ISS	   := SE1->E1_ISS
		  NSE1->E1_BAIXA   := SE1->E1_BAIXA
		  NSE1->E1_HIST    := SE1->E1_HIST
		  NSE1->E1_SITUACA := SE1->E1_SITUACA
		  NSE1->E1_SALDO   := SE1->E1_SALDO
		  NSE1->E1_SUPERVI := SE1->E1_SUPERVI
		  NSE1->E1_VEND1   := SE1->E1_VEND1
		  NSE1->E1_VEND2   := SE1->E1_VEND2
		  NSE1->E1_VEND3   := SE1->E1_VEND3
		  NSE1->E1_VEND4   := SE1->E1_VEND4
		  NSE1->E1_VEND5   := SE1->E1_VEND5
		  NSE1->E1_COMIS1  := SE1->E1_COMIS1
		  NSE1->E1_COMIS2  := SE1->E1_COMIS2
		  NSE1->E1_COMIS3  := SE1->E1_COMIS3
		  NSE1->E1_COMIS4  := SE1->E1_COMIS4
		  NSE1->E1_COMIS5  := SE1->E1_COMIS5
		  NSE1->E1_DESCONT := SE1->E1_DESCONT
		  NSE1->E1_MULTA   := SE1->E1_MULTA
		  NSE1->E1_JUROS   := SE1->E1_JUROS
		  NSE1->E1_VALLIQ  := SE1->E1_VALLIQ
		  NSE1->E1_MOEDA   := SE1->E1_MOEDA
		  NSE1->E1_BASCOM1 := SE1->E1_BASCOM1
		  NSE1->E1_BASCOM2 := SE1->E1_BASCOM2
		  NSE1->E1_BASCOM3 := SE1->E1_BASCOM3
		  NSE1->E1_BASCOM4 := SE1->E1_BASCOM4
		  NSE1->E1_BASCOM5 := SE1->E1_BASCOM5
		  NSE1->E1_FATURA  := SE1->E1_FATURA
		  NSE1->E1_OK	   := SE1->E1_OK
		  NSE1->E1_VALCOM1 := SE1->E1_VALCOM1
		  NSE1->E1_VALCOM2 := SE1->E1_VALCOM2
		  NSE1->E1_VALCOM3 := SE1->E1_VALCOM3
		  NSE1->E1_VALCOM4 := SE1->E1_VALCOM4
		  NSE1->E1_VALCOM5 := SE1->E1_VALCOM5
		  NSE1->E1_PEDIDO  := SE1->E1_PEDIDO
		  NSE1->E1_STATUS  := SE1->E1_STATUS
//		  NSE1->E1_ORIGEM  := SE1->E1_ORIGEM
//			NSE1->E1_DESCFIN := SE1->E1_DESCFIN
		  NSE1->E1_DIADESC := SE1->E1_DIADESC
		  MsUnLock()

		  DbSelectArea("SE1")
		  DbSkip()
	   EndDo
	EndIf

	DbSelectArea("SE3")  // le arquivo Kenia matriz
	DbSetOrder(1)
	If DbSeek( xFilial("SE3") + _cPREFIXO + _cTITULO )

	   While SE3->E3_FILIAL == xFilial("SE3") .and. ;
			 SE3->E3_PREFIXO == _cPREFIXO .and. ;
			 SE3->E3_NUM == _cTITULO .and. !Eof()

		  DbSelectArea("NSE3")
		  RecLock("NSE3", .t.)
		  NSE3->E3_FILIAL  := SE3->E3_FILIAL
		  NSE3->E3_VEND    := SE3->E3_VEND
		  NSE3->E3_PREFIXO := SE3->E3_PREFIXO
		  NSE3->E3_NUM	   := SE3->E3_NUM
		  NSE3->E3_EMISSAO := SE3->E3_EMISSAO
		  NSE3->E3_SERIE   := SE3->E3_SERIE
		  NSE3->E3_CODCLI  := SE3->E3_CODCLI
		  NSE3->E3_LOJA    := SE3->E3_LOJA
		  NSE3->E3_BASE    := SE3->E3_BASE
		  NSE3->E3_PORC    := SE3->E3_PORC
		  NSE3->E3_COMIS   := SE3->E3_COMIS
		  NSE3->E3_DATA    := SE3->E3_DATA
		  NSE3->E3_PARCELA := SE3->E3_PARCELA
		  NSE3->E3_TIPO    := SE3->E3_TIPO
		  NSE3->E3_BAIEMI  := SE3->E3_BAIEMI
		  NSE3->E3_PEDIDO  := SE3->E3_PEDIDO
		  NSE3->E3_AJUSTE  := SE3->E3_AJUSTE
		  NSE3->E3_SEQ	   := SE3->E3_SEQ
		  NSE3->E3_ORIGEM  := SE3->E3_ORIGEM
		  MsUnlock()

		  DbSelectArea("SE3")
		  DbSkip()
	   EndDo
	EndIf

	DbSelectArea("NSE1")
	DbCloseArea("NSE1")

	DbSelectArea("NSD1")
	DbCloseArea("NSD1")

	DbSelectArea("SD1")
	DbGoto( _cRSD1 )
	DbSetOrder( _cOSD1 )

	DbSelectArea("NSF1")
	DbCloseArea("NSE1")

	DbSelectArea("SE1")
	DbGoto( _cREGSE1 )
	DbSetOrder( _cORSE1 )

	DbSelectArea("NSE3")
	DbCloseArea("NSE3")

	DbSelectArea("SE3")
	DbGoto( _cREGSE3 )
	DbSetOrder( _cORDSE3 )

ENDIF

DbSelectArea( _cALIAS )
DbGoto( _cREGIST )
DbSetOrder( _cORDEM )

Return()

