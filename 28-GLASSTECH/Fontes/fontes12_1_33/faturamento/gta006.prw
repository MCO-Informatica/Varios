#include "Protheus.ch"

#define DS_MODALFRAME   128  // Torna-se ausente o fechar window da tela

/* Consulta de histórico de operações feitas no orçamento */
User Function gta006()

	Local aAreas:= {sx3->(GetArea()), GetArea()}
	Local cFil	:= m->cj_filial
	Local cOrc	:= m->cj_num
	Local cVend := m->cj_zzven+" - "+posicione("SA3",1,xfilial("SA3")+m->cj_zzven,"A3_NOME")

	Local cSql	:= ""
	Local nT    := 0

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	Local oBrw
	Local oDlg
	Local oGet01
	Local oGet02
	Local oPn1
	Local oPn2

	Private aCols := {}

	sx3->(dbSetOrder(2))

	cSql := "SELECT DISTINCT TTAT_DTIME,TTAT_USERID,TTAT_USER,"
	cSql += "CASE WHEN TTAT_OPERATI IN ('I','X') OR TTAT_DELET = '*' THEN ' ' ELSE TTAT_COLD END TTAT_COLD,"
	cSql += "CASE WHEN TTAT_OPERATI IN ('I','X') OR TTAT_DELET = '*' THEN ' ' ELSE TTAT_CNEW END TTAT_CNEW,"
	cSql += "CASE WHEN TTAT_OPERATI IN ('I','X') OR TTAT_DELET = '*' THEN ' ' ELSE TTAT_FIELD END TTAT_FIELD,"
	cSql += "CASE WHEN TTAT_OPERATI = 'I' THEN 'INCLUSAO' ELSE "
	cSql += "CASE WHEN TTAT_OPERATI = 'U' THEN 'ALTERACAO' ELSE "
	cSql += "CASE WHEN TTAT_OPERATI = 'X' THEN 'RECUPERACAO' ELSE 'OPER DESCONHECIDA' "
	cSql += "END END END OPERACAO,TTAT_OPERATI,TTAT_DELET DELET "
	cSql += "FROM "+RetSQLName("SCJ")+"_TTAT_LOG SCJ "
	cSql += "WHERE TTAT_PROGRAM = '"+funname()+"' AND TTAT_UNQ = '"+cFil+cOrc+"' "
	cSql += "UNION ALL "
	cSql += "SELECT DISTINCT TTAT_DTIME,TTAT_USERID,TTAT_USER,"
	cSql += "CASE WHEN TTAT_OPERATI IN ('I','X') OR TTAT_DELET = '*' THEN ' ' ELSE TTAT_COLD END TTAT_COLD,"
	cSql += "CASE WHEN TTAT_OPERATI IN ('I','X') OR TTAT_DELET = '*' THEN ' ' ELSE TTAT_CNEW END TTAT_CNEW,"
	cSql += "CASE WHEN TTAT_OPERATI IN ('I','X') OR TTAT_DELET = '*' THEN ' ' ELSE TTAT_FIELD END TTAT_FIELD,"
	cSql += "CASE WHEN TTAT_OPERATI = 'I' THEN 'INCLUSAO' ELSE "
	cSql += "CASE WHEN TTAT_OPERATI = 'U' THEN 'ALTERACAO' ELSE "
	cSql += "CASE WHEN TTAT_OPERATI = 'X' THEN 'RECUPERACAO' ELSE 'OPER DESCONHECIDA' "
	cSql += "END END END OPERACAO,TTAT_OPERATI,TTAT_DELET DELET "
	cSql += "FROM "+RetSQLName("SCK")+"_TTAT_LOG SCK "
	cSql += "WHERE TTAT_PROGRAM = '"+funname()+"' AND TTAT_UNQ = '"+cFil+cOrc+"' AND TTAT_OPERATI = 'U' "
	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb",.F.,.T.)
	while !trb->( Eof() )
		nT++
		if alltrim(trb->operacao) $ "INCLUSAO|RECUPERACAO"
			cOperacao := alltrim(trb->operacao)
		else
			if sx3->(dbSeek( alltrim(trb->ttat_field) ))
			   cOperacao := 'O campo '+alltrim(X3Titulo())
			else
				cOperacao := 'O campo '+alltrim(trb->ttat_field)
			EndIf
			if alltrim(trb->operacao) == "ALTERACAO"
				cOperacao += " ALTERADO"
			else
				cOperacao += ' '+alltrim(trb->operacao)
			endif
			cOperacao += ' de "'+alltrim(trb->ttat_cold)+'" para "'+alltrim(trb->ttat_cnew)+'"'
		endif
		Aadd(aCols, { strzero( nT ,2), cOperacao, trb->ttat_dtime, alltrim(trb->ttat_user) })
		trb->( DbSkip() )
	End
	trb->( DbCloseArea() )
	if Empty(aCols)
		Aadd(aCols, { "01", space(60), Stod(space(10)), space(20) })
	endif

	DEFINE MSDIALOG oDlg TITLE "Histórico Operações no Orçamento" FROM 000, 000  TO 400, 850 COLORS 0, 16777215 PIXEL //Style DS_MODALFRAME
	//oDlg:lEscClose := .f.

	oPn1 := tPanel():New(000,002,,oDlg,,,,,/*CLR_HCYAN*/,423,030)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	cLabelText := "Orçamento:"
	oGet01 := TGet():New(003,002,{|u|If(PCount()==0,cOrc ,cOrc:=u )},oPn1,040,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cCodCli",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Vendedor:"
	oGet02 := TGet():New(003,052,{|u|If(PCount()==0,cVend,cVend:=u)},oPn1,120,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cVend"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

	@ 009, 340 button oButton prompt "Sair"  size 037, 012 action oDlg:End() of oPn1 pixel

    /*******************************************************/
	oPn2 := tPanel():New(030,002,,oDlg,,,,,/*CLR_HCYAN*/,423,168)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	oBrw:=fwBrowse():New()
	oBrw:setOwner( oPn2 )
	oBrw:setDataArray()
	oBrw:setArray( aCols )
	oBrw:disableConfig()
	oBrw:disableReport()
	oBrw:SetLocate() // Habilita a Localização de registros
	oBrw:addColumn({"Id"        , {||aCols[oBrw:nAt,01]}, "C", "@!" , 1, 02, 0, .F. , , .F., , "IdItem", , .F., .T., , "IdIte1" })
	oBrw:addColumn({"Operação"  , {||aCols[oBrw:nAt,02]}, "C", "@!" , 1, 60, 0, .F. , , .F., , "IdOper", , .F., .T., , "IdOpe1" })
	oBrw:addColumn({"data"      , {||aCols[oBrw:nAt,03]}, "C", "@D" , 1, 10, 0, .F. , , .F., , "IdData", , .F., .T., , "IdDat1" })
	oBrw:addColumn({"Usuário"   , {||aCols[oBrw:nAt,04]}, "C", "@!" , 1, 20, 0, .F. , , .F., , "IdUsua", , .F., .F., , "IdUsu1" })

	oBrw:Activate(.t.)

    /*******************************************************/

	ACTIVATE MSDIALOG oDlg CENTERED

	aEval(aAreas, {|x| RestArea(x) })
Return
