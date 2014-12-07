$(function () {

// Clean up text pasted from Hesperian PDF's for use in the wiki.
$('.clean-button').click( function() {
  var textelement = $('#wpTextbox1');
    var text = textelement.val();
    
    var findtable = /((?:.|[\r\n])*<table class="wiki_table">)((?:.|[\r\n])*)(<\/table>(?:.|[\r\n])*)/m;
    var findRow = /\s*<tr>(?:.|[\r\n])*?<\/tr>/mg;
    var findKey = /\s*<tr>(?:.|[\r\n])*?<td>(.*?)<br/m;
    
    var ft = findtable.exec(text);
    
    var table = ft[2];
    var key;
    
    var rows = [], i, header;
    
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
	
	rows.sort(function(a,b) {
	  return a.key.localeCompare(b.key);
	});
	
	text = ft[1];
	
	text += header;
	for(i = 0; i < rows.length; i++) {
		text += rows[i].value;
	}
    
    text += ft[3];
        
    textelement.val(text).select();
  });
  
});