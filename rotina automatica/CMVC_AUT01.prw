#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

User Function CMVC_AUT01()
Local   aSay     := {}
Local   aButton  := {}
Local   nOpc     := 0
Local   Titulo   := 'IMPORTACAO DE TURMAS'
Local   cDesc1   := 'Esta rotina fara a importacao de Turmas.'
Local   cDesc2   := ''
Local   cDesc3   := ''
Local   lOk      := .T.

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 1, .T., { || nOpc := 1, FechaBatch() } } )
aAdd( aButton, { 2, .T., { || FechaBatch()            } } )

FormBatch( Titulo, aSay, aButton )

If nOpc == 1

	Processa( { || lOk := Runproc() },'Aguarde','Processando...',.F.)

	If lOk
		ApMsgInfo( 'Processamento terminado com sucesso.', 'ATENÇÃO' )
	Else
		ApMsgStop( 'Processamento realizado com problemas.', 'ATENÇÃO' )
	EndIf

EndIf
Return 

Static Function Runproc()
Local lRet    := .T.
Local aCampos := {}

// Criamos um vetor com os dados para facilitar o manuseio dos dados
aCampos := {}
aAdd( aCampos, { 'ZB1_CODIGO', 'A01'         } )
aAdd( aCampos, { 'ZB1_DESCRI'  , '5a A Manha'     } )
aAdd( aCampos, { 'ZB1_PERIOD' , '1' } )
aAdd( aCampos, { 'ZB1_SITUAC'  , '1'              } )

If !Import( 'MASTERZB1', aCampos )
	lRet := .F.
EndIf

// Importamos outro registro
aCampos := {}
aAdd( aCampos, { 'ZB1_CODIGO', 'A02'         } )
aAdd( aCampos, { 'ZB1_DESCRI'  , '5a B Tarde'     } )
aAdd( aCampos, { 'ZB1_PERIOD' , '1' } )
aAdd( aCampos, { 'ZB1_SITUAC'  , '2'              } )

If !Import( 'MASTERZB1', aCampos )
	lRet := .F.
EndIf

Return lRet

//-------------------------------------------------------------------
Static Function Import(  cIDComponente, aDados  )
Local  oModel, oAux, oStruct
Local  nI        := 0
Local  nJ        := 0
Local  nPos      := 0
Local  lRet      := .T.
Local  aAux	     := {}
Local  aC  	     := {}
Local  aH        := {}
Local  nItErro   := 0
Local  lAux      := .T.

// Aqui ocorre o instanciamento do modelo de dados (Model)
// Neste exemplo instanciamos o modelo de dados do fonte CMVC_02
// que é a rotina de manutenção de turmas
oModel := FWLoadModel( 'CMVC_02' )

// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
oModel:SetOperation( MODEL_OPERATION_INSERT )

// Antes de atribuirmos os valores dos campos temos que ativar o modelo
// Se o Modelo nao puder ser ativado, talvez por uma regra de ativacao
// o retorno sera .F.
lRet := oModel:Activate()

If lRet
	// Obtemos apenas o componente desejado
	oAux    := oModel:GetModel( cIDComponente )
	
	// Obtemos a estrutura de dados do componente
	oStruct := oAux:GetStruct()
	aAux	:= oStruct:GetFields()
	
	If lRet
		For nI := 1 To Len( aDados )
			// Verifica se os campos passados existem na estrutura do componente
			If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) ==  AllTrim( aDados[nI][1] ) } ) ) > 0
				
				// È feita a atribuicao dos dados no Model
				If !( lAux := oModel:SetValue( cIDComponente, aDados[nI][1], aDados[nI][2] ) )
					// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
					// o método SetValue retorna .F.
					lRet    := .F.
					Exit
				EndIf
			EndIf
		Next
	EndIf
	
	If lRet
		// Faz-se a validação dos dados, note que diferentemente das tradicionais "rotinas automáticas"
		// neste momento os dados não são gravados, são somente validados.
		If ( lRet := oModel:VldData() )
			// Se o dados foram validados faz-se a gravação efetiva dos dados (commit)
			lRet := oModel:CommitData()
		EndIf
	EndIf
EndIf

If !lRet
	// Se os dados não foram validados obtemos a descrição do erro para gerar LOG ou mensagem de aviso
	aErro   := oModel:GetErrorMessage()
	// A estrutura do vetor com erro é:
	//  [1] Id do formulário de origem
	//  [2] Id do campo de origem
	//  [3] Id do formulário de erro
	//  [4] Id do campo de erro
	//  [5] Id do erro
	//  [6] mensagem do erro
	//  [7] mensagem da solução
	//  [8] Valor atribuido
	//  [9] Valor anterior

	AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
	AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
	AutoGrLog( "Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
	AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
	AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
	AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
	AutoGrLog( "Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
	AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
	AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )

	If nItErro > 0
		AutoGrLog( "Erro no Item:              " + ' [' + AllTrim( AllToChar( nItErro  ) ) + ']' )
	EndIf

	MostraErro()
EndIf

// Desativamos o Model
oModel:DeActivate()

Return lRet
