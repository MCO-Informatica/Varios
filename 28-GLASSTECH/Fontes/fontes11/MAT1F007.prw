#include 'protheus.ch'
#include "topconn.ch"   
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#include "TOTVS.ch"

user function GetFluxo(nIdFluxo)
	Private cBDProd := "MSSQL/Paralelo" // comunicacao com BD Protheus. Usado na funcao //TCLINK.
	Private cBDAtae := "MSSQL/TPCP" // comunicacao com BD sistema GESTOQ. Usado na //funcao.
	Private cIPBD := "192.168.90.5" // IP do servidor de aplicacoes
	 
	Private _nTcConn // conectar com Gestoq
	Private _nTcCon2 // conectar com Protheus
	
	TCCONTYPE("TCPIP") // tipo de conexao que sera usada
  
	_nTcConn := TCLink(cBDAtae,cIPBD) // conexao com Gestoq(sistema que usa o BD SqlServer)
	_nTcCon2 := TCLink(cBDProd,cIPBD) // conexao com Protheus

	If (_nTcConn < 0)
		//mostra alerta de erro com a conexão BD postgres ou BD Protheus
	 
		//Alert("*** Erro de conexão ***")
	Else
		//Alert("*** Conexão OK ***")
		TCSETCONN(_nTcConn) // setando conexao com SqlServer
		return LerTab(nIdFluxo) // lendo uma tabela SqlServer
		//InsProt() // pegando os dados do Postgres e inserindo no Protheus
	EndIf
	
return ""

Static Function LerTab(nIdFluxo)
	
	local cCatal := ""
	Local cQuery := "SELECT ISNULL(O.CATALOGO, '') AS CATALOGO FROM FLUXO_SERIE_FILIAIS AS F " + ;
		"INNER JOIN ORDEM O ON O.ID_OF=F.ID_OF WHERE ID_FLUXO_SERIE=" + cValToChar(nIdFluxo)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRS", .F., .T.)
	TRS->(DbGoTop())
	
	cCatal := TRS->CATALOGO

	TRS->(DbCloseArea())
	
Return cCatal

// Função responsável por trazer área do componente quando o mesmo for MP
// Responsável também por realizar o cálculo do índice de perda
user function MAT1F007()
		
	local cComponent := M->G1_COMP
	
	if (SB1->B1_TIPO == 'MP')
		dbSelectArea('SB1')
		dbsetorder(1)
		dbseek(xFilial('SB1') + cComponent)
	
		Alert('Quantidade será calculada com a área de blank da peça.')
		
		M->G1_QUANT := SB1->B1_ZZBRUTA
		M->G1_PERDA := SB1->B1_ZZBRUTA - SB1->B1_ZZREAL
	endif 
	
return M->G1_OBSERV

user function Exec(oBlock, aParam)

return eval(&(oBlock), aParam)

user function TesteArr()
	local aCashews := {}
	
	//DbSelectArea('SB1')
	//DbSetOrder(1) 
	dbgotop()
	
	while !Eof()
		aadd(aCashews, B1_DESC)
		
		dbskip()
	enddo
return aCashews    

user function EndEst()

	local aCab := {}
	local aItem := {}
	
	local aParam := {}
	local cErro := ""
	local nX := 0

	SDA->(dbSelectArea("SDA"))
	SDA->(dbgotop())
	SDA->(dbseek(xFilial("SDA")))
	
	while !(SDA->(eof()))
		SB1->(dbSelectarea("SB1"))
		SB1->(dbseek(xFilial("SB1") + SDA->DA_PRODUTO))
		
		if (SDA->DA_FILIAL != xFilial("SDA")) .or. !(SB1->B1_TIPO = "PA" .and. (SB1->B1_LOCPAD = "07" .or. SB1->B1_LOCPAD = "08" .or. SB1->B1_LOCPAD = "09"))
			SDA->(dbskip())
		else
			// Pallets
			aCab := {{"DA_PRODUTO",SDA->DA_PRODUTO,}, {"DA_LOCAL", SDA->DA_LOCAL,}, {"DA_NUMSEQ", SDA->DA_NUMSEQ,}}//{"DA_LOCAL", SDA->DA_LOCAL,}}//, {"DA_NUMSEQ", SDA->DA_NUMSEQ,}}
			
			aItem := {{"DB_ITEM", "0001",},;
				{"DB_LOCALIZ", "PALLETS",},;
				{"DB_DATA", dDataBase,},;
				{"DB_QUANT", SDA->DA_QTDORI,}}
				
			lMsErroAuto := .F.
			lAutoErrNoFile := .T.
			
			msExecAuto({|x, y, z| Mata265(x, y, z)}, aCab, aItem, 3)
			
			if lMsErroAuto
				aAutoErro := GETAUTOGRLOG()
				for nX := 1 To Len(aAutoErro)
					cErro += aAutoErro[nX] + Chr(13)+Chr(10)
				next nX
				
				Alert(cErro)
			endif
		endif
	end
	
	Alert("Feito cagada com sucesso")

