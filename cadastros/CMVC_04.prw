#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function CMVC_04()
Local oBrowse
Static oGrafBar

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CMVC_04' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CMVC_04' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CMVC_04' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CMVC_04' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CMVC_04' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CMVC_04' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef() 
Local oModel 
Local oStruZB5 := FWFormStruct(1,"ZB5") 
Local oStruZB6 := FWFormStruct(1,"ZB6") 
Local oStruZB7 := FWFormStruct(1,"ZB7") 
Local aAux  
 
 aAux := FwStruTrigger( "ZB7_NOTA"     ,; // Campo Dominio       
 "LEGENDA"     ,; // Campo de Contradominio        
"U_LEGENDA()") // Regra de Preenchimento     

oStruZB7:AddField('Legenda', 'Legenda', 'LEGENDA', 'C', 20, 0, , , {}, .F., ;  
FWBuildFeature( STRUCT_FEATURE_INIPAD, "'BR_AZUL.BMP'"), .F., .F., .T., , )    

oStruZB7:AddTrigger( ;   
					aAux[1]  , ;    // [01] Id do campo de origem   
					aAux[2]  , ;    // [02] Id do campo de destino   
					aAux[3]  , ;    // [03] Bloco de codigo de validação da execução do gatilho   
					aAux[4]  )      // [04] Bloco de codigo de execução do gatilho    

oModel := MPFormModel():New("MD_TURMA_ALUNO")  
oModel:SetDescription("Cadastro de Turma x Aluno x Nota")    
oModel:addFields('MASTERZB5',,oStruZB5,,{|oFieldZB5| TurmaPosValid(oFieldZB5)})  
oModel:addGrid('DETAILZB6','MASTERZB5',oStruZB6,{|oGrid,nLine,cAction| LinePreAluno(oGrid,nLine,cAction)},{|oGrid| AlunoLinePos(oGrid)})  
oModel:addGrid('DETAILZB7','DETAILZB6',oStruZB7) 
 
 oModel:getModel('MASTERZB5'):SetDescription('Dados da Turma')  
 oModel:getModel('DETAILZB6'):SetDescription('Dados do Aluno')  
 oModel:getModel('DETAILZB7'):SetDescription('Dados das Notas do Aluno')    

oModel:GeTModel("DETAILZB6"):SetUniqueLine({"ZB6_RA"})
oModel:GeTModel("DETAILZB7"):SetOptional(.t.)

 oModel:SetRelation("DETAILZB6", ;       
 					{{"ZB6_FILIAL",'xFilial("ZB6")'},;        
 						{"ZB6_CODTUR","ZB5_CODTUR"  }}, ;       
 						ZB6->(IndexKey(1)))         
 						
 oModel:SetRelation("DETAILZB7", ;       
 					{{"ZB7_FILIAL",'xFilial("ZB7")'},;        
 					{"ZB7_CODTUR","ZB6_CODTUR"  },;        
 					{"ZB7_RA","ZB6_RA"}}, ;       
 					ZB7->(IndexKey(1)))    
 					
 oModel:AddCalc( 'CALC_ALUNO', 'MASTERZB5', 'DETAILZB6', 'ZB6_RA', 'CALC_ALUNO', 'COUNT', /*bCondition*/, /*bInitValue*/,'Número de alunos da Turma' /*cTitle*/, /*bFormula*/)  
 oModel:AddCalc( 'CALC_NOTA', 'DETAILZB6', 'DETAILZB7', 'ZB7_NOTA', 'MEDIA', 'AVERAGE', /*bCondition*/, /*bInitValue*/,'Media' /*cTitle*/, /*bFormula*/)    

