#INCLUDE "rwmake.ch"

User Function F050ISS()                                          
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050ISS    Autor ³ Nádia Mamude        º Data ³  26/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para gravar o Históricoº±±
±±º          ³ de acordo com o título principal.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA ENERGIA                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Local _cTipIss := Alltrim(GETMV("MV_VENCISS")) //E-Emissão /\ V-Vencimento /\ C-Contabilidade
Local _cAPROVA,_dDATALIB,_cSTATLIB,_cUSUALIB,_cCODAPRO,_cXRJ  // - variáveis para tratamento de RJ       
 
// - Parâmetro para indicar o Gestor para liberação do título
Local _cLiber := GetNewPar( "MV_FINALAP", "000001") 
 
If SE2->E2_ORIGEM ="FINA050".Or. SE2->E2_ORIGEM ="FINA080".Or. SE2->E2_ORIGEM ="MATA100"

_cAlias    := Alias()     
_nRegAtual := Recno()
		 
cHist := "ISS S/NF "+SE2->E2_NUM+" "+POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")//"ISS S/NF "+M->E2_NUM+" "+POSICIONE("SA2",1,XFILIAL("SA2")+M->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")
cNom  := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")//POSICIONE("SA2",1,XFILIAL("SA2")+M->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")

Reclock("SE2",.F.) 
 //SE2->E2_HIST := cHist
 SE2->E2_NOMFOR := cNom
Msunlock()

// Atribuição para os campos referentes a Recuperação Judicial
// Se posterior a RJ (16/10/2019) grava o título Liberado
//if SE2->E2_EMISSAO > CtoD("16/10/2019")
	_cAPROVA  := ""
	_dDATALIB := dDataBase
	_cSTATLIB := "03"
	_cUSUALIB := "INC POSTERIOR REC JUDIC  "
	_cCODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse código de liberador
    _cXRJ     := ""
	//comentado a pedido do Diego para que o imposto sempre fique liberado 26/02/2021 - André Couto
/*else
	_cAPROVA  := ""
	_dDATALIB := CtoD("  /  /    ")
	_cSTATLIB := ""
	_cUSUALIB := ""
	_cCODAPRO := _cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para liberação
 //	_cXRJ     := "S"
endif
*/
If _cTipIss = 'V'  
	U_ATUSE2IMP(nRegSE2)
EndIf

DbSelectArea(_cAlias)   

Endif


If SE2->E2_ORIGEM="MATA100"
_cAlias    := Alias()     
_nRegAtual := Recno()

_nRegistro := paramixb  // Registro Original 
// busca o Código de Retenção do Título Original
DbGoTo(_nRegistro)
 _cHist := "ISS S/NF "+SE2->E2_NUM+" "+POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")
 _cNom  := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")
 
DbGoTo(_nRegAtual)
Reclock("SE2",.F.)
 SE2->E2_HIST := _cHist
 SE2->E2_NOMFOR := _cNom
Msunlock()

DbSelectArea(_cAlias)   

Endif

Return