return

user function InsEst()

	local aParam := {}
	local cErro := ""
	local nX := 0
	
	dbSelectArea("SB1")
	dbgotop()
	
	while !SB1->(eof())
		aParam := {;
			{"B9_COD", SB1->B1_COD,}, {"B9_LOCAL", SB1->B1_LOCPAD,}, {"B9_QINI", 1000,}}
		
		lMsErroAuto := .F.
		lAutoErrNoFile := .T.
		
		msExecAuto({|x, y| Mata220(x, y)}, aParam, 3)
	
		if lMsErroAuto
			aAutoErro := GETAUTOGRLOG()
			for nX := 1 To Len(aAutoErro)
				cErro += aAutoErro[nX] + Chr(13)+Chr(10)
			next nX
			
			Alert(cErro)
		endif
		
		SB1->(dbskip())
	end
	
	Alert("Feito cagada com sucesso")

return

user function GetPDesc(cCod)
	// Define variáveis
	local cTipoVidro   := ""
	local cConformacao := ""
	local cEspessura   := ""
	local cCor  	     := ""
	local cModeloProd  := ""
	local cApliComer   := ""
	local cLado        := ""   
	local cSpace       := Space(1)   
	local cArea        := ""   
	local cDesc        := ""
	local cPosIPI      := ""
	
	DbSelectArea("SB1")
	dbsetorder(1)
	dbseek("    " + padr(cCod, 30, " "))	
	if (SB1->B1_TIPO <> 'PA')
		return SB1->B1_DESC
	endif
	
	// Seta valores da memória
	cTipoVidro   := SB1->B1_ZZTVIDR // Necessário select na descrição
	cConformacao := SB1->B1_ZZVIDRO   
	cEspessura   := CValToChar(SB1->B1_ZZESPES)
	cCor         := SB1->B1_ZZCVIDR // Necessário select na descrição
	cModeloProd  := SB1->B1_ZZMPROD // Necessário select na descrição
	cApliComer   := SB1->B1_ZZAPLCO // Necessário select na descrição
	cLado        := SB1->B1_ZZLVIDR // Necessário select na descrição   
	
	if (SB1->B1_POSIPI == "87082999")
		cPosIPI := "87082999"
	endif      
	
	// Realiza tratativa  
	cArea := "ZZ5"
	DbSelectArea(cArea)
	DbSetOrder(2)  
	DbSeek(xFilial( cArea ) + cTipoVidro)
	cTipoVidro := ZZ5->ZZ5_DESCRI   
	cArea := "ZZ6"
	DbSelectArea(cArea)
	DbSetOrder(2)  
	DbSeek(xFilial( cArea ) + cCor)
	cCor := ZZ6->ZZ6_DESCRI    
	cArea := "ZZ3"
	DbSelectArea(cArea)  
	DbSetOrder(1)
	DbSeek(xFilial( cArea ) + cModeloProd)
	cModeloProd := ZZ3->ZZ3_DESCRI 
	cArea := "ZZ4"     
	DbSelectArea(cArea)  
	DbSetOrder(2)
	DbSeek(xFilial( cArea ) + cApliComer)
	cApliComer := ZZ4->ZZ4_DESCRI    
	cArea := "ZZ7"   
	DbSelectArea(cArea)   
	DbSetOrder(2)
	DbSeek(xFilial( cArea ) + cLado)
	cLado := ZZ7->ZZ7_DESCRI        
	        
	// Retira espaços (Gambeta mode ON)
	if (AllTrim(cTipoVidro) <> "")
		cDesc += AllTrim(cTipoVidro) + cSpace
	endif     
	if (AllTrim(cConformacao) <> "")
		cDesc += AllTrim(cConformacao) + cSpace
	endif
	if (AllTrim(cEspessura) <> "")
		cDesc += AllTrim(cEspessura) + "MM" + cSpace
	endif	   
	if (AllTrim(cCor) <> "")
		cDesc += AllTrim(cCor) + cSpace
	endif
	if (AllTrim(cModeloProd) <> "")
		cDesc += AllTrim(cModeloProd) + cSpace
	endif  
	//if (AllTrim(cApliComer) <> "")
	//	cDesc += AllTrim(cApliComer) + cSpace
	//endif   
	if (AllTrim(cLado) <> "")
		cDesc += AllTrim(cLado) + cSpace
	endif  
	
	if (AllTrim(cPosIPI) <> "")
		cDesc += " C/G"
	endif
	
return cDesc

