#Include "TopConn.ch"
#Include "Protheus.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DBCONCLI  ºAutor  ³ Danilo Alves Del Busso ºData ³02/05/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para consultar clientes pela raiz do CNPJ, solicitaçãoº±±
±±º          ³ feita por usuários de vendas durante reunião.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function DBCONCLI() 

Local aSize, aObjects, aInfo

Local bOk      := {|| oDialog:End()}
Local bCancel  := {|| oDialog:End()}           
Local aButtons := {}

Private cTitle := "Consultar Clientes"

Private oDialog
Private aPosObj

Private oGetDados
Private aHeader := {}
Private aCols   := {}        

Private oBFiltro     

Private oPesqu
Private aPesqu := {"CNPJ Cliente","Nome Cliente"}
Private cPesqu
              
Private oGCgcCli
Private cGCgcCli := CRIAVAR("A1_CGC", .F.)

Private oGNomCli
Private cGNomCli := CRIAVAR("A1_NOME", .F.)    

Private lEdtCNPJ := .T.
Private lEdtNomC := .F. 

Private nColAnt := 0
Private cOrdAnt := "C"    
/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := MsAdvSize( [ ExpL1 ], [ ExpL2 ], [ ExpN1 ] )      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 -> Enchoicebar .T. ou .F.                            ³±±
±±³          ³ ExpL2 -> Retorna janela padrao siga                        ³±±
±±³          ³ ExpN1 -> Tamanho minimo ( altura )                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 -> Dimensoes da janela / area de trabalho            ³±±
±±³          ³     1 -> Linha inicial area trabalho                       ³±±
±±³          ³     2 -> Coluna inicial area trabalho                      ³±±
±±³          ³     3 -> Linha final area trabalho                         ³±±
±±³          ³     4 -> Coluna final area trabalho                        ³±±
±±³          ³     5 -> Coluna final dialog                               ³±±
±±³          ³     6 -> Linha final dialog                                ³±±
±±³          ³     7 -> Linha inicial dialog                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

aSize    := MsAdvSize()

If aSize[3] < 495 
	aSize[3] := 495
	aSize[4] := 283
	aSize[5] := 990
	aSize[6] := 597
	aSize[7] := 17
EndIf

aObjects := {{ 100, 040, .T., .F. },;
{ 100, 100, .T., .T. },;
{ 100, 022, .T., .F. }}

aInfo    := { aSize[1],;
aSize[2],;
aSize[3],;
aSize[4],;
3,;
3 }   
  

