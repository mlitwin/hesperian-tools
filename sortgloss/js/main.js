$(function () {

// Clean up text pasted from Hesperian PDF's for use in the wiki.
$('.clean-button').click( function() {
  var textelement = document.getElementById('wpTextbox1');
    var text = textelement.value;
    
    var findtable = /((?:.|[\r\n])*<table class="wiki_table">)((?:.|[\r\n])*)(<\/table>(?:.|[\r\n])*)/m;
    var findRow = /\s*<tr>(?:.|[\r\n])*?<\/tr>/mg;
    var findKey = /\s*<tr>(?:.|[\r\n])*?<td>(.*?)<br/m;
    
    // look for the <table>
    var ft = findtable.exec(text);
    
    var table = ft[2];
    var key;
    
    var rows = [], i, header;
    
    // loop through rows in the table, extracting the first row seperately
    var rowmatch;
	while ((rowmatch = findRow.exec(table)) !== null)
	{
	  key = findKey.exec(rowmatch[0]);
	  if( key) {
	    if(!header) {
	      header = rowmatch[0];
	    } else {
	  	  rows.unshift({ key: key[1], value: rowmatch[0]});
	  	}
	  }
	}
	
	// sort the rows by key
	rows.sort(function(a,b) {
	  return a.key.localeCompare(b.key);
	});
	
	// reconstitute the original text, now with a sorted table
	text = ft[1];
	
	text += header;
	for(i = 0; i < rows.length; i++) {
		text += rows[i].value;
	}
    
    text += ft[3];
        
    textelement.value = text;
  });
  
});