user function Echo(aParam)

return aParam[1] + aParam[2]

user function M250Prim()
	DbSelectArea('ZZB')
	RecLock('ZZB', .T.)
	ZZB_FILIAL := xFilial('ZZB')
	ZZB_COD := 'AUTO ROTINA'
	MsUnlock()
return .T.

// Função para inserir ordem de produção
user function InsM650(cNumOp, cCodProduto, nQnt)

	local cErro := {"", ""}
	local cLocPad := ""
	local cUnid := ""
	local cGrupo := ""

	dbSelectArea("SC2")
	cItemOP   := "01"
	cSequenOP := "001"
	
	// Abre o cadastro de produtos
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	// Caso não encontre o produto, mostra mensagem de erro
	if !(dbSeek(xFilial()+cCodProduto))
		cErro[1] := 'Produto não encontrado. Cod: ' + cCodProduto
		return cErro[1]
	endif    
	
	cLocPad := SB1->B1_LOCPAD
	cUnid := SB1->B1_UM
	cGrupo := SB1->B1_GRUPO
	
	if ((xFilial("SC2") == '0101') .And. (cGrupo $ GetMv("MV_GRTR")) .And. !(cGrupo $ GetMv("MV_NOGRTR")))
		cErro := U_FAT1F001(cCodProduto, nQnt)
		// Caso não consiga criar uma pedido de venda, exibe log de erro
		if (AllTrim(cErro[1]) <> '')
			cErro[1] := "Erro ao criar pedido  = " + cErro[1]
			return cErro[1]
		endif
	endif
	
	if type(cErro[2]) == "U"
		cErro[2] := ""
	endif

	// {'AUTEXPLODE'  , 'S', NIL},;
	//-- Monta array para utilizacao da Rotina Automatica
	aMata650  := {{'C2_NUM', cNumOp, NIL},;
		{'C2_ITEM'     , cItemOP, NIL},;
		{'C2_SEQUEN'   , cSequenOP, NIL},;
		{'C2_PRODUTO'  , cCodProduto, NIL},;
		{'C2_LOCAL'    , cLocPad, NIL},;
		{'C2_QUANT'    , nQnt, NIL},;
		{'C2_QTSEGUM'  , 0, NIL},;
		{'C2_UM'       , cUnid, NIL},;
		{'C2_SEGUM'    , "", NIL},;
		{'C2_PEDIDO'	 , cErro[2], NIL},;
		{'C2_DATPRI'   , dDatabase, NIL},;
		{'C2_DATPRF'   , dDatabase, NIL},;
		{'C2_EMISSAO'  , dDataBase, NIL}}
		
	/*aAdd(aMata650, {{'AUTEXPLOD', 'S', NIL},;
		{'C2_ITEM'     , , NIL},;
		{'C2_SEQUEN'   , , NIL},;
		{'C2_PRODUTO'  , , NIL},;
		{'C2_LOCAL'    , , NIL},;
		{'C2_QUANT'    , , NIL},;
		{'C2_QTSEGUM'  , , NIL},;
		{'C2_UM'       , , NIL},;
		{'C2_SEGUM'    , , NIL},;
		{'C2_PEDIDO'	 , , NIL},;
		{'C2_DATPRI'   , , NIL},;
		{'C2_DATPRF'   , , NIL},;
		{'C2_EMISSAO'  , , NIL}})*/
		
	lMsErroAuto := .F.
	lAutoErrNoFile := .T.
	lMsHelpAuto := .T.
	
	msExecAuto({|x, y| Mata650(x, y)}, aMata650,	3)
	
	//MostraErro(GetSrvProfString("StartPath", ""), "INSM250_ERRO.TXT")
	//cErro := MemoRead(GetSrvProfString("StartPath", "") + "\INSM250_ERRO.TXT")
	
	if lMsErroAuto
		MostraErro()
		aAutoErro := GETAUTOGRLOG()
		for nX := 1 To Len(aAutoErro)
			cErro[1] += aAutoErro[nX] + Chr(13)+Chr(10)
       next nX
	endif
	
return cErro[1]

//
// aParams[1] - Código da OP
// aParams[2] - Quantidade para inserir 
// aParams[3] - Perda para inserir
//
user function InsM250(cNumeroOP, nQnt, nPerda, cFluxo)
	
return SInsM250(cNumeroOP, nQnt, nPerda, cFluxo)	
	
