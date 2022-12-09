User Function EICPO400()

	local xRet     

	xRet := nil 
/*
Do Case
	Case PARAMIXB == "PO400GRAVAPC_ITEM"
		nPos  := aScan(aItensPo ,{ |x| Alltrim(x[1])=="C7_XITEMCT"})
		IF nPos > 0
			aItensPo[nPos, 2] := SC1->C1_XITEMCT
		else
		   AAdd(aItensPo, {"C7_XITEMCT" , SC1->C1_XITEMCT, Nil})
		ENDIF
EndCase
*/

IF cEMPANT == '02'
	Do Case
		
		Case PARAMIXB == "VALID"
			
			If cFlag ==  "Saldo_Q"
				lValido := U_EICATUSLD()
			ENDIF
			
			If cFlag ==  "Fabr"
				
				SA5->(DbSetOrder(3))
				If EICSFabFor(xFilial("SA5")+AvKey(Work->WKCOD_I,"A5_PRODUTO")+AvKey(M->W3_FABR,"A5_FABR")+AvKey(M->W2_FORN,"A5_FORNECE"), EICRetLoja("M","W3_FABLOJ"), EICRetLoja("M","W2_FORLOJ"))
					If SA5->A5_XBLOQ == "1" //sim
						Alert("Registro bloqueado para uso. Falta liberação da área responsável")
						lValido := .F.
					Endif
				Endif
			Endif
			
		Case PARAMIXB == "ANTES_GRAVA_PO"
			
			aOrdWORK := SaveOrd({"WORK","SB1","SW2"})
			nWkRecno:= Work->(RECNO())
			Work->(DBGOTOP())
			WHILE ! Work->(EOF())
				
				SB1->(DBSEEK(xFilial()+Work->WKCOD_I))
				
				IF  SB1->B1_XCOTA == '1'
					
					nSldB1 := ((Work->WKQTDE_O + SB1->B1_XQTDCOT) - Work->WKQTDE)
					
					IF 	nSldB1 <> SB1->B1_XQTDCOT
						SB1->(RecLock("SB1", .F.))
						SB1->B1_XQTDCOT := nSldB1
						SB1->(MsUnLock())
					Endif
					
				Endif
				
				Work->(DBSKIP())
				
			ENDDO
			Work->(DBGOTO(nWkRecno))
			RestOrd(aOrdWORK)
			
		Case ParamIXB == "ANTES_ESTORNO_PO"
			SB1->(DBSEEK(xFilial()+Work->WKCOD_I))
			
			IF  SB1->B1_XCOTA == '1'
				
				SB1->(RecLock("SB1", .F.))
				SB1->B1_XQTDCOT += Work->WKQTDE
				SB1->(MsUnLock())
				
			endif
			
	EndCase
Endif

DO Case
	//---------------------------------------
	//Ponto de entrada na montagem dos itens
	//do execauto do MATA120
	//---------------------------------------
	CASE PARAMIXB == "PO400GRAVAPC_ITEM"
		nPosCod  := AScan(aItensPo, {|x| AllTrim(x[1]) == "C7_NUMSC"})
    	nPosItem := AScan(aItensPo, {|x| AllTrim(x[1]) == "C7_ITEMSC"})
		
		if nPosCod > 0 .and. nPosItem > 0 .AND. M->W2_IMPCO <> "1"
			if SC1->(DBSeek(xFilial("SC1") + aItensPo[nPosCod][2]+ aItensPo[nPosItem][2]))
				if !empty(SC1->C1_XTABPRC)
					AAdd(aItensPo, {"C7_CODTAB", SC1->C1_XTABPRC, Nil})
				endif
			endif
		endif

	//-------------------------------------------------------
	//Ponto de entrada antes da abertura da tela de seleção
	//de itens da SI
	//--------------------------------------------------------
	CASE PARAMIXB == "COORDENADA_TELA_ITENS"
		//-----------------------------------------
		//Replica as informações de data de embarque
		//e data de entrega do primeiro item nos
		//demais itens
		//------------------------------------------
		replDtEmb(.T.)


	//------------------------------------------------------
	//Ponto de entrada durante a gravação das informações
	//da tela de seleção dos itens da SI na tabela
	//temporária
	//------------------------------------------------------
	CASE PARAMIXB == "GRAVA_ITENS_WORK"

		//-----------------------------------------
		//Copia as informações de data de embarque
		//e data de entrega do primeiro item
		//------------------------------------------
		replDtEmb(.F.)


	//--------------------------------------------------
	//Ponto de entrada na montagem da tabela temporária
	//--------------------------------------------------
	CASE PARAMIXB == "ADICIONA_WORK"
		//----------------------------------------------------
		//Verifica se o usuário quer auto popular informações
		//do cabeçalho com dados da SI
		//----------------------------------------------------
		getInfoSI()

	CASE PARAMIXB == 'SelecionaSI'
		//----------------------------------------------------
		//Verifica se inibe a tela de seleção de SI e 
		//auto popula a grid de itens com as informações de SI
		//já selecionada antes da abertura da tela de PO
		//----------------------------------------------------
		xRet := getSelSI()
	
EndCase

Return xRet

//Rotina para inserir impressão no menu
User Function IPO400MNU()
	Local aRetorno := {}

	aADD(aRetorno,{"Impressão de PO","U_IMCDR04()",0,6})
	aADD(aRetorno,{"Shipping ","U_IMCDR03()",0,6})
	Aadd(aRetorno, {"Log Integ. Fiorde", "U_FILOGSHW()", 0, 2})
