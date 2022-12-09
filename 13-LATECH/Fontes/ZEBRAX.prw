#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"    

User Function ZEBRAX()

Local lMark	:= .T.
Local aCampos    := {{"Z3_OK"     ,,"",},;
					{"Z3_LOTE"   ,,"LOTE", "@!"},;
					{"Z3_QUANTID",,"QTDE",PesqPict("SZ3","Z3_QUANTID")},;
					{"Z3_ARTIGO" ,,"ARTIGO", "@!"},;
					{"Z3_COR"    ,,"COR", "@!"},;
					{"Z3_PARTIDA",,"OP", "@!"},;
					{"Z3_NOME"   ,,"CLIENTE", "@!"}}

Private cQuery
Private cMarca   := GetMark()
Private bMark    := {|| Mark()}
Private cFiltro	 := ""
Private cCadastro:= "Etiquetas Lote"
Private aRotina := {{"Pesquisar", "AxPesqui",0,1},;
					{"Imprimir", "Execblock('ZEBRAETI',.F.,.F.)",0,3}}
Private bMark    := {|| Mark()}

Private cPerg      := "EST06R"

If !Pergunte(cPerg,.T.)
	Return()
Else
	_cQuery :=	""
	_cQuery +=	"SELECT * FROM SZ3010 "
	If !EMPTY(MV_PAR01)
		_cQuery +=	"WHERE Z3_LOTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	Else
		_cQuery +=	"WHERE Z3_IMP <> 'S' "
	EndIf
	_cQuery +=	"ORDER BY Z3_LOTE "
	
	MEMOWRIT("C:\SQLREL.txt",_cQuery)
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"SQL", .F., .T.)

	TCSETFIELD( "SQL","Z3_QUANTID","N",12,2)
EndIF


dbSelectArea("SQL")
dbGoTop()

	
dbSelectArea("SZ3")
_aStruct := dbStruct()
cTRB:= CriaTrab(_aStruct)

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
Endif                                 
	
dbUseArea( .T.,, cTRB, "TRB", NIL, .F. )
dbSelectArea("TRB")

dbSelectArea("SQL")
dbGoTop()
While Eof() == .f.
	dbSelectArea("TRB")
	RecLock("TRB",.t.)
	TRB->Z3_FILIAL	:=	SQL->Z3_FILIAL
	TRB->Z3_LOTE	:=	SQL->Z3_LOTE
	TRB->Z3_QUANTID	:=	SQL->Z3_QUANTID
	TRB->Z3_DESCRI	:=	SQL->Z3_DESCRI
	TRB->Z3_COMP	:=	SQL->Z3_COMP
	TRB->Z3_ORDEM	:=	SQL->Z3_ORDEM
	TRB->Z3_ARTIGO	:=	SQL->Z3_ARTIGO
	TRB->Z3_IMP		:=	SQL->Z3_IMP
	TRB->Z3_COR		:=	SQL->Z3_COR
	TRB->Z3_PARTIDA	:=	SQL->Z3_PARTIDA
	TRB->Z3_REVISOR	:=	SQL->Z3_REVISOR
	TRB->Z3_SAIDA	:=	SQL->Z3_SAIDA
	TRB->Z3_MARCA	:=	SQL->Z3_MARCA
	TRB->Z3_COPIAS	:=	SQL->Z3_COPIAS
	TRB->Z3_DOC		:=	SQL->Z3_DOC
	TRB->Z3_UM		:=	SQL->Z3_UM
	TRB->Z3_LARGURA	:=	SQL->Z3_LARGURA
	TRB->Z3_CLIENTE	:=	SQL->Z3_CLIENTE
	TRB->Z3_NOME	:=	SQL->Z3_NOME
	TRB->Z3_CNPJ	:=	SQL->Z3_CNPJ
	TRB->Z3_OK		:=	SQL->Z3_OK
	MsUnLock()
	
	dbSelectArea("SQL")
	dbSkip()
	
EndDo

dbSelectArea("SQL")
dbCloseArea("SQL")


dbSelectArea("TRB")        
cIndex:= CriaTrab(NIl,.F.)
IndRegua("TRB",cIndex,"Z3_FILIAL+Z3_LOTE+Z3_ARTIGO+Z3_COR",,,"Selecionando Registros...")

// Power By Marcio Lopes 20/08/2013
aSize	:= MsAdvSize( .F. )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

oMark	:= MsSelect():New("TRB","Z3_OK","",aCampos,.F.,@cMarca,{0,0,0,0},,,oDlg)
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT 
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || MarkAll(oMark,@lMark,cMarca) }
	
Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg,{|| Execblock('ZEBRAETI',.F.,.F.) },{|| oDlg:End() })

// Fim


//MarkBrow("TRB","Z3_OK",,aCampos,,cMarca,,,,,)

dbSelectArea("TRB")
dbCloseArea("TRB")

Return

User Function ZEBRAETI()
       
Local cCmd, bExecok	:= .F.

dbSelectArea("TRB")
dbGoTop()
ProcRegua(RecCount())

If Eof()
	MsgBox("Não há etiquetas a imprimir.","Etiquetas","Stop")
	dbSelectArea("TRB")
	dbCloseArea("TRB")
	Return
EndIf

//MSCBPRINTER("ELTRON","LPT1",,63,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
//MSCBLOADGRF("ETIQ.PCX")
//MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
//MSCBINFOETI("Etiqueta Produto","")
//MSCBWRITE("H10"+CHR(13)+CHR(10))  //aumenta a SZ3eratura da impressora

_nCount := 0
_nLinha := 0
ProcRegua(TRB->(RecCount()))

