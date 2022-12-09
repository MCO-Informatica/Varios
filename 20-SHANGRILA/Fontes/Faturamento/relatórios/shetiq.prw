#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/09/01

User Function SHETIQ()        // incluido pelo assistente de conversao do AP5 IDE em 13/09/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE")
SetPrvt("CSTRING,LCONTINUA,NVLRDESC,NTOTGER,NTOTQUANT,NTOTPROD")
SetPrvt("NTOTVEND,NTOTDESC,NTOTGDESC,NTOTQTDGER,NTOTFATGER,CUM")
SetPrvt("CMASCARA,NTAMREF,NTAMLIN,NTAMCOL,ARETURN,NOMEPROG")
SetPrvt("ALINHA,NLASTKEY,CPERG,CBTXT,CBCONT,LI")
SetPrvt("M_PAG,WNREL,CABEC1,CABEC2,NTIPO,CNOMARQ")
SetPrvt("LRET,CPROD,NTOTFAT,NTOTVAL,LEND,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SHETIQ   ³ Autor ³ Jaime Ranulfo Leite F ³ Data ³ 22.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Etiqueta para Mala Direta                                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Shangrila                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "Etiqueta para Mala Direta"
cDesc1 := "Este relatorio ira emitir o Relatorio de acordo"
cDesc2 := "com os Parametros definidos pelo usuario."
cDesc3 := ""
tamanho:= "P"
limite := 80
cString:= "SA1"
lContinua := .T.
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
aOrd    := { "Por Codigo     ","Por Nome        ","Por CEP         "  }
nomeprog:="SHETIQ"
nLastKey := 0
cPerg   := PADR("SHETIQ",LEN(SX1->X1_GRUPO))
cbtxt    := Space(10)
cbcont   := 00
li       := 80
m_pag    := 01
nOrdem   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

pergunte(cPerg,.F.)

wnrel := nomeprog
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C620Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C620IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SARMPED			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C620Imp(lEnd,WnRel,cString)

lContinua := .T.
cbtxt    := Space(10)
cbcont   := 00
nlin     := 80
m_pag    := 01
nTipo:=IIF(aReturn[4]==1,15,18)
nOrdem := aReturn[8]
aCampos  := {}

AADD(aCampos,{ "TB_CODIGO ","C",06,0 } )
AADD(aCampos,{ "TB_LOJA   ","C",02,0 } )
AADD(aCampos,{ "TB_NOME   ","C",40,0 } )
AADD(aCampos,{ "TB_CONTATO","C",30,0 } )
AADD(aCampos,{ "TB_ENDE   ","C",40,0 } )
AADD(aCampos,{ "TB_BAIRRO ","C",30,0 } )
AADD(aCampos,{ "TB_CIDADE ","C",40,0 } )
AADD(aCampos,{ "TB_ESTADO ","C",02,0 } )
AADD(aCampos,{ "TB_CEP    ","C",08,0 } )
AADD(aCampos,{ "TB_FONE   ","C",15,0 } )

cNomArq := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq,cNomArq, .T., .F. )
cNomArq1 := SubStr(cNomArq,1,7)+"1"

If nOrdem = 1 
	IndRegua(cNomArq,cNomArq1,"TB_CODIGO+TB_LOJA",,,"Selecionando Registros...")	//"Selecionando Registros..."
Elseif nOrdem = 2 
	IndRegua(cNomArq,cNomArq1,"TB_NOME",,,"Selecionando Registros...")	//"Selecionando Registros..."
Else
	IndRegua(cNomArq,cNomArq1,"TB_CEP",,,"Selecionando Registros...")	//"Selecionando Registros..."
Endif

