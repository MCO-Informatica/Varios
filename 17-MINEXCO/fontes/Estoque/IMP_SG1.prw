#include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma          ³ IMP_SG1              º Analista    ³ TOTVS MCINFOTEC - FABRICA SOFTWARE     º  Data  ³     10/12/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao         ³ Ler arquivo .CSV e faz a importaçao das estruturas de produtos (SG1)                                   º±±
±±º                  ³                                                                                                        º±±   
±±º                  ³                                                                                                        º±± 
±±º                  ³                                                                                                        º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso               ³ Exclusivo : SAVIS                                                                                     º±±  
±±º                  ³                                                                                                        º±±  
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IMP_SG1()
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Declaracao de Variaveis                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Local c_Caminho := Space(100)
Local n_Radio   := 1
Local l_Retorno := .F.
Local a_Arquivo := {}
Local n_Opcao   := 0
Local c_DesFun	:= "" 

Private d_DatLan := CriaVar("CT2_DATA")
Private c_NumLot := CriaVar("CT2_LOTE",.T.)
Private n_TotReg := 0
Private n_TotDeb := 0
Private n_TotCrd := 0

c_DesFun += "Este processamento tem o objetivo de ler um arquivo .CSV"+Chr(13)+Chr(10)
c_DesFun += "pré-formatado e proceder com a inclusão automática das"+Chr(13)+Chr(10)
c_DesFun += "estruturas de produtos (SG1)."+Chr(13)+Chr(10)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Monta tela de parametros                                                                                                    //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

While !l_Retorno
	n_Opcao := 0
	l_Retorno := .F.
	DEFINE MSDIALOG o_Dlg TITLE "Importação Estrutura Produtos - Planilha" From 0,0 To 22,50

	oSayLay := tSay():New(05,07,{|| c_DesFun},o_Dlg,,,,,,.T.,,,200,80)	
	oSayArq := tSay():New(60,07,{|| "Informe o arquivo para processamento :"},o_Dlg,,,,,,.T.,CLR_BLUE,,200,80)
	oGetArq := TGet():New(70,05,{|u| If(PCount()>0,c_Caminho:=u,c_Caminho)},o_Dlg,150,10,'@!',,,,,,,.T.,,,,,,,,,,'c_Caminho') 
	oBtnArq := tButton():New(70,160,"&Abrir...",o_Dlg,{|| c_Caminho := ABR_SG1(c_Caminho)},30,12,,,,.T.)
	
	
	oBtnImp := tButton():New(150,050,"&Processar",o_Dlg,{|| n_Opcao:=1,o_Dlg:End()},40,12,,,,.T.)
	oBtnCan := tButton():New(150,110,"&Cancelar",o_Dlg,{|| n_Opcao:=0,o_Dlg:End()},40,12,,,,.T.)
	
	ACTIVATE MSDIALOG o_Dlg CENTERED

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Valida o arquivo                                                                                                            //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	If n_Opcao == 1
		If Empty(c_Caminho)
			MsgInfo("Informe o arquivo","Aviso")
			l_Retorno := .F.
		ElseIf !File(c_Caminho)
			MsgInfo("Arquivo não encontrado","Aviso")
			l_Retorno := .F.
		Else
			l_Retorno := .T.
		EndIf
	Else
		l_Retorno := .T.
	EndIf

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Chama a rotina de leitura do arquivo, havendo conteudo, chama rotina de processamento                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

	If l_Retorno .And. n_Opcao == 1
		Processa({|lEnd| a_Arquivo := LER_SG1(c_Caminho,@lEnd)},"Aguarde ...","Processando a leitura do arquivo...")
		If Len(a_Arquivo) == 0
			MsgInfo("Não há registros para lançamento","Aviso")
		ElseIf MsgYesNo("Serão processados "+AllTrim(Str(Len(a_Arquivo)))+" registro(s) de "+AllTrim(Str(n_TotReg))+" registro(s) lido(s). Confirma ?")
			Processa({|lEnd| a_Arquivo := GRV_SG1(a_Arquivo,@lEnd)},"Aguarde ...","Importando Estruturas de Produtos...")
		EndIf
	EndIf	
End

Return(l_Retorno)


Static Function ABR_SG1(c_Arquivo)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Faz a abertura do arquivo .CSV escolhido                                                                                    //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

c_Arquivo := cGetFile(" (*.csv) |*.csv|","Arquivos (CSV)")

If !Empty(c_Arquivo)
	c_Arquivo += Space(100-Len(c_Arquivo))
