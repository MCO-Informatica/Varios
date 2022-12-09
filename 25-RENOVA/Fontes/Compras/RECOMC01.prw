#include 'totvs.ch'

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RECOMC01
Classe para tratativa da validacao dos itens da nota fiscal de entrada com produtos de ativo fixo

@author    Fernando Bombardi
@version   1.00
@since     03/03/2016

@type class

/*/
//------------------------------------------------------------------------------------------
CLASS RECOMC01

	METHOD New() CONSTRUCTOR
	METHOD ValidaContaTESAtivo()

ENDCLASS

//-----------------------------------------------------------------
METHOD New() CLASS RECOMC01

Return

//-----------------------------------------------------------------
/*/{Protheus.doc} ValidaContaTESAtivo
Metodo para validacao de Conta Contabil x TES para produtos que sao ativos fixo.

@author		Fernando Bombardi
@since 		29/01/2016

@type method

/*/
//-----------------------------------------------------------------
METHOD ValidaContaTESAtivo(_LRET) CLASS RECOMC01
Local _CATIVO := ""

_CATIVO	:= ALLTRIM( POSICIONE( "SF4", 1, xFilial("SF4") + aCols[n,nD1TES], "F4_ATUATF" ) )

// Verifica apenas linhas que não estejam deletadas
if aCols[n] [(len(aCols[n]))] = .F.
	
	// Verifica o grupo contábil
	IF SUBSTR(aCols[n][nD1CONTA],1,4) <> "1232"
	//IF SUBSTR(aCols[n][nD1CONTA],1,1) <> "1"
		
		If _CATIVO == "S" //Atualiza ativo
			_LRET := .F.
			ShowHelpDlg("RECOMC01", {"A TES informada atualiza ativo e não pode ser utilizada com a Conta Contabil "+ALLTRIM(aCols[n][nD1CONTA]),""},3,;
			{"Utilize outro TES para realizar a entrada da nota fiscal.",""},3)
		Endif
		
	Else
		// Verifica se é conta de exceção                                          
		if ALLTRIM(aCols[n][nD1CONTA]) $ ALLTRIM(GetMV("MV_XVLDCON"))
			// Se for conta de exceção não pode aceitar TES de ativo
			If _CATIVO == "S" //Atualiza ativo
				_LRET := .F.
				ShowHelpDlg("RECOMC01", {"A TES informada atualiza ativo e não pode ser utilizada com a Conta Contabil "+ALLTRIM(aCols[n][nD1CONTA]),""},3,;
				{"Utilize outro TES para realizar a entrada da nota fiscal.",""},3)
			Endif
		Else                                                        
		    // se for conta do grupo 1234 e não for conta de exceção a TES tem que ser de ativo
			If _CATIVO == "N" //Nao atualiza ativo
				_LRET := .F.
				ShowHelpDlg("RECOMC01", {"Para a Conta Contabil "+ALLTRIM(aCols[n][nD1CONTA])+" só podem ser utilizadas TES que não atualizam ativo. ",""},3,;
				{"Utilize outro TES para realizar a entrada da nota fiscal.",""},3)
			Endif
		Endif
		
	Endif
Endif
Return(_LRET)