Return oModel 

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6', {|cField| AllTrim(Upper(cField)) $ "ZB6_RA" })  
Local oStr2:= FWCalcStruct( oModel:GetModel('CALC_ALUNO') )  
Local oStr4:= FWCalcStruct( oModel:GetModel('CALC_NOTA') )  
Local oStruZB7:= FWFormStruct(2, 'ZB7', {|cField| AllTrim(Upper(cField)) $ "ZB7_RA|ZB7_CODTUR" })  
	
	oStruZB7:AddField( 'LEGENDA','01','Legenda','Legenda',, 'Get' ,'@BMP',,,.F.,,,,,,.T.,, )    
	oView := FWFormView():New()  
	oView:SetModel(oModel)    
	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')  
	oView:AddGrid('FORM_NOTA' , oStruZB7,'DETAILZB7')     
	oView:AddField('CALC2', oStr4,'CALC_NOTA')  
	oView:AddField('CALC1', oStr2,'CALC_ALUNO')    
	
	oView:AddOtherObject("GRAF",{|oPanel| CriaGrafico(oPanel) },,{|oPanel| GraRefresh() })
	
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 15)  
	//oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 27)  
	//oView:CreateHorizontalBox( 'BOX_NOTA', 19)   
	//oView:CreateHorizontalBox( 'BOX_CALCS', 21)  
	//oView:CreateVerticalBox( 'BOX_CALC_ALUNO', 50, 'BOX_CALCS')  
	//oView:CreateVerticalBox( 'BOX_CALC_NOTA', 50, 'BOX_CALCS')
 	
 	oView:CreateHorizontalBox( 'BOXFOLDER', 85)
	oView:CreateFolder( 'FOLDER', 'BOXFOLDER')
	oView:addSheet("FOLDER","ABA1","Alunos")
	oView:addSheet("FOLDER","ABA2","Notas")
	oView:addSheet("FOLDER","ABA3","Analises")
	
	oView:createHorizontalBox("BOX_ALUNOS",100,,,"FOLDER","ABA1")
	oView:createHorizontalBox("BOX_NOTA",100,,,"FOLDER","ABA2")
	oView:createHorizontalBox("BOX_CALCS",100,,,"FOLDER","ABA3")
 	oView:CreateVerticalBox( 'BOX_GRAFICO', 70, 'BOX_CALCS',,"FOLDER","ABA3") 
 	oView:CreateVerticalBox( 'BOX_CALCS2', 30, 'BOX_CALCS',,"FOLDER","ABA3") 
 	oView:CreateHorizontalBox( 'BOX_CALC_ALUNO', 50, 'BOX_CALCS2',,"FOLDER","ABA3")  
	oView:CreateHorizontalBox( 'BOX_CALC_NOTA', 50, 'BOX_CALCS2',,"FOLDER","ABA3")
 	
 	oView:SetOwnerView('FORM_NOTA','BOX_NOTA')  
 	oView:SetOwnerView('CALC2','BOX_CALC_NOTA')  
 	oView:SetOwnerView('CALC1','BOX_CALC_ALUNO')   
 	oView:SetOwnerView('FORM_ALUNOS','BOX_ALUNOS')  
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')   
 	oView:SetOwnerView("GRAF","BOX_GRAFICO")
 	
 	oView:SetViewProperty('FORM_ALUNOS' , 'ENABLEDGRIDDETAIL' , {70} )
	
	oView:AddUserButton('Incluir Aluno','',{|oView|NovoAluno(oView)},'Inclui um novo aluno',VK_F12,{MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE})
	
	oView:SetViewProperty("FORM_ALUNOS",'ONLYVIEW') 
	
Return oView 
 
Static Function NovoAluno()
	FWExecView("Novo Aluno","CMVC_01",MODEL_OPERATION_INSERT)
Return 
 
Static Function TurmaPosValid(oField) 
Local lValid := .T. 
Local cDescr := oField:GetValue("ZB5_DESTUR") 
 
 /*If "TURMA" $ Upper(cDescr)   
 	Help( ,, 'HELP',, 'A descrição da turma não pode conter o nome "TURMA".', 1, 0)   
 	lValid := .F.  
 EndIf*/  

Return lValid 
 
Static Function AlunoLinePos(oGrid) 
Local lValid := .T. 
Local cRA := oGrid:GetValue("ZB6_RA") 
 
 If IsAlpha(cRA)   
 	Help( ,, 'HELP',, 'O RA do aluno não pode iniciar com uma letra.', 1, 0)   
 	lValid := .F.  
 EndIf 
 
Return lValid  

Static Function LinePreAluno(oGrid,nLine,cAction) 
Local lValid := .T.    
	
	If cAction == "UNDELETE"   
		Help( ,, 'HELP',, 'Não é possivel desfazer a deleção de um Aluno da turma.', 1, 0)   
		lValid := .F.  
	EndIf    
Return lValid 
 
User Function Legenda() 
Local oModel := FWModelActive() 
Local cImg 
Local nNota      
	
	nNota := oModel:GetValue("DETAILZB7","ZB7_NOTA")    
	
	If nNota >= 7   
		cImg := "br_verde_ocean.bmp"  
	Else   
		cImg := "BR_VERMELHO.BMP"  
	EndIf 
	  
Return cImg


Static Function CriaGrafico(oPanel, lReDraw)
Local oModel	 := FWModelActive()
Local oModelNotas  := oModel:GetModel('DETAILZB7')
Local nI
Local nNotaGeral := 0
Local aMedia := {}
Local cDisc
Local nNotaDisc
Local nPos

Default lReDraw := .F.

FWSaveRows()

For nI := 1 To oModelNotas:Length()
	oModelNotas:GoLine(nI)
	If !oModelNotas:IsDeleted()
		nNotaDisc := oModelNotas:GetValue("ZB7_NOTA")
		cDisc := oModelNotas:GetValue("ZB7_CODDIS")
	
		nNotaGeral += nNotaDisc
		
		nPos := aScan(aMedia, {|x| x[1] == cDisc})
		
		If nPos == 0
			aAdd(aMedia, {cDisc, nNotaDisc, oModelNotas:GetValue('ZB7_DESDIS')} )
		Else
			aMedia[nPos][2] += nNotaDisc
		EndIf
	EndIf
Next

If !lReDraw
	oGrafBar := FWChartFactory():New()
	oGrafBar := oGrafBar:GetInstance( BARCHART )
	oGrafBar:Init( oPanel, .F., .F. )
	oGrafBar:SetMaxY( 5 )
	oGrafBar:SetTitle( "Media das Notas por Disciplina", CONTROL_ALIGN_CENTER )
	oGrafBar:SetLegend( CONTROL_ALIGN_RIGHT )
Else
	oGrafBar:Reset()
EndIf

For nI:=1 to Len(aMedia)
	oGrafBar:addSerie( aMedia[nI][3]    , aMedia[nI][2] )
Next nI 

oGrafBar:build()

FWRestRows()

Return

Static Function GraRefresh()
CriaGrafico( oGrafBar:oOwner, .T. )
Return NIL