If MV_PAR09 = 1   // Clientes
	
	dbSelectArea("SA1")
	Dbgotop()

	SetRegua(LastRec())		// Total de Elementos da regua
	
	Do While !EOF() 
	
		IncRegua()   
		
		If Trim(SA1->A1_NOME) < Trim(MV_PAR03) .Or. Trim(SA1->A1_NOME) > Trim(MV_PAR04) .Or. ;
         SA1->A1_EST < MV_PAR05 .Or. SA1->A1_EST > MV_PAR06	.Or. ;	
         SA1->A1_COD < MV_PAR01 .Or. SA1->A1_COD > MV_PAR02 .Or. ;
         SA1->A1_CEP < MV_PAR07 .Or. SA1->A1_CEP > MV_PAR08 .Or. SA1->A1_MD = "N"
	   	dbSelectArea("SA1")
	   	Dbskip()           
	   	Loop
		Endif
		
   	dbSelectArea(cNomArq)
   	RecLock(cNomArq,.T.)
		TB_CODIGO := SA1->A1_COD
		TB_LOJA   := SA1->A1_LOJA
		TB_NOME   := SA1->A1_NOME
		TB_CONTATO:= SA1->A1_CONTATO
		TB_ENDE   := SA1->A1_END 
		TB_BAIRRO := SA1->A1_BAIRRO
		TB_CIDADE := SA1->A1_MUN
		TB_ESTADO := SA1->A1_EST
		TB_CEP    := SA1->A1_CEP
		TB_FONE   := SA1->A1_TEL
		MsUnlock()
		
   	dbSelectArea("SA1")
   	Dbskip()
		
	Enddo
	
Elseif MV_PAR09 = 2   // Fornecedor

	dbSelectArea("SA2")
	Dbgotop()

	SetRegua(LastRec())		// Total de Elementos da regua
	
	Do While !EOF() 
	
		IncRegua()   
		
		If Trim(SA2->A2_NOME) < Trim(MV_PAR03) .Or. Trim(SA2->A2_NOME) > Trim(MV_PAR04) .Or. ;
         SA2->A2_EST < MV_PAR05 .Or. SA2->A2_EST > MV_PAR06	.Or. ;
         SA2->A2_COD < MV_PAR01 .Or. SA2->A2_COD > MV_PAR02 .Or. ;
         SA2->A2_CEP < MV_PAR07 .Or. SA2->A2_CEP > MV_PAR08 .Or. SA2->A2_MD = "N"       
	   	dbSelectArea("SA2")
	   	Dbskip()           
	   	Loop
		Endif
		
   	dbSelectArea(cNomArq)
   	RecLock(cNomArq,.T.)
		TB_CODIGO := SA2->A2_COD
		TB_LOJA   := SA2->A2_LOJA
		TB_NOME   := SA2->A2_NOME
		TB_CONTATO:= SA2->A2_CONTATO
		TB_ENDE   := SA2->A2_END 
		TB_BAIRRO := SA2->A2_BAIRRO
		TB_CIDADE := SA2->A2_MUN
		TB_ESTADO := SA2->A2_EST
		TB_CEP    := SA2->A2_CEP
		TB_FONE   := SA2->A2_TEL
		MsUnlock()
		
   	dbSelectArea("SA2")
   	Dbskip()
		
	Enddo
	
ElseIf MV_PAR09 = 3   // Vendedor
	
	dbSelectArea("SA3")
	Dbgotop()

	SetRegua(LastRec())		// Total de Elementos da regua
	
	Do While !EOF() 
	
		IncRegua()   
		
		If Trim(SA3->A3_NOME) < Trim(MV_PAR03) .Or. Trim(SA3->A3_NOME) > Trim(MV_PAR04) .Or. ;
         SA3->A3_EST < MV_PAR05 .Or. SA3->A3_EST > MV_PAR06	.Or. ;
         SA3->A3_COD < MV_PAR01 .Or. SA3->A3_COD > MV_PAR02 .Or. ;
         SA3->A3_CEP < MV_PAR07 .Or. SA3->A3_CEP > MV_PAR08 .Or. SA3->A3_MD = "N"
	   	dbSelectArea("SA3")
	   	Dbskip()           
	   	Loop
		Endif
		
   	dbSelectArea(cNomArq)
   	RecLock(cNomArq,.T.)
		TB_CODIGO := SA3->A3_COD
		TB_NOME   := SA3->A3_NOME
		TB_CONTATO:= ""
		TB_ENDE   := SA3->A3_END 
		TB_BAIRRO := SA3->A3_BAIRRO
		TB_CIDADE := SA3->A3_MUN
		TB_ESTADO := SA3->A3_EST
		TB_CEP    := SA3->A3_CEP
		TB_FONE   := SA3->A3_TEL
		MsUnlock()
		
   	dbSelectArea("SA3")
   	Dbskip()
		
	Enddo