Return aRetorno

/*/{Protheus.doc} getInfoSI
Retorna as informações de SI nos campos da PO
@type function
@version 1.0
@author marcio.katsumata
@since 23/03/2020
@return return_type, return_description
/*/
static function getInfoSI()
	local aPergs   as array
	local aRet     as array
	local aAreasPO as array

	aPergs   := {}
	aRet     := {}

	public lAbrTel400 as logical
	public dDtEmb400 as date
	public dDtEnt400 as date

	lAbrTel400 := .T.
	dDtEmb400  := stod("")
	dDtEnt400  := stod("")
	aAreasPO := {getArea(), SW0->(getArea())}	

	//--------------------------------------------------
	//Realiza a chamada da réplica de informações da SI
	//na PO apenas na inclusão da PO
	//--------------------------------------------------
	if isInCallStack('PO400Inclu')

		if msgYesNo("Deseja replicar informações de moeda, incoterm, via de transporte e condição de pagamento da SI para a capa da PO?")
			
			aAdd(aPergs,{9,"Informe o numero da SI abaixo" ,150,50,.T.})
			aAdd(aPergs,{1,"Unidade Requisitante",space(tamSx3("W0__CC")[1]),"","","SY3","",0,.F.}) // Tipo caractere
    		aAdd(aPergs,{1,"Numero da SI",space(tamSx3("W0__NUM")[1]),"","","SW0","",0,.F.}) // Tipo caractere
			
			If ParamBox(aPergs,"Parâmetros:",@aRet,,,,,,,.T.,.T.)
				cUnReq   := aRet[2]
				cNumSiOr := aRet[3]
				
				if !empty(cUnReq) .and. !empty(cNumSiOr)

					dbSelectArea("SW0")
					SW0->(dbSetOrder(1))
					if SW0->(dbSeek(xFilial("SW0")+cUnReq+cNumSiOr))
						//-----------------------------------
						//Variáveis responsáveis pela
						//auto população da grid de itens
						//-----------------------------------
						TCC     := cUnReq   
						TSi_Num := cNumSiOr 

						lAbrTel400 := .F.

						M->W2_MOEDA   :=SW0->W0_MOEDA   
    					M->W2_INCOTER :=SW0->W0_XINCOTE 
   						M->W2_TIPO_EM :=SW0->W0_XVIAEMB 
    					M->W2_COND_PA :=SW0->W0_XCONDPG 
						M->W2_COMPRA := SW0->W0_COMPRA

						//---------------------------------------------
						//Posiciona na tabela de condição de pagamento
						//para gravar informações de dias de pagamento
						//--------------------------------------------
						dbSelectArea("SY6")
						SY6->(dbSetOrder(1))
						if SY6->(dbSeek(xFilial("SY6")+M->W2_COND_PA))
							M->W2_DIAS_PA := SY6->Y6_DIAS_PA
						endif
						//--------------------------------------
						//Posiciona tabela de itens da SI
						//para gravar informações de fornecedor
						//e loja do fornecedor
						//--------------------------------------
						dbSelectArea("SW1")
						SW1->(dbSetOrder(1))
						if SW1->(dbSeek(xFilial("SW1")+SW0->(W0__CC+W0__NUM)))
							M->W2_FORN := SW1->W1_FORN
							M->W2_FORLOJ := SW1->W1_FORLOJ
						endif

						
					endif
				endif
			endif
		endif
	endif

	aEval(aAreasPO,{|aArea|restArea(aArea)})
	aSize(aAreasPO,0)
	aSize(aRet,0)
	aSize(aPergs,0)


return

/*/{Protheus.doc} getSelSI
Verifica se é necessário abrir a tela de seleção de SI
ou se realiza auto população da grid de itens sem
abrir a tela de seleção de SI
@type function
@version 1.0
@author marcio.katsumata
@since 23/03/2020
@return logical, abre a tela ou não?
/*/
static function getSelSI()
	local lRetorno as logical

	lRetorno := .T.

	//------------------------------------------------
	//Realiza a chamada de população da grid de itens
	//apenas na inclusão de PO
	//------------------------------------------------
	if isInCallStack('PO400Inclu')

		if ! lAbrTel400

			dbSelectArea("SW0")
			SW0->(dbSetOrder(1))
			if SW0->(dbSeek(xFilial("SW0")+TCC+TSi_Num))

				dbSelectArea("SW1")
				SW1->(dbSetOrder(1))
				SW1->(dbSeek(xFilial("SW1")+SW0->(W0__CC+W0__NUM)))

				If PO_ValidCC(.f.) .AND. PO_ValidSI(.f.)
    		    	nOpca := 1
				endif

			endif
		
			lAbrTel400 := .T.
			lRetorno := .F.

		endif

	endif

return lRetorno

/*/{Protheus.doc} replDtEmb
Replica informações da data de embarque
e data de entrega.
@type function
@version 1.0
@author marcio.katsumata
@since 23/04/2020
@param lReplica, logical, replica?
@return nil, nil
/*/
static function replDtEmb(lReplica)
	

	if lReplica 
		if !empty(dDtEmb400)
			M->W3_DT_EMB := dDtEmb400
			M->W3_DT_ENTR:= dDtEnt400
		endif

	else
		dDtEmb400 := M->W3_DT_EMB
		dDtEnt400 := M->W3_DT_ENTR
	endif

return
