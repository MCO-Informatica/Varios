#include "rwmake.ch"   
#include "protheus.ch"        
#include "topconn.ch"    

#DEFINE COD_PRODUTO  6  
#DEFINE DESC_PRODUTO 2
#DEFINE TIPO_PRODUTO 1
#DEFINE HR_MAQ_PROD  4

#DEFINE false .F.
#DEFINE true .T.      
#DEFINE and .and.

static cRef := ""      
static _bCopEstru := .F.

// Neste fonte é utilizado a classe ThComp que faz referência a biblioteca de componentes ThermoGlass 

user function TesteObj()     
	local cGet1 := Space(120)
	
	oThComp := ThComp():Create("Austin Felipe") 
	oThComp:cName := "Alteração para Austin Felipe Santos"
	Alert(oThComp:GetName())
	
	oThDialog := ThDialog():Create("janela1")
	oThDialog:Modal(true)
	oThDialog:SetTitle("Janela teste")   
	oThDialog:SetWidth(600)
	oThDialog:SetHeight(350)      
	
	oGet1 := ThEdit():Create("edit1")
	//oGet1:SetFormat("@!")  
	oGet1:BindVar(@cGet1)
	oGet1:SetTop(15); oGet1:SetLeft(5); oGet1:SetWidth(260); oGet1:SetHeight(10)
	oGet1:AddToWindow(@oThDialog)
	
	oThDialog:Show()
return    

// Função de retorno para MAT1F001
user function RETF001()   

	&(ReadVar()) := cRef

return cRef      

// Consulta Especifica de Produto - 002  
// Uso: FP002 (Filtro Produto 002)  
user function MAT1F001()
 
	// Inicializa retorno padrão
	local bRet := false
	// Realiza leitura da variável do componente caso o usuário esteja alterando
	private cCodigo := AllTrim(&(ReadVar()))
	// Executa filtro e pega valor padrão
	bRet 	   := ExecFilter()
 
return bRet
 
// Filtro estático do cadastro de produto 
static function ExecFilter()
 
	// Inicializa variáveis
	local oLstSB1     := nil   
	local cGetDesc    := Space(120)
	local cGetTipo    := Space(3)  
	local cGetCatal   := Space(120)
	private oDlgZZY   := nil
	private _bRet     := false
	private aDadosZZY := {}   
	private nList     := 0
        
 	MsAguarde({|_nLine, aDataSet, cFilter, oListRef| GetGridSource(-1, @aDadosZZY, "", nil)}, ;
 		"Pesquisa de Produtos Personalizada", "Filtrando, aguarde...")
 	
	if !_bRet
		return false  
	endif
	
	//Define MsDialog oDlgZZY Title "Busca de Produtos Personalizada" From 0,0 To 350, 600 Of oMainWnd Pixel 
	DEFINE MSDIALOG oDlgZZY TITLE "Busca de Produtos Personalizada" FROM 0, 0 TO 395, 650 PIXEL
    
    //@ 15,5 GET oGet1 VAR cGet1 PICT "@!" OF oDlgZZY PIXEL SIZE 245, 10                        
    //@ 5,5 SAY oSay VAR 'Descrição do Produto' OF oDlgZZY PIXEL SIZE 100, 10  
    
    // Cria Componentes Padroes do Sistema
	@ 5, 5 Say "Tipo" Size 17, 10 COLOR CLR_BLACK PIXEL OF oDlgZZY
	@ 15, 5 GET oGetTipo Var cGetTipo PICT "@!" OF oDlgZZY PIXEL Size 20, 10 
	@ 5, 30 Say "Descrição" Size 50, 10 COLOR CLR_BLACK PIXEL OF oDlgZZY
	@ 15, 30 GET oGetDescri Var cGetDesc PICT "@!" Size 259, 10 COLOR CLR_BLACK PIXEL OF oDlgZZY
	@ 30, 5 Say "Catálogo" Size 50, 10 COLOR CLR_BLACK PIXEL OF oDlgZZY
	@ 40, 5 GET oGetCatal Var cGetCatal PICT "@!" Size 285, 10 COLOR CLR_BLACK PIXEL OF oDlgZZY   
	DEFINE SBUTTON FROM 40, 296 TYPE 17 ACTION MsAguarde({|_nLine, aDataSet, cFilter, oListRef|GetGridSource(oLstZZY:nAt, @aDadosZZY, cGetDesc, @oLstZZY, cGetTipo, cGetCatal)}, ;
    	"Pesquisa de Produtos Personalizada", "Filtrando, aguarde...") ENABLE OF oDlgZZY   
	DEFINE SBUTTON FROM 183, 5 TYPE 1 ACTION ConfZZY(oLstZZY:nAt, @aDadosZZY, @_bRet) ENABLE OF oDlgZZY
	DEFINE SBUTTON FROM 183, 40 TYPE 2 ACTION oDlgZZY:End() ENABLE OF oDlgZZY
	
    //@ 5,25 SAY oSay VAR 'Descrição do Produto' OF oDlgZZY PIXEL SIZE 100, 10    
    //@ 15,5 GET oGetTipoProd VAR cTipoProd PICT "@!" OF oDlgZZY PIXEL SIZE 15, 10 
    
	@ 57, 5 LISTBOX oLstZZY ;
	VAR lVarMat ;       
	Fields HEADER "Tipo", "Catálogo", "Descrição";
	SIZE 317, 120 On DblClick ( ConfZZY(oLstZZY:nAt, @aDadosZZY, @_bRet) ) ;
	OF oDlgZZY PIXEL      
 
	oLstZZY:SetArray(aDadosZZY)
	oLstZZY:nAt := nList        
	oLstZZY:bLine := { || {aDadosZZY[oLstZZY:nAt,1], aDadosZZY[oLstZZY:nAt,2], aDadosZZY[oLstZZY:nAt,3]}}
	 
	Activate MSDialog oDlgZZY Centered
 
