#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR03  ³ Autor ³ MARCIO LOPES            ³ Data ³ 15/03/2011 ³±±
±±³          ³          ³       ³                         ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao Etiquetas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Etiqueta Codigo de Barras                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR100()

Private cQuery
Private cDesc			:= ""
Private cClas			:= ""
Private cGrup			:= ""
Private cDim1			:= ""
Private cDim2			:= ""
Private cDim3			:= ""
Private cDim4			:= ""
Private cDim5			:= ""
Private cDim6			:= ""
Private cDim7			:= ""
Private cNome			:= ""
Private aCodBar			:= {}
Private cPerg			:= PadR("RFATR100",Len(SX1->X1_GRUPO))
Private cImagem			:= "etiq.pcx"
//cPerg      := "ETIZ01"  // Nome da Pergunte

//If ! Pergunte(cPerg,.T.)
//     Return
//Endif

ValidPerg()

If !pergunte(cPerg,.T.)
	Return
Endif

cQuery := "SELECT B1_FILIAL, B1_COD, B1_DESC, B1_CODBAR FROM " +RETSQLNAME("SB1")
cQuery += " WHERE B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY B1_FILIAL, B1_COD"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)

DBSELECTAREA("TRB")
DBGOTOP()

WHILE !EOF()
	   
		cDesc			:= "TESTE DESCRICAO"
		cClas			:= "TESTE CLASSE"
		cNome			:= B1_DESC
		aCodBar			:= {B1_CODBAR}
        
/*        IF SUBSTR(ALLTRIM(B1_GRUPO),1,2) = "14"
        	cDim1 := "10,2-178mm x 262mm"
			cDim2 := "10-178mm x 258mm"
			cDim3 := "8,9-168mm x 223mm"
		ENDIF */
		

//	MSCBPRINTER("ALLEGRO 2","LPT1",,61,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
	MSCBPRINTER("S500-8","LPT1",,,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
	MSCBLOADGRF("/protheus_data/system/logo.bmp")
	MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
//	MSCBINFOETI("Etiqueta Produto","")
	MSCBWRITE("H10"+CHR(13)+CHR(10))  //aumenta a temperatura da impressora

	    MSCBBEGIN(val(mv_par03),6)
		

		//etiqueta1
		//MSCBGRAFIC(02,01,"logo")                           
		MSCBSAY(20,08,cNome,"R","0","21,22")
		MSCBSAY(17,09,"38.908.778/0001-76-SP","R","0","21,21")
		MSCBSAYBAR(05,13,aCodBar[1],'R','MB04',12,.f.,.t.,,,2,2)
        //etiqueta2
		MSCBSAY(47,08,cNome,"R","0","21,22")
		MSCBSAY(44,09,"38.908.778/0001-76-SP","R","0","21,21")
		MSCBSAYBAR(32,13,aCodBar[1],'R','MB04',12,.f.,.t.,,,2,2)
		//MSCBGRAFIC(36,10,"logo")                           

		//etiqueta3
		MSCBSAY(74,08,cNome,"R","0","21,22")
		MSCBSAY(71,09,"38.908.778/0001-76-SP","R","0","21,21")
		MSCBSAYBAR(59,13,aCodBar[1],'R','MB04',12,.f.,.t.,,,2,2)
		//MSCBGRAFIC(63,10,"logo")                           

		//etiqueta4
		MSCBSAY(101,08,cNome,"R","0","21,22")
		MSCBSAY(98,09,"38.908.778/0001-76-SP","R","0","21,21")
		MSCBSAYBAR(86,13,aCodBar[1],'R','MB04',12,.f.,.t.,,,2,2) 
		//MSCBGRAFIC(90,10,"logo")                           
		
/*		MSCBSAY(89,02,"AJUSTAVAL PARA " + cClas,"R","2","1,1")
		MSCBSAY(85,02,cDim1,"R","1","0,001")
		MSCBSAY(83,02,cDim2,"R","1","0,001")
		MSCBSAY(81,02,cDim2,"R","1","0,001")		
		MSCBSAYBAR(87,25,aCodBar[1],'R','MB07',15,.f.,.t.,,,2,2) 
		
		MSCBSAY(62,02,cDesc,"R","2","1,1")
		MSCBSAY(60,02,"AJUSTAVAL PARA "+ cClas,"R","2","1,1") 
		MSCBSAY(56,02,cDim1,"R","1","0,001")
		MSCBSAY(54,02,cDim2,"R","1","0,001")
		MSCBSAY(52,02,cDim2,"R","1","0,001")		
		MSCBSAYBAR(58,25,aCodBar[1],'R','MB07',15,.f.,.t.,,,2,2)		

		MSCBSAY(33,02,cDesc,"R","2","1,1")
		MSCBSAY(31,02,"AJUSTAVAL PARA " + cClas,"R","2","1,1")
		MSCBSAY(27,02,cDim1,"R","1","0,001")
		MSCBSAY(25,02,cDim2,"R","1","0,001")
		MSCBSAY(23,02,cDim2,"R","1","0,001")		
		MSCBSAYBAR(29,25,aCodBar[1],'R','MB07',15,.f.,.t.,,,2,2) */			
		
		MSCBEND() //Fim da Imagem da Etiqueta
		MSCBCLOSEPRINTER()
		

DBSKIP()

ENDDO
DBCLOSEAREA("TRB") 

Return

*---------------------------------*
Static Function ValidPerg()
*---------------------------------*

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	DBSelectArea("SX1") ; DBSetOrder(1)
	cPerg := PADR(cPerg,10)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cperg,"01","Do Produto:"		,"","","mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cperg,"02","Ate o Produto:"		,"","","mv_ch2","C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cperg,"03","Quantidade:"		,"","","mv_ch3","C", 4,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])

			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
			

		EndIf 
	Next    
	DBSelectArea(_sAlias)
