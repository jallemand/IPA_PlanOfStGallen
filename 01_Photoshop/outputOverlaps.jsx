function saveOverlapDifferences() {
	// Load in the existing large photoshop file
	var inputPSB = app.activeDocument.name;
	var doc = app.activeDocument;
	
	// Ensure the file is the large photoshop format and not the tiff
	if (inputPSB.split(".")[1] === "psb") {
		// Get the current path to the photoshop file
		var psbPath = app.activeDocument.path;
		// Get the path to the tiff mosaic
		var inputTiff = psbPath + "/" + inputPSB.split(".")[0] + ".tif";

		// Load in the mosaic
		var layer = doc.artLayers.add();
		var img = new File(inputTiff); 
		var openedFile = app.open(img);
		openedFile.selection.selectAll();
		openedFile.selection.copy();
		openedFile.close(SaveOptions.DONOTSAVECHANGES);
		doc.paste();
		doc.save();
		
		// get number of layers
		var numLayers = doc.layers.length;

		// Turn off all layers
		for(var i = 0 ; i < doc.layers.length;i++){
			doc.layers[i].visible = 0;
		}
		
		// Iterate through all the layers
		for (var i = 0; i < numLayers; i++) {
			// get the current layer
			var layer = doc.layers[i];
			
			// in the case that the layer is the mosaic
			if (layer.name == 'Layer 1') {
				layer.visible = 1;
				
				// Get the id number from the mosaic layer because this is used to reference all the others
				var baseLayerNum = layer.id;
				
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
				
				// Turn off the layer
				layer.visible = 0;
			}
		}

		// Change the layer names to remove the filename extension
		
		// Get the current number of layers as the mosaic has been added
		var numLayers = doc.layers.length;
		
		// Loop through layers
		for (var i = 0; i < numLayers; i++) {
			// Get current layer
			var layer = doc.layers[i];
			
			// Ensure that the layer is not the input mosaic layer
			if (layer.name != 'Layer 1') {
				
				// Change the name of the layer
				var currentLayer = app.activeDocument.layers[i];  
				currentLayer.name = currentLayer.name.split(".")[0] + "_outside_diff"
			}
		}
		
		// Remove the loaded tif
		doc.layers[0].remove();
		doc.save();
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



