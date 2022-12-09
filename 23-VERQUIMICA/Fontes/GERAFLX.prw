#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
             
/*           
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERAFLX   ºAutora ³Vanessa Tomaz Bello º Data ³  09/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para gerar arquivo DBF de fluxo de caixa            º±±
±±º          ³                                                            º±±        
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³  Uso     ³ Santos Flora - Solicitado Nilza                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GERAFLX()
Local lRet 	     := .F.

Private oDlg01
Private oFont1
Private _dMesRef := CTOD("  /  /  ")
Private _cGera   := Space(50)

Define msDialog oDlg01 From 00,00 To 220,370 Title "Exportação de Dados do Financeiro" Pixel &&145
Define Font oFont1 Name "Arial" Size 0,-12 Bold
@005,005 To 045,180 of oDlg01 Pixel  
    
&& SE5 --> Movimentação Bancária
&& SE2 --> Contas a Pagar
&& SE1 --> Contas a Receber
&& SC7 --> Pedidos de Compras
&& SE8 --> Saldos Bancários
&& SEH --> Controle de Aplicação / Empréstimo
&& SC6 --> Itens do Pedidos de Vendas

@010,010 Say "Este programa ira exportar para arquivo DBF uma" Font oFont1 of oDlg01 Pixel
@020,010 Say "massa de dados relativas as tabelas SE5,SE2,SE1," Font oFont1 of oDlg01 Pixel
@030,010 Say "SC7,SE8,SEH e SC6."	Font oFont1 of oDlg01 Pixel
                                                     
@050,007 SAY "Data Referencia : " Font oFont1 of oDlg01 Pixel
@050,120 MSGET _dMesRef  SIZE 60,10 OF oDlg01 Pixel //Valid Len(Alltrim(_cMesRef)) == 7

@080,115 BmpButton Type 1 Action(lRet := .T.,Close(oDlg01))
@080,150 BmpButton Type 2 Action(lRet := .F.,Close(oDlg01))
Activate Dialog oDlg01 Centered

If lRet
   If MsgYesNo(OemToAnsi("Confirma inicio da exportação de dados para DBF?. Arquivo DBF atual sera apagado(se existir)"),OemToAnsi("A T E N Ç Ã O"))                  
        begin Transaction
                  	
    	Processa({||  fReajust()},"Gerando arquivo dbf...")
    	                 
        End transaction        
        
   EndIf
Endif   
   
MsgInfo("Finalizou")

Return(lRet)

        
static function fReajust()

&&Gero arquivo temporario

Local _Conteudo := ""

   _ARQUIVO := __RELDIR+"fluxo.csv"

   If  !file(_ARQUIVO)
      handle := FCREATE(_ARQUIVO)
   Else
      handle := FCREATE(_ARQUIVO)
   Endif

_Conteudo := "DATAMOV;MES;TIPO;VALORMOV;NATUREZA;NAT1;NAT2;BANCO;AGENCIA;NRCHEQUE;DOCUMENT;RECPAG;"
_Conteudo += "BENEFICI;TIPODOC;MOTBAIXA;EMISSAO;PREFIXO;NUMERO;CODIGO;LOJA;NOME;ORIGEM"

&&pego dados do SE5 para considerar pagos
if Select("TAAE") > 0
   DbSelectArea("TAAE")
   DbCloseArea("TAAE")
Endif      
        
_cQuery  := "SELECT * "
_cQuery  += "FROM "+RetSqlName("SE5")+"  AS SE5 "
_cQuery  += "WHERE SE5.D_E_L_E_T_ <> '*' AND SE5.E5_DATA >= '"+Dtos(_dMesRef)+"' "
_cQuery  += "ORDER BY SE5.E5_DATA,SE5.E5_CLIFOR,SE5.E5_LOJA,SE5.E5_PREFIXO,SE5.E5_NUMERO,SE5.E5_PARCELA"
       
TCQUERY _cQuery NEW ALIAS "TAAE"

DbSelectArea("TAAE")
DbGoTop()

While TAAE->(!Eof())
      FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))                             
      _Conteudo := SUBSTR(TAAE->E5_DATA,7,2)+"/"+SUBSTR(TAAE->E5_DATA,5,2)+"/"+SUBSTR(TAAE->E5_DATA,1,4) + ";"
      _Conteudo += ALLTRIM(STR(YEAR(STOD(TAAE->E5_DATA))))+"-"+STRZERO(Month(STOD(TAAE->E5_DATA)),2) +"-"+Substr(cmonth(STOD(TAAE->E5_DATA)),1,3) + ";"
      _Conteudo += TAAE->E5_TIPO + ";"
      _Conteudo += IIF(TAAE->E5_RECPAG == 'P',REPLACE(CVALTOCHAR((TAAE->E5_VALOR * -1)),".",","),REPLACE(CVALTOCHAR(TAAE->E5_VALOR),".",",")) + ";"
      _Conteudo += TAAE->E5_NATUREZ + ";"
      _Conteudo += Substr(TAAE->E5_NATUREZ,1,3)+"-"+Posicione("SED",1,xFilial("SED")+Substr(TAAE->E5_NATUREZ,1,3),"ED_DESCRIC") + ";"
      _Conteudo += Substr(TAAE->E5_NATUREZ,1,6)+"-"+Posicione("SED",1,xFilial("SED")+Substr(TAAE->E5_NATUREZ,1,6),"ED_DESCRIC") + ";"
      _Conteudo += TAAE->E5_BANCO + ";"
      _Conteudo += TAAE->E5_AGENCIA + ";"
      _Conteudo += TAAE->E5_NUMCHEQUE + ";"
      _Conteudo += TAAE->E5_DOCUMEN + ";"
      _Conteudo += TAAE->E5_RECPAG + ";"
      _Conteudo += TAAE->E5_BENEF + ";"
      _Conteudo += TAAE->E5_TIPODOC + ";"
      _Conteudo += TAAE->E5_MOTBX + ";"
      _Conteudo += ";"
      _Conteudo += TAAE->E5_PREFIXO + ";"
      _Conteudo += TAAE->E5_NUMERO + ";"                                         
      _Conteudo += TAAE->E5_CLIFOR + ";"
      _Conteudo += TAAE->E5_LOJA + ";"
      _Conteudo += IIF(TAAE->E5_RECPAG == 'P',Posicione("SA2",1,xFilial("SA2")+TAAE->E5_CLIFOR+TAAE->E5_LOJA,"A2_NOME"),Posicione("SA1",1,xFilial("SA1")+TAAE->E5_CLIFOR+TAAE->E5_LOJA,"A1_NOME")) + ";"
      _Conteudo += TAAE->E5_ORIGEM 
      DbSelectArea("TAAE")
      TAAE->(DbSkip())
Enddo

&&Busco os titulos em aberto na SE2...
if Select("TAAE") > 0
   DbSelectArea("TAAE")
   DbCloseArea("TAAE")
Endif      
        
_cQuery  := "SELECT * "
_cQuery  += "FROM "+RetSqlName("SE2")+"  AS SE2 "
_cQuery  += "WHERE SE2.D_E_L_E_T_ <> '*' AND SE2.E2_VENCREA >= '"+Dtos(_dMesRef)+"' "
_cQuery  += "AND SE2.E2_SALDO > 0 "
_cQuery  += "ORDER BY SE2.E2_VENCREA,SE2.E2_FORNECE,SE2.E2_LOJA,SE2.E2_PREFIXO,SE2.E2_NUM,SE2.E2_PARCELA "
       
TCQUERY _cQuery NEW ALIAS "TAAE"

DbSelectArea("TAAE")
DbGoTop()

While TAAE->(!Eof())
      FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
      _Conteudo := SUBSTR(TAAE->E2_VENCREA,7,2)+"/"+SUBSTR(TAAE->E2_VENCREA,5,2)+"/"+SUBSTR(TAAE->E2_VENCREA,1,4) + ";"
      If STOD(TAAE->E2_VENCREA) < Date()    &&atrasados...
         If STOD(TAAE->E2_VENCREA) < Firstday(Date())     &&atrasado meses anteriores ao atual
            _cText := "Atrasado "
            _cYear := ALLTRIM(STR(YEAR(Date())))
            _cMes  := STRZERO(Month(DATE()),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
         Else                                             &&atrasado dentro do mes atual
            _cYear := ALLTRIM(STR(YEAR(STOD(TAAE->E2_VENCREA))))
            _cMes  := STRZERO(Month(STOD(TAAE->E2_VENCREA)),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
         Endif   
      Else
         If STOD(TAAE->E2_VENCREA) >= Date() .And. STOD(TAAE->E2_VENCREA) <= lastday(Date())   &&a vencer no mes atual
            _cText := "a vencer "
            _cYear := ALLTRIM(STR(YEAR(STOD(TAAE->E2_VENCREA))))
            _cMes  := STRZERO(Month(STOD(TAAE->E2_VENCREA)),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+"AVE" + ";"
         Else
            _cYear := ALLTRIM(STR(YEAR(STOD(TAAE->E2_VENCREA))))
            _cMes  := STRZERO(Month(STOD(TAAE->E2_VENCREA)),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(STOD(TAAE->E2_VENCREA)),1,3) + ";"
         Endif   
      Endif                                

      _Conteudo += TAAE->E2_TIPO + ";"
      _Conteudo += REPLACE(CVALTOCHAR((TAAE->E2_SALDO * -1)),".",",") + ";" 
      _Conteudo += TAAE->E2_NATUREZ + ";"
      _Conteudo += Substr(TAAE->E2_NATUREZ,1,3)+"-"+Posicione("SED",1,xFilial("SED")+Substr(TAAE->E2_NATUREZ,1,3),"ED_DESCRIC") + ";"
      _Conteudo += Substr(TAAE->E2_NATUREZ,1,6)+"-"+Posicione("SED",1,xFilial("SED")+Substr(TAAE->E2_NATUREZ,1,6),"ED_DESCRIC") + ";"
      _Conteudo += ";"
      _Conteudo += ";"
      _Conteudo += ";"
      _Conteudo += Alltrim(TAAE->E2_HIST) + ";"
      _Conteudo += "P" + ";"
      _Conteudo += TAAE->E2_NOMFOR + ";"
      _Conteudo += "" + ";"
      _Conteudo += ";"
      _Conteudo += "  /  /    " + ";"
      _Conteudo += TAAE->E2_PREFIXO + ";"
      _Conteudo += TAAE->E2_NUM + ";"
      _Conteudo += TAAE->E2_FORNECE + ";"
      _Conteudo += TAAE->E2_LOJA + ";"
      _Conteudo += Posicione("SA2",1,xFilial("SA2")+TAAE->E2_FORNECE+TAAE->E2_LOJA,"A2_NOME") + ";"
      _Conteudo += TAAE->E2_ORIGEM 
      TAAE->(DbSkip())
Enddo
     
&&Busco os titulos em aberto na SE1...
if Select("TAAE") > 0
   DbSelectArea("TAAE")
   DbCloseArea("TAAE")
Endif      
        
_cQuery  := "SELECT * "
_cQuery  += "FROM "+RetSqlName("SE1")+"  AS SE1 "
_cQuery  += "WHERE SE1.D_E_L_E_T_ <> '*' AND SE1.E1_VENCREA >= '"+Dtos(_dMesRef)+"' "
_cQuery  += "AND SE1.E1_SALDO > 0 "
_cQuery  += "ORDER BY SE1.E1_VENCREA,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA "
       
TCQUERY _cQuery NEW ALIAS "TAAE"

DbSelectArea("TAAE")
DbGoTop()

While TAAE->(!Eof())
      FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
      _Conteudo := SUBSTR(TAAE->E1_VENCREA,7,2)+"/"+SUBSTR(TAAE->E1_VENCREA,5,2)+"/"+SUBSTR(TAAE->E1_VENCREA,1,4) + ";"
      If STOD(TAAE->E1_VENCREA) < Date()    &&atrasados...
         If STOD(TAAE->E1_VENCREA) < Firstday(Date())     &&atrasado meses anteriores ao atual
            _cText := "Atrasado "
            _cYear := ALLTRIM(STR(YEAR(Date())))
            _cMes  := STRZERO(Month(Date()),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
         Else                                             &&atrasado dentro do mes atual
            _cYear := ALLTRIM(STR(YEAR(STOD(TAAE->E1_VENCREA))))
            _cMes  := STRZERO(Month(STOD(TAAE->E1_VENCREA)),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
         Endif   
      Else
         If STOD(TAAE->E1_VENCREA) >= Date() .And. STOD(TAAE->E1_VENCREA) <= lastday(Date())   &&a vencer no mes atual
            _cText := "a vencer "
            _cYear := ALLTRIM(STR(YEAR(STOD(TAAE->E1_VENCREA))))
            _cMes  := STRZERO(Month(STOD(TAAE->E1_VENCREA)),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+"AVE" + ";"
         Else
            _cYear := ALLTRIM(STR(YEAR(STOD(TAAE->E1_VENCREA))))
            _cMes  := STRZERO(Month(STOD(TAAE->E1_VENCREA)),2)
            _Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(STOD(TAAE->E1_VENCREA)),1,3) + ";"
         Endif   
      Endif                              

      _Conteudo += TAAE->E1_TIPO + ";"
      _Conteudo += REPLACE(CVALTOCHAR(TAAE->E1_SALDO),".",",") + ";"
      _Conteudo += TAAE->E1_NATUREZ + ";"
      _Conteudo += Substr(TAAE->E1_NATUREZ,1,3)+"-"+Posicione("SED",1,xFilial("SED")+Substr(TAAE->E1_NATUREZ,1,3),"ED_DESCRIC") + ";"
      _Conteudo += Substr(TAAE->E1_NATUREZ,1,6)+"-"+Posicione("SED",1,xFilial("SED")+Substr(TAAE->E1_NATUREZ,1,6),"ED_DESCRIC") + ";"
      _Conteudo += ";"
      _Conteudo += ";"
      _Conteudo += ";"
      _Conteudo += TAAE->E1_NOMCLI + ";"
      _Conteudo += "R" + ";"
      _Conteudo += ";"
      _Conteudo += ";"
      _Conteudo += ";"
      _Conteudo += "  /  /    " + ";"     
      _Conteudo += TAAE->E1_PREFIXO + ";"
      _Conteudo += TAAE->E1_NUM + ";"
      _Conteudo += TAAE->E1_CLIENTE + ";"
      _Conteudo += TAAE->E1_LOJA + ";"
      _Conteudo += Posicione("SA1",1,xFilial("SA1")+TAAE->E1_CLIENTE+TAAE->E1_LOJA,"A1_NOME") + ";"
      _Conteudo += TAAE->E1_ORIGEM 
      TAAE->(DbSkip())
Enddo
  
&&Busco os pedidos de compras em aberto na SC7...
if Select("TAAE") > 0
	DbSelectArea("TAAE")
	DbCloseArea("TAAE")
Endif

_cQuery  := "SELECT * "
_cQuery  += "FROM "+RetSqlName("SC7")+" AS SC7 "
_cQuery  += "WHERE SC7.D_E_L_E_T_ <> '*' AND (SC7.C7_RESIDUO <> 'S' AND SC7.C7_ENCER <> 'E') AND SC7.C7_FLUXO <> 'N' "
_cQuery  += "AND (SC7.C7_QUJE < SC7.C7_QUANT) "
_cQuery  += "ORDER BY SC7.C7_DATPRF,SC7.C7_NUM, SC7.C7_ITEM"

TCQUERY _cQuery NEW ALIAS "TAAE"

DbSelectArea("TAAE")
DbGoTop()

While TAAE->(!Eof())
	_nQt     := (TAAE->C7_QUANT - TAAE->C7_QUJE)	
	_nValTot := _nQt * TAAE->C7_PRECO
	If TAAE->C7_MOEDA == 2
	      _nCOTAC := 1
	      DBSELECTAREA("SM2")
          DBSETORDER(1)
          if DBSEEK(DTOS(Date() - 1))  &&Sempre um dia antes ao atual...
              if SM2->M2_MOEDA2 <> 0
	             _nCOTAC  := SM2->M2_MOEDA2	          
	          Endif   
	      endif   
	      _nValTot := ((_nQt * TAAE->C7_PRECO) * _nCOTAC)
	Elseif TAAE->C7_MOEDA == 3
	      _nCOTAC := 1
	      DBSELECTAREA("SM2")
          DBSETORDER(1)
          if DBSEEK(DTOS(Date() - 1))  &&Sempre um dia antes ao atual...
              if SM2->M2_MOEDA3 <> 0
	             _nCOTAC  := SM2->M2_MOEDA3	          
	          Endif   
	      endif   
	      _nValTot := ((_nQt * TAAE->C7_PRECO) * _nCOTAC)
	Elseif TAAE->C7_MOEDA == 4
	      _nCOTAC := 1
	      DBSELECTAREA("SM2")
          DBSETORDER(1)
          if DBSEEK(DTOS(Date() - 1))  &&Sempre um dia antes ao atual...
              if SM2->M2_MOEDA4 <> 0
	             _nCOTAC  := SM2->M2_MOEDA4	          
	          Endif   
	      endif   
	      _nValTot := ((_nQt * TAAE->C7_PRECO) * _nCOTAC)
	Elseif TAAE->C7_MOEDA == 5
	      _nCOTAC := 1
	      DBSELECTAREA("SM2")
          DBSETORDER(1)
          if DBSEEK(DTOS(Date() - 1))  &&Sempre um dia antes ao atual...
              if SM2->M2_MOEDA5 <> 0
	             _nCOTAC  := SM2->M2_MOEDA5	          
	          Endif   
	      endif   
	      _nValTot := ((_nQt * TAAE->C7_PRECO) * _nCOTAC)      	      
	Endif
	if STOD(TAAE->C7_DATPRF) < date()
	   _aPags   := Condicao(_nValTot,TAAE->C7_COND,,date())
	Else   
	   _aPags   := Condicao(_nValTot,TAAE->C7_COND,,STOD(TAAE->C7_DATPRF))
	Endif
	
	If len(_aPags) > 0
		
		For _nx:= 1 to len(_aPags)
			_dDatPed := _aPags[_nx][1]

            FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
            _CONTEUDO := SUBSTR(DTOS(_DDATPED),7,2)+"/"+SUBSTR(DTOS(_DDATPED),5,2)+"/"+SUBSTR(DTOS(_DDATPED),1,4)+";"
						
			If _dDatPed  < Date()    &&atrasados...
				If _dDatPed  < Firstday(Date())     &&atrasado meses anteriores ao atual
					_cText := "Atrasado "
					_cYear := ALLTRIM(STR(YEAR(Date())))
					_cMes  := STRZERO(Month(DATE()),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(Date()),1,3) + ";"
				Else                                             &&atrasado dentro do mes atual
					_cYear := ALLTRIM(STR(YEAR(Date())))
					_cMes  := STRZERO(Month(DATE()),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(Date()),1,3) + ";"

				Endif
			Else
				If _dDatPed  >= Date() .And. _dDatPed <= lastday(Date())   &&a vencer no mes atual
					_cText := "a vencer "
					_cYear := ALLTRIM(STR(YEAR(_dDatPed )))
					_cMes  := STRZERO(Month(_dDatPed),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+"AVE" + ";"
				Else
					_cYear := ALLTRIM(STR(YEAR(_dDatPed )))
					_cMes  := STRZERO(Month(_dDatPed),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(_dDatPed),1,3) + ";"
				Endif
			Endif
			_Conteudo += "PD" + ";"
			_Conteudo += REPLACE(CVALTOCHAR((_aPags[_nx][2] * -1)),".",",") + ";"
			_cNat          := Posicione("SA2",1,xFilial("SA2")+TAAE->C7_FORNECE+TAAE->C7_LOJA,"A2_NATUREZ")
			_Conteudo += _cNat + ";"
            _Conteudo += Substr(_cNat,1,3)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,3),"ED_DESCRIC") + ";"
            _Conteudo += Substr(_cNat,1,6)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,6),"ED_DESCRIC") + ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += TAAE->C7_PRODUTO + ";"
			_Conteudo += TAAE->C7_DESCRI + ";"
			_Conteudo += "P" + ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"                                                           
			_Conteudo += SUBSTR(TAAE->C7_DATPRF,7,2)+"/"+SUBSTR(TAAE->C7_DATPRF,5,2)+"/"+SUBSTR(TAAE->C7_DATPRF,1,4) + ";"
			_Conteudo += TAAE->C7_ITEM + ";"
			_Conteudo += TAAE->C7_NUM + ";"
			_Conteudo += TAAE->C7_FORNECE + ";"
			_Conteudo += TAAE->C7_LOJA + ";"
			_Conteudo += Posicione("SA2",1,xFilial("SA2")+TAAE->C7_FORNECE+TAAE->C7_LOJA,"A2_NOME") + ";"
			_Conteudo += ""
		Next _nx
		
	Else
    	FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
		_Conteudo := SUBSTR(TAAE->C7_DATPRF,7,2)+"/"+SUBSTR(TAAE->C7_DATPRF,5,2)+"/"+SUBSTR(TAAE->C7_DATPRF,1,4) + ";"
			
		If STOD(TAAE->C7_DATPRF) < Date()    &&atrasados...
			If STOD(TAAE->C7_DATPRF) < Firstday(Date())     &&atrasado meses anteriores ao atual
				_cText := "Atrasado "
				_cYear := ALLTRIM(STR(YEAR(Date())))
				_cMes  := STRZERO(Month(DATE()),2)
				_Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
			Else                                             &&atrasado dentro do mes atual
				_cYear := ALLTRIM(STR(YEAR(STOD(TAAE->C7_DATPRF))))
				_cMes  := STRZERO(Month(STOD(TAAE->C7_DATPRF)),2)
				_Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
			Endif
		Else
			If STOD(TAAE->C7_DATPRF) >= Date() .And. STOD(TAAE->C7_DATPRF) <= lastday(Date())   &&a vencer no mes atual
				_cText := "a vencer "
				_cYear := ALLTRIM(STR(YEAR(STOD(TAAE->C7_DATPRF))))
				_cMes  := STRZERO(Month(STOD(TAAE->C7_DATPRF)),2)
				_Conteudo += _cYear+"-"+_cMes+"-"+"AVE" + ";"
			Else
				_cYear := ALLTRIM(STR(YEAR(STOD(TAAE->C7_DATPRF))))
				_cMes  := Alltrim(STR(Month(STOD(TAAE->C7_DATPRF))))
				_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(STOD(TAAE->C7_DATPRF)),1,3) + ";"
			Endif
		Endif
		
		_Conteudo += "PD" + ";"
		_Conteudo += (_nValTot * -1) + ";"
		_cNat          := Posicione("SA2",1,xFilial("SA2")+TAAE->C7_FORNECE+TAAE->C7_LOJA,"A2_NATUREZ")
		_Conteudo += _cNat + ";"
        _Conteudo += Substr(_cNat,1,3)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,3),"ED_DESCRIC") + ";"
        _Conteudo += Substr(_cNat,1,6)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,6),"ED_DESCRIC") + ";"
		_Conteudo += ";"
		_Conteudo += ";"
		_Conteudo += TAAE->C7_PRODUTO + ";"
		_Conteudo += TAAE->C7_DESCRI + ";"
		_Conteudo += "P" + ";"
		_Conteudo += ";"
		_Conteudo += ";"
		_Conteudo += ";"
		_Conteudo += SUBSTR(TAAE->C7_DATPRF,7,2)+"/"+SUBSTR(TAAE->C7_DATPRF,5,2)+"/"+SUBSTR(TAAE->C7_DATPRF,1,4) + ";"
		_Conteudo += TAAE->C7_ITEM + ";"
		_Conteudo += TAAE->C7_NUM + ";"
		_Conteudo += TAAE->C7_FORNECE + ";"
		_Conteudo += TAAE->C7_LOJA + ";"
		_Conteudo += Posicione("SA2",1,xFilial("SA2")+TAAE->C7_FORNECE+TAAE->C7_LOJA,"A2_NOME") + ";"
		_Conteudo += ""
	Endif
	
	
	TAAE->(DbSkip())
Enddo

&&Busco dados relativos ao saldo bancario SE8
if Select("TAAE") > 0
   DbSelectArea("TAAE")
   DbCloseArea("TAAE")
Endif      
        
_cQuery  := "SELECT E8_BANCO, E8_AGENCIA, E8_CONTA, E8_DTSALAT, E8_SALATUA, A6_NREDUZ "
_cQuery  += "FROM "+RetSqlName("SE8")+"  AS SE8, "+RetSqlName("SA6")+" AS SA6 "
_cQuery  += "WHERE SE8.D_E_L_E_T_ <> '*' AND SA6.D_E_L_E_T_ <> '*' AND SE8.E8_DTSALAT < '"+Dtos(Date())+"' "
_cQuery  += "AND SE8.E8_BANCO = SA6.A6_COD AND SE8.E8_AGENCIA = SA6.A6_AGENCIA AND SE8.E8_CONTA = SA6.A6_NUMCON "
_cQuery  += "ORDER BY SE8.E8_BANCO, SE8.E8_AGENCIA, SE8.E8_CONTA, SE8.E8_DTSALAT DESC "
       
TCQUERY _cQuery NEW ALIAS "TAAE"

DbSelectArea("TAAE")
DbGoTop()

While TAAE->(!Eof())
	_cBco   := TAAE->E8_BANCO
	_cAgc   := TAAE->E8_AGENCIA
	_cCta   := TAAE->E8_CONTA
	_nConta := 1
	While TAAE->(!Eof()) .And. _cBco == TAAE->E8_BANCO .And. _cAgc == TAAE->E8_AGENCIA .And. _cCta == TAAE->E8_CONTA
    	FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
		If _nConta == 1
			_Conteudo := SUBSTR(TAAE->E8_DTSALAT,7,2)+"/"+SUBSTR(TAAE->E8_DTSALAT,5,2)+"/"+SUBSTR(TAAE->E8_DTSALAT,1,4) + ";"
			_Conteudo += ALLTRIM(STR(YEAR(STOD(TAAE->E8_DTSALAT))))+"-"+STRZERO(Month(STOD(TAAE->E8_DTSALAT)),2) +"-"+"ATR" + ";"   &&precisa forcar ser ATR para entrar na primeira coluna...
			_Conteudo += "SD" + ";"
			_Conteudo += REPLACE(CVALTOCHAR(TAAE->E8_SALATUA),".",",") + ";"
			_Conteudo += "001001" + ";"
			_Conteudo += "001"+"-"+Alltrim(Posicione("SED",1,xFilial("SED")+"001","ED_DESCRIC")) + ";"
			_Conteudo += "001001"+"-"+Alltrim(Posicione("SED",1,xFilial("SED")+"001001","ED_DESCRIC"))+" "+AllTRIM(TAAE->A6_NREDUZ)+" "+AlLTRIM(TAAE->E8_AGENCIA)+" "+ALLTRIM(TAAE->E8_CONTA) + ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += "  /  /    " + ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ""
			DbSelectArea("TAAE")
		Endif
		_nConta ++
		TAAE->(DbSkip())
	Enddo
Enddo

&&Busco dados relativos as aplicaçoes na tabela SEH
if Select("TAAE") > 0
   DbSelectArea("TAAE")
   DbCloseArea("TAAE")
Endif      
        
_cQuery  := "SELECT EH_BANCO, EH_AGENCIA, EH_CONTA, EH_NUMERO, EH_DATA, EH_SALDO, A6_NREDUZ "
_cQuery  += "FROM "+RetSqlName("SEH")+"  AS SEH, "+RetSqlName("SA6")+" AS SA6 "
_cQuery  += "WHERE SEH.D_E_L_E_T_ <> '*' AND SA6.D_E_L_E_T_ <> '*' AND SEH.EH_SALDO > 0 "
_cQuery  += "AND SEH.EH_BANCO = SA6.A6_COD AND SEH.EH_AGENCIA = SA6.A6_AGENCIA AND SEH.EH_CONTA = SA6.A6_NUMCON "
_cQuery  += "ORDER BY SEH.EH_NUMERO"
       
TCQUERY _cQuery NEW ALIAS "TAAE"

DbSelectArea("TAAE")
DbGoTop()

While TAAE->(!Eof())
  	FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
	_Conteudo := SUBSTR(TAAE->EH_DATA,7,2)+"/"+SUBSTR(TAAE->EH_DATA,5,2)+"/"+SUBSTR(TAAE->EH_DATA,1,4) + ";"
	_Conteudo += ALLTRIM(STR(YEAR(Date()-1)))+"-"+STRZERO(Month(Date()-1),2) +"-"+"ATR" + ";"   &&precisa forcar ser ATR para entrar na primeira coluna...
	_Conteudo += "SD" + ";"
	_Conteudo += REPLACE(CVALTOCHAR(TAAE->EH_SALDO),".",",") + ";"
	_Conteudo += "002001" + ";"
	_Conteudo += "002"+"-"+Alltrim(Posicione("SED",1,xFilial("SED")+"002","ED_DESCRIC")) + ";"
	_Conteudo += "002001"+"-"+Alltrim(Posicione("SED",1,xFilial("SED")+"002001","ED_DESCRIC"))+" "+AllTRIM(TAAE->A6_NREDUZ)+" "+AlLTRIM(TAAE->EH_AGENCIA)+" "+ALLTRIM(TAAE->EH_CONTA) + ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += "  /  /    " + ";"
	_Conteudo += ";"
	_Conteudo += TAAE->EH_NUMERO + ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ";"
	_Conteudo += ""
	DbSelectArea("TAAE")
	TAAE->(DbSkip())
Enddo                                                                                    

&&Busco os pedidos de vendas em aberto na SC6...
if Select("TAAE") > 0
	DbSelectArea("TAAE")
	DbCloseArea("TAAE")
Endif

_cQuery  := "SELECT * "
_cQuery  += "FROM "+RetSqlName("SC6")+" AS SC6, "+RetSqlName("SC5")+" AS SC5, "+RetSqlName("SF4")+" AS SF4  "
_cQuery  += "WHERE SC6.D_E_L_E_T_ <> '*' AND SC5.D_E_L_E_T_ <> '*' AND SC6.C6_BLQ = ' ' "  &&AND SC6.C6_FLUXO = 'S' "    //Pedido bloqueado C6_BLQ = "S"    e residuo = "R"
_cQuery  += "AND (SC6.C6_QTDENT < SC6.C6_QTDVEN) AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_TES = SF4.F4_CODIGO AND SF4.F4_DUPLIC = 'S' "  
_cQuery  += "ORDER BY SC6.C6_ENTREG,SC6.C6_NUM, SC6.C6_ITEM"

TCQUERY _cQuery NEW ALIAS "TAAE"

DbSelectArea("TAAE")
DbGoTop()

While TAAE->(!Eof())
	_nQt     := (TAAE->C6_QTDVEN - TAAE->C6_QTDENT)
	_nValTot := _nQt * TAAE->C6_PRCVEN
	if STOD(TAAE->C6_ENTREG) < date()
		_aPags   := Condicao(_nValTot,TAAE->C5_CONDPAG,,date())
	Else
		_aPags   := Condicao(_nValTot,TAAE->C5_CONDPAG,,STOD(TAAE->C6_ENTREG))
	Endif
	
	If len(_aPags) > 0
		
		For _nx:= 1 to len(_aPags)
			_dDatPed := _aPags[_nx][1]
        	FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
            _CONTEUDO := SUBSTR(DTOS(_DDATPED),7,2)+"/"+SUBSTR(DTOS(_DDATPED),5,2)+"/"+SUBSTR(DTOS(_DDATPED),1,4)+";"
			
			If _dDatPed  < Date()    &&atrasados...
				If _dDatPed  < Firstday(Date())     &&atrasado meses anteriores ao atual
					_cText := "Atrasado "
					_cYear := ALLTRIM(STR(YEAR(Date())))
					_cMes  := STRZERO(Month(DATE()),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(Date()),1,3) + ";"

				Else                                             &&atrasado dentro do mes atual
					_cYear := ALLTRIM(STR(YEAR(Date())))
					_cMes  := STRZERO(Month(DATE()),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(Date()),1,3) + ";"

				Endif
			Else
				If _dDatPed  >= Date() .And. _dDatPed <= lastday(Date())   &&a vencer no mes atual
					_cText := "a vencer "
					_cYear := ALLTRIM(STR(YEAR(_dDatPed )))
					_cMes  := STRZERO(Month(_dDatPed),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+"AVE" + ";"
				Else
					_cYear := ALLTRIM(STR(YEAR(_dDatPed )))
					_cMes  := STRZERO(Month(_dDatPed),2)
					_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(_dDatPed),1,3) + ";"
				Endif
			Endif
			_Conteudo += "PV" + ";"
			_Conteudo += REPLACE(CVALTOCHAR((_aPags[_nx][2] * .88)),".",",") + ";"
			_cNat           := Posicione("SA1",1,xFilial("SA1")+TAAE->C6_CLI+TAAE->C6_LOJA,"A1_NATUREZ")
			_Conteudo += _cNat + ";"
			_Conteudo += Substr(_cNat,1,3)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,3),"ED_DESCRIC") + ";"
			_Conteudo += Substr(_cNat,1,6)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,6),"ED_DESCRIC") + ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += TAAE->C6_PRODUTO + ";"
			_Conteudo += TAAE->C6_DESCRI + ";"
			_Conteudo += "R" + ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += ";"
			_Conteudo += SUBSTR(TAAE->C6_ENTREG,7,2)+"/"+SUBSTR(TAAE->C6_ENTREG,5,2)+"/"+SUBSTR(TAAE->C6_ENTREG,7,2) + ";"
			_Conteudo += TAAE->C6_ITEM + ";"
			_Conteudo += TAAE->C6_NUM + ";"
			_Conteudo += TAAE->C6_CLI + ";"
			_Conteudo += TAAE->C6_LOJA + ";"
			_Conteudo += Posicione("SA1",1,xFilial("SA1")+TAAE->C6_CLI+TAAE->C6_LOJA,"A1_NREDUZ") + ";"
			_Conteudo += ""
		Next _nx
		
	Else 
       	FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10))
		_Conteudo := SUBSTR(TAAE->C6_ENTREG,7,2)+"/"+SUBSTR(TAAE->C6_ENTREG,5,2)+"/"+SUBSTR(TAAE->C6_ENTREG,1,4) + ";"
		
		If STOD(TAAE->C6_ENTREG) < Date()    &&atrasados...
			If STOD(TAAE->C6_ENTREG) < Firstday(Date())     &&atrasado meses anteriores ao atual
				_cText := "Atrasado "
				_cYear := ALLTRIM(STR(YEAR(Date())))
				_cMes  := STRZERO(Month(DATE()),2)
				_Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
			Else                                             &&atrasado dentro do mes atual
				_cYear := ALLTRIM(STR(YEAR(STOD(TAAE->C6_ENTREG))))
				_cMes  := STRZERO(Month(STOD(TAAE->C6_ENTREG)),2)
				_Conteudo += _cYear+"-"+_cMes+"-"+"ATR" + ";"
			Endif
		Else
			If STOD(TAAE->C6_ENTREG) >= Date() .And. STOD(TAAE->C6_ENTREG) <= lastday(Date())   &&a vencer no mes atual
				_cText := "a vencer "
				_cYear := ALLTRIM(STR(YEAR(STOD(TAAE->C6_ENTREG))))
				_cMes  := STRZERO(Month(STOD(TAAE->C6_ENTREG)),2)
				_Conteudo += _cYear+"-"+_cMes+"-"+"AVE" + ";"
			Else
				_cYear := ALLTRIM(STR(YEAR(STOD(TAAE->C6_ENTREG))))
				_cMes  := Alltrim(STR(Month(STOD(TAAE->C6_ENTREG))))
				_Conteudo += _cYear+"-"+_cMes+"-"+Substr(cmonth(STOD(TAAE->C6_ENTREG)),1,3) + ";"
			Endif
		Endif
				
		_Conteudo += "PV" + ";"
		_Conteudo += REPLACE(CVALTOCHAR((_nValTot * .88)),".",",") + ";"
		_cNat           := Posicione("SA1",1,xFilial("SA1")+TAAE->C6_CLI+TAAE->C6_LOJA,"A1_NATUREZ")
		_Conteudo += _cNat + ";"
		_Conteudo += Substr(_cNat,1,3)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,3),"ED_DESCRIC") + ";"
		_Conteudo += Substr(_cNat,1,6)+"-"+Posicione("SED",1,xFilial("SED")+Substr(_cNat,1,6),"ED_DESCRIC") + ";"
		_Conteudo += ";"
		_Conteudo += ";"
		_Conteudo += TAAE->C6_PRODUTO + ";"
		_Conteudo += TAAE->C6_DESCRI + ";"
		_Conteudo += "R" + ";"
		_Conteudo += ";"
		_Conteudo += ";"
		_Conteudo += ";"
		_Conteudo += SUBSTR(TAAE->C6_ENTREG,7,2)+"/"+SUBSTR(TAAE->C6_ENTREG,5,2)+"/"+SUBSTR(TAAE->C6_ENTREG,1,4) + ";"
		_Conteudo += TAAE->C6_ITEM + ";"
		_Conteudo += TAAE->C6_NUM + ";"
		_Conteudo += TAAE->C6_CLI + ";"
		_Conteudo += TAAE->C6_LOJA + ";"
		_Conteudo += Posicione("SA1",1,xFilial("SA1")+TAAE->C6_CLI+TAAE->C6_LOJA,"A1_NREDUZ") + ";"
		_Conteudo += ""
	Endif
	
	TAAE->(DbSkip())
Enddo
FCLOSE(M->handle)

/*
    
_cArquivo := __RELDIR+"FLUXO.DBF"
	
dbSelectArea("XLS")
Copy To &(_cArquivo)
	
__COPYFILE (_cArquivo,"C:\TOTVS\MICROSIGA\PROTHEUS_DATA\SYSTEM\FLUXO.DBF")
	
if Select("XLS") > 0
   DbSelectArea("XLS")
   DbCloseArea("XLS")
Endif    
*/