Else
	c_Arquivo := Space(100)
EndIf

Return(c_Arquivo)




Static Function LER_SG1(c_Arquivo,l_End)

Local c_Linha     := ""
Local c_Trecho    := ""
Local n_Handle    := 0
Local a_Arquivo   := {}
Local c_TipoDc    := ""
Local l_Fim       := l_End
Local n_ColPos    := 0
Local n_G1_FILIAL := 1
Local n_G1_COD    := 2
Local n_G1_COMP   := 3
Local n_G1_TRT    := 4
Local n_G1_QUANT  := 5
Local n_G1_PERDA  := 6
Local n_G1_INI    := 7
Local n_G1_FIM    := 8
Local n_G1_OBSERV := 9
Local n_G1_FIXVAR := 10
Local n_G1_GROPC  := 11
Local n_G1_OPC    := 12
Local n_G1_REVINI := 13
Local n_G1_REVFIM := 14
Local n_G1_NIV    := 15
Local n_G1_NIVINV := 16
Local n_G1_POTENCI:= 17
Local n_G1_VLCOMPE:= 18

Local c_G1_FILIAL := ""
Local c_G1_COD    := ""
Local c_G1_COMP   := ""
Local c_G1_TRT    := ""
Local c_G1_QUANT  := ""
Local c_G1_PERDA  := ""
Local c_G1_INI    := ""
Local c_G1_FIM    := ""
Local c_G1_OBSERV := ""
Local c_G1_FIXVAR := ""
Local c_G1_GROPC  := ""
Local c_G1_OPC    := ""
Local c_G1_REVINI := ""
Local c_G1_REVFIM := ""
Local c_G1_NIV    := ""
Local c_G1_NIVINV := ""
Local c_G1_POTENCI:= ""
Local c_G1_VLCOMPE:= ""




n_Handle := FT_FUSE(c_Arquivo)
n_TotReg := FT_FLASTREC()-1

FT_FGOTOP()
FT_FSKIP()
ProcRegua(n_TotReg)

While !FT_FEOF()
	If l_End
		Exit
	EndIf
	n_ColPos := 0
	c_Linha := FT_FREADLN()
	While !Empty(c_Linha)
		n_ColPos ++
		c_Trecho := If(At(";",c_Linha)>0,Substr(c_Linha,1,At(";",c_Linha)-1),c_Linha)
		c_Linha := If(At(";",c_Linha)>0,Substr(c_Linha,At(";",c_Linha)+1),"")
		Do Case
			Case n_G1_FILIAL  == n_ColPos
				c_G1_FILIAL := Padr(c_Trecho,TamSX3("G1_FILIAL") [1])
			Case n_G1_COD     == n_ColPos
				c_G1_COD	:= Padr(c_Trecho,TamSX3("G1_COD")    [1])
			Case n_G1_COMP    == n_ColPos
				c_G1_COMP   := Padr(c_Trecho,TamSX3("G1_COMP")   [1])
			Case n_G1_TRT     == n_ColPos                         
				c_G1_TRT    := Padr(c_Trecho,TamSX3("G1_TRT")    [1])
			Case n_G1_QUANT   == n_ColPos
				c_G1_QUANT  := Val(StrTran(StrTran(c_Trecho,".",""),",","."))
			Case n_G1_PERDA   == n_ColPos
				c_G1_PERDA  := Val(StrTran(StrTran(c_Trecho,".",""),",","."))
			Case n_G1_INI     == n_ColPos
				c_G1_INI    := STOD(c_Trecho)
			Case n_G1_FIM     == n_ColPos
				c_G1_FIM    := STOD(c_Trecho)
			Case n_G1_OBSERV  == n_ColPos
				c_G1_OBSERV := Padr(c_Trecho,TamSX3("G1_OBSERV") [1])
			Case n_G1_FIXVAR  == n_ColPos
				c_G1_FIXVAR := Padr(c_Trecho,TamSX3("G1_FIXVAR") [1])
			Case n_G1_GROPC   == n_ColPos
				c_G1_GROPC  := Padr(c_Trecho,TamSX3("G1_GROPC")  [1])
			Case n_G1_OPC     == n_ColPos
				c_G1_OPC    := Padr(c_Trecho,TamSX3("G1_OPC")    [1])
			Case n_G1_REVINI  == n_ColPos
				c_G1_REVINI := Padr(c_Trecho,TamSX3("G1_REVINI") [1])
			Case n_G1_REVFIM  == n_ColPos
				c_G1_REVFIM := Padr(c_Trecho,TamSX3("G1_REVFIM") [1])
			Case n_G1_NIV     == n_ColPos
				c_G1_NIV    := Padr(c_Trecho,TamSX3("G1_NIV")    [1])
			Case n_G1_NIVINV  == n_ColPos
				c_G1_NIVINV := Padr(c_Trecho,TamSX3("G1_NIVINV") [1])
			Case n_G1_POTENCI  == n_ColPos
				c_G1_POTENCI:= Val(StrTran(StrTran(c_Trecho,".",""),",","."))
			Case n_G1_VLCOMPE   == n_ColPos
				c_G1_VLCOMPE:= Padr(c_Trecho,TamSX3("G1_VLCOMPE")[1])
		EndCase
	End
    
	aAdd(a_Arquivo, {c_G1_FILIAL,c_G1_COD,c_G1_COMP,c_G1_TRT,c_G1_QUANT,c_G1_PERDA,c_G1_INI,c_G1_FIM,c_G1_OBSERV,c_G1_FIXVAR,c_G1_GROPC,c_G1_OPC,c_G1_REVINI,c_G1_REVFIM,c_G1_NIV,c_G1_NIVINV,c_G1_POTENCI,c_G1_VLCOMPE})

	IncProc()

	FT_FSKIP()