static function SInsM250(cNumeroOP, nQnt, nPerda, cFluxo)
	
	local aMata250 
	local cErro := ""
	local nX := 0
	local cB1Conta := ""
	local nIncrement := 0
	local cDoc := ""
	
	If(ValType(nQnt) != 'N')
		nQnt := Val(nQnt)
	endif
	
	If(ValType(nPerda) != 'N')
		nPerca := Val(nPerda)
	endif

	//local bCondicao := {|| D3_TM == '010' .and. D3_CF == 'PR0' .and. D3_NUMSEQ == '001164'}
	//local cCondicao := "D3_TM == '010' .and. D3_CF == 'PR0' .and. D3_NUMSEQ == '001164'"
	
	//aadd(aParams, '015160')
	//aadd(aParams, 444)
	//aadd(aParams, 0)
	
	// Selecionando area que a mata usa
	// Tentativa para solucionar o problema de não apontar
	/*dbSelectArea("SB1")
	dbSelectArea("SB9")
	dbSelectArea("SD3")
	dbSelectArea("SD4")
	dbSelectArea("SF5")
	dbSelectArea("SHD")
	dbSelectArea("SI1")
	dbSelectArea("SI2")
	dbSelectArea("SI5")
	dbSelectArea("SI6")
	dbSelectArea("SI7")*/
	
	SC2->(dbSelectArea("SC2"))
	SC2->(dbsetorder(1))
	
	SC2->(dbseek(xFilial() + cNumeroOP))

	// Caso não encontre, retorna erro
	if (AllTrim(SC2->C2_NUM) == '')
		cErro := 'OP não encontrada. NUM: ' + cNumeroOP + ', xFILIAL: ' + xFilial()
		return cErro
	endif
	
	SD3->(dbSelectArea("SD3"))
	SD3->(dbsetorder(13))
	// Caso já exista lançamento vinculado, não aponta mais
	if (SD3->(dbseek(xFilial() + cFluxo)))
		//cErro := 'Fluxo já apontado. NUM: ' + cNumeroOP + ', xFILIAL: ' + xFilial()
		return cErro
	endif
	
	SB1->(dbSelectArea("SB1"))
	SB1->(dbseek(xFilial("SB1") + SC2->C2_PRODUTO))
	cB1Conta := SB1->B1_CONTA 
	SB1->(dbclosearea())
	
	cDoc := AllTrim(SC2->C2_NUM) + AllTrim(SC2->C2_ITEM)
	
	//{"D3_FLUXO", AllTrim(cFluxo), nil},;
	if (SB1->B1_RASTRO = 'N')
		aMata250 := {;
		{"D3_TM", "010", nil},;
		{"D3_COD", SC2->C2_PRODUTO, nil},;
		{"D3_UM", SC2->C2_UM, nil},;
		{"D3_QUANT", nQnt, nil},;
		{"D3_PERDA", nPerda, nil},;
		{"D3_OP", SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN, nil},;
		{"D3_LOCAL", SC2->C2_LOCAL, nil},;
		{"D3_EMISSAO", dDataBase, nil},;
		{"D3_CONTA", cB1Conta, nil},;
		{"D3_USUARIO", "ROBO", nil},;
		{"D3_FLUXO", cFluxo, nil},;
		{"D3_CC", SC2->C2_CC, nil}} 
	else
		aMata250 := {;
		{"D3_TM", "010", nil},;
		{"D3_COD", SC2->C2_PRODUTO, nil},;
		{"D3_UM", SC2->C2_UM, nil},;
		{"D3_QUANT", nQnt, nil},;
		{"D3_PERDA", nPerda, nil},;
		{"D3_OP", SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN, nil},;
		{"D3_LOTECTL", SC2->C2_NUM, nil},;
		{"D3_DTVALID", dDataBase + 365, nil},;
		{"D3_LOCAL", SC2->C2_LOCAL, nil},;
		{"D3_EMISSAO", dDataBase, nil},;
		{"D3_CONTA", cB1Conta, nil},;
		{"D3_USUARIO", "ROBO", nil},;
		{"D3_FLUXO", cFluxo, nil},;
		{"D3_CC", SC2->C2_CC, nil}} 
	endif
	
		
	lMsErroAuto := .F.
	lAutoErrNoFile := .T.
	lMsHelpAuto := .T.
	
	msExecAuto({|x, y| Mata250(x, y)}, aMata250,	3)
	
	//MostraErro(GetSrvProfString("StartPath", ""), "INSM250_ERRO.TXT")
	//cErro := MemoRead(GetSrvProfString("StartPath", "") + "\INSM250_ERRO.TXT")
	
	// Ideia Zabotto
	cErro := If(Type('cErroTw') != 'U', cErroTw, '')
	
	if AllTrim(cErro) != ""
		return "Erro ao executar ponto de entrada: " + cErro
	endif
	
	if lMsErroAuto
		//MostraErro()
		aAutoErro := GETAUTOGRLOG()
		for nX := 1 To Len(aAutoErro)
			cErro += aAutoErro[nX] + Chr(13)+Chr(10)
       next nX
	endif
	
return cErro