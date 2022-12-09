#include "Protheus.ch"  

#define cCODIGO_SINDPD_RCE '01'
#define cSIM '1'
#define cNAO '2'

#define cCONTRIBUICAO_ASSISTENCIAL_VERBA 		 	'459'
#define nCONTRIBUICAO_ASSISTENCIAL_TETO 		 	50
#define nCONTRIBUICAO_ASSISTENCIAL_PERCENTUAL  	1
#define nMODIFICADOR_FUNCIONARIO_SINDICALIZADO 	0.5

#define cMENSALIDADE_SINDICAL_VERBA 				'408'
#define nMENSALIDADE_SINDICAL 						15.00
#define nMENSALIDADE_SINDICAL_PERCENTUAL  		100

/*/{Protheus.doc} geraCont
Cálculo especifíco do SINDPD SP - TRABA PROCESS DE DADOS DE SP

Fórmula para Contribuição Assistêncial:
	1% sobre salário do funcionário com teto R$ 40,00. 
	Se for sindicalizado aplicado 50% de desconto e o teto fica em R$ 20,00.

Fórmula para Mensalidade Sindical:
	R$ 10,40 Fixo.

@type function
@author BrunoNunes
@since 26/11/2013
@version P12 1.12.17 
@history 11/01/2018, Bruno Nunes, OTRS - 2018011010000356. Alteração no cálculo sindical devido a virada do sistema para P12. 
@return null, Nulo
/*/
User function geraCont()
                  
	Local _nSalario := SRA->RA_SALARIO              
	Local _nValCont   := 0
  	  	
  	if SRA->RA_SINDICA == cCODIGO_SINDPD_RCE 
  	  	
	  	//Fórmula da Contribuição Assistêncial
		If SRA->RA_ASSIST == cSIM          				
			_nValCont :=   _nSalario*(nCONTRIBUICAO_ASSISTENCIAL_PERCENTUAL/100)
			If _nValCont > nCONTRIBUICAO_ASSISTENCIAL_TETO         
				_nValCont := nCONTRIBUICAO_ASSISTENCIAL_TETO
			EndIf
			if SRA->RA_MENSIND == cSIM
				fgeraverba(	cCONTRIBUICAO_ASSISTENCIAL_VERBA,_nValCont*nMODIFICADOR_FUNCIONARIO_SINDICALIZADO, nCONTRIBUICAO_ASSISTENCIAL_PERCENTUAL,,,,,,,,.T.,)
			else
				fgeraverba(cCONTRIBUICAO_ASSISTENCIAL_VERBA, _nValCont, nCONTRIBUICAO_ASSISTENCIAL_PERCENTUAL,,,,,,,,.T.,)
			endif
		EndIf
		
		//Fórmula da Mensalidade Sindical 
		If SRA->RA_MENSIND == cSIM
			fgeraverba(cMENSALIDADE_SINDICAL_VERBA, nMENSALIDADE_SINDICAL, nMENSALIDADE_SINDICAL_PERCENTUAL,,,,,,,,.T.,)
		Endif
	endif            
Return(.T.)  
