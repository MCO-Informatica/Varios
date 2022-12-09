user function 2tmkVfim()

_CPEDIDO := SC5->C5_NUM
_CATEND  := SC6->C6_PEDCLI
_CORC    := SUA->UA_NUM            
_CESTVER := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")
_CliCod  := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_COD")
_LojCod	 := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_LOJA")
_CliNom  := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")

IF SUA->UA_OPER == "1"
	DBSELECTAREA("SC5")
	RECLOCK("SC5",.F.)
	SC5->C5_NOMCLI  	:= POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
	SC5->C5_VKGFAT  	:= SUA->UA_VKGFAT
	SC5->C5_NOMVEN  	:= POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_NOME")
//  SC5->C5_VEND2   	:= POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_VEND2")
	SC5->C5_VRTIMER 	:= TIME()
	SC5->C5_EMISSAO 	:= DDATABASE
	SC5->C5_VROBSPV 	:= SUA->UA_VROBSPV
    SC5->C5_LIBEROK 	:= "S"       
   	SC5->C5_INDPRES 	:= "3"
	SC5->C5_PEDCLI      := SUA->UA_PEDCLI
	SC5->C5_MENNOTA     := SUA->UA_MENNOTA
	SC5->C5_MENNOT1     := SUA->UA_MENNOT1
	SC5->C5_VRBSPV      := SUA->UA_VRBSPV
	SC5->C5_FRETE       := SUA->UA_FRETE
	SC5->C5_VEND2		:= SUA->UA_VEND2
	SC5->C5_VEND3		:= SUA->UA_VEND3
	SC5->C5_VEND4		:= SUA->UA_VEND4	
	SC5->C5_VEND5		:= SUA->UA_VEND5
	SC5->C5_COMIS2		:= SUA->UA_COMIS2
	SC5->C5_COMIS3		:= SUA->UA_COMIS3
	SC5->C5_COMIS4		:= SUA->UA_COMIS4	
	SC5->C5_COMIS5		:= SUA->UA_COMIS5
	SC5->C5_TRANSP		:= SUA->UA_TRANSP
	SC5->C5_FRETE		:= SUA->UA_FRETE
	MSUNLOCK("SC5")
	
//--------------------------------------------------------------------------------------
//			CUSTOMIZA��O ADVTEC ----- ADICIONADO CAMPOS NA SUB PARA GRAVAR NA SC6
//-------------------------------------------------------------------------------------
	DBSELECTAREA("SUB")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SUB")+_CORC)
		WHILE !EOF() .AND. _CORC == SUB->UB_NUM
			_CPV     := SUB->UB_NUMPV
			_CIT     := SUB->UB_ITEMPV
			_CPRD    := SUB->UB_PRODUTO
            _CTESVER := POSICIONE("SF4",1,XFILIAL("SF4")+SUB->UB_TES,"F4_CF")
			
			DBSELECTAREA("SC6")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SC6")+_CPEDIDO+_CIT+_CPRD)
				
				RECLOCK("SC6",.F.)
				SC6->C6_VRDESC  := SUB->UB_VRDESC
				SC6->C6_VRSB2   := SUB->UB_VRSB2
				SC6->C6_VRSLDPR := SUB->UB_VRSLDPR
				SC6->C6_QTDLIB  := SUB->UB_QTDLIB
				SC6->C6_QTDEMP  := SUB->UB_QTDLIB
				SC6->C6_VRPOR   := SUB->UB_VRPOR
				SC6->C6_VRVLRDE := SUB->UB_VRVLRDE
				SC6->C6_PRUNIT  := 0               
