/*
 * JQuery (probably wisely) disables the ability to execute a JS script
 * when doing a CORS request.
 *
 * This patch re-instates the ability to run a script, even if from CORS
 */

// Install script dataType
jQuery.ajaxPrefilter(function(s) {
	s.accepts.script =  "text/javascript, application/javascript, " +
			"application/ecmascript, application/x-ecmascript"

	s.contents.script = /\b(?:java|ecma)script\b/;

	s.converters["text script"] = function( text ) {
			jQuery.globalEval( text );
			return text;
  };
} );

// Handle cache's special case and crossDomain
jQuery.ajaxPrefilter( "script", function( s , o) {
	if ( s.crossDomain ) {
		s.type = o.type;
	}
} );
