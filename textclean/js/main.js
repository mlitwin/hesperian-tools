$(function () {

// Clean up text pasted from Hesperian PDF's for use in the wiki.
$('.clean-button').click( function() {
  var textelement = $('#textsrc');
    var text = textelement.val();
    
    // Diagnose hard-breaks and convert to spaces.
    text = text.replace(/([^\n])\n([^\n])/gm, "$1 $2");
        
    textelement.val(text).select();
  });
  
});