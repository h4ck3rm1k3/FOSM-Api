/* generated javascript */
var skin = 'vector';
var stylepath = '/w/skins';

/* MediaWiki:Common.js */
/* Any JavaScript here will be loaded for all users on every page load. */
//================================================================================
//*** Dynamic Navigation Bars
 
// set up the words in your language
var NavigationBarHide = 'hide';
var NavigationBarShow = 'show';
 
// set up max count of Navigation Bars on page,
// if there are more, all will be hidden
// NavigationBarShowDefault = 0; // all bars will be hidden
// NavigationBarShowDefault = 1; // on pages with more than 1 bar all bars will be hidden
if (typeof NavigationBarShowDefault == 'undefined' ) {
    var NavigationBarShowDefault = 1;
}
 
// adds show/hide-button to navigation bars
addOnloadHook(function() {
	// shows and hides content and picture (if available) of navigation bars
	// Parameters:
	//     indexNavigationBar: the index of navigation bar to be toggled
	function toggleNavigationBar(indexNavigationBar)
	{
	   var NavToggle = document.getElementById("NavToggle" + indexNavigationBar);
	   var NavFrame = document.getElementById("NavFrame" + indexNavigationBar);
 
	   if (!NavFrame || !NavToggle) {
		   return false;
	   }
 
	   // if shown now
	   if (NavToggle.firstChild.data == NavigationBarHide) {
		   for (
				   var NavChild = NavFrame.firstChild;
				   NavChild != null;
				   NavChild = NavChild.nextSibling
			   ) {
			   if (NavChild.className == 'NavPic') {
				   NavChild.style.display = 'none';
			   }
			   if (NavChild.className == 'NavContent') {
				   NavChild.style.display = 'none';
			   }
			   if (NavChild.className == 'NavToggle') {
				   NavChild.firstChild.data = NavigationBarShow;
			   }
		   }
 
	   // if hidden now
	   } else if (NavToggle.firstChild.data == NavigationBarShow) {
		   for (
				   var NavChild = NavFrame.firstChild;
				   NavChild != null;
				   NavChild = NavChild.nextSibling
			   ) {
			   if (NavChild.className == 'NavPic') {
				   NavChild.style.display = 'block';
			   }
			   if (NavChild.className == 'NavContent') {
				   NavChild.style.display = 'block';
			   }
			   if (NavChild.className == 'NavToggle') {
				   NavChild.firstChild.data = NavigationBarHide;
			   }
		   }
	   }
	}
 
	function toggleNavigationBarFunction(indexNavigationBar) {
		return function() {
			toggleNavigationBar(indexNavigationBar);
			return false;
		};
	}
 
   var indexNavigationBar = 0;
   // iterate over all < div >-elements
   var divs = document.getElementsByTagName("div");
   for (var i=0;  i<divs.length; i++) {
       var NavFrame = divs[i];
       // if found a navigation bar
       if (NavFrame.className == "NavFrame") {
 
           indexNavigationBar++;
           var NavToggle = document.createElement("a");
           NavToggle.className = 'NavToggle';
           NavToggle.setAttribute('id', 'NavToggle' + indexNavigationBar);
           NavToggle.setAttribute('href', '#');
		   NavToggle.onclick = toggleNavigationBarFunction(indexNavigationBar);
 
           var NavToggleText = document.createTextNode(NavigationBarHide);
           NavToggle.appendChild(NavToggleText);
 
           // add NavToggle-Button as first div-element
           // in < div class="NavFrame" >
           NavFrame.insertBefore(
               NavToggle,
               NavFrame.firstChild
           );
           NavFrame.setAttribute('id', 'NavFrame' + indexNavigationBar);
       }
   }
   // if more Navigation Bars found than Default: hide all
   if (NavigationBarShowDefault < indexNavigationBar) {
       for(
               var i=1;
               i<=indexNavigationBar;
               i++
       ) {
           toggleNavigationBar(i);
       }
   }
});

if ( wgNamespaceNumber == 6 ) {
    importScript('MediaWiki:Common.js/file.js');
}

/* MediaWiki:Vector.js */
/* Any JavaScript here will be loaded for users using the Vector skin */