End
FT_FUSE()

Return(a_Arquivo)  





Static Function GRV_SG1(a_Arquivo,l_End)


Local a_Area   := GetArea()
Local a_Cab    := {}
Local a_Itens  := {}
Local n_Linha  := 1
Local i        := 0
Local c_NumDoc := "000001"

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private CTF_LOCK := 0

ProcRegua(n_TotReg)


For i := 1 To n_TotReg
	If l_End
		Exit
	EndIf

	IncProc()


a_Cab :=          { {"G1_COD"        ,a_Arquivo[i,2]	,NIL},;
                    {"G1_QUANT"      ,a_Arquivo[i,6]	,NIL},;
                    {"NIVALT"        ,"S"				,NIL}} //A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura


			a_Gets := {}
			aadd(a_Gets,	{"G1_FILIAL"	,a_Arquivo[i,1]		,NIL})
			aadd(a_Gets,	{"G1_COD"		,a_Arquivo[i,2]		,NIL})
			aadd(a_Gets,	{"G1_COMP"		,a_Arquivo[i,3]		,NIL})
			aadd(a_Gets,	{"G1_TRT"		,a_Arquivo[i,4]		,NIL})
			aadd(a_Gets,	{"G1_QUANT"		,a_Arquivo[i,5]		,NIL})
			@aadd(a_Gets,	{"G1_PERDA"		,a_Arquivo[i,6]		,NIL})
			aadd(a_Gets,	{"G1_INI"		,a_Arquivo[i,7]		,NIL})
			aadd(a_Gets,	{"G1_FIM"		,a_Arquivo[i,8]		,NIL})
			aadd(a_Gets,	{"G1_OBSERV"	,a_Arquivo[i,9]		,NIL})
			aadd(a_Gets,	{"G1_FIXVAR"	,a_Arquivo[i,10]	,NIL})
			aadd(a_Gets,	{"G1_GROPC"		,a_Arquivo[i,11]	,NIL})
			aadd(a_Gets,	{"G1_OPC"		,a_Arquivo[i,12]	,NIL})
			aadd(a_Gets,	{"G1_REVINI"	,a_Arquivo[i,13]	,NIL})
			aadd(a_Gets,	{"G1_REVFIM"	,a_Arquivo[i,14]	,NIL})
			aadd(a_Gets,	{"G1_NIV"		,a_Arquivo[i,15]	,NIL})
			aadd(a_Gets,	{"G1_NIVINV"	,a_Arquivo[i,16]	,NIL})
			//aadd(a_Gets,	{"G1_POTENCI"	,a_Arquivo[i,17]	,NIL})
			aadd(a_Gets,	{"G1_VLCOMPE"	,a_Arquivo[i,18]	,NIL})
			
			aadd(a_Itens,a_Gets)
   

	n_Linha ++
 
Next i

Begin Transaction

	MSExecAuto({|x, y,z| MATA200(x,y,z)},a_Cab,a_Itens,3)

	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	Else
		MsgInfo("Estrutura(s) incluida(s) com sucesso !","Aviso")
	Endif

End Transaction

RestArea(a_Area)

Return()