//				SC6->C6_OPER	:= "01"
//				SC6->C6_OPER    := SUB->UB_VROPER
				SC6->C6_TES 	:= SUB->UB_TES
				SC6->C6_NUMPCOM := SUB->UB_NUMPCOM
				SC6->C6_ITEMPC  := SUB->UB_ITEMPC				

				IF _CESTVER == "SP"
				   SC6->C6_CF  := _CTESVER
				ELSEIF _CESTVER == "EX"
				   SC6->C6_CF  := "7"+SUBSTR(_CTESVER,2,3)
				ELSE
				   SC6->C6_CF  := "6"+SUBSTR(_CTESVER,2,3)
				ENDIF
				MSUNLOCK("SC6")
			ENDIF
			

            // LIBERA O PEDIDO QUE VEM DO CALL CENTER
			IF SUB->UB_QTDLIB > 0
               RECLOCK("SC9",.T.)                         
               SC9->C9_FILIAL   := XFILIAL("SC9")
                SC9->C9_PEDIDO  := _CPEDIDO
                SC9->C9_ITEM    := SC6->C6_ITEM
                SC9->C9_CLIENTE := SC6->C6_CLI
                SC9->C9_LOJA    := SC6->C6_LOJA           
                SC9->C9_PRODUTO := SC6->C6_PRODUTO
                SC9->C9_QTDLIB  := SUB->UB_QTDLIB
                SC9->C9_DATALIB := DDATABASE    
                SC9->C9_GRUPO   := POSICIONE("SB1",1,XFILIAL("SB1")+SC6->C6_PRODUTO,"B1_GRUPO")           
                SC9->C9_SEQUEN  := "01"                
                SC9->C9_PRCVEN  := SC6->C6_PRCVEN
                SC9->C9_LOCAL   := "01"
                SC9->C9_TPCARGA := "2"                                                                                
               MSUNLOCK("SC9")
               
               // FAZ O TRATAMENTO DE LIBERACAO DO PRODUTO DIRETO NO SB2...
               dbSelectArea("SB2")
               dbSetOrder(1)
               IF dbSeek(xfilial("SB2")+SC6->C6_PRODUTO+"01")
               		RECLOCK("SB2",.F.)
		                SB2->B2_RESERVA  := SB2->B2_RESERVA + SUB->UB_QTDLIB
		                SB2->B2_QPEDVEN  := SB2->B2_QPEDVEN - SUB->UB_QTDLIB
		               MSUNLOCK("SB2")
               ENDIF
			ENDIF      
			   
			DBSELECTAREA("SUB")
			DBSKIP()
		END
	ENDIF
ENDIF
       
// Rotina para cria��o do Natureza Financeira no Cliente
DbSelectArea("SA1")
DbSetOrder(1)
_cConta := "112001"

If DbSeek(xFilial("SA1") + _CliCod+_LojCod,.f.)

  While !RecLock("SA1", .F.)
  End
   
   SA1->A1_NATUREZ := IIf(EMPTY(SA1->A1_NATUREZ), "1001"           , SA1->A1_NATUREZ)
   SA1->A1_RISCO   := IIf(EMPTY(SA1->A1_RISCO  ), "E"              , SA1->A1_RISCO	)  
   SA1->A1_COND	   := IIf(EMPTY(SA1->A1_COND   ), "051"            , SA1->A1_COND   ) //AVISTA           
   SA1->A1_CONTA   := IIf(EMPTY(SA1->A1_CONTA  ), _cConta + _CliCod, SA1->A1_CONTA  )
  MsUnLock("SA1")
EndIf                    

// +-----------------------------------------------------+
// | Verifica se j� existe Conta Cont�bil para o Cliente |
// +-----------------------------------------------------+
DbSelectArea("CT1")
DbSetOrder(1)
//_cCodCli := IIF(SM0->M0_CODIGO == "01",_CliCod,SUBS(_CliCod,2,5))
_cCodCli := _CliCod

If !DbSeek(xFilial("CT1") + _cConta + _cCodCli,.f.)

	While !RecLock("CT1",.t.)
	End
	CT1->CT1_CONTA  := _cConta + _cCodCli
	CT1->CT1_DESC01 := _CliNom
	CT1->CT1_CLASSE := "2"
	CT1->CT1_NORMAL := "1"
	CT1->CT1_RES    := ""
	CT1->CT1_BLOQ   := "2"
	CT1->CT1_DC     := ""
	CT1->CT1_CVD02  := "1"
	CT1->CT1_CVD03  := "1"
	CT1->CT1_CVD04  := "1"
	CT1->CT1_CVD05  := "1"
	CT1->CT1_CVC02  := "1"
	CT1->CT1_CVC03  := "1"
	CT1->CT1_CVC04  := "1"
	CT1->CT1_CVC05  := "1"
	CT1->CT1_CTASUP := _cConta
	CT1->CT1_ACITEM := "2"
	CT1->CT1_ACCUST := "2"
	CT1->CT1_ACCLVL := "2"
	CT1->CT1_DTEXIS := CToD('01/01/1980') //dDataBase
	CT1->CT1_AGLSLD := "2"
	CT1->CT1_CCOBRG := "2"
	CT1->CT1_ITOBRG := "2"
	CT1->CT1_CLOBRG := "2"
	CT1->CT1_LALUR  := "0"
	CT1->CT1_CTLALU := _cConta + _cCodCli
	MsUnLock("CT1")
EndIf
return