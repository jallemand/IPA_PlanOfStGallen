function saveOverlapDifferences() {
	// Load in the existing large photoshop file
	var inputPSB = app.activeDocument.name;
	var doc = app.activeDocument;
	if (inputPSB.split(".")[1] === "psb") {
		var psbPath = app.activeDocument.path;
		var inputTiff = psbPath + "/" + inputPSB.split(".")[0] + ".tif";

		var outputPath = psbPath + "/" + "Output_Overlap";
		var outFullPath = File(outputPath + "/" +  inputPSB.split(".")[0] + "_overlap.psb");
		
		if (Folder(outputPath).exists == false) {
			new Folder(outputPath).create()
		};  
		
		var outImagesPath = outputPath + inputPSB.split(".")[0] + "_images";
		if (Folder(outImagesPath).exists == false) {
			new Folder(outImagesPath).create()
		};  
		
		

		// Save to the outputPSB
		savePSB(outFullPath);

		var layer = doc.artLayers.add();
		
		var img = new File(inputTiff); 
		var openedFile = app.open(img);

		openedFile.selection.selectAll();
		openedFile.selection.copy();
		openedFile.close(SaveOptions.DONOTSAVECHANGES);
		doc.paste();

		var numLayers = doc.layers.length;

		// Main loop over layers
		// Turn off all layers
		for(var i = 0 ; i < doc.layers.length;i++){
			doc.layers[i].visible = 0;
		}
		
		// numLayers = 1;
		for (var i = 0; i < numLayers; i++) {
			var layer = doc.layers[i];
			if (layer.name == 'Layer 1') {
				layer.visible = 1;
				var baseLayerNum = layer.id;
				var diffNum = layer.id - doc.layers.length ;
				
				// Set the base layer to subtract
				var idsetd = charIDToTypeID( "setd" );
					var desc1 = new ActionDescriptor();
					var idnull = charIDToTypeID( "null" );
						var ref1 = new ActionReference();
						var idLyr = charIDToTypeID( "Lyr " );
						var idOrdn = charIDToTypeID( "Ordn" );
						var idTrgt = charIDToTypeID( "Trgt" );
						ref1.putEnumerated( idLyr, idOrdn, idTrgt );
					desc1.putReference( idnull, ref1 );
					var idT = charIDToTypeID( "T   " );
						var desc2 = new ActionDescriptor();
						var idMd = charIDToTypeID( "Md  " );
						var idBlnM = charIDToTypeID( "BlnM" );
						var idblendSubtraction = stringIDToTypeID( "blendSubtraction" );
						desc2.putEnumerated( idMd, idBlnM, idblendSubtraction );
					var idLyr = charIDToTypeID( "Lyr " );
					desc1.putObject( idT, idLyr, desc2 );
				executeAction( idsetd, desc1, DialogModes.NO );
				
			} else {
				layer.visible = 1;
				doc.activeLayer = layer;
				
				// Inverts and applies the current mask
				try {
					// =======================================================
					var idslct = charIDToTypeID( "slct" );
						var desc3 = new ActionDescriptor();
						var idnull = charIDToTypeID( "null" );
							var ref3 = new ActionReference();
							var idChnl = charIDToTypeID( "Chnl" );
							var idChnl = charIDToTypeID( "Chnl" );
							var idMsk = charIDToTypeID( "Msk " );
							ref3.putEnumerated( idChnl, idChnl, idMsk );
							var idLyr = charIDToTypeID( "Lyr " );
							ref3.putName( idLyr, layer.name );
						desc3.putReference( idnull, ref3 );
						var idMkVs = charIDToTypeID( "MkVs" );
						desc3.putBoolean( idMkVs, false );
					executeAction( idslct, desc3, DialogModes.NO );

					// =======================================================
					var idInvr = charIDToTypeID( "Invr" );
					executeAction( idInvr, undefined, DialogModes.NO );

					// =======================================================
					var idDlt = charIDToTypeID( "Dlt " );
						var desc4 = new ActionDescriptor();
						var idnull = charIDToTypeID( "null" );
							var ref4 = new ActionReference();
							var idChnl = charIDToTypeID( "Chnl" );
							var idOrdn = charIDToTypeID( "Ordn" );
							var idTrgt = charIDToTypeID( "Trgt" );
							ref4.putEnumerated( idChnl, idOrdn, idTrgt );
						desc4.putReference( idnull, ref4 );
						var idAply = charIDToTypeID( "Aply" );
						desc4.putBoolean( idAply, true );
					executeAction( idDlt, desc4, DialogModes.NO );

				} catch(e) {
					alert(e);
				}
				
				try {
					// Set the current layer to subtract
					var idsetd = charIDToTypeID( "setd" );
						var desc5 = new ActionDescriptor();
						var idnull = charIDToTypeID( "null" );
							var ref5 = new ActionReference();
							var idLyr = charIDToTypeID( "Lyr " );
							var idOrdn = charIDToTypeID( "Ordn" );
							var idTrgt = charIDToTypeID( "Trgt" );
							ref5.putEnumerated( idLyr, idOrdn, idTrgt );
						desc5.putReference( idnull, ref5 );
						var idT = charIDToTypeID( "T   " );
							var desc6 = new ActionDescriptor();
							var idMd = charIDToTypeID( "Md  " );
							var idBlnM = charIDToTypeID( "BlnM" );
							var idDfrn = charIDToTypeID( "Dfrn" );
							desc6.putEnumerated( idMd, idBlnM, idDfrn );
						var idLyr = charIDToTypeID( "Lyr " );
						desc5.putObject( idT, idLyr, desc6 );
					executeAction( idsetd, desc5, DialogModes.NO );
				} catch(e) {
					alert("Error setting the current layer to subtract");
					alert(e);
				}
				
				
				doc.activeLayer = doc.layers[0];
				try {				
					// Selects the base layer and the current layer
					// =======================================================
					var idslct = charIDToTypeID( "slct" );
						var desc7 = new ActionDescriptor();
						var idnull = charIDToTypeID( "null" );
							var ref7 = new ActionReference();
							var idLyr = charIDToTypeID( "Lyr " );
							ref7.putName( idLyr, layer.name );
						desc7.putReference( idnull, ref7 );
						var idselectionModifier = stringIDToTypeID( "selectionModifier" );
						var idselectionModifierType = stringIDToTypeID( "selectionModifierType" );
						var idaddToSelection = stringIDToTypeID( "addToSelection" );
						desc7.putEnumerated( idselectionModifier, idselectionModifierType, idaddToSelection );
						var idMkVs = charIDToTypeID( "MkVs" );
						desc7.putBoolean( idMkVs, false );
						var idLyrI = charIDToTypeID( "LyrI" );
							var list7 = new ActionList();
							list7.putInteger( baseLayerNum - i - 1 );
							list7.putInteger( baseLayerNum );
						desc7.putList( idLyrI, list7 );
					executeAction( idslct, desc7, DialogModes.NO );
					
					// Sets the selected region to be that of the current layer
					// =======================================================
					var idsetd = charIDToTypeID( "setd" );
						var desc8 = new ActionDescriptor();
						var idnull = charIDToTypeID( "null" );
							var ref8 = new ActionReference();
							var idChnl = charIDToTypeID( "Chnl" );
							var idfsel = charIDToTypeID( "fsel" );
							ref8.putProperty( idChnl, idfsel );
						desc8.putReference( idnull, ref8 );
						var idT = charIDToTypeID( "T   " );
							var ref9 = new ActionReference();
							var idChnl = charIDToTypeID( "Chnl" );
							var idChnl = charIDToTypeID( "Chnl" );
							var idTrsp = charIDToTypeID( "Trsp" );
							ref9.putEnumerated( idChnl, idChnl, idTrsp );
							var idLyr = charIDToTypeID( "Lyr " );
							ref9.putName( idLyr, layer.name );
						desc8.putReference( idT, ref9 );
					executeAction( idsetd, desc8, DialogModes.NO );
					
					// Creates a merged copy of the subtracted two layers
					// =======================================================
					var idCpyM = charIDToTypeID( "CpyM" );
					executeAction( idCpyM, undefined, DialogModes.NO );
					
					// Sets the current layer to active... THIS CAN BE SHORTENED
					// =======================================================
					var idslct = charIDToTypeID( "slct" );
						var desc10 = new ActionDescriptor();
						var idnull = charIDToTypeID( "null" );
							var ref10 = new ActionReference();
							var idLyr = charIDToTypeID( "Lyr " );
							ref10.putName( idLyr, layer.name );
						desc10.putReference( idnull, ref10 );
						var idMkVs = charIDToTypeID( "MkVs" );
						desc10.putBoolean( idMkVs, false );
						var idLyrI = charIDToTypeID( "LyrI" );
							var list10 = new ActionList();
							list10.putInteger( 62 );
						desc10.putList( idLyrI, list10 );
					executeAction( idslct, desc10, DialogModes.NO );
					
					// Select all of the current layer
					// =======================================================
					var idsetd = charIDToTypeID( "setd" );
						var desc11 = new ActionDescriptor();
						var idnull = charIDToTypeID( "null" );
							var ref11 = new ActionReference();
							var idChnl = charIDToTypeID( "Chnl" );
							var idfsel = charIDToTypeID( "fsel" );
							ref11.putProperty( idChnl, idfsel );
						desc11.putReference( idnull, ref11 );
						var idT = charIDToTypeID( "T   " );
						var idOrdn = charIDToTypeID( "Ordn" );
						var idAl = charIDToTypeID( "Al  " );
						desc11.putEnumerated( idT, idOrdn, idAl );
					executeAction( idsetd, desc11, DialogModes.NO );
					
					// Delete the existing data of the current layer
					// =======================================================
					var idDlt = charIDToTypeID( "Dlt " );
					executeAction( idDlt, undefined, DialogModes.NO );
					
					// Paste the copy-merged data
					// =======================================================
					var idpast = charIDToTypeID( "past" );
						var desc12 = new ActionDescriptor();
						var idinPlace = stringIDToTypeID( "inPlace" );
						desc12.putBoolean( idinPlace, true );
						var idAntA = charIDToTypeID( "AntA" );
						var idAnnt = charIDToTypeID( "Annt" );
						var idAnno = charIDToTypeID( "Anno" );
						desc12.putEnumerated( idAntA, idAnnt, idAnno );
						var idAs = charIDToTypeID( "As  " );
						var idPxel = charIDToTypeID( "Pxel" );
						desc12.putClass( idAs, idPxel );
					executeAction( idpast, desc12, DialogModes.NO );
					
				} catch(e) {
					alert("Error trying to get the difference");
					alert(e);
				}

				layer.visible = 0;
			}
		}
		// Remove the base layer
		// doc.layers[0].remove();
		
		var numLayers = doc.layers.length;
		for (var i = 0; i < numLayers; i++) {
			var layer = doc.layers[i];
			if (layer.name != 'Layer 1') {
				var currentLayer = app.activeDocument.layers[i];  
				currentLayer.name = currentLayer.name.split(".")[0] + "_outside_diff"
			}
		}
		
		doc.save();
		doc.close(SaveOptions.DONOTSAVECHANGES);
	} else {
		try {
			doc.close(SaveOptions.DONOTSAVECHANGES);
		} catch(e) {
			
		}
	}
}

function savePSB(saveFile) {   
    var desc1 = new ActionDescriptor();   
    var desc2 = new ActionDescriptor();   
    desc2.putBoolean( stringIDToTypeID('maximizeCompatibility'), true );   
    desc1.putObject( charIDToTypeID('As  '), charIDToTypeID('Pht8'), desc2 );   
    desc1.putPath( charIDToTypeID('In  '), new File(saveFile) );   
    desc1.putBoolean( charIDToTypeID('LwCs'), true );   
    executeAction( charIDToTypeID('save'), desc1, DialogModes.NO );   
};  

saveOverlapDifferences();