/*
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Sintaxe   ³ ExpA1 := MsObjSize( ExpA2, ExpA3, [ ExpL1 ], [ ExpL2 ] )   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA2 -> Area de trabalho                                  ³±±
±±³          ³ ExpA3 -> Definicoes de objetos                             ³±±
±±³          ³    1 - Tamanho X    / 2 - Tamanho Y  / 3 - Dimensiona X    ³±±
±±³          ³    4 - Dimensiona Y / 5 - Retorna dimensoes X e Y ao inves ³±±
±±³          ³       de linha / coluna final                              ³±±
±±³          ³ ExpL1 -> Mantem a proporcao dos objetos                    ³±±
±±³          ³ ExpL2 -> Indica calculo de objetos horizontais             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpA1 -> Array com as posicoes de cada objeto              ³±±
±±³          ³     1 -> Linha inicial                                     ³±±
±±³          ³     2 -> Coluna inicial                                    ³±±
±±³          ³     3 -> Linha final                                       ³±±
±±³          ³     4 -> Coluna final Ou:                                  ³±±
±±³          ³     Caso seja passado o elemento 5 de cada definicao de    ³±±
±±³          ³     objetos como .t. o retorno sera:                       ³±±
±±³          ³     3 -> Tamanho da dimensao X                             ³±±
±±³          ³     4 -> Tamanho da dimensao Y                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

aPosObj  := MsObjSize(aInfo, aObjects)

Define MsDialog oDialog Title cTitle From aSize[7], 0 To aSize[6], aSize[5] Of oMainWnd Pixel

@ aPosObj[1][1], aPosObj[1][2] To aPosObj[1][3]+14, aPosObj[1][4] Prompt "Filtro" Of oDialog Pixel   

@ aPosObj[1][1]+10, aPosObj[1][2]+10 Say "Filtrar Por:" Of oDialog Pixel
@ aPosObj[1][1]+9, aPosObj[1][2]+45 ComboBox oPesqu Var cPesqu Items aPesqu Valid fValCom(.T.) Size 60, 50 When .T. Of oDialog Pixel

@ aPosObj[1][1]+25, aPosObj[1][2]+10 Say "CNPJ Cliente:" Of oDialog  Pixel
@ aPosObj[1][1]+24, aPosObj[1][2]+45 MSGet oGCgcCli Var CGCgcCli Size 80, 09  Of oDialog When lEdtCNPJ Picture "@R 99.999.999/9999-99" Pixel

@ aPosObj[1][1]+40, aPosObj[1][2]+10 Say "Nome Cliente:" Of oDialog  Pixel
@ aPosObj[1][1]+39, aPosObj[1][2]+45 MSGet oGNomCli Var CGNomCli Size 155, 09  Of oDialog When lEdtNomC Picture "@!" Pixel
 
@ aPosObj[1][1]+25, aPosObj[1][2]+205 Button oBFiltro Prompt "Filtrar Clientes" Size 80, 11 Action BtnFiltro() Of oDialog Pixel

oGetDados := MsNewGetDados():New(aPosObj[2][1]+15, aPosObj[2][2], aPosObj[2][3]-1, aPosObj[2][4]-1, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDialog, aHeader, aCols)
                    
oGCgcCli:SetFocus()

oGetDados:lInsert := .F.
oGetDados:lDelete := .F.
oGetDados:lUpdate := .F.

Activate MsDialog oDialog On Init (EnchoiceBar(oDialog,{||lOk:=.T.,oDialog:End()},{||oDialog:End()},,@aButtons))      


Return()   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BtnFiltro ºAutor  ³Microsiga           º Data ³  03/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao Botao Filtrar                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BtnFiltro()
                                         
If Empty(cGCgcCli) .AND. Empty(cGNomCli)
     MsgInfo("Informe Parte do CNPJ ou Nome do Cliente para efetuar a busca...","Aviso")
     Return()
EndIf

If temCaracEspec()
    MsgInfo("O nome do cliente não deve possuir caracteres especiais, acentuações nem pontuações...", "Aviso")
    Return()
EndIf            

Processa({|| FilClientes() }, "Aguarde", "Gerando Consulta ...", .F.)

oGetDados := MsNewGetDados():New(aPosObj[2][1]+10, aPosObj[2][2], aPosObj[2][3]-1, aPosObj[2][4]-1, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDialog, aHeader, aCols)
oGetDados:lInsert := .F.
oGetDados:lDelete := .F.
oGetDados:lUpdate := .F.
oGetDados:lActive := .F.
oGetDados:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}
		
Return()   

Static Function FilClientes()

Local _cQry := ""
Local nRecQtd := 0

aHeader := {}

Aadd(aHeader,{"Código"       ,"A1_COD" 		,PesqPict("SA1","A1_COD")	,TamSx3("A1_COD")[1]	,TamSx3("A1_COD")[2]	,"",, TamSx3("A1_COD")[3]	,,,""})  
Aadd(aHeader,{"Loja"      	 ,"A1_LOJA" 	,PesqPict("SA1","A1_LOJA")	,TamSx3("A1_LOJA")[1]	,TamSx3("A1_LOJA")[2]	,"",, TamSx3("A1_LOJA")[3]	,,,""})     
Aadd(aHeader,{"Nome Fantasia"      ,"A1_NOME"		,PesqPict("SA1","A1_NOME") 	,TamSx3("A1_NOME")[1]	,TamSx3("A1_NOME")[2]	,"",, TamSx3("A1_NOME")[3]	,,,""})
Aadd(aHeader,{"Nome Reduzido"      ,"A1_NREDUZ"		,PesqPict("SA1","A1_NREDUZ") 	,TamSx3("A1_NREDUZ")[1]	,TamSx3("A1_NREDUZ")[2]	,"",, TamSx3("A1_NREDUZ")[3]	,,,""})
Aadd(aHeader,{"CNPJ"       	 ,"A1_CGC" 		,PesqPict("SA1","A1_CGC")	,TamSx3("A1_CGC")[1]	,TamSx3("A1_CGC")[2]	,"",, TamSx3("A1_CGC")[3]	,,,""})
Aadd(aHeader,{"Regiao"       ,"A1_REGIAO" 	,PesqPict("SA1","A1_REGIAO")	,TamSx3("A1_REGIAO")[1]	,TamSx3("A1_REGIAO")[2]	,"",, TamSx3("A1_REGIAO")[3]	,,,""})
Aadd(aHeader,{"Divisao"      ,"A1_GRPVEN" 	,PesqPict("SA1","A1_GRPVEN")	,TamSx3("A1_GRPVEN")[1]	,TamSx3("A1_GRPVEN")[2]	,"",, TamSx3("A1_GRPVEN")[3]	,,,""})
Aadd(aHeader,{"Ultima Compra","A1_ULTCOM"	,PesqPict("SA1","A1_ULTCOM")	,TamSx3("A1_ULTCOM")[1]	,TamSx3("A1_ULTCOM")[2]	,"",,TamSx3("A1_ULTCOM")[3]	,,,""})
Aadd(aHeader,{"Vendedores"	 ,"Vendedores"	,"@!"							,300					,0						,"",,"C",,,""})


_cQry += "SELECT A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_REGIAO, A1_GRPVEN, A1_ULTCOM FROM SA1010 WHERE D_E_L_E_T_ <> '*' AND (" + IIF(cPesqu == "CNPJ Cliente"," A1_CGC LIKE '" + AllTrim(Upper(CGCgcCli)) + "%'", " A1_NOME LIKE '%" + AllTrim(Upper(CGNomCli)) + "%' OR A1_NREDUZ LIKE '%" + AllTrim(Upper(FwNoAccent(CGNomCli))) + "%'") + ") ORDER BY A1_NOME" 
_cQry := ChangeQuery(_cQry)    


If Select("CONCLITMP") > 0
	CONCLITMP->(DbCloseArea())
EndIf

TCQUERY _cQry NEW ALIAS "CONCLITMP"

aCols := {}    

nRecQtd := Contar("CONCLITMP","!Eof()")   

ProcRegua(nRecQtd)

Dbselectarea("CONCLITMP")  
CONCLITMP->(DbGoTop())     
      
If nRecQtd > 10
     MsgInfo("Sua pesquisa retornou mais do que 10 registros, tente ser mais específico nos filtros...","Aviso")
     Return()
EndIf

While CONCLITMP->(!Eof())     

	_cVendedores := " | "

	_cQry := "SELECT A3_COD, A3_NOME, Z12_REGDES FROM Z12010 INNER JOIN SA3010 ON (Z12_COD = A3_COD) WHERE Z12_REGIAO+Z12_GRUPO = '"+CONCLITMP->A1_REGIAO+CONCLITMP->A1_GRPVEN+"' AND Z12010.D_E_L_E_T_ <> '*'"
	TCQUERY _cQry NEW ALIAS "CONVENTMP" 	
	While CONVENTMP->(!Eof())
	     _cVendedores += AllTrim(CONVENTMP->A3_NOME) + " | "
	     CONVENTMP->(DbSkip())
	EndDo 
	CONVENTMP->(dbCloseArea()) 
	                                        
	aAdd(aCols, { CONCLITMP->A1_COD  , ;    
	CONCLITMP->A1_LOJA,;
	CONCLITMP->A1_NOME,;
	CONCLITMP->A1_NREDUZ,;
	CONCLITMP->A1_CGC,;
	CONCLITMP->A1_REGIAO,;
	CONCLITMP->A1_GRPVEN ,;
	StoD(CONCLITMP->A1_ULTCOM) ,;
	_cVendedores ,;
	.F.} )    
	
	CONCLITMP->(DbSkip())
	IncProc()
EndDo
CONCLITMP->(dbCloseArea())  


Return(Nil)    

Static Function fValCom(lTroca)
Local lRet := .T.
Default lTroca := .F.

If cPesqu == "CNPJ Cliente"
	lEdtCNPJ := .T.
	lEdtNomC := .F.    
	cGNomCli  := Space(Len(cGNomCli))      
	cGCgcCli  := Space(Len(cGCgcCli))
	oGCgcCli:SetFocus()  
EndIf

If cPesqu == "Nome Cliente"
	lEdtNomC := .T.
	lEdtCNPJ := .F.        
	cGCgcCli  := Space(Len(cGCgcCli))
	cGNomCli  := Space(Len(cGNomCli)) 
	oGNomCli:SetFocus() 
EndIf

Return(lRet)                                 
Static Function temCaracEspec()     
Local lRet := .F. 

For nX := 1 To Len(AllTrim(cGNomCli))
     If !(SUBSTR(cGNomCli,nX,1)$'ABCDEFGHIJKLMNOPQRSTUVXWYZ.-, ')
     	lRet := .T.
     EndIf
Next 
Return lRet 


Static Function fOrdTemp(obj, col)

Local aTmpCols  := {}
Local aTmpTotal := {}

If nColAnt != col
	nColAnt := col
	cOrdAnt := "C"
Else
	If cOrdAnt == "C"
		cOrdAnt := "D"
	Else
		cOrdAnt := "C"
	EndIf
EndIf

nPosTos := Len(oGetDados:ACOLS)

For nX := 1 To nPosTos -1
	aadd(aTmpCols,aClone(oGetDados:ACOLS[nX]))
Next nX

aAdd(aTmpTotal,aClone(oGetDados:ACOLS[nPosTos]))

oGetDados:ACOLS := aClone(aTmpCols)

If cOrdAnt == "C"
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] < y[col]})
Else
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] > y[col]})
EndIf

aAdd(oGetDados:ACOLS,aClone(aTmpTotal[1]))

oGetDados:oBrowse:Refresh(.T.)

Return()
