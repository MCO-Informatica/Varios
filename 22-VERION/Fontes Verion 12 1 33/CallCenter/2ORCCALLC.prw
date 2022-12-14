
#Include 'Protheus.ch'                                             
#include "rwmake.ch"     
#INCLUDE "MSOLE.CH"
                           
#define IT_ALIQICM	1
#define IT_VALICM	2
#define IT_BASEICM	3
#define IT_VALIPI	4
#define IT_BASEICM	5
#define IT_VALMERC	6
#define IT_DESCONTO	7
#define IT_PRCUNI	8
#define IT_VALSOL  	9
#define NF_DESCZF	10

User Function 2ORCCALC(cNum)
// --------------------------------------------------------------------------
// Programa para emiss?o de Pedido de Venda da Verion utilizando Word
//---------------------------------------------------------------------------

cabec1     :=""
cabec2     :=""
cabec3     :=""
wnrel      :="ORCCALLC"
titulo     :="Emissao Or?amento com base no Call Center"
cDesc1     :="Emite Or?amento com base no Call Center "
cDesc2     :=""
cDesc3     :=""
cString    :="SUA"
nElementos := 0
nLastKey   := 0
aReturn    := { "Especial", 1,"Faturamento", 1, 2, 1, "",1 }
nomeprog   := "ORCCALLCA"
cPerg      := "ORCCALLCEN"
_nLin      := 80
tamanho    := "G"
m_pag      := 1
nTipo      := 15
_nPri      := 1
cemp 	   := SM0->M0_CODIGO

//-------------------------------------------------------------------
// Verifica as perguntas selecionadas
//-------------------------------------------------------------------
ValidPerg()


//-------------------------------------------------------------------
//? Envia controle para a funcao SETPRINT
//-------------------------------------------------------------------
/*wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"","","","",.F.)
If nLastKey == 27
   Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif
*/


//-------------------------------------------------------------------
// rotina RptDetail
//-------------------------------------------------------------------
RptStatus({|| RptDetail(cNUM)})

Return         


Static Function RptDetail(cNUM)
_aStru := {}
_aItem := {}
_aQtvn := {}
_aDesc := {}
_aPrve := {}
_aCodi := {}
_aUnid := {}
_aVlIp := {}
_aVlTt := {}
_aDtEn := {}
_aPraz := {}
_aDsct := {}                   
_aPipi := {}
_aPSt  := {}             
_aClfis := {}
_aTotal := {}
_Totitens := 0 //CALCULA O TOTAL DE ITENS
_cmensa   := 0 //CONTROLA A MENSAGEM EXIBIDA
nPacresFin:= 0
nTFat     := 0
nPrcVen   := 0
nQuant    := 0
nPrUnit   := 0
nAcresFin := 0
nValDesc  := 0
nVldesc   := 0
cProduto  := ""
_CPAISAG  := 0        
_nTSUB    := 0  
_nUSUB	  := 0
_nvuipi	  := 0	
_Ncont    := ''
_Depto    := ''
_Ndepto   := ''     
_cClfis   := ''        
_cemail   := ''
_cac	  := ''	                   
_ctrata	  := 'Sr.'
_cCargove := 'Vendedor' 
_aICM	  := {}

If empty(cNUM)
	Pergunte(cPerg,.T.) 
	par01 := mv_par01
	par02 := mv_par02 
//	
else
	par01 := cNUM
	par02 := cNUM 
//	Pergunte(cPerg,.T.)
endif


dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SE4")
dbSetOrder(1)
DbSelectArea("SUA") //CABE?ALHO DO PEDIDO 
dbSetOrder(1)
dbGoTop()
dbseek(xfilial("SUA")+par01)