ElseIf MV_PAR09 = 4   // Funcionarios
	
	dbSelectArea("SRA")
	Dbgotop()

	SetRegua(LastRec())		// Total de Elementos da regua
	
	Do While !EOF() 
	
		IncRegua()   
		
		If Trim(SRA->RA_NOME) < Trim(MV_PAR03) .Or. Trim(SRA->RA_NOME) > Trim(MV_PAR04) .Or. ;
         SRA->RA_ESTADO < MV_PAR05 .Or. SRA->RA_ESTADO > MV_PAR06	.Or. ;
         SRA->RA_MAT < MV_PAR01 .Or. SRA->RA_MAT > MV_PAR02 .Or. ;
         SRA->RA_CEP < MV_PAR07 .Or. SRA->RA_CEP > MV_PAR08 .Or. SRA->RA_MD = "N"
	   	dbSelectArea("SRA")
	   	Dbskip()           
	   	Loop
		Endif
		
   	dbSelectArea(cNomArq)
   	RecLock(cNomArq,.T.)
		TB_CODIGO := SRA->RA_MAT
		TB_NOME   := SRA->RA_NOME
		TB_CONTATO:= ""
		TB_ENDE   := SRA->RA_ENDEREC 
		TB_BAIRRO := SRA->RA_BAIRRO
		TB_CIDADE := SRA->RA_MUNICIP
		TB_ESTADO := SRA->RA_ESTADO
		TB_CEP    := SRA->RA_CEP
		TB_FONE   := SRA->RA_TELEFON
		MsUnlock()
		
   	dbSelectArea("SRA")
   	Dbskip()
		
	Enddo

Endif

SetPrc(0,0)
nLin := 0

dbSelectArea(cNomArq)
Dbgotop()
SetRegua(LastRec())		// Total de Elementos da regua

Do While !EOF() 
	
	IncRegua()
	
	// Rotina de Impressao
	
	@ Prow()  ,000 PSAY Chr(15)+TB_NOME + " [" + TB_CODIGO + "]" 
	/*If !Empty(TB_CONTATO)
	   @ Prow()+1,000 PSAY Chr(15)+"A/C - "+TB_CONTATO
	Endif*/
	@ Prow()+1,000 PSAY Chr(15)+"Ender.: "+TB_ENDE
	@ Prow()+1,000 PSAY Chr(15)+"Bairro: "+TB_BAIRRO
	@ Prow()+1,000 PSAY Chr(15)+"Cidade: "+TB_CIDADE+" "+TB_ESTADO
	@ Prow()+1,000 PSAY Chr(15)+"C.E.P.: "+Transform(TB_CEP,"@R 99999-999") //+"   Fone: "+TB_FONE
	@ Prow()+2,000 PSAY ""
	
	Dbskip()
	
Enddo

SetPrc(0,0)

dbSelectArea(cNomArq)
dbCloseArea()

cDelArq := cNomArq+".DBF"
fErase(cDelArq)
fErase(cNomArq1+OrdBagExt())

Set Device To Screen

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.




Static Function ValidPerg
*------------------------

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
// Grupo/Ordem/Pergunta        /Pergunta        /Pergunta        /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Def01/Def01/Cnt01/Var02/Def02/Def02/Def02/Cnt02/Var03/Def03/Def03/Def03/Cnt03/Var04/Def04/Def04/Def04/Cnt04/Var05/Def05/Def05/Def05/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Do  Codigo             ","Do  Codigo             ","Do  Codigo             ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Codigo             ","Ate Codigo             ","Ate Codigo             ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","De  Nome               ","De  Nome               ","De  Nome               ","mv_ch3","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate Nome               ","Ate Nome               ","Ate Nome               ","mv_ch4","C",30,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","De  UF                 ","De  UF                 ","De  UF                 ","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate UF                 ","Ate UF                 ","Ate UF                 ","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","De  CEP                ","De  CEP                ","De  CEP                ","mv_ch7","C",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ate CEP                ","Ate CEP                ","Ate CEP                ","mv_ch8","C",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Tipo                   ","Tipo                   ","Tipo                   ","mv_ch9","N",01,0,0,"C","","mv_par09","Cliente","Cliente","Cliente","","","Fornecedor","Fornecedor","Fornecedor","","","Vendedores","Vendedores","Vendedores","","","Funcionarios","Funcionarios","Funcionarios","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return




