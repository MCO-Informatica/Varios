#include 'protheus.ch'
#include 'parmtype.ch'

user function zGrCustC7()
	
	Local _cRetorno 
	
	if  ! ALLTRIM(SC7->C7_ITEMCTA) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")	
		
		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "MP" ;
										.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
				_cRetorno := 	"Materia Prima"	
				// materia prima				
				
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "AI" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
				// comerciais
				_cRetorno := 	"Comerciais"	
					
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "EM" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(M->C7_PRODUTO),"B1_TIPO")) == "GE" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "GG" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "MC" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "ME" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// materia prima				
				_cRetorno := 	"Materia Prima"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "MO" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003") 
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "OI" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// materia prima				
				_cRetorno := 	"Materia Prima"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "PA" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "PI" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "PP" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "PV" ;
													.AND. !SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "SL" ;
													.AND. SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// comerciais
				_cRetorno := 	"Comerciais"
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
												.AND. SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22"  .AND. !ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003/22220018/2219005")
												//.AND. ALLTRIM(CA120FORN) <> "000022"
						
				// servicos
				_cRetorno := 	"Servicos"					
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
												.AND. SUBSTR(ALLTRIM(SC7->C7_PRODUTO),1,2) == "22"  .AND. ALLTRIM(SC7->C7_PRODUTO) $ ("22220018/2219005")
						
				// fabricacao
				_cRetorno := 	"Fabricacao"						
						
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+ALLTRIM(SC7->C7_PRODUTO),"B1_TIPO")) == "MO" ;
												.AND. ALLTRIM(CA120FORN) == "000022"
						
				// engenharia slc
				_cRetorno := 	"Engenharia SLC"
						
		elseif ALLTRIM(SC7->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
						
				// frete
				_cRetorno := 	"Frete"
					
		else
						
				// Materia Prima
				_cRetorno := 	"Materia Prima"	
			
		endif
		
	else
		_cRetorno	:= SPACE(10)
				
	endif
	
return _cRetorno