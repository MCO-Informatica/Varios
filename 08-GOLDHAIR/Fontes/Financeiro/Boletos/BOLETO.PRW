#INCLUDE "rwmake.ch"
#Include "topconn.ch"                                                                                                                               
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                  
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPBOLETO º Autor ³Marcel Medeiros     º Data ³  17/02/06   º±±                                         
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³PROGRMA DE IMPRESSAO DOS BOLETOS GRAFICO                    º±±             
±±º          ³                                                            º±±     
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5 IDE                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                      
±±º							                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                                                                       º±±  
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                    
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------------------------------------------------------------
User Function impboleto(_cPrefixp,_cNumerp,_cNumFimp,_cParcInip,_cParcFimp,_lPerguntp)
* Emissao do boleto em modo grafico
*-----------------------------------------------------------------------------
local _vAmbSe1:=se1->(getarea()),;
_vAmbSa1:=sa1->(getarea()),;                        
_vAmbSee:=see->(getarea()),;
_vAmbSf2:=sf2->(getarea())  
Private xChave
Private cString
Private aOrd       := {}
Private CbTxt      := ""
Private cDesc1     := "Impressao do boleto bancario em modo grafico."
Private cDesc2     := ""
Private cDesc3     := ""
Private cPict      := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "BOLETO"
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "BOLETO"
Private titulo     := "Boleto bancario"
Private nLin       := 80                                   
Private lPrint     := .F.
Private Cabec1     := ""
Private Cabec2     := ""
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private _xPrefixo  := _cPrefixp
Private _xNumIni   := _cNumerp
Private _xNumFim   := _cNumFimp
Private _xParcIni  := _cParcIniP
Private _xParcFim  := _cParcFimP
Private _lPergunta := _lPerguntp
Private imprime    := .T.
Private wnrel      := nomeprog
Private cString    := "SE1"
private _oPRN
private _cInst1    := ""
private _cInst2    := ""
private _cInst3	   := ""      
SetPrvt("_vBoletos")

ValidPerg(cPerg)
if _lpergunta==nil.or._lPergunta==.t.
	if !pergunte(cPerg,.t.)                                                         
		return
	endif
endif    


_cTpTIT := Alltrim(Str(MV_PAR13)) // Iif(cTpBol="1",MV_PAR03,"")  
_cBanco := Alltrim(Str(MV_PAR14))
_cBanco :=Iif(_cBanco="1","001","033")     

	

DBSELECTAREA("SE5")
    
