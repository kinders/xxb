CKEDITOR.editorConfig = function( config ) {

  // config.mathJaxLib = '/mathjax/rails/mathjax_rails/MathJax.js?config=TeX-AMS_HTML';
  config.mathJaxLib = '//cdn.mathjax.org/mathjax/2.2-latest/MathJax.js?config=TeX-AMS_HTML';

	config.toolbarGroups = [
		{ name: 'clipboard', groups: [ 'undo', 'clipboard' ] },
		{ name: 'editing', groups: [ 'selection', 'find', 'spellchecker', 'editing' ] },
		{ name: 'links', groups: [ 'links' ] },
		{ name: 'insert', groups: [ 'insert' ] },
		{ name: 'forms', groups: [ 'forms' ] },
		{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'tools', groups: [ 'tools' ] },
		'/',
		{ name: 'others', groups: [ 'others' ] },
		{ name: 'styles', groups: [ 'styles' ] },
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'colors', groups: [ 'colors' ] },
		{ name: 'paragraph', groups: [ 'align', 'bidi', 'list', 'indent', 'blocks', 'paragraph' ] },
		{ name: 'about', groups: [ 'about' ] }
	];

	config.removeButtons = 'About,Styles';


};


// Optional plugin
// (La)TeX2MathML
// Color Button
// Enhanced Image
// Find / Replace
// Font Size and Family
// Image Rotate
// Justify
// Mathematical Formulas
// Print
// Select All
