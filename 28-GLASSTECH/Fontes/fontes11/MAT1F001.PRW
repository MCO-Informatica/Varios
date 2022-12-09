#include "rwmake.ch"   
#include "protheus.ch"        
#include "topconn.ch"    

#DEFINE COD_PRODUTO  1
#DEFINE TIPO_PRODUTO 2
#DEFINE DESC_PRODUTO 3
#DEFINE HR_MAQ_PROD  4

#DEFINE false .F.
#DEFINE true .T.      
#DEFINE and .and.

static cRef := ""           

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
	local cCod := AllTrim(&(ReadVar()))
	// Executa filtro e pega valor padrão
	bRet 	   := ExecFilter(cCod)
 
return bRet
 
// Filtro estático do cadastro de produto 
static function ExecFilter(cCod)
 
	// Inicializa variáveis
	local oLstSB1     := nil   
	local cGet1       := Space(120)
	private oDlgZZY   := nil
	private _bRet     := false
	private aDadosZZY := {}   
	private nList     := 0
        
 	MsAguarde({|_nLine, aDataSet, cFilter, oListRef| GetGridSource(-1, @aDadosZZY, "", nil, cCod)}, ;
 		"Pesquisa de Produtos Personalizada", "Filtrando, aguarde...")
 	
	if !_bRet
		return false  
	endif
 
	//--Montagem da Tela
	Define MsDialog oDlgZZY Title "Busca de Produtos Personalizada" From 0,0 To 350, 600 Of oMainWnd Pixel
    
    @ 15,5 GET oGet1 VAR cGet1 PICT "@!" OF oDlgZZY PIXEL SIZE 260, 10   
                         
    @ 5,5 SAY oSay VAR 'Descrição do Produto' OF oDlgZZY PIXEL SIZE 100, 10     
    
    DEFINE SBUTTON FROM 15, 270 TYPE 17 ACTION MsAguarde({|_nLine, aDataSet, cFilter, oListRef|GetGridSource(oLstZZY:nAt, @aDadosZZY, cGet1, @oLstZZY, cCod)}, ;
    	"Pesquisa de Produtos Personalizada", "Filtrando, aguarde...") ENABLE OF oDlgZZY   
    
	@ 30,5 LISTBOX oLstZZY ;
	VAR lVarMat ;       
	Fields HEADER "Cod. Produto", "Tipo", "Descrição";
	SIZE 292,125 On DblClick ( ConfZZY(oLstZZY:nAt, @aDadosZZY, @_bRet) ) ;
	OF oDlgZZY PIXEL      
 
	oLstZZY:SetArray(aDadosZZY)
	oLstZZY:nAt := nList        
	oLstZZY:bLine := { || {aDadosZZY[oLstZZY:nAt,1], aDadosZZY[oLstZZY:nAt,2], aDadosZZY[oLstZZY:nAt,3]}}
	 
	DEFINE SBUTTON FROM 160,5 TYPE 1 ACTION ConfZZY(oLstZZY:nAt, @aDadosZZY, @_bRet) ENABLE OF oDlgZZY
	DEFINE SBUTTON FROM 160,35 TYPE 2 ACTION oDlgZZY:End() ENABLE OF oDlgZZY
	 
	Activate MSDialog oDlgZZY Centered
 
Return _bRet     

static function GetGridSource(_nLine, aDataSet, cFilter, oListRef, cCod)
	
	//private cProdCod := "" 
	local cQuery     := "" 
	local lReturn    := true
	                                                    
	// Verifica index    
	if (_nLine > 0) and (Len(aDataSet) > 0)
		cCod := aDataSet[_nLine, COD_PRODUTO]
	endif

	// Limpa dataSet        
	aDataSet 	   := {}
	
	cQuery := " SELECT SB1.B1_COD, SB1.B1_TIPO, SB1.B1_DESC, SB1.B1_ZZHRMAQ, SB1.B1_ZZBRUTA" 
	cQuery += " FROM "+RetSQLName("SB1") + " AS SB1 "
	cQuery += " WHERE (RTRIM(LTRIM(SB1.B1_ZZFILIA)) = '" + xFilial("SG1") + "' OR RTRIM(LTRIM(SB1.B1_ZZFILIA)) = '')"
	cQuery += " AND SB1.D_E_L_E_T_<> '*'"  
	
	if AllTrim(cFilter) <> ""     
		cQuery += " AND SB1.B1_DESC LIKE '%" + AllTrim(cFilter) + "%'" 
	endif      
	
	cQuery += " ORDER BY SB1.B1_DESC"

    TcQuery cQuery new alias "CUSTOM_PROD"	 
    
    CUSTOM_PROD->(DbGoTop())
	if CUSTOM_PROD->(Eof())
		Aviso( "Filtro de Produtos Personalizados", "Não existe dados a consultar", {"Ok"} ) 
		oGet1:SetFocus()
		lReturn := false
	endif
	 
	Do While CUSTOM_PROD->(!Eof())
	 
		aAdd( aDataSet, ;
			{ CUSTOM_PROD->B1_COD, ;
			  CUSTOM_PROD->B1_TIPO, ;
			  CUSTOM_PROD->B1_DESC, ;
			  CUSTOM_PROD->B1_ZZHRMAQ, ;
			  CUSTOM_PROD->B1_ZZBRUTA} )
		 
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
	
	if aDadosZZY[_nPos, TIPO_PRODUTO] == "MO" 
		//Prepara cQuery para pegar o valor da H/M
		cQuery := "SELECT ISNULL(B1_ZZBRUTA, 0) AS B1_ZZBRUTA FROM " + RetSqlName("SB1") + " SB1 WHERE RTRIM(LTRIM(SB1.B1_COD)) = '" + SG1->G1_COD + "'"
		cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
		TcQuery cQuery new alias "PRODUTO"
		
		PRODUTO->(DbGoTop())
		M->G1_QUANT := PRODUTO->B1_ZZBRUTA * aDadosZZY[_nPos, HR_MAQ_PROD]
		PRODUTO->(DbCloseArea())
	 
		Alert("A quantidade foi calculada com base no valor Hr/Maq do cadastro.")
		//Alert()
	endif
 
return 0