While !Eof() .and. SUA->UA_NUM <= par02
	_cmensa:=1
	If _Totitens == 0
		_Ctotal    := 0
		_cNum      := SUA->UA_NUM
		_corca     := SUA->UA_NUM 
		_cData     := SUA->UA_EMISSAO
		_cfrete1   := SUA->UA_FRETE 
		_ctransp   := SUA->UA_TRANSP         
		_cTPFrete  := iif(SUA->UA_TPFRETE = 'C','CIF','FOB')
		_cOBS	   := alltrim(SUA->UA_VROBSPV) // if(Empty(SC5->C5_MENPEDV),Space(01),ALLTRIM(SC5->C5_MENPEDV))
		_cTpPv     := Substr(SUA->UA_NUM,6,1)          
		_nPcDesc   := "" 
		_cSubVlr   := "IPI:"
		_cValid    := "10 Dias"
		_ntotre    := SUA->UA_VLRLIQ
		_ntotdo    := 0
		_ntoteu    := 0
		_ntotor    := SUA->UA_VLRLIQ
		_ntpmoe    := SUA->UA_MOEDA
		_cmoeda    := IIF(SUA->UA_MOEDA=1,"Reais",IIF(SUA->UA_MOEDA=2,"Dolar",iif(SUA->UA_MOEDA=3,"Euro","")))    
		_vend      := Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_NOME")    
		nPacresFin := 0
        // CADASTRO DE CLIENTE
		If SUA->UA_PROSPEC
 			dbSelectArea("SUS")
			Dbsetorder(1)
			DbSeek(xFilial("SUS") + SUA->UA_CLIENTE + SUA->UA_LOJA,.f.)
			_ccliente      := SUS->US_NOME
			_cEnd          := SUS->US_END
			_cCid          := alltrim(US_MUN)+" - "+alltrim(US_EST)+" - "+alltrim(US_CEP)
			_cFone         := alltrim(US_DDD)+" - "+alltrim(US_TEL)
			_cFax          := alltrim(US_DDD)+" - "+US_Fax
		  	_cCNPJ         := US_CGC
			_ccidade       := US_Mun
			_cestado       := US_est
			_cCep          := US_cep
			_cbairro       := US_bairro
			_cIE           := US_INSCR
			_cCOD          := US_COD
			_cendcob       := '' //A1_endcob         // Endereco de cobranca
			_ccepco        := '' //A1_CEPC           //Cep de cobranca
			_cBairroc      := '' //A1_Bairroc        //Bairro de cobranca
			_cCidaco       := '' //A1_Munc           // Cidade de Cobrnaca
			_cEstC         := '' //A1_EstC           //Estado de Cobranca
			_cendent       := '' //A1_endent         // Endereco de entrega
			_cCepentre     := '' //A1_Cepe           // Cep  de Entrega
			_cBairroentre  := '' //A1_BAIRROE        // Bairro de Entrega
			_cCidadeentre  := '' //A1_MUNE           //Cidade de Entrega
			_cEstadoentre  := '' //A1_EstE           // Estado de entrega
			_CTIPOCLI      := US_TIPO
		Else
			dbSelectArea("SA1")
			Dbsetorder(1)
			If dbSeek(xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA)
				_ccliente      := A1_NOME
				_cEnd          := A1_END
				_cCid          := alltrim(A1_MUN)+" - "+alltrim(A1_EST)+" - "+alltrim(A1_CEP)
				_cFone         := alltrim(A1_DDD)+" - "+alltrim(A1_TEL)
				_cFax          := alltrim(A1_DDD)+" - "+A1_Fax
			  	_cCNPJ         := A1_CGC
				_ccidade       := A1_Mun
				_cestado       := A1_est
				_cCep          := A1_cep
				_cbairro       := A1_bairro
				_cIE           := A1_INSCR
				_cCOD          := A1_COD
				_cendcob       := A1_endcob         // Endereco de cobranca
				_ccepco        := A1_CEPC           //Cep de cobranca
				_cBairroc      := A1_Bairroc        //Bairro de cobranca
				_cCidaco       := A1_Munc           // Cidade de Cobrnaca
				_cEstC         := A1_EstC           //Estado de Cobranca
				_cendent       := A1_endent         // Endereco de entrega
				_cCepentre     := A1_Cepe           // Cep  de Entrega
				_cBairroentre  := A1_BAIRROE        // Bairro de Entrega
				_cCidadeentre  := A1_MUNE           //Cidade de Entrega
				_cEstadoentre  := A1_EstE           // Estado de entrega
				_CTIPOCLI      := A1_TIPO
			Else
				_ccliente      := _cac     := _cEnd      := _cCid          := _cFone         := _cFax          := " "
				_cemail        := _cCNPJ   := _ccidade   := _cestado       := _cCep          := _cbairro       := " "
				_cIE           := _cCOD    := _cendcob   := _ccepco        := _cBairroc      := _cCidaco       := " "
				_cEstC         := _cendent := _cCepentre := _cBairroentre  := _cCidadeentre  := _cEstadoentre  := " "
			Endif
		Endif
        // CADASTRO DE VENDEDOR
		dbSelectArea("SA3")
		Dbsetorder(1)
		DbSeek(xFilial("SA3") + SUA->UA_VEND)
		_crepres := SA3->A3_NREDUZ      
		_creprer := SA3->A3_NOME      
		_cemaVE  := SA3->A3_EMAIL
		_CTELVE  := SA3->A3_TEL
        _cDDDVE  := SA3->A3_DDDTEL
        if DbSeek(xFilial("SUM") + SA3->A3_CARGO)          
			_cCargove := SUM->UM_DESC
        Else
			_cCargove := 'Vendedor'
		Endif
		dbSelectArea("SE4")                      
		
		If dbSeek(xFilial("SE4") +SUA->UA_CONDPG)
			_cCpag    := E4_DESCRI
		Else
			_cCpag    := ""
		Endif

		dbSelectArea("SA4")// Dados Tranportadora
		Dbsetorder(1)
		Dbseek(Xfilial("SA4")+  _ctransp)
		_CFoneTrans := SA4->A4_DDD+" - "+SA4->A4_TEL
		_ctransp    := SA4->A4_NREDUZ
		
		dbSelectArea("SU5")// Contato
		Dbsetorder(1)
		if Dbseek(Xfilial("SU5")+  SUA->UA_CODCONT)
			_Ncont  := SU5->U5_CONTAT
			_Depto  := SU5->U5_DEPTO
			_cemail := SU5->U5_EMAIL
			dbSelectArea("SX5")
			dbSetOrder(1)
			If dbSeek(xFilial("SX5")+"AX"+SU5->U5_TRATA)
				_cTrata := AllTrim(SX5->X5_DESCRI)
			Else
				_cTrata := "Sr."
			Endif
    	Endif
		    
		dbSelectArea("SQB")// Departamento
		Dbsetorder(1)
		if	Dbseek(Xfilial("SQB") + _Depto )
			_Ndepto := SQB->QB_DESCRIC
		Endif
		    
		dbSelectArea("SUB")//ITENS DO PEDIDO
		Dbsetorder(1)
		Dbseek(Xfilial("SUB")+ SUA->UA_NUM)
		_cNum        := SUB->UB_NUM
		_nVez        := 1     
		_nvlipi      := 0
		nItem        := 0					                                               
		aImpostos    := {}
			
		//?????????????????????????????????????????????Ŀ
		//?Inicializa a funcao fiscal                   ?
		//???????????????????????????????????????????????
		//		MaFisSave()
		//		MaFisEnd()
		// 		MaFisIni(SUA->UA_CLIENTE,SUA->UA_LOJA,"C","N",_CTIPOCLI,aImpostos,,,"SB1","MTR700")
	
		If SUA->UA_PROSPEC == .F.
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SUA->UA_CLIENTE+SUA->UA_LOJA)
		
			MaFisIni(SA1->A1_COD,SA1->A1_LOJA,"C","N",SA1->A1_TIPO,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")
	  	Else
			dbSelectArea("SUS")
			dbSetOrder(1)
			dbSeek(xFilial()+SUA->UA_CLIENTE+SUA->UA_LOJA)

			MaFisIni(SUS->US_COD,SUS->US_LOJA,"C","N",SUS->US_TIPO,MaFisRelImp("MTR700",{"SUA","SUB"}),,,"SB1","MTR700")
		EndIf

		While !EOF() .And. SUB->UB_NUM  == _cNum
			If SUB->UB_NUM  == _cNum
	
				// CADASTRO DE PRODUTO
				dbSelectArea("SB1")
				Dbsetorder(1)
				Dbseek(Xfilial("SB1")+ SUB->UB_PRODUTO)
				_cUM  := SB1->B1_UM
				_cipi := SB1->B1_IPI
				_CNOM := SB1->B1_DESC  
				_cClfis := SB1->B1_POSIPI  
			
				dbSelectArea("SUB")

				nVldesc   := SUB->UB_VALDESC
				nTFat     := (SUB->UB_QUANT * SUB->UB_VRUNIT)
				nPrcVen   := SUB->UB_VRUNIT
				nQuant    := SUB->UB_QUANT 
				nPrUnit   := NoRound(nTFat/nQuant,TamSX3("C6_PRCVEN")[2])
				nAcresFin := A410Arred(nPrcVen*nPacresFin/100,"D2_PRCVEN")
				nTFat     += A410Arred(nQuant*nAcresFin,"D2_TOTAL")
				nValDesc  := a410Arred(nPrUnit*nQuant,"D2_DESCON")-nTFat
				nValDesc  := IIf(nVlDesc==0,nVlDesc,nValDesc)
				nValDesc  := Max(0,nValDesc)
				nPrUnit   += nAcresFin
				cTes      := SUB->UB_TES				
				cProduto  := SUB->UB_PRODUTO

 	//			MaFisAdd(cProduto,cTes,nQuant,nPrunit,nValdesc,,,,0,0,0,0,(nTFat+nValDesc),0,0,0)

				nItem += 1
				_nVuipi   := MaFisRet(nItem,"IT_VALIPI")
				_nUSUB    := MaFisRet(nItem,"IT_VALSOL") //fValSub() 
				_nICM	  := MaFisRet(nItem,"IT_ALIQICM")
						
				_Ctotal   := SUB->UB_VLRITEM + _Ctotal
				_nvlipi   := _nvlipi + _nVuipi 					
				_nVez     := _nVez + 1
				_nTSUB 	  += _nUSUB
					
				AADD(_aItem,SUB->UB_ITEM)
				AADD(_aDesc,ALLTRIM(_CNOM))
				AADD(_aCodi,SUB->UB_PRODUTO)
				AADD(_aUnid,_cUM)
				AADD(_aVlIp,_cipi)
				AADD(_aDtEn,DtoC(SUB->UB_DTENTRE))
				AADD(_aPraz,SUB->UB_VRDDL)
				AADD(_aQtvn,SUB->UB_QUANT) 						//Transform(SUB->UB_QUANT   ,"@E 999,999,999.99"))
				AADD(_aPrve,alltrim(str(SUB->UB_VRUNIT,10,2)))	// Transform(SUB->UB_VRUNIT  ,"@E 999,999,999.99"))
				AADD(_aPipi,alltrim(str(_nVuipi,10,2)))			//  Transform(_nVuipi         ,"@E 999,999,999.99"))
				AADD(_aPst ,alltrim(str(_nUSUB,10,2)))			// Transform(_nUSUB          ,"@E 999,999,999.99"))
				AADD(_aVlTt,alltrim(str(SUB->UB_VLRITEM,10,2)))	// Transform(SUB->UB_VLRITEM ,"@E 999,999,999.99"))
				AADD(_aTOTAL,alltrim(str((SUB->UB_VRUNIT*SUB->UB_QUANT)+_nVuipi+_nUSUB,10,2)))//
				AADD(_aDsct,alltrim(str(SUB->UB_DESC,10,2)))	// Transform(SUB->UB_DESC    ,"@E 999,999,999.99"))   
				AADD(_aClfis,_cClfis    )
				AADD(_aICM,_nICM)
			Else
				AADD(_aItem,"")
				AADD(_aQtvn,"")
				AADD(_aDesc,"")
				AADD(_aPrve,"")
				AADD(_aCodi,"")
				AADD(_aUnid,"")
				AADD(_aVlIp,"")
				AADD(_aVlTt,"")
				AADD(_aDtEn,"")
				AADD(_aPraz,'0')
				AADD(_aDsct,0)
				AADD(_aTOTAL,0)
			Endif
 				
			Dbselectarea("SUB")
			Dbsetorder(1)
			DbSkip()
		END
	_nvez:= _nvez-1 //numero de itens no or?amento
	Endif    

	_Ctota1   := 0
	_ntotd1   := 0
	_ntote1   := 0

	// tratamento de valores em outras moedas !!!
	
	IF _ntpmoe = 2  // dolar
    	_Ctota1   := xMoeda(_Ctotal,_ntpmoe,1,_cData)
		_ntotd1   := xMoeda(_Ctotal,_ntpmoe,2,_cData)
		_ntote1   := xMoeda(_Ctotal,_ntpmoe,3,_cData)
		_ntoto1   := _ntotd1 + _nvlipi + _nTSUB + _cfrete1

    	_Ctotal   := alltrim(Transform(_ctota1,"@E 999,999,999.99")) //Transform(_ctota1,"@E 999,999,999.99")
		_ntotdo   := alltrim(Transform(_ntotd1,"@E 999,999,999.99")) //Transform(_ntotd1,"@E 999,999,999.99")
		_ntoteu   := alltrim(Transform(_ntote1,"@E 999,999,999.99")) //Transform(_ntote1,"@E 999,999,999.99")
	    _ntotor   := alltrim(Transform(_ntoto1,"@E 999,999,999.99")) //Transform(_ntoto1,"@E 999,999,999.99")

	ELSEIF _ntpmoe = 3  // euro
    	_Ctota1   := xMoeda(_Ctotal,_ntpmoe,1,_cData)
		_ntotd1   := xMoeda(_Ctotal,_ntpmoe,2,_cData)
		_ntote1   := xMoeda(_Ctotal,_ntpmoe,3,_cData)
		_ntoto1   := _ntote1 + _nvlipi + _nTSUB + _cfrete1

    	_Ctotal   := alltrim(Transform(_ctota1,"@E 999,999,999.99")) //Transform(_ctota1,"@E 999,999,999.99")
		_ntotdo   := alltrim(Transform(_ntotd1,"@E 999,999,999.99")) //Transform(_ntotd1,"@E 999,999,999.99")
		_ntoteu   := alltrim(Transform(_ntote1,"@E 999,999,999.99")) //Transform(_ntote1,"@E 999,999,999.99")
	    _ntotor   := alltrim(Transform(_ntoto1,"@E 999,999,999.99")) //Transform(_ntoto1,"@E 999,999,999.99")
	else //IF _ntpmoe = 1  // REAIS
		_Ctota1   := xMoeda(_Ctotal,_ntpmoe,1,_cData)
		_ntotd1   := xMoeda(_Ctotal,_ntpmoe,2,_cData)
		_ntote1   := xMoeda(_Ctotal,_ntpmoe,3,_cData)
		_ntoto1   := _Ctota1 + _nvlipi + _nTSUB + _cfrete1

    	_Ctotal   := alltrim(Transform(_ctota1,"@E 999,999,999.99")) //Transform(_ctota1,"@E 999,999,999.99")
		_ntotdo   := alltrim(Transform(_ntotd1,"@E 999,999,999.99")) //Transform(_ntotd1,"@E 999,999,999.99")
		_ntoteu   := alltrim(Transform(_ntote1,"@E 999,999,999.99")) //Transform(_ntote1,"@E 999,999,999.99")
	    _ntotor   := alltrim(Transform(_ntoto1,"@E 999,999,999.99")) //Transform(_ntoto1,"@E 999,999,999.99")
	ENDIF

    cAer := PraRBox()
  	cArquivo := GETMV("MV_XWORD") + cAer	
	_Nvalor   := 20

	// Inicializa o Ole com o MS-Word 97 ( 8.0 )	
	//   oWord := OLE_CreateLink('TMsOleWord97')	
   	oWord := OLE_CreateLink()	
   	if !oWord <> '0'
   		OLE_NewFile(oWord,cArquivo)
   		OLE_SetProperty( oWord, oleWdVisible,   .T. )
	   	OLE_SetProperty( oWord, oleWdPrintBack, .T. )
 		If SUA->UA_NUMSC5 > '      '
			_cNum += "      Pedido Numero: " + SUA->UA_NUMSC5
	   	Endif
   		OLE_SetDocumentVar(oWord,"PRT_NUMERO"     ,_cNum)
	   	OLE_SetDocumentVar(oWord,"prt_data"       ,_cData)
   		OLE_SetDocumentVar(oWord,"PRT_CLIENTE"    ,_cCliente)
	   	OLE_SetDocumentVar(oWord,"PRT_NCONT"       ,_Ncont) // _cAC			
   		OLE_SetDocumentVar(oWord,"PRT_FONECLI"    ,_cFone)
	   	OLE_SetDocumentVar(oWord,"PRT_EMAIL"      ,_cemail)
   		OLE_SetDocumentVar(oWord,"PRT_CONDPGT"    ,_cCpag)
	   	OLE_SetDocumentVar(oWord,"PRT_VALIDPR"    ,_cValid)
   		OLE_SetDocumentVar(oWord,"PRT_TOTREA"     ,_Ctotal)
	   	OLE_SetDocumentVar(oWord,"PRT_TOTDOL"     ,_ntotdo)
   		OLE_SetDocumentVar(oWord,"PRT_TOTEUR"     ,_ntoteu)
	   	OLE_SetDocumentVar(oWord,"PRT_TOTORC"     ,_ntotor)
   		OLE_SetDocumentVar(oWord,"PRT_FRETE"      ,alltrim(Transform(_cfrete1,"@E 999,999,999.99")))
	   	OLE_SetDocumentVar(oWord,"PRT_TPFRE"      ,_cTPFrete)
   		OLE_SetDocumentVar(oWord,"PRT_CMOEDA"     ,_cmoeda)
	   	OLE_SetDocumentVar(oWord,"PRT_VEND"       ,_crepres)   
   		OLE_SetDocumentVar(oWord,"PRT_VENDC"       ,_creprer)   
	   	OLE_SetDocumentVar(oWord,"prt_ftra"       ,_CFoneTrans)
   		OLE_SetDocumentVar(oWord,"prt_trans"      ,_ctransp)
	   	OLE_SetDocumentVar(oWord,"PRT_END"        ,_cEnd)
   		OLE_SetDocumentVar(oWord,"PRT_CEP"        ,_cCep)
	   	OLE_SetDocumentVar(oWord,"PRT_BAIRRO"      ,_cbairro)
   		OLE_SetDocumentVar(oWord,"PRT_CIDADE"      ,_ccidade)
	   	OLE_SetDocumentVar(oWord,"PRT_UF"          ,_cestado)
   		OLE_SetDocumentVar(oWord,"PRT_MAILVE"      ,_cemaVE)
	   	OLE_SetDocumentVar(oWord,"PRT_DDDVE"		  ,_CDDDVE)
   		OLE_SetDocumentVar(oWord,"PRT_TELVE"		  ,_CTELVE)
	   	OLE_SetDocumentVar(oWord,"PRT_carve"    	  ,_cCargove)    
   		OLE_SetDocumentVar(oWord,"PRT_CSEREL"      ,_CPAISAG)
	   	OLE_SetDocumentVar(oWord,"prt_nroitens"	,STR(len(_aitem))) 
   		OLE_SetDocumentVar(oWord,"PRT_Ncont"     ,_Ncont)
	   	OLE_SetDocumentVar(oWord,"PRT_Ndepto"    ,_Ndepto)    
   		OLE_SetDocumentVar(oWord,"PRT_trata"    	,_ctrata)    
	   	OLE_SetDocumentVar(oWord,"PRT_obs"    	,_cOBS)

   		_nVezant:=_nVez
	   	_nVez   := 1 
   		_nCont  := 0
	   	_ctotipi:= 0 

		//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
		// prt_cod1, prt_cod2 ... prt_cod10
		for nK := 1 to Len(_aItem)                                           
			OLE_SetDocumentVar(oWord,"PRT_SEQ"+AllTrim(Str(nK))  , alltrim(Str(nK)) ) //right('00'+AllTrim(Str(nK)),3) 
			OLE_SetDocumentVar(oWord,"PRT_ITEM"+AllTrim(Str(nK)) ,_aItem[nK])
			OLE_SetDocumentVar(oWord,"PRT_QTDE"+AllTrim(Str(nK)) ,_aQtvn[nK])
			OLE_SetDocumentVar(oWord,"PRT_UN"+AllTrim(Str(nK))   ,_aUnid[nK])
			OLE_SetDocumentVar(oWord,"PRT_COD"+AllTrim(Str(nK))  ,_aCodi[nK])
			OLE_SetDocumentVar(oWord,"PRT_DESCR"+AllTrim(Str(nK)),_aDesc[nK])
			OLE_SetDocumentVar(oWord,"PRT_PRAZO"+AllTrim(Str(nK)),alltrim(_aPraz[nK]))
			OLE_SetDocumentVar(oWord,"PRT_DSC"+AllTrim(Str(nK))  ,_aDsct[nK])
			OLE_SetDocumentVar(oWord,"PRT_UNIT"+AllTrim(Str(nK)) ,_aPrve[nK])
			OLE_SetDocumentVar(oWord,"PRT_IPI"+AllTrim(Str(nK))  ,_aPipi[nK])
			OLE_SetDocumentVar(oWord,"PRT_ST"+AllTrim(Str(nK))   ,_aPst[nK])
			OLE_SetDocumentVar(oWord,"PRT_CLFIS"+AllTrim(Str(nK)),_aClfis[nK])
			OLE_SetDocumentVar(oWord,"PRT_TOTAL"+AllTrim(Str(nK)) ,_atotal[nK])  
			OLE_SetDocumentVar(oWord,"PRT_ICM"+AllTrim(Str(nK)) ,_aICM[nK])  
		next
		IF cemp = '01'
			OLE_ExecuteMacro(oWord,"tabitens")
	    Else
			OLE_ExecuteMacro(oWord,"tabitensA")
	    Endif	
	
    	//--Atualiza Variaveis
	    OLE_UpDateFields(oWord)

    	DbSelectArea("SUA")
    	dbSetOrder(1)
	    Dbskip()
    	Loop
	ELSE
    	 Alert("Verifique nao foi possivel abri o Documento " + cArquivo)
	     return .t.
	ENDIF
END    

//Set Device To Screen

//If aReturn[5] = 1
//	Set Printer To
//	Commit
//	Ourspool(wnrel)
//Endif
/*
If MsgYesNo("Salve o documento ?")
//	Ole_PrintFile(oWord,"ALL",,,1)
	OLE_CloseLink(oWord)  
	OLE_CloseLink( oWord )	
Else
	OLE_CloseFile( oWord )
	OLE_CloseLink( oWord )
Endif	
*/

Alert("Verifique o Documento aberto e Salve o mesmo")
	OLE_CloseFile( oWord )
	OLE_CloseLink( oWord )
	if .not. empty(cNUM)
		DbSelectArea("SUA")
		Dbskip(-1)
    endif	
 

MS_FLUSH()

Return

Static Function  PraRBox()
Local aParB := {}
Local aRetP := {}
Local aOptR := {'Modelo Padrao'  , 'Modelo Completo', 'Modelo AEM ' ,  'livre', 'livre', 'livre' }
Local aOptF := {'COTPADR','COTCOMP','COTAEM','   ', '   ', '   '}
Local nTipR := 1
 
aAdd(aParB,{3, 'Selecionar', nTipR, aOptR, 100, '', .T.})           

	If ! ParamBox(aParB, 'Lista de Modelo Word', @aRetP,,,,,,,, .F., .F.)
		Return 'Livre.dot'
	EndIf

	nTipRes := aRetP[1] 

	IF cemp = '01'
		Return aOptF[nTipRes]+ 'V.dot' 
	Else
		Return aOptF[nTipRes]+ 'A.dot'
	Endif	

return 'Livre.dot'

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?VALIDPERG ? Autor ? RICARDO CAVALINI   ? Data ?  02/04/2002 ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Verifica a existencia das perguntas criando-as caso seja   ???
???          ? necessario (caso nao existam).                             ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs   := {}
Local i,j
cPerg		  :="ORCCALLCEN"

DbSelectArea("SX1")
DbSetOrder(1)
// ESTRUTURA SX1 !!!
//          X1_GRUPO,X1_ORDEM,X1_PERGUNT        ,X1_PERSPA,X1_PERENG,X1_VARIAVL,X1_TIPO,X1_TAMANHO,X1_DECIMAL,X1_PRESEL,X1_GSC,X1_VALID,X1_VAR01  ,X1_DEF01   ,X1_DEFSPA1,X1_DEFENG1,X1_CNT01,X1_VAR02,X1_DEF02,X1_DEFSPA2,X1_DEFENG2,X1_CNT02,X1_VAR03,X1_DEF03,X1_DEFSPA3,X1_DEFENG3,X1_CNT03,X1_VAR04,X1_DEF04,X1_DEFSPA4,X1_DEFENG4,X1_CNT04,X1_VAR05,X1_DEF05,X1_DEFSPA5,X1_DEFENG5,X1_CNT05,X1_F3,X1_PYME,X1_GRPSXG,X1_HELP,X1_PICTURE,X1_IDFIL
aAdd(aRegs,{cPerg   ,"01"    ,"Do Atendimento ?",""       ,""       ,"mv_ch1"  ,"C"    ,06        ,0         ,0        ,"G"   ,""      ,"mv_par01",""          ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""		,""		   ,""		,""		 ,""	  ,""		 ,""		,""		 ,""   ,""     ,""       ,""     ,""        ,""      }) 
aAdd(aRegs,{cPerg   ,"02"    ,"Ate Atendimento?",""       ,""       ,"mv_ch2"  ,"C"    ,06        ,0         ,0        ,"G"   ,""      ,"mv_par02",""          ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""        ,""        ,""      ,""      ,""      ,""		,""		   ,""		,""		 ,""	  ,""		 ,""		,""		 ,""   ,""     ,""       ,""     ,""        ,""      }) 

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next

DbSelectArea(_sAlias)
Return      