Return
                              





/*

************************************************** caba *****************************************************
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Rdmake	 ³ EtiqProd ³Autor  ³ Magh Moura            ³ Data ³ 16.05.06  ±±
±±º			 ³          ³Modif  ³ Magh Moura            ³ Data ³ 25/09/06  ±±
±±º			 ³          ³Modif  ³ SUPORTE               ³ Data ³ 21/02/07  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ±±
±±³Descri‡…o ³ Rotina de impressao de etiquetas codigo de Barras	       ±±
±±³          ³ do cadastro de produtos x Lote.                 			   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºUso       ³ Minexco Com. Imp. Exp. Ltda.                                ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ±±
±±ºConf.Impr.³ ELTRON LP2142. (Configurar esse drive de impressao sempre)  ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
USER FUNCTION Etiq()

Local cCmd, bExecok	:= .F.
Local lRet			:= .T.

cPerg      := "EST06R"  // Nome da Pergunte
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Pergunte(cPerg,.T.)
	lRet	:=	.f.
EndIF

BuscaEtiq()

If lRet
	dbSelectArea("TEMP")
	dbGoTop()
	ProcRegua(RecCount())
	
	If Eof()
		MsgBox("Não há etiquetas a imprimir.","Etiquetas","Stop")
		dbSelectArea("TEMP")
		dbCloseArea("TEMP")
		Return
	EndIf
	
	MSCBPRINTER("ELTRON","LPT1",,48,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
	MSCBLOADGRF("ETIQ.PCX")
	MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
	MSCBINFOETI("Etiqueta Produto","")
	MSCBWRITE("H10"+CHR(13)+CHR(10))  //aumenta a temperatura da impressora
	
	ProcRegua(TEMP->(RecCount()))
	
	While  ! TEMP->(eof())
		
		If !Empty(TEMP->Z3_CNPJ)
			_cCNPJ := Subs(TEMP->Z3_CNPJ,1,2)+"."+Subs(TEMP->Z3_CNPJ,3,3)+"."+Subs(TEMP->Z3_CNPJ,6,3)+"/"+Subs(TEMP->Z3_CNPJ,9,4)+"-"+Subs(TEMP->Z3_CNPJ,13,2)
		ElseIf mv_par04==1
			_cCNPJ := "50.747.674/0001-22"
		Else
			_cCNPJ := "05.567.611/0001-30"
		EndIf
		
		bExecOk:= .T.
		IncProc("Imprimindo Etiqueta...")
		MSCBBEGIN(1,6,48) //Inicio da Imagem da Etiqueta
		MSCBGRAFIC(55,05,"ETIQ")
		//					MSCBGRAFIC(2,3,"ETIQ")
		//					MSCBBOX(05,02,99,48)
		//					MSCBLINEH(10,10,45)
		//					MSCBLINEH(15,15,45)
		//					MSCBLINEV(20,20,05)
		//					MSCBLINEH(20,20,45)
		//					MSCBLINEH(25,25,45)
		//					MSCBLINEV(55,55,48)
		MSCBSAY(05,05,Iif(!Empty(TEMP->Z3_NOME),TEMP->Z3_NOME,Iif(mv_par04==1,"KENIA","ONITEX")),"N","4","2,2")
		//MSCBSAY(20,14,TEMP->Z3_NOME,"N","2","1,1")
		MSCBSAY(05,21,"Lote:","N","2","1,1")
		MSCBSAY(15,21,TEMP->Z3_LOTE,"N","2","1,1")
		MSCBSAY(34,21,"OP:","N","2","1,1")
		MSCBSAY(39,21,TEMP->Z3_PARTIDA,"N","2","1,1")
		MSCBSAY(50,21,"Rev:","N","2","1,1")
		MSCBSAY(55,21,TEMP->Z3_REVISOR,"N","2","1,1")
		MSCBSAY(05,28,"Artigo:","N","2","1,1")
		MSCBSAY(15,28,TEMP->Z3_ARTIGO,"N","2","1,1")
		MSCBSAY(30,28,"Cor:","N","2","1,1")
		MSCBSAY(40,28,TEMP->Z3_COR,"N","2","1,1")
		MSCBSAY(50,28,"Qtde:","N","2","1,1")
		MSCBSAY(60,28,Transform(TEMP->Z3_QUANTID,"@E 999,999,999.99"),"N","2","1,1")
		MSCBSAYBAR(73,33,ALLTRIM(TEMP->Z3_LOTE),'N','MB07',08,.F.,.T.,.F.,,2,2,,,,.T.)
		MSCBSAY(05,35,"Compos:","N","2","1,1")
		MSCBSAY(15,35,TEMP->Z3_COMP,"N","2","1,1")
		MSCBSAY(05,42,"CNPJ:","N","2","1,1")
		MSCBSAY(15,42,_cCNPJ,"N","2","1,1")
		MSCBSAY(20,47,"**** RECLAMACOES SOMENTE COM ESTA ETIQUETA ****","N","2","1,1")
		MSCBSAY(05,48,"","N","2","1,1")
		MSCBEND()
		
		
		dbSelectArea("SZ3")
		dbSetOrder(1)
		dbSeek(TEMP->(Z3_FILIAL+Z3_LOTE+Z3_ARTIGO+Z3_COR),.f.)
	
		RecLock("SZ3",.F.)
		SZ3->Z3_IMP	:=	"S"
		MsUnLock()

		dbSelectArea("TEMP")
		dbSkip()
	EndDo
	
	dbSelectArea("TEMP")
	dbCloseArea("TEMP")
	
Else
	msgalert("Voce Cancelou a Operação.")
EndIf


Return


Static Function BuscaEtiq()

cQuery := "SELECT * FROM SZ3010 "
cQuery += "WHERE D_E_L_E_T_ = '' "
If !Empty(mv_par01)
	cQuery += "AND Z3_LOTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
Else
	cQuery += "AND Z3_IMP <> 'S' "
EndIf
If !Empty(mv_par03)
	cQuery += "AND Z3_CLIENTE <> '"+MV_PAR03+"' "
EndIf

cQuery += "ORDER BY Z3_LOTE"


cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TEMP", .F., .T.)

Return

  */