While  ! TRB->(eof())
	
    If !Marked("Z3_OK")
        DbSkip()
        Loop
    EndIf

	if __cUserId == '000070'
		MSCBPRINTER("ELTRON","LPT1",,61,.f.,,,,,"EXPEDICAO") //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.    
	else		
		MSCBPRINTER("ELTRON","LPT1",,61,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.                   
	endif		

	MSCBLOADGRF("ETIQ.PCX")
	MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
	MSCBINFOETI("Etiqueta Produto","")
	MSCBWRITE("H10"+CHR(13)+CHR(10))  //aumenta a SZ3eratura da impressora

	If !Empty(TRB->Z3_CNPJ)
		_cCNPJ := Subs(TRB->Z3_CNPJ,1,2)+"."+Subs(TRB->Z3_CNPJ,3,3)+"."+Subs(TRB->Z3_CNPJ,6,3)+"/"+Subs(TRB->Z3_CNPJ,9,4)+"-"+Subs(TRB->Z3_CNPJ,13,2)
	ElseIf mv_par04==1
		_cCNPJ := "50.747.674/0001-22"
	Else
		_cCNPJ := "05.567.611/0001-30"
	EndIf
	
	bExecOk:= .T.
	IncProc("Imprimindo Etiqueta...")
	MSCBBEGIN(1,6,61) //Inicio da Imagem da Etiqueta
	MSCBGRAFIC(55,(05+_nCount),"ETIQ")
	//					MSCBGRAFIC(2,3,"ETIQ")
	//					MSCBBOX(05,02,99,48)
	//					MSCBLINEH(10,10,45)
	//					MSCBLINEH(15,15,45)
	//					MSCBLINEV(20,20,05)
	//					MSCBLINEH(20,20,45)
	//					MSCBLINEH(25,25,45)
	//					MSCBLINEV(60,60,48)
	MSCBSAY(05,(05+_nCount),Iif(!Empty(TRB->Z3_NOME),TRB->Z3_NOME,Iif(mv_par04==1,"KENIA","ONITEX")),"N","4","2,2")
	//MSCBSAY(20,14,TRB->Z3_NOME,"N","2","1,1")
	MSCBSAY(05,(21+_nCount),"Lote:","N","2","1,1")
	MSCBSAY(15,(21+_nCount),TRB->Z3_LOTE,"N","2","1,1")
	MSCBSAY(34,(21+_nCount),"OP:","N","2","1,1")
	MSCBSAY(39,(21+_nCount),TRB->Z3_PARTIDA,"N","2","1,1")
	MSCBSAY(50,(21+_nCount),"Rev:","N","2","1,1")
	MSCBSAY(55,(21+_nCount),TRB->Z3_REVISOR,"N","2","1,1")
	MSCBSAY(05,(28+_nCount),"Artigo:","N","2","1,1")
	MSCBSAY(15,(28+_nCount),TRB->Z3_ARTIGO,"N","2","1,1")
	MSCBSAY(30,(28+_nCount),"Cor:","N","2","1,1")
	MSCBSAY(40,(28+_nCount),TRB->Z3_COR,"N","2","1,1")
	MSCBSAY(50,(28+_nCount),"Qtde:","N","2","1,1")
	MSCBSAY(60,(28+_nCount),Transform(TRB->Z3_QUANTID,"@E 999,999,999.99"),"N","2","1,1")
	MSCBSAYBAR(73,(33+_nCount),ALLTRIM(TRB->Z3_LOTE),'N','MB07',08,.F.,.T.,.F.,,2,2,,,,.T.)
	MSCBSAY(05,(35+_nCount),"Compos:","N","2","1,1")
	MSCBSAY(15,(35+_nCount),TRB->Z3_COMP,"N","2","1,1")
	MSCBSAY(05,(42+_nCount),"CNPJ:","N","2","1,1")
	MSCBSAY(15,(42+_nCount),_cCNPJ,"N","2","1,1")
	//MSCBSAY(20,(47+_nCount),"**** RECLAMACOES SOMENTE COM ESTA ETIQUETA ****","N","2","1,1")
	MSCBSAY(14,(47+_nCount),"** RECLAMACOES SOMENTE COM A PECA INTACTA E ESTA ETIQUETA **","N","2","1,1")
	//MSCBSAY(05,(63+_nCount),"X-X","N","2","1,1")
	MSCBEND()     
	MSCBCLOSEPRINTER()
	
	_nLinha	:= _nLinha + 1
	If _nLinha == 2
		//_nCount := 	_nCount + 1
		_nLinha := 0
	Endif
	
	dbSelectArea("SZ3")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ3")+TRB->(Z3_LOTE+Z3_ARTIGO+Z3_COR),.F.)
		RecLock("SZ3",.F.)
		SZ3->Z3_IMP	:=	"S"
		SZ3->Z3_OK	:=	""
		MsUnLock()
	EndIf
	
	dbSelectArea("TRB")
	dbSkip()
EndDo
        
// MSCBCLOSEPRINTER()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarkAll   ºAutor  ³ Marcio Lopes       º Data ³  12/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca / Desmarca seleção de todos os itens.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarkAll(oMark,lMark,cMarca)	

DbSelectArea("TRB")
TRB->(DbGotop())
nSel := 0
While TRB->(!Eof())

	RecLock("TRB")
		If lMark
			Replace Z3_OK 	With cMarca
			nSel++
		Else
			nSel := 0
			Replace Z3_OK 	With Space(02)
		EndIf
	TRB->(MsUnlock())
	TRB->(DbSkip())
	
EndDo

TRB->(DbGotop())
lMark := !lMark

Return
          
/* parametros mscbspool 
prg.nativa = epl
impressora = eltron     
fila = expedicao
porta = lpt1
tamanho = (branco)
path = \impter
drive windows = nao
settings = (branco)
limite lixeira = 99999999
*/