RptStatus({|lAbortPrint| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
sa1->(restarea(_vAmbSa1))
se1->(restarea(_vAmbSe1))
see->(restarea(_vAmbSee)) 
sf2->(restarea(_vAmbSf2))
Return

*-----------------------------------------------------------------------------
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
*-----------------------------------------------------------------------------
Local _cPrefIni:= ""
Local _cPrefFim:= ""
Local _cNumeIni:= ""
Local _cNumeFim:= ""
Local _cParcIni:= ""
Local _cParcFim:= ""
Local _cTipoIni:= ""
Local _cTipoFim:= ""
Local _dEmisIni:=ctod("")
Local _dEmisFim:=ctod("")
Local _lVisualizar:=.t.
Local _lConfigurar:=.t.
Local _lAutomatico:=.f.
Local _cFiltro:=""
Local _vBoletos:={}

pergunte(cperg,.f.) 

// Caso a impressao tenha sido disparada por outra rotina que nao o menu,
// considerar os parametros recebidos, nao utilizar o indice condicional
if _xPrefixo<>nil
	_lAutomatico:=.t.
	_cPrefIni  := _xPrefixo
	_cPrefFim  := _xPrefixo
	_cNumeIni  := _xNumIni
	_cNumeFim  := _xNumFim
	_cParcIni  := _xParcIni
	_cParcFim  := _xParcFim
	_cTipoIni  := "   "
	_cTipoFim  := "ZZZ"
	_dEmisIni  := ctod("01/01/04")
	_dEmisFim  := ctod("31/12/35")
else
	_cPrefIni:=mv_par01 // Prefixo de
	_cPrefFim:=mv_par02 // Prefixo ate
	_cNumeIni:=mv_par03 // Numero de
	_cNumeFim:=mv_par04 // Numero ate
	_cParcIni:=mv_par05 // Parcela de
	_cParcFim:=mv_par06 // Parcela ate
	_cTipoIni:=mv_par07 // Tipo de
	_cTipoFim:=mv_par08 // Tipo ate
	_dEmisIni:=mv_par09 // Emissao de
	_dEmisFim:=mv_par10 // Emissao ate
endif
_lVisualizar:=(mv_par11==1)
_lConfigurar:=(mv_par12==1)


////////////////////////////////////////////////////////////                                                       

_cFiltro:="e1_filial='"+xfilial("SE1")+"' .and. "                                           
_cFiltro+="e1_prefixo>='"+_cPrefIni+"' .and. e1_prefixo<='"+_cPrefFim+"' .and. "
_cFiltro+="e1_num    >='"+_cNumeIni+"' .and. e1_num    <='"+_cNumeFim+"' .and. "     
_cFiltro+="dtos(e1_emissao)>='"+dtos(_dEmisIni)+"' .and. dtos(e1_emissao)<='"+;
dtos(_dEmisFim)+"' .and. "
_cFiltro+="e1_parcela>='"+_cParcIni+"' .and. e1_parcela<='"+_cParcFim+"' .and. "
_cFiltro+="e1_tipo   >='"+_cTipoIni+"' .and. e1_tipo   <='"+_cTipoFim+"' .and. "
_cFiltro+="e1_portado ='"+_cBanco+"' "

_cOrdem:=se1->(indexkey())
se1->(indregua(alias(),criatrab(,.f.),_cOrdem,,_cFiltro,"Selecionando registros"))
_nCount:=0
                                                                              
se1->(dbeval({||_nCount++}))
setregua(_nCount)           

dbselectarea("SE1")
dbgotop()

If Eof()  
   retindex("SE1")
   msgstop("Nao existem dados gerados para Impressão do Boleto. Verifique os parametros.","Sem Dados","STOP")  
   Return
EndIf

dbselectarea("SE1")
dbgotop()

//////////////////////////////////////////
aTitulos:={}
While !Eof()                                                                                                   
	aAdd(aTitulos, {	.F.,;						// 1=Mark
						SE1->E1_PREFIXO,;		// 2=Prefixo do Título
						SE1->E1_NUM,;			// 3=Número do Título
						SE1->E1_PARCELA,;		// 4=Parcela do Título
						SE1->E1_TIPO,;			// 5=Tipo do Título
						SE1->E1_NATUREZ,;		// 6=Natureza do Título
						SE1->E1_CLIENTE,;		// 7=Cliente do título
						SE1->E1_LOJA,;			// 8=Loja do Cliente
						SE1->E1_NOMCLI,;		// 9=Nome do Cliente
						SE1->E1_EMISSAO,;		//10=Data de Emissão do Título
						SE1->E1_VENCTO,;		//11=Data de Vencimento do Título
						SE1->E1_VENCREA,;		//12=Data de Vencimento Real do Título
						SE1->E1_VALOR,;			//13=Valor do Título
						SE1->E1_HIST,;			//14=Histótico do Título
						0,;
						SE1->E1_NUMBCO,;		//16=Nosso Número
						SE1->(Recno());
						})
	dbSkip()
EndDo   

retindex("SE1")

_oprn := TMSPrinter():New()
_oprn:SetPortrait()

If _lConfigurar
   _oprn:Setup()
Endif

If nLastKey == 27
	Return
Endif                                                
                                                                                   
	
//Imprimir Boletos
U_MTBCO(aTitulos,_lAutomatico,_cPrefIni,_cPrefFim,_cNumeIni,	_cNumeFim,_cParcIni,_cParcFim,_cTipoIni,_cTipoFim,_dEmisIni,_dEmisFim,_lVisualizar,_lConfigurar) //Boletos
  
Return                                                                                                                                                

*--------------------------------------------------------------------------------
Static Function VALIDPERG(cPerg)
*--------------------------------------------------------------------------------
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
AADD(aRegs,{cPerg,"01","Prefixo de         :","","","mv_ch1","C",03,0,0,"G","","mv_par01",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Prefixo ate        :","","","mv_ch2","C",03,0,0,"G","","mv_par02",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Numero de          :","","","mv_ch3","C",06,0,0,"G","","mv_par03",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Numero ate         :","","","mv_ch4","C",06,0,0,"G","","mv_par04",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Parcela de         :","","","mv_ch5","C",03,0,0,"G","","mv_par05",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Parcela ate        :","","","mv_ch6","C",03,0,0,"G","","mv_par06",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Tipo de            :","","","mv_ch7","C",03,0,0,"G","","mv_par07",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Tipo ate           :","","","mv_ch8","C",03,0,0,"G","","mv_par08",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Emissao de         :","","","mv_ch9","D",08,0,0,"G","","mv_par09",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Emissao ate        :","","","mv_chA","D",08,0,0,"G","","mv_par10",""    ,"","",""      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Visualizar impressao","","","mv_chB","N",01,0,0,"C","","mv_par11","Sim"    ,"","","","","Nao"      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Configurar impress.:","","","mv_chC","N",01,0,0,"C","","mv_par12","Sim"    ,"","","","","Nao"      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Imprime Sobre ?     ","","","mv_chD","N",01,0,0,"C","","mv_par13","Titulo"    ,"","","","","Pedido"      ,"","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Banco do Boleto     ","","","mv_chE","N",01,0,0,"C","","mv_par14","Brasil"    ,"","","","","Santander"      ,"","","","","","","","","","",""})

For i:=1 to Len(aRegs)
 If !dbSeek(cPerg+Space(4)+aRegs[i,2])
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