Return _bRet     

static function GetGridSource(_nLine, aDataSet, cFilter, oListRef, cTipoProdFilter, cCatProdFilter)
	
	//private cProdCod := "" 
	local cQuery     := "" 
	local lReturn    := true
	                                                    
	// Verifica index    
	if (_nLine > 0) and (Len(aDataSet) > 0)
		cCodigo := aDataSet[_nLine, COD_PRODUTO]
	endif

	// Limpa dataSet        
	aDataSet 	   := {}
	
	cQuery := " SELECT SB1.B1_TIPO, SB1.B1_ZZCATAL, SB1.B1_DESC, SB1.B1_ZZHRMAQ, SB1.B1_ZZBRUTA, SB1.B1_COD" 
	cQuery += " FROM "+RetSQLName("SB1") + " AS SB1 "
	cQuery += " WHERE (RTRIM(LTRIM(SB1.B1_ZZFILIA)) = '" + xFilial("SG1") + "' OR RTRIM(LTRIM(SB1.B1_ZZFILIA)) = '')"
	cQuery += " AND SB1.D_E_L_E_T_<> '*'"        
	
	if AllTrim(cTipoProdFilter) <> ""
		cQuery += " AND SB1.B1_TIPO = '" + AllTrim(cTipoProdFilter) + "'"
	endIf
	
	if AllTrim(cFilter) <> ""     
		cQuery += " AND SB1.B1_DESC LIKE '%" + AllTrim(cFilter) + "%'" 
	endif    
	
	if AllTrim(cCatProdFilter) <> ""
		cQuery += " AND SB1.B1_ZZCATAL LIKE '%" + AllTrim(cCatProdFilter) + "%'" 
	endIf  
	
	cQuery += " ORDER BY SB1.B1_DESC"

    TcQuery cQuery new alias "CUSTOM_PROD"	 
    
    CUSTOM_PROD->(DbGoTop())
	if CUSTOM_PROD->(Eof())
		Aviso( "Filtro de Produtos Personalizados", "Não existe dados a consultar", {"Ok"} ) 
		oGetTipo:SetFocus()
		lReturn := false
	endif
	 
	Do While CUSTOM_PROD->(!Eof())
	 
		aAdd( aDataSet, ;
			{ CUSTOM_PROD->B1_TIPO, ;
			  CUSTOM_PROD->B1_ZZCATAL, ;
			  CUSTOM_PROD->B1_DESC, ;
			  CUSTOM_PROD->B1_ZZHRMAQ, ;
			  CUSTOM_PROD->B1_ZZBRUTA, ;
			  CUSTOM_PROD->B1_COD} )
		 
		CUSTOM_PROD->(DbSkip())
	 
	Enddo
	  
	CUSTOM_PROD->(DbClosearea()) 
	
	nList := aScan(aDataSet, {|x| alltrim(x[3]) == alltrim(cCodigo)})
 
	iif(nList = 0,nList := 1,nList)   
	
	if oListRef <> nil
   		oListRef:SetArray(aDataSet)
		oListRef:nAt := nList  
		oListRef:bLine := { || {aDataSet[oListRef:nAt,1], aDataSet[oListRef:nAt,2], aDataSet[oListRef:nAt,3]}}
	endif  
	
	_bRet := lReturn
	
return lReturn   

