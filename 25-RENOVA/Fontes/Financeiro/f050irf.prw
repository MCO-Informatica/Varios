//|=====================================================================|
//|Programa: F050IRF.PRW   |Autor: Marciane Gennari   | Data: 22/11/10  |
//|=====================================================================|
//|Descricao: Ponto de entrada para gravar histórico no titulo de IRRF  |
//|           Código da Retenção e Gera Dirf SIM.                       |
//|=====================================================================|
//|Sintaxe:                                                             |
//|=====================================================================|
//|Uso: Ponto de entrada da rotina FINA050                              |
//|=====================================================================|
//|       ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.             |
//|---------------------------------------------------------------------|
//|=====================================================================|
#Include "rwmake.ch"

User Function F050IRF()

Local _cRotina  := Alltrim(FunName())
Local _cCnpj    := ""
Local _cMes     := ""
Local _cAno     := ""
Local _cHist    := ""
Local _cNom     := ""
Local _cNome	:= ""
Local _cFor     := ""
Local _cLoj     := ""
Local _cTipIrf  := Alltrim(GETMV("MV_VENCIRF")) //E-Emissão /\ V-Vencimento /\ C-Contabilidade
Local _cPrefixo := M->E2_PREFIXO  //Gileno - Tratamento para gravar codigo de retenção 3208 para Arrendamento e Aluguel

Local _cAPROVA,_dDATALIB,_cSTATLIB,_cUSUALIB,_cCODAPRO,_cXRJ  //Luiz M Suguiura (29/10/2019) - variáveis para tratamento de RJ       

// Luiz M Suguiura (29/10/2019) - Parâmetro para indicar o Gestor para liberação do título
//Local _cLiber := GetNewPar( "MV_FINALAP", "000001") 

// Luiz M. Suguiura - 29/10/2019
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
	_cXRJ     := "S"
*/
//endif

If _cRotina == "FINA050" .or. _cRotina == "MATA103" .or. _cRotina == "FINA750" .or. _cRotina == "CNTA120"
	
	_cMes     := Subs(Dtos(SE2->E2_VENCREA),5,2)
	_cAno     := Subs(Dtos(SE2->E2_VENCREA),1,4)
	
	If _cRotina == "FINA050" .or. _cRotina == "FINA750"
		_cFor := M->E2_FORNECE
		_cLoj := M->E2_LOJA
	ElseIf _cRotina == "CNTA120"
		_cFor := SUBSTR(SE2->E2_TITPAI,19,6)
		_cLoj := SUBSTR(SE2->E2_TITPAI,25,2)
	Else
		_cFor   := SF1->F1_FORNECE
		_cLoj   := SF1->F1_LOJA
	EndIf

//Se vier vazio é porque o IR esta sendo gerado na baixa para titulos onde o fornecedor é pessoa fisica.	
	If Empty(_cFor)
		_cFor := SUBSTR(SE2->E2_TITPAI,19,6)
	//	nRegSE2:= M->PARAMIXB
	Endif
	
	If Empty(_cLoj)
		_cLoj := SUBSTR(SE2->E2_TITPAI,25,2)
	Endif

	_cNome  := GetAdvFval("SA2","A2_NREDUZ",xFilial("SA2")+_cFor+ _cLoj,1)
	//	_cCnpj  := GetAdvFval("SA2","A2_CGC"   ,xFilial("SA2")+_cFor+ _cLoj,1)
	_cNom   := GetAdvFval("SA2","A2_NOME"  ,xFilial("SA2")+_cFor+ _cLoj,1)
	_cTipp  := GetAdvFval("SA2","A2_TIPO"  ,xFilial("SA2")+_cFor+ _cLoj,1) //Fisico ou Juridico
	_cHist := "IRF S/NF "+SE2->E2_NUM
	//--- Retornar o CNPJ da Matriz - sempre 01 é Matriz.
	//---  1o. parametro: 02 - CNPJ
	//---  2o. parametro: 01 - Filial 01
	//	_cCnpj   :=  u_dadosSM0("02","01")
	_cCnpj   :=  SM0->M0_CGC
	
	
	RECLOCK("SE2",.F.)
	If Empty(Alltrim(SE2->E2_CODRET))
	//	SE2->E2_CODRET  := "1708"
		IF _cTipp == 'F'
		//  	If _cPrefixo =="ARR" .OR. _cPrefixo =="ALU"
			SE2->E2_CODRET  := "3208"//Aluguel e Arrendamento
		Else
			SE2->E2_CODRET  := "1708"
	//		Endif
		Endif
	Endif
	
	SE2->E2_DIRF        := "1"
	SE2->E2_XCNPJC   := _cCnpj
	SE2->E2_XCONTR  := SM0->M0_NOMECOM
	SE2->E2_E_APUR  := (CTOD("01"+"/"+_cMes+"/"+_cAno)-1)  //-- Competencia mes/ano - Ultimo dia do mes anterior a data do vencimento do imposto
	SE2->E2_HIST       := _cHist+" "+_cNome
	SE2->E2_NOMFOR  :=_cNome

    // Luiz M. Suguiura - 29/10/2019 - Atualização dos campos referentes RJ
    SE2->E2_APROVA  := _cAPROVA  
    SE2->E2_DATALIB := _dDATALIB 
    SE2->E2_STATLIB := _cSTATLIB 
    SE2->E2_USUALIB := _cUSUALIB 
    SE2->E2_CODAPRO := _cCODAPRO 
    SE2->E2_XRJ     := _cXRJ     

	MSUNLOCK()
	
Else
	
	RECLOCK("SE2",.F.)
	SE2->E2_HIST       := _cHist+" "+_cNome

    // Luiz M. Suguiura - 29/10/2019 - Atualização dos campos referentes RJ
    SE2->E2_APROVA  := _cAPROVA  
    SE2->E2_DATALIB := _dDATALIB 
    SE2->E2_STATLIB := _cSTATLIB 
    SE2->E2_USUALIB := _cUSUALIB 
    SE2->E2_CODAPRO := _cCODAPRO 
    SE2->E2_XRJ     := _cXRJ     

	MSUNLOCK()
	
EndIf

//If _cRotina == "FINA050" .or. _cRotina == "FINA750" .or. _cRotina == "FINA080" .or. _cRotina == "FINA241"
If _cRotina == "FINA050" 
	If _cTipIrf = 'V'
		U_ATUSE2IMP(nRegSE2)
	EndIf
EndIf

RETURN
