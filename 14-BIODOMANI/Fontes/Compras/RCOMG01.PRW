#include "protheus.ch"


/*/{Protheus.doc} RCOMG01
Permite Movimentação no Armazem Cadastrado  // Faz Link com o Fonte RESTG01.PRW
@type function
@version 12.1.33
@author Anderson Martins
@since 9/14/2022
/*/

User Function RCOMG01()


Local _cArmazem	:= aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "D1_LOCAL" })]

If CTIPO$"N"
	If Alltrim((cUserName)) $ "Administrador|danielle.pereira|daniel.borges|fernanda.sanches|teste.bloqueio|ariane.lopes|gabrielly.antunes|roberto.cesar|fernanda.alcaide|UPDUO01|UPDUO02|maria.claudino|cristiane.cazzolli|Igor.Araujo|thais.botelho|luiz.gustavo|fernando.antunes|alessandro.martins|jose.luis|marcio.sergio|"

		If !Alltrim((cUserName)) $ "roberto.cesar|alessandro.martins|fernando.antunes|danielle.pereira|daniel.borges|maria.claudino|ariane.lopes|jose.luis|marcio.sergio|UPDUO01|UPDUO02" .and. _cArmazem$"01A3.03A3.06A3"
			MsgStop("Você não tem permissão para realizar movimentação de estoque neste armazém.")
			_cArmazem := ""
		EndIf

        /*
        If !Alltrim((cUserName)) $ "maria.claudino|alessandro.martins|danielle.pereira|UPDUO01|UPDUO02" .and. _cArmazem$"03A2.06A2"
            MsgStop("Você não tem permissão para realizar movimentação de estoque neste armazém.")
            _cArmazem := ""
        EndIf*/

        If !Alltrim((cUserName)) $ "fernanda.alcaide|maria.claudino|roberto.cesar|alessandro.martins|ferando.antunes|daniel.borges|danielle.pereira|jose.luis|marcio.sergio|UPDUO01|UPDUO02" .and. _cArmazem$"03A2.06A2"
            MsgStop("Você não tem permissão para realizar movimentação de estoque neste armazém.")
            _cArmazem := ""
        EndIf

        If !Alltrim((cUserName)) $ "ariane.lopes|gabrielly.antunes|Igor.Araujo|luiz.gustavo|alessandro.martins|daniel.borges|danielle.pereira|UPDUO01|UPDUO02" .and. _cArmazem $ "01A1.02A1.04A1.05A1.06A1.07A1.08A1.09A1.10A1.11A1.12A1.13A1.14A1.15A1.16A1.17A1.18A1.19A1.20A1"
            MsgStop("Você não tem permissão para realizar movimentação de estoque neste armazém.")
            _cArmazem := ""
        EndIf

        /*If Alltrim((cUserName)) $ "maria.claudino" .and. _cArmazem <> "03A2"
            MsgStop("Você não tem permissão para realizar movimentação de estoque neste armazém.")
            _cArmazem := ""
        EndIf*/

        If Alltrim((cUserName)) $ "cristiane.cazzolli" .and. _cArmazem <> "01A1"
            MsgStop("Você não tem permissão para realizar movimentação de estoque neste armazém.")
            _cArmazem := ""
        EndIf

        /*If Alltrim((cUserName)) $ "luiz.gustavo" .and. _cArmazem $ "01A1"
                MsgStop("Você não tem permissão para realizar movimentação de estoque neste armazém.")
                _cArmazem := ""
        EndIf*/

    Else
        MsgStop("Você não tem permissão para realizar movimentação de estoque.")
        _cArmazem := ""
    EndIf
ENDIF

Return(_cArmazem)   
