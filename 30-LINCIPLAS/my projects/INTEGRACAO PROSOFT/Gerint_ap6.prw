#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 10/02/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function GERINT()        // incluido pelo assistente de conversao do AP6 IDE em 10/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("ACAMPOS,CSTRING,ALINHA,CPERG,CSAVSCR1,CSAVCUR1")
SetPrvt("CSAVROW1,CSAVCOL1,CSAVCOR1,CNOME,CDATA,CNOMEARQ")
SetPrvt("NTREGS,CSAV7,XDEBITO,XCREDITO,XHIST01,XHIST02")
SetPrvt("XHIST03,NTAMANHO,CINTEIRO,CTAMVLR,CDECIMAL,NCONT")
SetPrvt("CANO,CMES,CDIA,XREGISTRO,_SALIAS,AREGS")
SetPrvt("I,J,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 10/02/02 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿑un뇚o    � GERINT    � Autor �                       � Data � 27.02.03 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri뇚o �  GERA ARQUIVO DE IMPORTACAO PARA PROSOFT                    낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴캑굇
굇� Uso      � CONCRECON                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aCampos:={}
cString:="SF2"
aLinha := { }
cPerg  :="GERINT"
ValidPerg()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Salva a Integridade dos dados de Entrada                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

pergunte("GERINT",.T.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01            // Da Data de Emissao                   �
//� mv_par02            // Ate Data de Emissao                  �
//� mv_par03            // Nome do Arquivo                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP6 IDE em 10/02/02 ==> Processa( {|| Execute(RunProc) } )
dbcommitAll()

dbSelectArea("cNomeArq")
dbGotop()
cNome := "F:\CTBMOV04\CTBIMPOR.001"
cData := DTOS(MV_PAR01)
COPY TO &cNome SDF
dbCloseArea("cNomeArq") //Fecha 
Return

// Substituido pelo assistente de conversao do AP6 IDE em 10/02/02 ==> Function RunProc
Static Function RunProc()

aCampos:={ {"REGISTRO" ,"C", 133,0}}
cNomeArq:=CriaTrab(aCampos)
Use &cNomeArq Alias cNomeArq New

dbSelectArea("SF2")
dbSetOrder(6)
Set Softseek On
dbSeek(xFilial()+DTOS(mv_par01))
Set Softseek Off
nTregs:= Reccount()
ProcRegua(nTregs)
xDebito := space(05)
xCredito:= space(05)
xHist01 := space(30)
xHist02 := space(30)
xHist03 := space(30)
nTamanho:=0
cInteiro:=""
cTamvlr :=0
cDecimal:=""
nCont   :=1

While !EOF() .and. SF2->F2_EMISSAO <= mv_par02
	
	IncProc()
	
	If SF2->F2_SERIE<>"UNI"
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	xDebito:=SUBSTR(SA1->A1_COD,1,5)
	
	nTamanho := len(ALLTRIM(SA1->A1_CGC))
	
	If nTamanho==11
		xCredito:="64112"
	Else
		xCredito:="64111"
	Endif
	
	xHist01 := "CONF. N/NFS No. " + SF2->F2_DOC + SPACE(08)
	cInteiro:=STRZERO(INT(SF2->F2_VALBRUT),11)
	cDecimal:=SUBSTR(STRZERO(SF2->F2_VALBRUT*100,14),13,2)
	cAno:=SUBSTR(STR(YEAR(SF2->F2_EMISSAO)),17,2)
	cMes:=STRZERO(month(SF2->F2_EMISSAO),2)
	cDia:=STRZERO(day(SF2->F2_EMISSAO),2)
	xRegistro :=cAno+cMes+cDia+substr(SF2->F2_DOC,1,6)+xDebito+xCredito
	xRegistro :=xRegistro+xHist01+xHist02+xHist03+cInteiro+"."+cDecimal+Strzero(ncont,6)
	
	dbSelectArea("cNomeArq")
	reclock("cNomeArq",.T.)
	cNomeArq->REGISTRO := xRegistro
	
	dbSelectArea("SF2")
	dbSkip()
	nCont:=nCont+1
	
EndDO

Return

// Substituido pelo assistente de conversao do AP6 IDE em 10/02/02 ==> Function ValidPerg
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Data Inicial das NFS","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Final das NFS  ","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Nome Arq. p/PROSOFT ","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
