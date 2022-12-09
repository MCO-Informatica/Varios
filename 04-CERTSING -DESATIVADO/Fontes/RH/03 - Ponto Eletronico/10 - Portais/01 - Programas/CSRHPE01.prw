#include 'protheus.ch'
#include 'parmtype.ch'

user function CSRHPE01( aMarc, aTabCalend, cPerAponta )
	default aMarc 	   := {} //Array com marca��es
	default aTabCalend := {} //Array com calendario padrao
	default cPerAponta := {} //Periodo de apontamento

	processa( {|| PONAPO3p(  aMarc, aTabCalend, cPerAponta  ) }, "Portal do Ponto", "Atualizando", .F. )
return

static function PONAPO3p(  aMarc, aTabCalend, cPerAponta )
	local cFilFunc   := SRA->RA_FILIAL //Filial do funcionario
	local cMatFunc   := SRA->RA_MAT	//Matricula do funcionario
	local cIdLog     := "" //Codigo RD0 de quem mecheu no registro
	local dDiaDe     := cToD("//") //Data inicial para alteracao
	local dDiaAte    := cToD("//") //Data final para alteracao
	local lAltRH     := .T. //Indica que aquela altera��o foi realizada pelo RH e dever� ter outra fluxo.

	default aMarc 	   := {} //Array com marca��es
	default aTabCalend := {} //Array com calendario padrao
	default cPerAponta := {} //Periodo de apontamento

	procRegua( 0 ) //Atribuo uma regua infinita

	//Verifico se a filial, matricula e periodo de apontamento estao preenchidos.
	if !empty(cFilFunc) .and. !empty(cMatFunc) .and. !empty(cPerAponta)
		//incProc()//Inicio
		/*Executo a rotina de atualiza��o do portal do ponto, assim caso a altera��o
		feita pelo RH gere alguma altera��o,o sistema dever� tratar de uma forma diferente*/
		U_CSRH012(cFilFunc, cMatFunc, cPerAponta, cIdLog, dDiaDe, dDiaAte, lAltRH )
	endif
return