static function ConfZZY(_nPos, aDadosZZY, _bRet)
                       
 	if (Len(aDadosZZY) <= 0)
 		Aviso( "Filtro de Produtos Personalizados", "Não existe produto para retornar", {"Ok"} )   
 	   	oGet1:SetFocus()	  
 		return                                       
 	endif
	cCodigo := aDadosZZY[_nPos, COD_PRODUTO]
   	//&(ReadVar()) := cCodigo   
   	
   	cRef := cCodigo
	_bRet := true
	oDlgZZY:End()   
	
	//Prepara cQuery para pegar o valor da H/M e o catalogo do item principal
	//cQuery := "SELECT ISNULL(B1_ZZBRUTA, 0) AS B1_ZZBRUTA, B1_ZZCATAL, ISNULL(B1_ZZREAL, 0) AS B1_ZZREAL FROM " + RetSqlName("SB1") + " SB1 WHERE RTRIM(LTRIM(SB1.B1_COD)) = '" + SG1->G1_COD + "'"
	cQuery := "SELECT ISNULL(B1_ZZBRUTA, 0) AS B1_ZZBRUTA, B1_ZZCATAL, ISNULL(B1_ZZREAL, 0) AS B1_ZZREAL FROM " + RetSqlName("SB1") + " SB1 WHERE RTRIM(LTRIM(SB1.B1_COD)) = '" + cCodPai + "'" 
	cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
	TcQuery cQuery new alias "PRODUTO"
	
	PRODUTO->(DbGoTop())
	if aDadosZZY[_nPos, TIPO_PRODUTO] == "MO" 
		M->G1_QUANT := PRODUTO->B1_ZZBRUTA * aDadosZZY[_nPos, HR_MAQ_PROD]
		Alert("A quantidade foi calculada com base no valor Hr/Maq do cadastro.")
	endif
	
	if (aDadosZZY[_nPos, TIPO_PRODUTO] == 'MP')	
		Alert('Quantidade será calculada com a área de blank da peça.')
		//Alert(cCodPai)
		M->G1_QUANT := PRODUTO->B1_ZZBRUTA
		M->G1_PERDA := PRODUTO->B1_ZZBRUTA - PRODUTO->B1_ZZREAL
	endif 
	M->G1_ZZCATPR := PRODUTO->B1_ZZCATAL
	PRODUTO->(DbCloseArea())
 
return 0

user function MA200CAB()
	MsAguarde({|| MT002ATU()}, "Estrutura personalizada", "Verificando atualizações pendentes...")
return 

static function MT002ATU()
	/*local aRegAtu := {}
	local nI := 1
	
	DbSelectArea('ZZB')
	DbGoTop()
	
	while !Eof()
		Aadd(aRegAtu, {ZZB->ZZB_COD, ''})
		dbSkip() 
	end
	
	// Verifica se o array está preenchido
	if (Len(aRegAtu) == 0)
		return
	endif
	
	DbSelectArea('SB1')
	DbSetOrder(1)
	
	for nI := 1 to Len(aRegAtu)
		DbSeek(xFilial('SB1') + aRegAtu[nI][1])
		// Coloca o G1_ZZCATPR
		aRegAtu[nI][2] := SB1->B1_ZZCATAL
	end
	
	DbSelectArea('SG1')
	DbSetOrder(1)
	for nI := 1 to Len(aRegAtu)
		DbClearFilter()
		DbSetFilter({|| SG1->G1_COD == aRegAtu[nI][1]}, 'SG1->G1_COD == aRegAtu[nI][1]')
		DbGoTop()
		while !(eof())
			RecLock('SG1', .F.)
			SG1->G1_ZZCATPR := aRegAtu[nI][2]
			MsUnlock()
			dbskip()
		end
	end
	DbClearFilter()
	
	DbSelectArea('ZZB')
	DbSetOrder(1)
	for nI := 1 to Len(aRegAtu)
		DbSeek(xFilial('ZZB') + aRegAtu[nI][1])
		RecLock('ZZB', .F.)
		DbDelete()
		MsUnlock()
	end
	
	_bCopEstru := .F.*/
return

user function MT200PAI(cCod)
	//Alert(SB1->B1_COD)	
	private cCodPai := SB1->B1_COD
return .T.

user function MT200CSI()
	_bCopEstru := .F.
	
	if (AllTrim(ParamIXB[1]) <> '') .and. (AllTrim(ParamIXB[2]) <> '')
		_bCopEstru := .T.
	endif
return

user function MT200MAP()
	/*if (Paramixb[5] <> 3) 
		return .T.
	endif
	
	if (_bCopEstru == .F.)
		return .T.
	endif
		
	DbSelectArea('ZZB')
	RecLock('ZZB', .T.)
	ZZB_FILIAL := xFilial('ZZB')
	ZZB_COD := cProduto
	MsUnlock()
	
	Alert('Registro copiado. Necessário clicar em [Alterar] e [Confirmar] no registro copiado.')*/
return .T.