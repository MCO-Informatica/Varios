#Include 'Protheus.ch'

/*/{Protheus.doc} MT680GD3
(long_description)
@author Matheus Abraão
@since 13/10/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function MT680GD3()
Local cProduto    := PARAMIXB[1] // H6_PRODUTO
Local cOp         := PARAMIXB[2] // H6_OP
Local cIdentOpPai := PARAMIXB[3] // H6_IDENT

Local lRet        := PARAMIXB[4] // Retorno

Local cmv_tmpad := If(ExistBlock("MA680TMP"),ExecBlock("MA680TMP",.F.,.F.),GetMV("MV_TMPAD"))
local aVetor := {}
local nQtd		:= 0

if upper(alltrim(FUNNAME())) == "MATA681"
	if alltrim(posicione("SF5",1,xFilial("SF5")+padr(cmv_tmpad,tamsx3("F5_CODIGO")[1]),"F5_TRANMOD")) == 'N'
		if "P" $ upper(SH6->H6_LOCAL)
			if "MOD" $ SD3->D3_COD
				SD3->(RecLock("SD3",.F.))
					SD3->D3_LOCAL := "P1" // Chumbado P1 a pedido do cliente Norberto
				SD3->(MsUnlock())
			endif
		endif
	endif
	
	/*// ajusta saldo empenho MOD
	if "MOD" $ SD3->D3_COD
		SD4->(dbSelectArea("SD4"))
		SD4->(dbSetOrder(1)) // D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE
		if SD4->(dbSeek(xFilial("SD4") + padr(SD3->D3_COD,tamsx3("D3_COD")[1])) + SD3->D3_OP + SD3->D3_TRT)		
	
			aVetor:={{"D4_COD"     ,padr(SD3->D3_COD,tamsx3("D3_COD")[1]),NIL},;
	      {"D4_OP"     ,SD3->D3_OP,NIL},;
	      {"D4_TRT"     ,SD3->D3_TRT,NIL},;
	      {"D4_LOCAL"     ,SD3->D3_LOCAL,NIL},;
	      {"D4_QTDEORI",SD4->D4_QTDEORI,NIL},;
	      {"D4_QUANT"     ,SD4->D4_QUANT,NIL},;
	      {"ZERAEMP"     ,"S",NIL}} //Zera empenho do processo de assistencia
	      
	      lMSHelpAuto := .T.
	      lMSErroAuto := .F.
	      MSExecAuto({|x,y| MATA380(x,y)},aVetor,4)
		endif
	endif*/
endif

Return lRet

