(function() {
	var textelement = document.getElementById('wpTextbox1');
	var text = textelement.value;

	var findtable = /((?:.|[\r\n])*<table class="wiki_table">)((?:.|[\r\n])*)(<\/table>(?:.|[\r\n])*)/m;
	var findRow = /\s*<tr>(?:.|[\r\n])*?<\/tr>[\r\n]*/mg;
	var findKey = /\s*<tr>(?:.|[\r\n])*?<td>(.*?)<br/m;

	// look for the <table>
	var ft = findtable.exec(text);

	var table = ft[2];
	var key;

	var rows = [], index = 0, header;

	// loop through rows in the table, extracting the first row seperately
	var rowmatch;
	while ((rowmatch = findRow.exec(table)) !== null)
	{
	  key = findKey.exec(rowmatch[0]);
	  if( key) {
		if(!header) {
		  header = rowmatch[0];
		} else {
		  rows.unshift({
		  	key: key[1],
		  	value: rowmatch[0],
		  	index: index});
		}
		index++;
	  }
	}

	// sort the rows by key
	rows.sort(function(a,b) {
	  if( a.key === b.key) {
	  	return a.index - b.index;
	  }
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
})();