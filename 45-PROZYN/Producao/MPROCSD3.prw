#Include 'totvs.ch'  
#include "protheus.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MPROCSD3  ºAutor  ³newbridge           º Data ³  30-06-15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizar campo personalizado TIPO nos movimentos de apontaº±±
±±º          ³ mento de OP                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp11 top ms-sql                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function MPROCSD3()

	Static oDlg
	Static oButton1
	Static oButton2
	Static oGet1
	Static cGet1 := CTOD(SPACE(8))
	Static oGet2
	Static cGet2 := CTOD(SPACE(8))
	Static oSay1
	Static oSay2

	Static cAliasQry := GetNextAlias()
	Static nOpca := 0


	DEFINE MSDIALOG oDlg TITLE "Processa SD3" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL

	@ 035, 008 SAY oSay1 PROMPT "Periodo" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 033, 036 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 032, 102 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg VALID  {|| cGet2 >= cGet1} COLORS 0, 16777215 PIXEL
	@ 010, 035 SAY oSay2 PROMPT "Processar movimentos de produção para gravar campo personalizado do tipo (SD3)" SIZE 115, 016 OF oDlg COLORS 0, 16777215 PIXEL
	DEFINE SBUTTON oButton1 FROM 053, 118 TYPE 01 OF oDlg ENABLE ACTION MsAguarde( {|| OkProc()},"Aguarde","Processando...",.F.) 
	DEFINE SBUTTON oButton2 FROM 051, 049 TYPE 02 OF oDlg ENABLE ACTION { || oDlg:end() }
	ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function OkProc()

	cGet1 := DToS(cGet1)
	cGet2 := DToS(cGet2)

	oDlg:End()

	BeginSql Alias cAliasQry
		SELECT D3_OP, D3_TIPO
		FROM %table:SD3% SD3
		WHERE SD3.%notDel%
		AND D3_FILIAL = %xfilial:SD3%
		AND D3_ESTORNO <> 'S'
		AND SUBSTRING(D3_OP,7,5) = '01001'
		AND D3_CF = 'PR0'
		AND D3_EMISSAO BETWEEN %Exp:cGet1% AND %Exp:cGet2%
		ORDER BY D3_OP
	EndSql

	(cAliasQry)->(DbGoTop())
	While (cAliasQry)->(!EOF())

		MsProcTxt( "Atualizando OP "+(cAliasQry)->D3_OP )	
		GravaSD3()

		(cAliasQry)->(DbSkip())
	EndDo

	(cAliasQry)->(DbCloseArea())

Return




Static Function GravaSD3()

	Local aArea := SD3->(GetArea())
	Local cOp := Substr((cAliasQry)->D3_OP,1,6)

	SD3->(DbSetOrder(1)) //op+produto
	SD3->(DbSeek(XFilial("SD3")+cOp))

	While SD3->(!EOF()) .And. Substr(SD3->D3_OP,1,6) = cOp
		RecLock("SD3",.F.)
		SD3->D3_XTIPO := (cAliasQry)->D3_TIPO
		SD3->(MsUnLock())
		SD3->(DbSkip())
	EndDo

	RestArea(aArea)

Return
