#INCLUDE "PROTHEUS.CH"
#INCLUDE "TECA080.CH"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ZEREPARTE   ³ Autor ³ Norival Junior      ³ Data ³ 07/08/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Zera Reparte da tabela SBZ		                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Kit				                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function TELREPARTE()

Public oCombo
Public oDlg
Public cAutent		:= SPACE(15)
Public aArea		:= GetArea()
Public cRet			:= ""
Public oSay
Public cFilial		:= SPACE(02)
Public cGrupo		:= SPACE(04)//'0003'  //Grupo de Livros Nacionais
Public cGrupo1		:= SPACE(04)//'0003'  //Grupo de Livros Nacionais
Public cRet			:= ""



DEFINE MSDIALOG oDlg TITLE "Zera Repartes" FROM 09,00 TO 250, 350 PIXEL

//@ 020,015 Say "Filial de"																		Pixel
//@ 030,015 GET cFilial 											Size 085,09 			Of oDlg Pixel
//@ 020,110 Say "Filial ate" 																		Pixel
//@ 030,110 MSGET cFilial 										Size 085,09 			Of oDlg Pixel

@ 020,045 Say "Grupo de "																		Pixel
@ 030,045 MSGET cGrupo 											Size 085,09 F3 "SBM" 	Of oDlg Pixel
@ 045,045 Say "Grupo ate" 																		Pixel
@ 055,045 MSGET cGrupo1 				 							Size 085,09 F3 "SBM" 	Of oDlg Pixel
                                                   	
@ 085,095 BMPBUTTON TYPE 01 ACTION ZEREPARTE(cGrupo, cGrupo1)
@ 085,125 BMPBUTTON TYPE 02 ACTION Close(oDlg)

Activate Dialog oDlg Centered

RestArea(aArea)

Return(cRet)


Static Function ZEREPARTE(cGrupo, cGrupo1)

//Private nEmax		:= BZ_EMAX
//Private nMin		:= B1_EMIN
Private cQuery		:= ''



//	_cQuery += _cEnter + "AND AIE_FILIAL 		= '" + xFilial('AIE') + "'"

cQuery := "SELECT BZ.BZ_FILIAL, BZ.BZ_COD, BZ.BZ_EMAX, BZ.BZ_EMIN, B1.B1_GRUPO"
cQuery += " FROM SBZ010 AS BZ"
cQuery += " INNER JOIN SB1010 AS B1 "
cQuery += " ON BZ.BZ_COD = B1.B1_COD"
cQuery += " WHERE BZ_FILIAL ='" +xFilial("SBZ")+ "'"
cQuery += " AND B1.D_E_L_E_T_ = ''"
cQuery += " AND BZ.D_E_L_E_T_ = ''"
//cQuery += " AND B1.B1_GRUPO BETWEEN'" +cGrupo+ AND  +cGrupo1+"'"
cQuery += " AND B1.B1_GRUPO BETWEEN '" +cGrupo+ "' AND '"  +cGrupo1+ "'"
cQuery += " AND BZ.BZ_EMIN > 0"
cQuery += " AND BZ.BZ_EMAX > 0"

If SELECT("TRB") > 0
	dbSelectArea("TRB")
	DBCLOSEAREA()
Endif

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"TRB",.F.,.T.)},"Aguarde...","Processando Dados...")




WHILE !TRB->(EOF()) //.AND. AA6->AA6_CODPRO == cCodProOS
	
	Private cCodigo		:= TRB->BZ_COD
	
	dbSelectArea("SBZ")
	dbSetOrder(1)
	IF dbSeek(xFilial("SBZ")+alltrim(cCodigo))
		
		RECLOCK("SBZ",.F.)
		SBZ->BZ_EMIN 		:= 0
		SBZ->BZ_EMAX 		:= 0
		MSUNLOCK("SBZ")
		
	Endif
	TRB->(DBSKIP())
ENDDO

MsgAlert("Proceso Finalizado")

Return
